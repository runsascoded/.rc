#!/usr/bin/python

import re
from subprocess import PIPE, Popen
import sys

regex = '(^|\n).*import scala_soy_library.*\n(\n?)'

files = sys.argv[1:]
for file in files:
    print 'Examining file %s' % file
    with open(file,'r') as fd:
        contents = fd.read()
    m = re.search(regex, contents)
    if not m:
        print '***Skipping %s' % file
        continue
    replacement = m.group(2) if m.group(1) and m.group(2) else ''
    contents = contents[:m.start()] + replacement + contents[m.end():]
    with open(file, 'w') as fd:
        fd.write(contents)
    print '\tWrote %s' % file

