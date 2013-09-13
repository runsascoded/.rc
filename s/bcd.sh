#!/bin/sh

A=test/jvm/com/foursquare/coremodel
B=test/jvm/com/foursquare/counters
C=test/jvm/com/foursquare/dbtests
D=test/jvm/com/foursquare/game/model

run() {
    label=$1
    shift
    args=$@
    # echo /tmp/$label
    ./pants test $args > /tmp/$label
    echo "$label: $?"
}

run 'bcd' $B $C $D
run 'bc' $B $C
run 'bd' $B $D
run 'cd' $C $D

# ./pants test $B $C $D > /tmp/bcd
# echo "bcd: $?"

# ./pants test $B $C > /tmp/bc
# echo "bc: $?"

# ./pants test $B $D > /tmp/bd
# echo "bd: $?"

# ./pants test $C $D > /tmp/cd
# echo "cd: $?"

