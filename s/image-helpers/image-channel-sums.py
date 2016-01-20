#!/usr/bin/env python

import pickle
from os import path
import sys

import numpy as np
from skimage.io import imread

for arg in sys.argv[1:]:
    outfile = path.join(path.dirname(arg), path.splitext(arg)[0] + '.stats')
    if path.exists(outfile):
        print("Already found %s; continuing" % outfile)
        continue

    img = imread(arg).astype(float)
    shape = img.shape
    num = 1
    for d in img.shape[:-1]:
        num *= d

    sums = np.asarray([ img[:,:,i].sum() for i in range(3) ])
    #means = sums / num

    squares = np.square(img)
    sum_squares = np.asarray([ squares[:,:,i].sum() for i in range(3) ])

    print("Writing to %s:\n%d\n%s\n%s" % (outfile, num, sums, sum_squares))
    with open(outfile, 'wb') as f:
        pickle.dump(
                {
                    "num": num,
                    "sums": sums,
                    "squares": sum_squares
                },
                f
        )

    #sq_means = sum_squares / num

    # mean_squares = means*means
    # variances = sq_means - mean_squares
    # stddevs = np.sqrt(variances)
    #
    # print("UL:", img[100][100])
    # print("UL sq:", squares[100][100])
    # print("shape:", img.shape)
    # print("squares shape:", squares.shape)
    # print("num:", num)
    # print("sums:", sums)
    # print("means:", means)
    # print("sum_squares:", sum_squares)
    # print("sq_means:", sq_means)
    # print("vars:", variances)
    # print("stddevs:", stddevs)
