#!/usr/bin/python

import fileinput
import re
import sys

def parse_col(arg):
    segments = arg.split(':')
    if len(segments) == 1:
        start = 2*int(arg)
        end = 2*int(arg) + 2
        return (start, None if not end else end)
    if len(segments) == 2:
        return (
            None if segments[0] == '' else (2*int(segments[0])),
            None if segments[1] == '' else (2*int(segments[1]))
        )
    raise Exception('Malformed arg: %s' % arg)

cols = map(parse_col, sys.argv[1].split(','))
sys.argv = sys.argv[1:]

for line in fileinput.input():
    l = re.split('(\s+)', line.strip())
    offset = 0
    if l and not l[0]:
        offset = 1
    # print "line: %s, cols: %s" % (l, cols)
    for col in cols:
        slice = l[
                (None if col[0] == None else col[0] + offset):(None if col[1] == None else col[1] + offset)
        ]
        sys.stdout.write(''.join(slice).strip())
    print ''
