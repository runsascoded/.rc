
import sys

def get_args(num_reqd_sysargs=0):
	if len(sys.argv) - 1 < num_reqd_sysargs:
		raise Exception("Required %d args but found %d" % (num_reqd_sysargs, len(sys.argv) - 1))
	if len(sys.argv) - 1 == num_reqd_sysargs:
		# print 'equal'
		args=[]
		for arg in sys.stdin:
			args.append(arg)
		return args
	# print 'more'
	return sys.argv[num_reqd_sysargs:]
