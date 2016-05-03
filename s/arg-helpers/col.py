#!/usr/bin/env python

import argparse
import fileinput
import re
import sys

parser = argparse.ArgumentParser(description='Process some integers.')

parser.add_argument(
    '-i',
    '-in',
    '--in-seperator',
    #metavar='in',
    dest="input_delimiter",
    #action="store_str",
    type=str,
    help="input field seperator regex",
    default='\s+'
)

parser.add_argument(
    '-o',
    '-out',
    "--output-delimiter",
    #metavar="out",
    dest="output_delimiter",
    type=str,
    help="output field delimiter",
    default=" "
)

parser.add_argument(
    '-k',
    '--keep-original-range-spacing',
    dest="keep_original_range_spacing",
    #type=bool,
    action="store_true",
    help="When true, will preserve input's (white-)spacing in colon-delimited columnar ranges",
    default=False
)

args, unknown = parser.parse_known_args()

output_delimiter = args.output_delimiter#.decode('string-escape')
#print("out delim: %s" % output_delimiter)

def parse_col(arg):
    segments = arg.split(':')
    if len(segments) == 1:
        start = 2*int(arg)
        if start < 0:
            start += 1
            end = min(start + 2, 0)
        else:
            end = start + 2
        return (start, None if not end else end)
    if len(segments) == 2:
        start = None
        if segments[0] != '':
            start = 2*int(segments[0])
            if start < 0:
                start += 1

        end = None
        if segments[1] != '':
            end = 2*int(segments[1])
            if end < 0:
                end += 1

        return (start, end)

    raise Exception('Malformed arg: %s' % arg)

cols = [parse_col(c) for c in unknown[0].split(',')]
sys.argv = unknown[0:]

from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE, SIG_DFL)

for line in fileinput.input():
    l = re.split('(%s)' % args.input_delimiter, line.strip())

    offset = 0

    first = True
    for col in cols:

        if args.keep_original_range_spacing:
            slice = l[
                    (None if col[0] == None else col[0] + offset):(None if col[1] == None else col[1] + offset)
            ]
            joiner = ''
        else:
            slice = l[
                    (None if col[0] == None else col[0]):(None if col[1] == None else col[1]):2
            ]
            joiner = output_delimiter

        if not first:
            sys.stdout.write(output_delimiter)

        first = False

        sys.stdout.write(joiner.join(slice).strip())
    print('')
