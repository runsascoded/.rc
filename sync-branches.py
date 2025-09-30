#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.9"
# dependencies = [
#     "click",
#     "gitpython",
#     "utz",
# ]
# ///

"""Sync commits between gh-all and gh-server branches on GitHub."""

import os
import sys
from pathlib import Path

from utz.cli import opt, flag

from click import command, option
from git import Repo
from utz import err, env
import re

def get_submodule_changes(repo, commit):
    """Get list of submodules that changed in a commit."""
    # Get diff for submodules only
    diff = repo.git.diff(f"{commit}^", commit, "--", ":(exclude).github", ":(exclude)*.py", ":(exclude)*.sh", ":(exclude)*.md", ":(exclude).rc", ":(exclude).gitmodules")

    # Parse submodule changes
    changed_submodules = set()
    for line in diff.split('\n'):
        # Look for submodule path changes
        if line.startswith('diff --git a/') or line.startswith('+++ b/'):
            match = re.match(r'(?:diff --git a/|\+\+\+ b/)([^/\s]+)', line)
            if match:
                path = match.group(1)
                # Check if it's a submodule directory
                if (Path(repo.working_dir) / path).is_dir():
                    changed_submodules.add(path)

    return changed_submodules

def has_file_changes(repo, commit):
    """Check if commit has non-submodule file changes."""
    # Check for changes to actual files (not submodules)
    diff_files = repo.git.diff(f"{commit}^", commit, "--name-only", "--",
                               ".github", "*.py", "*.sh", "*.md", ".rc", ".gitmodules").strip()
    return bool(diff_files)

def get_server_submodules():
    """Get list of submodules that exist on server branches."""
    # These are the modules that don't exist on server branches
    non_server_modules = {'1pass', 'go', 'hammerspoon', 'osx', 'ruby'}

    # Get all submodules
    all_modules = set()
    gitmodules_path = Path('.gitmodules')
    if gitmodules_path.exists():
        content = gitmodules_path.read_text()
        for match in re.finditer(r'\[submodule "([^"]+)"\]', content):
            all_modules.add(match.group(1))

    return all_modules - non_server_modules

def generate_submodule_commit_message(repo, changed_submodules):
    """Generate commit message for submodule changes using git submodule-auto-commit."""
    # Use git submodule-auto-commit -m to generate the proper message
    # This matches the local workflow (g saca)
    # Note: Requires git helpers to be in PATH (workflow sources git/.git-rc)
    submodule_args = list(sorted(changed_submodules))
    msg = repo.git.execute(['git', 'submodule-auto-commit', '-m'] + submodule_args)
    return msg.strip()

def sync_commit(repo, source_branch, target_branch, commit_sha):
    """Sync a single commit from source to target branch."""
    err(f"Syncing commit {commit_sha[:8]} from {source_branch} to {target_branch}")

    is_server_target = 'server' in target_branch

    # Get commit details
    commit = repo.commit(commit_sha)
    commit_msg = commit.message.strip()

    # Check if this commit has already been synced by matching author/committer/time
    # This is the canonical way to align commits across branches since messages may differ
    author_email = commit.author.email
    author_name = commit.author.name
    author_time = commit.authored_datetime
    committer_time = commit.committed_datetime

    try:
        # Since committer times are monotonic, we can efficiently check for matching commits
        # Look for a commit with same author email and author time (canonical identity)
        existing = repo.git.log(
            target_branch,
            '--format=%H %ae %at %ce %ct',
            f'--author={author_email}',
            '--max-count=20'  # Check recent commits only, since times are monotonic
        ).strip().split('\n')

        for line in existing:
            if not line:
                continue
            parts = line.split()
            if len(parts) >= 5:
                commit_hash = parts[0]
                existing_commit = repo.commit(commit_hash)
                # Check if author time matches (the canonical identifier)
                if existing_commit.authored_datetime == author_time:
                    err(f"  Commit already synced to {target_branch} (by author/time): {commit_hash[:8]} - {existing_commit.message.strip()[:50]}")
                    return False

                # Optimization: if we've gone past this commit time (monotonic), stop looking
                if existing_commit.committed_datetime < committer_time:
                    break
    except:
        pass

    # Determine commit type
    changed_submodules = get_submodule_changes(repo, commit_sha)
    has_files = has_file_changes(repo, commit_sha)

    if changed_submodules and not has_files:
        # Pure submodule change - generate new commit
        err(f"  Submodule-only change: {', '.join(changed_submodules)}")

        # Checkout target branch
        repo.git.checkout(target_branch)

        # For server branch, filter out non-server submodules
        if is_server_target:
            server_modules = get_server_submodules()
            changed_submodules = changed_submodules & server_modules
            if not changed_submodules:
                err(f"  No server-relevant submodules changed, skipping")
                return False

        # Update each submodule to match source
        for submodule in changed_submodules:
            try:
                # Get the submodule commit from source branch
                source_commit = repo.git.ls_tree(commit_sha, submodule).split()[2]
                repo.git.submodule('update', '--init', submodule)

                # Update submodule to the commit from source
                sub_repo = Repo(Path(repo.working_dir) / submodule)
                sub_repo.git.checkout(source_commit)

                # Stage the change
                repo.git.add(submodule)
            except Exception as e:
                err(f"  Error updating submodule {submodule}: {e}")

        # Generate commit message based on actual changes
        if repo.index.diff('HEAD'):
            msg = generate_submodule_commit_message(repo, changed_submodules)

            # Preserve original author and committer information
            author = commit.author
            author_date = commit.authored_datetime
            committer = commit.committer
            committer_date = commit.committed_datetime

            # Format dates as "epoch timezone_offset" which is git's internal format
            # This ensures timezone is properly preserved
            author_date_str = f"{int(author_date.timestamp())} {author_date.strftime('%z')}"
            committer_date_str = f"{int(committer_date.timestamp())} {committer_date.strftime('%z')}"

            with env(
                GIT_COMMITTER_NAME=committer.name,
                GIT_COMMITTER_EMAIL=committer.email,
                GIT_COMMITTER_DATE=committer_date_str
            ):
                # Create commit with original author and committer info
                repo.index.commit(
                    msg,
                    author=author,
                    author_date=author_date_str
                )

            err(f"  Created new commit: {msg} (preserving author: {author.name}, committer: {committer.name})")

            return True
        else:
            err(f"  No changes to commit")
            return False

    elif has_files and not changed_submodules:
        # Pure file change - cherry-pick
        err(f"  File-only change, cherry-picking")

        # Checkout target branch and cherry-pick
        repo.git.checkout(target_branch)
        try:
            # Cherry-pick preserves author but not committer, so we need to fix that
            repo.git.cherry_pick(commit_sha, '--no-commit')

            # Preserve original author and committer information
            author = commit.author
            author_date = commit.authored_datetime
            committer = commit.committer
            committer_date = commit.committed_datetime

            # Format dates as "epoch timezone_offset" which is git's internal format
            # This ensures timezone is properly preserved
            author_date_str = f"{int(author_date.timestamp())} {author_date.strftime('%z')}"
            committer_date_str = f"{int(committer_date.timestamp())} {committer_date.strftime('%z')}"

            with env(
                GIT_AUTHOR_NAME=author.name,
                GIT_AUTHOR_EMAIL=author.email,
                GIT_AUTHOR_DATE=author_date_str,
                GIT_COMMITTER_NAME=committer.name,
                GIT_COMMITTER_EMAIL=committer.email,
                GIT_COMMITTER_DATE=committer_date_str
            ):
                # Commit with preserved author and committer info
                repo.git.commit('--no-edit')

            err(f"  Cherry-picked successfully (preserving committer info)")
            return True
        except Exception as e:
            # Handle conflicts or errors
            err(f"  Cherry-pick failed: {e}")
            try:
                repo.git.cherry_pick('--abort')
            except:
                pass
            return False

    elif has_files and changed_submodules:
        # Mixed change - handle both file and submodule changes
        err(f"  Mixed file and submodule changes")
        err(f"    Files changed: yes")
        err(f"    Submodules changed: {', '.join(changed_submodules)}")

        # Checkout target branch
        repo.git.checkout(target_branch)

        # For server branch, filter out non-server submodules
        if is_server_target:
            server_modules = get_server_submodules()
            relevant_submodules = changed_submodules & server_modules
            if not relevant_submodules and not has_files:
                err(f"  No server-relevant changes, skipping")
                return False

        try:
            # Cherry-pick but preserve committer info
            repo.git.cherry_pick(commit_sha, '--no-commit')

            # Preserve original committer information
            committer = commit.committer
            committer_date = commit.committed_datetime

            # Use utz.env for temporary environment variables
            with env(
                GIT_COMMITTER_NAME=committer.name,
                GIT_COMMITTER_EMAIL=committer.email,
                GIT_COMMITTER_DATE=committer_date.strftime('%Y-%m-%d %H:%M:%S %z')
            ):
                # Commit with preserved committer info
                repo.git.commit('--no-edit')

            err(f"  Cherry-picked successfully (preserving committer info)")
            return True
        except Exception as e:
            err(f"  Cherry-pick failed: {e}")
            try:
                repo.git.cherry_pick('--abort')
            except:
                pass
            return False
    else:
        # Empty commit or other edge case
        err(f"  No changes detected, skipping")
        return False


@command
@opt('-s', '--source', default='all', help='Source branch (default: all)')
@opt('-t', '--target', default='server', help='Target branch (default: server)')
@flag('-n', '--dry-run', help='Show what would be done without making changes')
def sync_branches(source, target, dry_run):
    """Sync recent commits between GitHub branches (all <-> server)."""

    # Debug info if running in GitHub Actions
    github_event = os.environ.get('GITHUB_EVENT_NAME', '')
    if github_event:
        github_actor = os.environ.get('GITHUB_ACTOR', '')
        err(f"Running in GitHub Actions context: Event={github_event}, Actor={github_actor}")

    repo = Repo('.')

    # Save current branch to return to it later
    original_branch = repo.active_branch.name

    try:
        # Get recent commits from source branch that aren't in target
        repo.git.checkout(source)

        # Quick check: if HEAD commits have identical author/committer info, branches are in sync
        source_head = repo.commit('HEAD')
        target_head = repo.commit(target)

        if (source_head.author.name == target_head.author.name and
            source_head.author.email == target_head.author.email and
            source_head.authored_datetime == target_head.authored_datetime and
            source_head.committer.name == target_head.committer.name and
            source_head.committer.email == target_head.committer.email and
            source_head.committed_datetime == target_head.committed_datetime):
            err(f"Branches appear to be in sync (HEAD commits have identical author/committer)")
            err(f"  {source}: {source_head.hexsha[:8]} - {source_head.message.strip()[:50]}")
            err(f"  {target}: {target_head.hexsha[:8]} - {target_head.message.strip()[:50]}")
            return

        # Find commits to sync using monotonic committer times
        # Walk back from source HEAD until we find a commit that exists in target
        target_head_time = target_head.committed_datetime

        # Build a set of target commits by their metadata for efficient lookup
        # We'll stop once we go past the oldest source commit we might sync
        target_commits = {}

        # Find the oldest source commit time we might need to check
        oldest_source_time = source_head.committed_datetime
        temp_current = source_head
        while temp_current.parents and temp_current.committed_datetime >= target_head_time:
            temp_current = temp_current.parents[0]
            oldest_source_time = temp_current.committed_datetime

        try:
            # Iterate through target commits, stopping when we go past our timeframe
            for tc in repo.iter_commits(target):
                # Stop if we've gone past the oldest source commit we might sync
                if tc.committed_datetime < oldest_source_time:
                    break

                # Key by author/committer metadata
                key = (tc.author.name, tc.author.email, tc.authored_datetime,
                       tc.committer.name, tc.committer.email, tc.committed_datetime)
                target_commits[key] = tc
        except Exception as e:
            err(f"Error building target commit index: {e}")

        commits_to_sync = []
        current = source_head

        while True:
            # Check if this commit exists in target (by metadata)
            current_key = (current.author.name, current.author.email, current.authored_datetime,
                          current.committer.name, current.committer.email, current.committed_datetime)

            if current_key in target_commits:
                # Found the sync point
                err(f"Found sync point: {current.hexsha[:8]} matches target commit")
                break

            # Check if we've gone past target's HEAD time without finding a match
            if current.committed_datetime < target_head_time:
                # This is an error - branches have diverged
                err(f"ERROR: Branches appear to have diverged!")
                err(f"  Source commit {current.hexsha[:8]} (time: {current.committed_datetime})")
                err(f"  is older than target HEAD (time: {target_head_time})")
                err(f"  but doesn't exist in target branch")
                raise Exception(f"Branches have diverged - manual intervention required")

            # Add to sync list
            commits_to_sync.append(current.hexsha)

            # Move to parent
            if current.parents:
                current = current.parents[0]
            else:
                # Reached root without finding sync point
                err(f"WARNING: Reached root of {source} without finding sync point with {target}")
                break

        if not commits_to_sync:
            err(f"No new commits to sync from {source} to {target}")
            return

        # Reverse to get chronological order (oldest first)
        commits = list(reversed(commits_to_sync))

        err(f"Found {len(commits)} commit(s) to sync")

        synced = 0
        for commit_sha in commits:
            if dry_run:
                commit = repo.commit(commit_sha)
                err(f"Would sync: {commit_sha[:8]} - {commit.message.strip()[:50]}")
            else:
                if sync_commit(repo, source, target, commit_sha):
                    synced += 1

        if not dry_run:
            err(f"\nSynced {synced} commit(s) from {source} to {target}")

            # Push the target branch if we made changes
            if synced > 0:
                err(f"Pushing {target} branch...")
                repo.git.push('origin', target)

    finally:
        # Return to original branch
        repo.git.checkout(original_branch)

if __name__ == '__main__':
    sync_branches()
