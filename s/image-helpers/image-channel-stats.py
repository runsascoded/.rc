#!/usr/bin/env python

import numpy as np
import pickle
import sys

num = 0
sums = 0
squares = 0

for arg in sys.argv[1:]:
    with open(arg, 'rb') as fd:
        o = pickle.load(fd)
        num += o['num']
        sums += o['sums']
        squares += o['squares']

print(num)
print(sums)
print(squares)

sums = np.asarray(sums)
squares = np.asarray(squares)

means = sums / num
sq_means = squares / num

mean_squares = means*means
variances = sq_means - mean_squares
stddevs = np.sqrt(variances)

print("num:", num)
print("sums:", sums)
print("means:", means)
print("sum_squares:", squares)
print("sq_means:", sq_means)
print("vars:", variances)
print("stddevs:", stddevs)

with open('stats', 'wb') as f:
    pickle.dump(
            {
                'means': means,
                'stddevs': stddevs
            },
            f
    )
