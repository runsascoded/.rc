
import os
from subprocess import Popen,PIPE
import sys
from tempfile import mkdtemp
import time

control_masters_dir = '%s/.ssh/controlmasters/' % os.getenv('HOME')

def get_socket_for_host(host):
  sockets = [ control_masters_dir + socket for socket in os.listdir(control_masters_dir) if host in socket ]
  if len(sockets) > 1:
      raise Exception('Found multiple sockets for host %s:\n%s' % (host, sockets.join('\n')))
  if len(sockets):
    return sockets[0]
  return None

class SshChannel:

  def __init__(self, host, user=None):

    self.channel = None
    self.tmpdir = None

    if Popen([ 'ssh', '-O', 'check', host ]).wait() == 0:
        self.socket = get_socket_for_host(host)
        if not self.socket:
            raise Exception(
                'Expected to find ControlMaster for host %s, but didn\'t find one at %s' % (host, control_masters_dir)
            )
        return

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
    if self.channel:
      self.channel.terminate()
      os.remove(self.socket)
      os.rmdir(self.tmpdir)

