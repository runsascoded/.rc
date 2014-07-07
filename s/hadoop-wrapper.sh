#!/bin/sh

if [ ! $(which hadoop) ]; then

  ssh demeter "hadoop fs -${@}"

else

  hadoop fs -${@}

fi
