
import operator
import re
import sys

from get_args import get_args

def custom_filter(fn, cmp):
	def ret_fn(x):
		return fn(x, cmp)
	return ret_fn

def filt(arg, cmp):
	return cmp(int(
		filter(lambda x: x, re.split('\s+', arg))[0]
		), int(sys.argv[1]))

def run_with_operator(cmp):
	print "".join(filter(custom_filter(filt, cmp), get_args(1))),
