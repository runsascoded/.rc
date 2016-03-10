# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc

test -r /sw/bin/init.sh && . /sw/bin/init.sh

if [ -s "$HOME/.rvm/scripts/rvm" ]; then
  source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

if [ -s "$HOME/.gvm/scripts/gvm" ]; then
  source "$HOME/.gvm/scripts/gvm"
fi

# OPAM configuration
. /Users/ryan/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

export NVM_DIR=~/.nvm
. $(brew --prefix nvm)/nvm.sh

[[ -s "/Users/ryan/.gvm/scripts/gvm" ]] && source "/Users/ryan/.gvm/scripts/gvm"
