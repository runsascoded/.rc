#!/usr/bin/env python

import argparse
from os.path import exists, splitext
import pickle
import sys

import numpy as np

from skimage.io import imread

parser = argparse.ArgumentParser()
parser.add_argument('-s', '--stats', dest='stats_file', default='stats', help='stats file with mean and stddev to normalize with')
parser.add_argument('images', metavar='I', type=str, nargs='+', help='image files to normalize')

opts = parser.parse_args(sys.argv[1:])
with open(opts.stats_file, 'rb') as f:
    o = pickle.load(f)
    means = np.asarray(o['means'])
    stddevs = np.asarray(o['stddevs'])

print("Means: %s\nStddevs: %s" % (means, stddevs))

for arg in sys.argv[1:]:
    img = (imread(arg).astype(float) - means) / stddevs
    outfile = splitext(arg)[0] + '.npy'
    if exists(outfile):
        print("%s already exists" % outfile)
        continue
    print("Writing %s" % outfile)
    np.save(outfile, img)

