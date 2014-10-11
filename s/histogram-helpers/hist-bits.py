#!/usr/bin/python

import argparse
import fileinput
import re
import sys


def int_to_bits(n):
    bits = []
    t = 1
    sign = 1
    if n < 0:
        n = -n
        sign = -1
    while n > 0:
        if n % 2 == 1:
            bits.append(t*sign)
        n /= 2
        t *= 2
    bits.reverse()
    return bits

def HexInts(value):
    if type(value) == str:
        value = [ value ]
    return [
        bit_int
        for segments in value
        for segment in segments.split(',')
        for bit_int in int_to_bits(int(segment, 0))
    ]

def or_reduce_fn(so_far, n):
    if so_far & n:
        raise Exception('%d and %d not bitwise disjoint' % (so_far, n))
    return so_far | n

def or_reduce(ints):
    return reduce(or_reduce_fn, ints, 0)


def _sign_list(l, sign):
    return ','.join(map(lambda s: sign+str(s), l))

def _nonempty_join(sep, *ls):
    return sep.join(filter(lambda x: x, ls))


class BitSet:

    def __init__(self, bitset):
        ints = HexInts(bitset)
        self.force_bits = filter(lambda i: i > 0, ints)
        self.filter_bits = map(lambda i: -i, filter(lambda i: i < 0, ints))
        self._init_nums()
        self.total = 0


    def _init_nums(self):
        self.force_num = or_reduce(self.force_bits)
        self.filter_num = or_reduce(self.filter_bits)
        assert self.force_num & self.filter_num == 0, \
            'Forcing bits %d and filtering bits %d overlap: %d' % (
                self.force_bits,
                self.filter_bits,
                self.force_bits & self.filter_bits
            )


    def add_force_bits(self, bits):
        assert not set(self.force_bits).intersection(set(bits))
        self.set_force_bits(self.force_bits + bits)


    def add_filter_bits(self, bits):
        assert not set(self.filter_bits).intersection(set(bits))
        self.set_filter_bits(self.filter_bits + bits)


    def set_force_bits(self, force_bits):
        self.force_bits = force_bits
        self._init_nums()

    def set_filter_bits(self, filter_bits):
        self.filter_bits = filter_bits
        self._init_nums()


    def maybe_add(self, flags, count):
        if flags & self.force_num == self.force_num and flags & self.filter_num == 0:
            self += count


    def __add__(self, other):
        assert type(other) == int
        self.total += other
        return self


    def __repr__(self):
        return '%s: %d' % (
            _nonempty_join(' ', _sign_list(self.force_bits, '+'), _sign_list(self.filter_bits, '-')),
            self.total
        )


parser = argparse.ArgumentParser()
parser.add_argument('-b', dest="bit_sets", action='append', help="Positive and negative integers to force filter in or out", default=[])
parser.add_argument('-f', dest="force_flags", type=HexInts, help="Restrict to entries containing these flags", default=[])
parser.add_argument('-F', dest="filter_flags", type=HexInts, help="Filter out entries containing these flags", default=[])

args, unprocessed_args = parser.parse_known_args()

force_flags = args.force_flags
filter_flags = args.filter_flags

bit_sets = map(BitSet, args.bit_sets)
for bit_set in bit_sets:
    bit_set.add_force_bits(force_flags)
    bit_set.add_filter_bits(filter_flags)

sys.argv = [ sys.argv[0] ] + unprocessed_args

total = 0
for line in fileinput.input():
    count, flags = map(int, re.split('\s+', line.strip()))
    [ bitset.maybe_add(flags, count) for bitset in bit_sets ]

for bitset in bit_sets:
    print bitset


