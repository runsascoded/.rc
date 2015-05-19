# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc

test -r /sw/bin/init.sh && . /sw/bin/init.sh

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$HOME/.jenv/bin:$PATH"

if which jenv &> /dev/null; then
  JAVA_HOME_bak="$JAVA_HOME"
  eval "$(jenv init -)"
  export JAVA_HOME="$JAVA_HOME_bak"
fi

# added by Anaconda3 2.2.0 installer
export PATH="/Users/ryan/anaconda/bin:$PATH"
