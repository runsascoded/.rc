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
            debug "Sourcing: $arg"
            source "$arg"
        elif [ -s "$SOURCEME_DIR/$arg" ]; then
            debug "Sourcing: $SOURCEME_DIR/$arg"
            source "$SOURCEME_DIR/$arg"
        else
          debug "Couldn't source nonexistent file: '$arg'"
        fi
    done
}

source_and_path() {
    for dir in "$@"; do
        if [ -d "$dir" ]; then
          debug "Adding $dir to \$PATH and sourcing rc files..."
          prepend_to_path "$dir"
          try_source "$dir"/.*-rc
        elif [ -d "$s/$dir" ]; then
          debug "Adding $s/$dir to \$PATH and sourcing rc files..."
          prepend_to_path "$s/$dir"
          try_source "$s/$dir"/.*-rc
        elif [ -s "$arg" ]; then
            debug "Sourcing: $arg"
            source "$arg"
        elif [ -s "$SOURCEME_DIR/$arg" ]; then
            debug "Sourcing: $SOURCEME_DIR/$arg"
            source "$SOURCEME_DIR/$arg"
        else
          debug "Couldn't source nonexistent file: '$arg'"
        fi
    done
}

alias enw="emacs -nw"

try_source ".vars-rc"

source_and_path "$c"/adam-helpers
source_and_path arg-helpers
source_and_path color-helpers
source_and_path echo-helpers
source_and_path find-helpers
source_and_path grep-helpers
source_and_path js-helpers
source_and_path less-helpers
source_and_path ls-helpers
source_and_path maven-helpers
source_and_path py-helpers
source_and_path rsync-helpers
source_and_path screen-helpers
source_and_path sort-helpers
source_and_path which-helpers
source_and_path "$s"/sinai

try_source ".path-rc"

export SPARK_BUILD_ARGS="-Pyarn"
source_and_path "$c"/spark-helpers

source_and_path bash-helpers
source_and_path brew-helpers
source_and_path comm-helpers
source_and_path diff-helpers
source_and_path file-helpers
source_and_path hadoop-helpers
source_and_path head-tail-helpers
source_and_path jar-helpers
source_and_path net-helpers
source_and_path perl-helpers
source_and_path "$c"/samtools-helpers
source_and_path zinc-helpers

try_source "$s/git-configs/.git-rc"
export gh="$c/git-helpers"
export gha="$gh/aliases"
try_source "$gh/.git-rc"

try_source ".ec2-rc"
try_source ".editor-rc"

try_source "$c/z/z.sh"
try_source "$c/commacd/.commacd.bash"
prepend_to_path "$c/sejda-1.0.0/bin"

prepend_to_path "$s/slim-helpers"

try_source ".history-rc"
try_source ".java-rc"
try_source ".keychain-rc"
try_source ".locale-rc"
try_source ".misc-rc"
try_source ".postgres-rc"
try_source ".rpi-rc"
try_source ".source-rc"
try_source "$s/watchman-helpers/.watchman-rc"

dedupe_path_var PATH PYTHONPATH NODE_PATH

# added by travis gem
if [ -f /Users/ryan/.travis/travis.sh ]; then
  source /Users/ryan/.travis/travis.sh
fi

# OPAM configuration
. /Users/ryan/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

export ZEROS_DIR="$HOME/zeros"
if [ -s /usr/share/dict/words ]; then
  export dict=/usr/share/dict/words
fi

alias pgc="ping google.com"

alias uz="unzip-dir"

alias pyv="python --version"

alias kca="killall CloudApp"
alias mdp="mkdir -p"
alias d="diff"

append_to_path "$HOME/Library/Android/sdk/platform-tools"
append_to_path "$HOME/node_modules/.bin"

# Dropbox
append_to_path "$c/Dropbox-Uploader"
alias db="dropbox_uploader.sh"
alias dbu="dropbox_uploader.sh upload"

alias sal="ssh-add -l"
alias m=man

alias sejda=sejda-console
alias ydl="youtube-dl"


# git-helpers
export DEFAULT_REMOTE=upstream

export sh="$c/spark-helpers"

alias rmf="rm -f"
alias rmrf="rm -rf"

alias tx="tar xvzf"
alias ua=unalias

alias le=less
alias L=less

export GPG_TTY=$(tty)

append_to_path "$HOME/ipfs"

export SLIM_HOME="$c/spree/slim"
export SPREE_HOME="$c/spree"

append_to_path "$HOME/macports/bin"

export GIT_PS1_DESCRIBE_STYLE=branch

export t=$'\t'
export n=$'\n'

export COMM_STRIP_WHITESPACE=1

alias x=xargs
