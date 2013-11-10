

refname_chars_regex = "[a-zA-Z0-9-_/]+"

def named(name, regex):
	return "(?P<%s>%s)" % (name, regex)

def refname_regex(name):
	return named(name, refname_chars_regex)

def captured_whitespace_regex(name):
	return named(name, '\s+')

