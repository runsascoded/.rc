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

# IP vars
export EIP="184.73.189.241"
#export HOMEIP="66.65.177.142"
export LOKOIP="192.168.1.131"
export CHROMECAST_MAC="D0:E7:82:55:CD:86"

export RPIIP="192.168.1.106"
alias srpi="ssh ryan@$RPIIP"


# Set up JAVA_HOME, jenv
# rm this temporarily; trying to use jenv instead...
export java_home_cmd="/usr/libexec/java_home"
if [ -x "$java_home_cmd" ]; then

    if which jenv &> /dev/null; then
      jenv_version=$(jenv version | grep --color=none -o '1\.[0-9]*')
    else
      jenv_version=1.8
    fi

    debug "Setting java version from jenv: $jenv_version"
    export JAVA_HOME=$($java_home_cmd -v $jenv_version)
    debug "Set: $JAVA_HOME"

    export JAVA6_HOME=$($java_home_cmd -v 1.6)
fi

export SCALA_HOME="/usr/local/Cellar/scala/2.10.3/libexec"
export SCALA="$SCALA_HOME"
export ANDROID="$HOME/lib/android-sdk-mac_x86"


# EC2 creds, paths
export EC2_HOME="$HOME/.ec2"
if [ -e "ls $EC2_HOME/pk-*.pem" ]; then
    export EC2_PRIVATE_KEY=`ls "$EC2_HOME"/pk-*.pem`
fi
if [ -e "ls $EC2_HOME/cert-*.pem" ]; then
    export EC2_CERT=`ls "$EC2_HOME"/cert-*.pem`
fi


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


# $EDITOR, $DIFF
export EDITOR=emacs
if whch mld; then
    export DIFF=mld
elif whch meld; then
    export DIFF=meld
fi


# Postgres paths
export PGDIR=/Applications/Postgres.app/Contents/MacOS
export PGHOME=$PGDIR/bin
#export PGDATA=$HOME/Library/Application\ Support/Postgres/var/
export PGDATA=/usr/local/postgres9.3.1/data
append_to_path "$PGHOME"


#export RUBYOPT=rubygems
#export GLOG_logtostderr=1
prepend_to "C_INCLUDE_PATH" "/usr/local/include"


# Make aliases
alias mkae="make"
alias maek="make"
alias kmae="echo 'seriously ryan? go to bed, sober up, and try again'"
alias dmake="DEBUG=1 make"


### START-Keychain ###
# Let  re-use ssh-agent and/or gpg-agent between logins
which keychain &> /dev/null
if [ 0 -eq $? ]; then
    keychain "$HOME/.ssh/github_rsa"
    source "$HOME/.keychain/$HOSTNAME-sh"
fi
### End-Keychain ###


# General utilities
alias pe="perl -pe"
alias bn="basename"
alias y="echo yes"
alias n="echo no"
alias dush="du -s -h"
alias sopen='open -a Sublime\ Text\ 2.app'
#alias top="top -o cpu"
alias tp="htop --sort-key cpu"
alias es="emerge --search"
#alias mount_mango="sshfs git@mango:/home/git/dev $HOME/mango -oauto_cache,reconnect,volname=mango"
alias chomd="chmod"
alias clean_derived="rm -rf ~/Library/Developer/Xcode/DerivedData/"
alias e="echo"
alias dtab="diff /tmp/a /tmp/b"
alias mtab="meld /tmp/a /tmp/b"
alias pg="ps aux | grep"
alias es="emerge --search"
alias flushdns='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'
alias xt='exit'
export UNAME=$(uname)

# ObjectId utils
alias ppb="python -c \"import sys;i=float(sys.argv[1]);print('%3.1fB' % i if i < 1024.0 else '%3.1fKB' % (i / 1024.0) if i < 1048576.0 else '%3.1fMB' % (i / 1048576.0) if i < 1073741824.0 else '%3.1fGB' % (i / 1073741824.0) if i < 1099511627776.0 else '%3.1fTB' % (i / 1099511627776.0))\""
alias oiddate="python -c \"import struct;import sys;import datetime;print(datetime.datetime.utcfromtimestamp(struct.unpack('>i', sys    .argv[1].decode('hex')[0:4])[0]))\""


# Navigation aliases
alias c=". ~/s/c"
alias s="pushd .; cd ~/s"
alias go="pushd .; cd"

alias u="cd .."
alias uu="cd ../.."
alias uuu="cd ../../.."
alias uuuu="cd ../../../.."
alias psh="pushd ."
alias pop="popd"
alias p="popd"
alias b="popd"


# `ls` aliases
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias llt="ls -ltr"
alias lh="ls -lh"
alias lhs="ls -lhS"
alias lss="ls -lSr"


# Git aliases
alias gcd="g cd"
alias gf="git fetch"
alias gfo="git fetch origin"

try_source "$HOME/.gitcomplete"
try_source "$HOME/.git-completion.bash"

alias gd="git diff"
alias gdc="gd --cached"
alias gln="git lg"
alias gs="git status"
alias gb="g b"
alias gl="git lg"
alias gls="git ls-files"

alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit -a"
alias gcam="git commit -a -m"

alias garc='git arc'
alias garcs='git arc src'
alias guu='git conflicting'

alias grt=". ~/s/git-root"
alias gr="git remote -vv"
alias gsh="gn sh"  # git-show-short
alias rmu="git ls-files --other --exclude-standard | xargs rm -f"
alias snippets='git log --since "8days" --oneline --author ryan'

alias gss="git stash save"
alias gsa="git stash apply"
alias gsp="git stash pop"
alias gsl="gn sl"
alias gss="g ss"

export MIRROR_REMOTES="devbox,rpi,demeter"
#append_to_path "/usr/local/git/bin"


# `screen` aliases
alias rscr="screen -r -S"
alias dscr="screen -D -S"


# PYTHONPATH
append_to "PYTHONPATH" "$HOME/c/mongo-python-driver/"
append_to "PYTHONPATH" "/Library/Python/2.7/site-packages"

append_to "PYTHONPATH" "$s"
append_to "PYTHONPATH" "$s/py"
append_to "PYTHONPATH" "$s/git"
append_to "PYTHONPATH" "$s/git/util"

# Hammerlab internal-tools PYTHONPATH
append_to "PYTHONPATH" "$ints/scripts/git"
append_to "PYTHONPATH" "$ints/scripts/git/util"


# Sinai path vars
export sinai="$HOME/sinai"

export data="$sinai/data"
export DATA="$data"

export guac="$sinai/guacamole"
export GUAC="$guac"

export ints="$sinai/internal-tools"
export INTERNAL_TOOLS="$ints"

export guac_tools="$ints/scripts/guacamole"
export mvn_tools="$ints/scripts/mvn-utils"
export jar_tools="$ints/scripts/jar-utils"

append_to_path "$guac_tools" "$mvn_tools" "$jar_tools"

# Sinai Hadoop/Demeter paths
export hhome="/user/willir31"
export hh="$hhome"
export hdfs="hdfs://demeter-nn1.demeter.hpc.mssm.edu"
export Hhome="${hdfs}${hhome}"
export Hh="${hdfs}${hh}"
export HH="$Hh"

export hdata="${hh}/data"
export Hdata="${hdfs}${hdata}"

export h100k="${hdata}/100k"
export H100k="${hdfs}${h100k}"

export hout="${h100k}/out"
export Hout="${hdfs}${hout}"

export dream="/datasets/dream/data"
export training="$dream/training"

# Guac dependency paths
export ADAM="$HOME/c/adam"
export SPARK="$HOME/c/spark"
export PICARD="$HOME/c/picard"
export HADOOP_BAM="$HOME/c/hadoop-bam"

alias gdos="guacamole-demeter-over-ssh"


### LESS options ###
export LESS=

# case-insensitive search
export LESS="$LESS -i"

# show bash colors
export LESS="$LESS -R"

# auto-number lines
export LESS="$LESS -N"

# don't wrap lines
export LESS="$LESS -S"


if which brew &> /dev/null; then
  export cellar=$(brew --prefix)/Cellar
fi

#[ -s "/Users/ryan/.scm_breeze/scm_breeze.sh" ] && source "/Users/ryan/.scm_breeze/scm_breeze.sh"

# Maven aliases
alias mvnp="mvn package -DskipTests"
alias mvncp="mvn clean package -DskipTests"

export m2="$HOME/.m2/repository"
export M="$m2"


# For ADAM
export "MAVEN_OPTS=-Xmx512m -XX:MaxPermSize=128m"
export m2adam="$m2/org/bdgenomics/adam"

alias adam='java -jar /Users/ryan/c/neal-adam/adam-cli/target/adam-0.6.1-SNAPSHOT.jar'
alias a2v="adam adam2vcf"
alias v2a="adam vcf2adam"


set-java() {
  export JAVA_HOME=$(/usr/libexec/java_home -v $1)
  jenv_version=$(jenv versions | grep --color=never -o "[^ ]*$1[^ ]*")
  if [ $? -eq 0 ]; then
    echo "Found $jenv_version"
    jenv global $jenv_version
    jenv shell $jenv_version
  fi
}

dedupe_path_var PATH
dedupe_path_var PYTHONPATH
dedupe_path_var NODE_PATH

# Foursquare aliases
alias fwop="./fs web --opinionator=pants --apirouter=pants"
alias gen-soy="./pants gen --gen-custom-soy-langs=scala"
alias gen-thrift="./pants gen --gen-custom-thrift-langs=scala_record"
alias lbgsc="gfl; ./fs bg && ./fs sc"
alias bgsc="./fs bg && ./fs sc"
alias sc="./fs sc"
alias lbg="gfl; ./fs bg"
alias mongo_test='mkdir /tmp/mongo-testdb; mongod --dbpath /tmp/mongo-testdb --maxConns 1500'
export sjcf=src/jvm/com/foursquare
export tjcf=test/jvm/com/foursquare
export PANTS_DEV=1
alias sdr="ssh dev-ryan"
alias devport="ssh dev-ryan sudo /usr/sbin/lsof -P -i TCP | grep 7136"

try_source "$HOME/.foursquarerc"


try_source ".colors-rc"
try_source ".grep-rc"
try_source ".history-rc"
try_source ".js-rc"
try_source ".locale-rc"
try_source ".rpi-rc"
try_source ".source-rc"

