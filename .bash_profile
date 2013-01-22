# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc

test -r /sw/bin/init.sh && . /sw/bin/init.sh

##
# Your previous /Users/ryan/.bash_profile file was backed up as /Users/ryan/.bash_profile.macports-saved_2012-10-24_at_00:10:41
##

# MacPorts Installer addition on 2012-10-24_at_00:10:41: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
