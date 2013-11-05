#!/usr/bin/python

import os
import re

color_char_regex = '\x1b' + '\[(?:[0-9];)?[0-9]+m'

def color_symbol(name):
	return os.getenv(name).replace('\\033', '\x1b')

def color(name, s=None, cond=True):
	if s == None:
		return color_symbol(name) 
	if cond:
		return color_symbol(name) + s + color_symbol('COff')
	return s

def clen(s):
	return len(re.sub(color_char_regex, '', str(s)))
