#!/bin/sh

if [ "$HOSTNAME" == demeter* ]; then

  hadoop fs -"$@"

else

  ssh demeter "hadoop fs -${@}"

fi
