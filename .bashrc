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

# Path env-var shorthands
export home="$HOME"
export c="$HOME/c"
export C="$c"

export GITHUBUSER="ryan-williams"
export GITHUB_USER="ryan-williams"

export s="$HOME/s"
export S="$s"
export SRCDIR="$s"

export dl="$HOME/Downloads"
export DL="$dl"

export SOURCEME_DIR="$s/source-files"
try_source() {
    for arg in "$@"; do
        if [ -s "$arg" ]; then
            source "$arg"
        elif [ -s "$SOURCEME_DIR/$arg" ]; then
            source "$SOURCEME_DIR/$arg"
        else
          debug "Couldn't source nonexistent file: '$arg'"
        fi
    done
}

alias awch=". alias-which"
alias aw=". alias-which"

try_source ".vars-rc"
try_source ".path-rc"

try_source ".maven-rc"
try_source ".sinai-rc"

try_source ".brew-rc"
try_source ".colors-rc"
try_source ".less-rc"
try_source ".ec2-rc"
try_source ".editor-rc"

export gh="$c/git-helpers"
export gha="$gh/aliases"
try_source "$gh/.git-rc"

try_source ".grep-rc"
try_source ".history-rc"
try_source ".java-rc"
try_source ".js-rc"
try_source ".keychain-rc"
try_source ".ls-rc"
try_source ".locale-rc"
try_source ".misc-rc"
try_source ".nav-rc"
try_source ".postgres-rc"
try_source ".pythonpath-rc"
try_source ".rpi-rc"
try_source ".rsync-rc"
try_source ".screen-rc"
try_source ".source-rc"
try_source "$s/watchman-helpers/.watchman-rc"

dedupe_path_var PATH PYTHONPATH NODE_PATH

export MIRROR_REMOTES="demeter,rpi"

# added by travis gem
if [ -f /Users/ryan/.travis/travis.sh ]; then
  source /Users/ryan/.travis/travis.sh
fi

# OPAM configuration
. /Users/ryan/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

