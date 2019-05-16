# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

debug() {
  if [ ! -z "$VERBOSE" -o ! -z "$DEBUG" ]; then
    echo $@
  fi
}

vb() {
  if [ -n "$VERBOSE" ]; then
    unset VERBOSE
    echo "quiet mode enabled"
  else
    export VERBOSE=1
    echo "verbose mode enabled"
  fi
}

# Uncomment to log info about files being sourced, etc.
# VERBOSE=1

export REPO="$(dirname "${BASH_SOURCE[0]}")"

try_source() {
    for arg in "$@"; do
        if [ -s "$arg" ]; then
            debug "Sourcing: $arg"
            source "$arg"
        else
          debug "Couldn't source nonexistent file: '$arg'"
        fi
    done
}

export MODULES="$REPO"
load_helpers() {
    for module in "$@"; do
        local dir="$MODULES/$module"
        if [ -d "$dir" ]; then
          debug "Adding $dir to \$PATH and sourcing rc files..."
          try_source "$dir"/.*-rc
          prepend_to_path "$dir"
          ssh_config="$dir/.ssh/config"
          if [ -s "$ssh_config" ]; then
            local line="Include $ssh_config"
            if grep -q "$line" "$HOME/.ssh/config"; then
              debug "SSH config already Included: $ssh_config"
            else
              debug "Adding ssh config: $ssh_config"
              echo "Include $ssh_config" >> "$HOME/.ssh/config"
            fi
          fi
          gitignore="$dir/global.gitignore"
          if [ -s "$gitignore" ]; then
            debug "Adding global git ignore file: $gitignore"
            git add-global-ignore "$gitignore"
          fi
          gitconfig="$dir/.gitconfig"
          if [ -s "$gitconfig" ]; then
            debug "Adding global git config file: $gitconfig"
            git-add-global-file include.path "$gitconfig"
          fi
        else
          debug "Couldn't source nonexistent file: '$dir'"
        fi
    done
}

load_helpers bash  # load this module first; it provides `prepend_to_path` above!
load_helpers path

load_helpers git  # this module should stand alone / be import-able outside of this repo

load_helpers which
load_helpers brew  # which

# which
load_helpers diff file path jar osx

load_helpers maven
load_helpers sinai  # which, maven

load_helpers \
	adam arg audio \
	bash bigwig \
	"case" col color comm \
	datetime dict docker dropbox \
	emacs \
	find \
	gcloud go gradle grep \
	hadoop head-tail histogram \
	image influx \
	js \
	kubectl \
	less line ls \
	nav net num \
	objid ocaml \
	parallel perl perms postgres \
	returncode rsync ruby \
	samtools sbt scala screen size slim spark sort ssh \
	travis \
	watchman whitespace \
	xml \
	zinc zip

load_helpers py  # brew, path; also make sure pyenv is first on path

export gh="$REPO/git-helpers"
export gha="$gh/aliases"

dedupe_path_var PATH PYTHONPATH NODE_PATH
