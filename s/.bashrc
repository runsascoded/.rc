
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

# Path env-var shorthands
export home="$HOME"
export c="$HOME/c"
export C="$c"

export GITHUBUSER="ryan-williams"
export GITHUB_USER="ryan-williams"

export REPO="$(dirname "${BASH_SOURCE[0]}")"

export s="$REPO"
export S="$s"
export SRCDIR="$s"

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
        elif [ -d "$c/$dir" ]; then
          debug "Adding $c/$dir to \$PATH and sourcing rc files..."
          prepend_to_path "$c/$dir"
          try_source "$c/$dir"/.*-rc
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


try_source "$c/bash-helpers/vars/.vars-rc"

source_and_path "$c/demeter-kickstart/scripts"

source_and_path which-helpers

source_and_path brew-helpers  # which
source_and_path py-helpers    # brew, path

append_to_path "$c/yarn-logs-helpers"
source_and_path maven-helpers

source_and_path diff-helpers  # which
source_and_path file-helpers  # which
source_and_path path-helpers  # which
source_and_path jar-helpers   # which
source_and_path osx-helpers   # which

export SPARK_BUILD_ARGS="-Pyarn"
source_and_path "$c"/spark-helpers
export sh="$c/spark-helpers"

source_and_path "$c"/adam-helpers
source_and_path "$c"/samtools-helpers
source_and_path "$c"/screen-helpers

source_and_path arg-helpers
source_and_path bash-helpers
source_and_path bigwig-helpers
source_and_path audio-helpers
source_and_path case-helpers
source_and_path collectd-helpers
source_and_path col-helpers
source_and_path color-helpers
source_and_path comm-helpers
source_and_path datetime-helpers
source_and_path dict-helpers
source_and_path docker-helpers
source_and_path dropbox-helpers
source_and_path emacs-helpers
source_and_path find-helpers
source_and_path gcloud-helpers
source_and_path go-helpers
source_and_path gradle-helpers
source_and_path grep-helpers
source_and_path hadoop-helpers
source_and_path head-tail-helpers
source_and_path histogram-helpers
source_and_path image-helpers
source_and_path influx-helpers
source_and_path js-helpers
source_and_path kubectl-helpers
source_and_path less-helpers
source_and_path line-helpers
source_and_path ls-helpers
source_and_path nav-helpers
source_and_path net-helpers
source_and_path num-helpers
source_and_path objid-helpers
source_and_path ocaml-helpers
source_and_path parallel-helpers
source_and_path perl-helpers
source_and_path perms-helpers
source_and_path postgres-helpers
source_and_path returncode-helpers
source_and_path rsync-helpers
source_and_path ruby-helpers
source_and_path sbt-helpers
source_and_path scala-helpers
source_and_path size-helpers
source_and_path slim-helpers
source_and_path sort-helpers
source_and_path ssh-helpers
source_and_path travis-helpers
source_and_path watchman-helpers
source_and_path whitespace-helpers
source_and_path xml-helpers
source_and_path zinc-helpers
source_and_path zip-helpers

source_and_path "$s"/sinai  # which, yarn-logs-helpers, maven

try_source "$s/git-configs/.git-rc"
export gh="$c/git-helpers"
export gha="$gh/aliases"
try_source "$gh/.git-rc"

try_source "$c/z/z.sh"
try_source "$c/commacd/.commacd.bash"

try_source ".ec2-rc"
try_source ".history-rc"
try_source ".locale-rc"
try_source ".rpi-rc"

# git-helpers
export DEFAULT_REMOTE=upstream

append_to_path "$HOME/ipfs"

export GIT_PS1_DESCRIBE_STYLE=branch

export YAAFE_PATH="/Users/ryan/yaafelib/yaafe_extensions"
#append_to PYTHONPATH /Users/ryan/yaafelib
append_to PYTHONPATH "$HOME"
#append_to PATH "$YAAFE_PATH"

export smr=src/main/resources
export sms=src/main/scala
export str=src/test/resources
export sts=src/test/scala

dedupe_path_var PATH PYTHONPATH NODE_PATH

ea LFS_ADMINUSER foo
ea LFS_ADMINPASS bar
ea LFS_SCHEME http
ea LFS_HOST http

. $c/tgmi/.tagomi-rc
