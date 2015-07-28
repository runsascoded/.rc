#!/usr/bin/env bash

for f in $(ls /tmp/patches)
do
    c=$(find src/jvm/com/foursquare/apiserver/snippet -name $f | wc -l)
    if [ $c -ne 1 ]
    then
        echo "$f: $c"
        continue
    fi
    real=$(find src/jvm/com/foursquare/apiserver/snippet -name $f)
    patch $real /tmp/patches/$f
    if [ $? -eq 0 ]; then
        echo "Success: $f"
        mkdir -p /tmp/old_patches
        mv /tmp/patches/$f /tmp/old_patches
    fi
    break
done
