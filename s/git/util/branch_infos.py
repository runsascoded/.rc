__author__ = 'ryan'

from branch_info import BranchInfo
from color import clen
import subprocess


class BranchInfos:

    def set_max(self, prop_name):
        self.maxs[prop_name] = max(
            map(lambda bi: clen(getattr(bi, prop_name) if hasattr(bi, prop_name) else ''), self.branches))

    def cmd(self):
        return ["git", "branch", "-vv"]

    def branchInfoClass(self):
        return BranchInfo

    def __init__(self):
        self.maxs = {}

        out, err = subprocess.Popen(self.cmd(), stdout=subprocess.PIPE).communicate()

        lines = out.splitlines()

        self.branches_by_name = {}
        self.branches_by_hash = {}

        for line in lines:
            info = self.branchInfoClass()(line)
            self.branches_by_name[info.name] = info
            if info.hash not in self.branches_by_hash:
                self.branches_by_hash[info.hash] = []
            self.branches_by_hash[info.hash].append(info)

        hashes = map(lambda bi: bi.hash, self.branches_by_name.values())
        cmd = ['git', 'show',
               # NOTE(ryan): seems to omit 'master' branch in Git 1.7.1; doesn't seem to be necessary in general.
               #'--quiet',
               '-s',
               '--format=%h\t%ci\t%cr'] + hashes
        out, err = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()

        lines = out.splitlines()
        for line in lines:
            if not line:
                continue
            cols = line.strip().split('\t')
            if len(cols) != 3:
                raise Exception(
                    'Expected 3 columns, found %d:\n%s\nfull output:\n%s' % (len(cols), cols, out))
            hsh, date, reldate = cols
            map(lambda bi: bi.set_dates(date, reldate),
                self.branches_by_hash[hsh])

        self.branches = sorted(
            self.branches_by_name.values(), key=lambda bi: bi.datetime, reverse=True)

        map(self.set_max, [
            'remote', 'ahead_str', 'behind_str', 'reldate', 'hash'])

        print ''
        for bi in self.branches:
            print bi.to_string(self.maxs)
        print ''

