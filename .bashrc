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
  if [ "$VERBOSE" ]; then
    echo $@
  fi
}

try_source ".vars-rc"

# Path env-var shorthands
export home="$HOME"
export c="$HOME/c"
export C="$c"

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

# PATH initialization
#append_to_path "/opt/google/depot_tools"
append_to_path "/usr/sbin"
append_to_path "/usr/include"
append_to_path "/sbin"
append_to_path "/sw/bin"
append_to_path "$HOME/bin"

append_to_path "$s"
append_to_path "$s/arg-helpers"
append_to_path "$s/case-helpers"
append_to_path "$s/diff-helpers"
append_to_path "$s/git"
append_to_path "$s/git/aliases"
append_to_path "$s/hadoop"
append_to_path "$s/hammerlab"
append_to_path "$s/head-tail-helpers"
append_to_path "$s/jar-utils"
append_to_path "$s/ls-helpers"
append_to_path "$s/mvn"
append_to_path "$s/perl"
append_to_path "$s/py"
append_to_path "$s/returncode-helpers"
append_to_path "$s/which-helpers"

# Only put `mld` on PATH if `meld` exists!
if whch meld; then
  append_to_path "$s/mld-dir";
fi

append_to_path "$HOME"  # Add $HOME to $PATH
append_to_path "/usr/local/bin"  # For brew
#append_to_path "$HOME/.rvm/bin"  # Add RVM to PATH for scripting
#append_to_path "/usr/local/heroku/bin"  # Added by the Heroku Toolbelt
#append_to_path "$HOME/play-2.1.0"
#append_to_path "$EC2_HOME/bin"




try_source ".maven-rc"
try_source ".sinai-rc"

try_source ".brew-rc"
try_source ".colors-rc"
try_source ".less-rc"
try_source ".ec2-rc"
try_source ".editor-rc"
try_source ".git-rc"
try_source ".grep-rc"
try_source ".history-rc"
try_source ".java-rc"
try_source ".js-rc"
try_source ".keychain-rc"
try_source ".locale-rc"
try_source ".ls-rc"
try_source ".misc-rc"
try_source ".nav-rc"
try_source ".postgres-rc"
try_source ".pythonpath-rc"
try_source ".rpi-rc"
try_source ".screen-rc"
try_source ".source-rc"

dedupe_path_var PATH PYTHONPATH NODE_PATH

