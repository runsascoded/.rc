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

load_helpers() {
    for module in "$@"; do
        if [ -d "$module" ]; then
          debug "Adding $module to \$PATH and sourcing rc files..."
          try_source "$module"/.*-rc
          prepend_to_path "$module"
        else
          debug "Couldn't source nonexistent file: '$arg'"
        fi
    done
}


load_helpers bash  # load this module first; it provides `prepend_to_path` above!

load_helpers which
load_helpers brew  # which
load_helpers py  # brew, path

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
	gcloud git go gradle grep \
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

export gh="$REPO/git-helpers"
export gha="$gh/aliases"

dedupe_path_var PATH PYTHONPATH NODE_PATH
