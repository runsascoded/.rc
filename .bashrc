# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

export UNAME=$(uname)

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

if [ -e $HOME/.rpi_bashrc ]; then
    source $HOME/.rpi_bashrc
fi

# virtualenvwrapper
#export WORKON_HOME=$HOME/Projects/virtualenvs
#source /usr/local/bin/virtualenvwrapper.sh

export SRCDIR=$HOME/s

export PANTS_DEV=1

if [ $RPI ]; then
    echo "rpi.. setting LC_ALL=C"
    export LC_ALL=C
else
    echo "not rpi.. setting LC_ALL=en_US.UTF-8"
    export LC_ALL=en_US.UTF-8
fi

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export TZ=UTC

export NODE_PATH="$NODE_PATH:."

export USE_LIBPCRE=yes

alias chomd="chmod"
alias clean_derived="rm -rf ~/Library/Developer/Xcode/DerivedData/"
alias g="git"

alias grp="ggrep"

export GREP_OPTIONS="--color=auto"

alias ppb="python -c \"import sys;i=float(sys.argv[1]);print('%3.1fB' % i if i < 1024.0 else '%3.1fKB' % (i / 1024.0) if i < 1048576.0 else '%3.1fMB' % (i / 1048576.0) if i < 1073741824.0 else '%3.1fGB' % (i / 1073741824.0) if i < 1099511627776.0 else '%3.1fTB' % (i / 1099511627776.0))\""
alias oiddate="python -c \"import struct;import sys;import datetime;print(datetime.datetime.utcfromtimestamp(struct.unpack('>i', sys    .argv[1].decode('hex')[0:4])[0]))\""

alias dtab="diff /tmp/a /tmp/b"
alias mtab="meld /tmp/a /tmp/b"

alias sdr="ssh dev-ryan"

export HISTSIZE=1000000
export HISTFILESIZE=1000000
shopt -s histappend
export PROMPT_COMMAND="history -a"

source ~/.git-completion.bash

alias hn="history -n"
alias devport="ssh dev-ryan sudo /usr/sbin/lsof -P -i TCP | grep 7136"

alias flushdns='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'

alias garc='git arc'
alias garcs='git arc src'
alias guu='git conflicting'

alias xt='exit'

# Put your fun stuff here.

try_source() {
    for arg in $@; do
        if [ -e "$arg" ]; then
            source $arg
        fi
    done
}

try_source "/etc/bash_completion"
try_source "$HOME/.gitcomplete"

# Set colorful prompt
source ~/s/prompt_colors
export PS1="$On_IYellow$BIBlack \t $clear $BBlue\u$clear@$BGreen\h$clear: $BPurple\W$clear$BRed\$(__git_ps1 :%s)$clear\$ "

# Export bash colors
source ~/s/bash_colors


export EIP="184.73.189.241"
export HOMEIP="66.65.177.142"
export RPIIP="192.168.1.106"
export LOKOIP="192.168.1.131"
export CHROMECAST_MAC="D0:E7:82:55:CD:86"

alias srpi="ssh ryan@$RPIIP"

export SCALA=/usr/local/Cellar/scala/2.9.1/libexec
export ANDROID=$HOME/lib/android-sdk-mac_x86
export EC2_HOME=$HOME/.ec2
export PATH=$PATH:$EC2_HOME/bin:/usr/local/git/bin:$HOME/bin:$HOME/play-2.1.0

export PATH="$PATH:$HOME/sinai/internal-tools/scripts/guacamole"
alias gdos="guacamole-demeter-over-ssh"


# Path env-var shorthands
export c=$HOME/c
export s=$HOME/s
export dl=$HOME/Downloads/
export m2=$HOME/.m2/repository

export dream=/datasets/dream/data
export training=$dream/training

export sinai=$HOME/sinai
export data=$sinai/data
export guac=$sinai/guacamole


java_home_cmd="/usr/libexec/java_home"
if [ -x "$java_home_cmd" ]; then
    export JAVA_HOME=$($java_home_cmd -v 1.8)
fi

if [ -e "ls $EC2_HOME/pk-*.pem" ]; then
    export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
fi
if [ -e "ls $EC2_HOME/cert-*.pem" ]; then
    export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
fi

try_source "$HOME/.foursquarerc" "$HOME/.asanarc"

export sjcf=src/jvm/com/foursquare
export tjcf=test/jvm/com/foursquare


# Env vars
export PATH=${PATH}":/opt/google/depot_tools:/usr/sbin:/usr/include:$HOME/s:$HOME/s/git:$HOME/s/hadoop:/sbin:/sw/bin"
export EDITOR=emacs
if [ ! -z "$(which meld 2> /dev/null)" ]; then
    export DIFF=meld
#elif [ ! -z "$(which opendiff)" ]; then
#    export DIFF=opendiff
fi

# PostgresApp
export PGDIR=/Applications/Postgres.app/Contents/MacOS
export PGHOME=$PGDIR/bin
#export PGDATA=$HOME/Library/Application\ Support/Postgres/var/
export PGDATA=/usr/local/postgres9.3.1/data
export PATH=${PATH}:$PGHOME

#export RUBYOPT=rubygems
export GLOG_logtostderr=1
export C_INCLUDE_PATH=/usr/local/include:$C_INCLUDE_PATH

# Making
alias dmake="DEBUG=1 make"

alias pgrp="pcregrep"

# Making
alias mkae="make"
alias maek="make"
alias kmae="echo 'seriously ryan? go to bed, sober up, and try again'"

#alias lpants='export BUILD_NUMBER=$(date +%y%m%d%H%M%S); echo "BUILD NUMBER: $BUILD_NUMBER"; time ./pants compile -u -x --mongo-hosts=localhost --mongo-port=27001 --mongo-db=pants --mongo-collection=timings'

#alias top="top -o cpu"
alias tp="htop --sort-key cpu"

alias rmu="git ls-files --other --exclude-standard | xargs rm -f"
alias es="emerge --search"

alias mongo_test='mkdir /tmp/mongo-testdb; mongod --dbpath /tmp/mongo-testdb --maxConns 1500'
alias mount_mango="sshfs git@mango:/home/git/dev $HOME/mango -oauto_cache,reconnect,volname=mango"

### START-Keychain ###
# Let  re-use ssh-agent and/or gpg-agent between logins
which keychain &> /dev/null
if [ 0 -eq $? ]; then
    keychain $HOME/.ssh/github_rsa
    source $HOME/.keychain/$HOSTNAME-sh
fi
### End-Keychain ###

# Sourcing
alias resource="unalias resource; source ~/.bashrc"

# Navigating
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

# Inspecting files
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias llt="ls -ltr"
alias lh="ls -lh"
alias lhs="ls -lhS"
alias lss="ls -lSr"

alias pg="ps aux | grep"
alias es="emerge --search"

# Git aliases
if [ -z "$DIFF" ]; then
    alias gd="git diff"
else
    alias gd="git difftool -y -t $DIFF"
fi
alias gln="git lg"
alias gdc="gd --cached"
alias gs="git status"
alias gb="g b"
alias gl="git lg"
alias gls="git ls-files"
alias gc="git commit -a"
alias grt=". ~/s/git-root"
alias gr="git remote -vv"
alias gf="git fetch"
alias gss="git stash save"
alias gsa="git stash apply"
alias gsp="git stash pop"

alias rscr="screen -r -S"
alias dscr="screen -D -S"

export PYTHONPATH="$HOME/c/mongo-python-driver/:$HOME/s:$HOME/s/py:$HOME/s/git:/Library/Python/2.7/site-packages:$PYTHONPATH"

export MIRROR_REMOTES="devbox,rpi,demeter"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# For brew
export PATH="/usr/local/bin:$PATH"

# Add $HOME to $PATH
export PATH="$HOME:$PATH"

export home=$HOME
export hhome=/user/willir31

# default to case-insensitive search in `less`
export LESS="-i -R"

if which brew &> /dev/null; then
  export cellar=$(brew --prefix)/Cellar
fi

#[ -s "/Users/ryan/.scm_breeze/scm_breeze.sh" ] && source "/Users/ryan/.scm_breeze/scm_breeze.sh"
alias adam='java -jar /Users/ryan/c/neal-adam/adam-cli/target/adam-0.6.1-SNAPSHOT.jar'
alias a2v="adam adam2vcf"
alias v2a="adam vcf2adam"
alias fwop="./fs web --opinionator=pants --apirouter=pants"
alias snippets='git log --since "8days" --oneline --author ryan'
alias sopen='open -a Sublime\ Text\ 2.app'

alias gfo="git fetch origin"
alias gfl="git fixlint"
alias pe="perl -pe"
alias gfl="git fixlint"
alias gen-soy="./pants gen --gen-custom-soy-langs=scala"
alias gen-thrift="./pants gen --gen-custom-thrift-langs=scala_record"
alias lbgsc="gfl; ./fs bg && ./fs sc"
alias bgsc="./fs bg && ./fs sc"
alias sc="./fs sc"
alias lbg="gfl; ./fs bg"
alias gcd="g cd"
alias rsrc="source ~/.bashrc"
