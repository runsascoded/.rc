#!/usr/bin/env python

import sys

num = 0
prev_printed_len = 0
while True:
    line = sys.stdin.readline()
    if not line:
        break
    num += 1
    if num % 1 == 0:
      print '%s%d' % ('\b' * prev_printed_len, num),
      sys.stdout.flush()
      prev_printed_len = len(str(num)) + 1
