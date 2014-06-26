#!/usr/bin/python

import fileinput
import re
import sys

cols = map(int, sys.argv[1].split(','))
sys.argv = sys.argv[1:]

for line in fileinput.input():
    l = re.split('\s+', line.strip())
    for col in cols:
        if abs(col) >= len(l):
            continue

        # print l
        # print col
        print l[col],
    print ''
