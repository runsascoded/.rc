#!/usr/bin/env python

import argparse
import datetime
import sys
import threading
import time

parser = argparse.ArgumentParser()
print_strategy_group = parser.add_mutually_exclusive_group()
print_strategy_group.add_argument(
    "-c",
    "--checkpoint",
    type=int,
    dest="checkpoint_interval",
    help="Print the number of lines counted so far every <N> lines"
)

print_strategy_group.add_argument(
    "-e",
    "--exp-backoff",
    type=str,
    dest="exponential_backoff_strategy",
    help="""Strategy for exponentially backing off of intermediate lines-counted updates:
    - integer <N> will cause printing every power of N lines
    - "d", "dec", or "decimal" will print every 1eN, 2eN, and 5eN, so 1, 2, 5, 10, 20, 50, 100, etc.
    """.strip()
)

print_strategy_group.add_argument(
    "-r",
    "--round-numbers",
    action="store_true",
    dest="round_numbers",
    help="Print all numbers that have exactly 1 significant figure, e.g. 100, 200, ... 900, 1000, 2000, ..."
)

print_strategy_group.add_argument(
    "-f",
    "--fibonacci",
    action="store_true",
    dest="fibonacci",
    help="Print an intermediate status every Fibonacci number"
)

print_strategy_group.add_argument(
    "-i",
    "--interval",
    type=int,
    dest="interval",
    help="Interval (in seconds) at which to print status updates"
)


parser.add_argument(
    "-m",
    "--minimum-print",
    type=int,
    default=10000,
    dest="minimum_print",
    help="Don't bother printing any updates until the count clears this value."
)

parser.add_argument(
    "-t",
    "--timestamps",
    action="store_true",
    default=False,
    dest="timestamps",
    help="Print timestamps with each intermediate update"
)

parser.add_argument(
    "-d",
    "--durations",
    action="store_false",
    default=True,
    dest="durations",
    help="Print rate of consumption of counted lines at each intermediate step"
)

parser.add_argument(
    "-a",
    "--append-intermediates",
    default=False,
    action="store_true",
    dest="append_output",
    help="Instead of printing intermediate statuses in place, print them each on separate lines"
)

opts, args = parser.parse_known_args()

class PrintStrategy:
    def compute_next_checkpoint(self):
        pass

class LinearPrintStrategy(PrintStrategy):
    def __init__(self, interval):
        self.interval = interval
        self.next_checkpoint = interval

    def compute_next_checkpoint(self):
        self.next_checkpoint += self.interval

class GeometricPrintStrategy(PrintStrategy):
    global opts

    def __init__(self, exp, coeffs=None, start_point=opts.minimum_print):
        self.exp = exp
        self.cur_exp_power = 1

        self.coeffs = coeffs if coeffs else [ 1 ]
        self.cur_coeff_idx = 0

        self.next_checkpoint = 1
        while self.next_checkpoint < start_point:
            self.compute_next_checkpoint()

    def compute_next_checkpoint(self):
        self.cur_coeff_idx += 1
        if self.cur_coeff_idx == len(self.coeffs):
            self.cur_coeff_idx = 0
            self.cur_exp_power *= self.exp

        self.next_checkpoint = self.coeffs[self.cur_coeff_idx] * self.cur_exp_power

class FibonacciPrintStrategy(PrintStrategy):

    def __init__(self):
        self.last_checkpoint = 0
        self.next_checkpoint = 1


    def compute_next_checkpoint(self):
        t = self.last_checkpoint
        self.last_checkpoint = self.next_checkpoint
        self.next_checkpoint += t


class IntervalPrintStrategy(PrintStrategy):
    def __init__(self, interval_s, init=True):
        self.next_checkpoint = 0
        self.initd = False
        self.killed = False
        self.interval_s = interval_s
        if init:
            self.init()

    def start_fn_interval(self, func):
        def func_wrapper():
            if not self.killed:
                self.start_fn_interval(func)
            func()
        self.t = threading.Timer(self.interval_s, func_wrapper)
        self.t.start()

    def init(self, fn):
        self.start_fn_interval(fn)
        self.initd = True

    def kill(self):
        self.killed = True
        self.t.cancel()


print_strategy = None

if opts.exponential_backoff_strategy:
    try:
        print_strategy = GeometricPrintStrategy(int(opts.exponential_backoff_strategy))
    except ValueError:
        if opts.exponential_backoff_strategy in [ 'd', 'dec', 'decimal' ]:
            print_strategy = GeometricPrintStrategy(10, [ 1, 2, 5 ])
        else:
            raise Exception('Invalid exponential-backoff print-strategy: %s' % opts.exponential_backoff_strategy)

elif opts.checkpoint_interval:
    print_strategy = LinearPrintStrategy(opts.checkpoint_interval)

elif opts.round_numbers:
    print_strategy = GeometricPrintStrategy(10, range(1, 10))

elif opts.fibonacci:
    print_strategy = FibonacciPrintStrategy()

elif opts.interval:
    print_strategy = IntervalPrintStrategy(opts.interval, init=False)

else:
    print_strategy = GeometricPrintStrategy(10, [ 1, 2, 5 ])


class DeletingPrinter:
    def __init__(self):
        self.last_print_len = 0

    def p(self, s):
        o = str(s)
        print "%s%s" % ('\b' * self.last_print_len, o),
        sys.stdout.flush()
        self.last_print_len = len(o) + 1


class AppendingPrinter:
    def p(self, s):
        print s


class Timer:
    def __init__(self, init=True):
        if init:
            self.init()

    def init(self):
        self.first_time = time.time()
        self.last_time = self.first_time

    def get_times(self):
        cur_time = time.time()
        since_last = cur_time - self.last_time
        since_first = cur_time - self.first_time
        sys.stdout.flush()
        self.last_time = cur_time
        return since_last, since_first


class RateComputer:
    def __init__(self, num=0, init=True):
        self.initd = False
        if init:
            self.init(num)

    def init(self, num=0):
        if self.initd:
            return
        self.timer = Timer()
        self.first_num = num
        self.last_num = self.first_num
        self.initd = True


    def get_rates(self, num):
        since_last, since_first = self.timer.get_times()
        cur_rate = (num - self.last_num) / since_last
        all_time_rate = (num - self.first_num) / since_first
        self.last_num = num
        return cur_rate, all_time_rate


printer = AppendingPrinter() if opts.append_output else DeletingPrinter()
rater = RateComputer(init=False)

def fmt_float(f):
    return "%s" % float("%f" % f)

num = 0
def print_num():
    printer.p(
        "%s%d%s" % (
            ("%s: " % datetime.datetime.now().strftime('%Y/%m/%d %H:%M:%S')
             if opts.timestamps
             else ""),
            num,
            (" %s/s (%s/s all time)" % tuple(map(lambda f: str(int(f)), list(rater.get_rates(num))))
             if opts.durations
             else "")
        )
    )

try:
    while True:
        line = sys.stdin.readline()
        if hasattr(print_strategy, 'initd') and print_strategy.initd == False:
            print_strategy.init(print_num)
        if not rater.initd:
            rater.init()
        if not line:
            break
        num += 1
        if print_strategy.next_checkpoint and num >= print_strategy.next_checkpoint:
            if num >= opts.minimum_print:
                print_num()

            print_strategy.compute_next_checkpoint()
except KeyboardInterrupt:
    if hasattr(print_strategy, 'kill'):
        print_strategy.kill()
    print ''
    pass

printer.p(num)
