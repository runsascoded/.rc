B# /etc/skel/.bash_profile
0;95;c
# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc

test -r /sw/bin/init.sh && . /sw/bin/init.sh


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
