
import os
from subprocess import Popen,PIPE
import sys
from tempfile import mkdtemp
import time

class SshChannel:

  def __init__(self, host, user=None):

    user_str = '%s@' % user if user else ''

    host_str = '%s%s' % (user_str, host)

    self.tmpdir = mkdtemp()
    self.socket = os.path.join(self.tmpdir, 'channel_socket')

    self.channel = Popen(['ssh', '-M', '-S', self.socket, host_str], stdin=PIPE, stdout=PIPE, stderr=PIPE)
    first_sleep = True
    sleep_time = .1
    while not os.path.exists(self.socket):
      if first_sleep:
        sys.stdout.write('\twaiting for channel to open')
        first_sleep = False
      sys.stdout.write('.')
      sys.stdout.flush()
      time.sleep(sleep_time)
      sleep_time *= 1.1

  def close(self):
    self.channel.terminate()
    os.remove(self.socket)
    os.rmdir(self.tmpdir)

