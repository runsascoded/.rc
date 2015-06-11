#!/usr/bin/env bash
# Script running for phabricator arcanist command-line tool.
# This checks to see if it's been installed. If not, it downloads and
# installs phabricator.
# In any case, it then runs the installed phabricator arc script.

PHAB_DIR=$HOME/s/arc

if [ ! -e "$PHAB_DIR" ]; then
  mkdir -p $PHAB_DIR
  cd $PHAB_DIR
  git clone git://github.com/facebook/libphutil.git
  git clone git://github.com/facebook/arcanist.git
  cd ../..
fi

cp ~/.arcconfig ./.arcconfig
$PHAB_DIR/arcanist/bin/arc $*
rm -f .arcconfig
