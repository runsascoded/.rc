__author__ = 'ryan'

from pygments.lexer import RegexLexer
from pygments.token import *
import sys


StackTraceBegin = Token.StackTraceBegin
StackTraceEnd = Token.StackTraceEnd
StackTraceLine = Token.StackTraceLine

class StackTraceLexer(RegexLexer):
    name = 'StackTrace'

    tokens = {
        'root': [
            (r'^[^\s][^\n]*\n\s+at .*?\n', StackTraceBegin, 'stack_trace'),
            (r'^[^\s].*?\n', Text),
            ],
        'stack_trace': [
            (r'^Exception.*?\n', StackTraceLine),
            (r'^Caused by:.*?\n', StackTraceLine),
            (r'^\s+at .*?\n', StackTraceLine),
            (r'^\s+\.{3} [0-9]+ more\n', StackTraceLine),
            (r'^[^\s].*?\n', StackTraceEnd, '#pop')
        ]
    }

    def get_stack_traces(self, text):
        val = None
        for index, token, value in RegexLexer.get_tokens_unprocessed(self, text):
            if token is Error:
                raise Exception('Lexing error: %s' % (str(index, token, value)))
            if token is StackTraceBegin:
                assert val == None
                val = value
            elif token is StackTraceLine:
                if not val:
                    raise Exception('Got StackTraceLine without StackTraceBegin: %s' % str(index, token, value))
                val += value
            elif token is StackTraceEnd:
                if not val:
                    raise Exception('Got StackTraceLine without StackTraceBegin: %s' % str(index, token, value))
                val += value
                yield val
                val = None


    def get_tokens_unprocessed(self, text):
        for index, token, value in RegexLexer.get_tokens_unprocessed(self, text):
            yield index, token, value

if __name__ == '__main__':
    stl = StackTraceLexer()
    if len(sys.argv) >= 2:
        with open(sys.argv[1], 'r') as fd:
            print '\n'.join(map(str, stl.get_stack_traces(fd.read())))
    else:
        print '\n'.join(map(str, stl.get_stack_traces(sys.stdin.read())))


