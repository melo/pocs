#
# Small demo of message::passing as a logger of HTTP requests of a psgi App
#
# Uses ZeroMQ as transport
#
# Actually this also works as a demonstration of the problems
# described here:
#
# https://github.com/lestrrat/ZeroMQ-Perl/issues/42
#
# Define BOOM=1 when you run it and watch.
#
# To startup this app:
#
#     starman --workers 5 --port 127.0.0.1:5000 --max-requests 3 --preload-app app.psgi
#
# Then on another terminal:
#
#     ab -n 100 http://127.0.0.1:5000/
#
# Without BOOM=1 all is well, define BOOM=1 and it will die after 11
# requests...
#
# Message::Passing::ZeroMQ has code to clear all ZeroMQ contexts
# *before* the fork, and that is the solution. I'll take that code and
# write a module that hides all of this, and provide a saner API
#
# Pedro Melo, Tue Aug 21 17:14:26 UTC 2012

use strict;
use warnings;
use Plack::Request;

use ZMQ::LibZMQ2;
use ZMQ::Constants ':v2.1.11', ':all';
use JSON 'encode_json';
use Proc::PidChange ':all';

my ($ctx, $log_zq);
unless ($ENV{SKIP_BOOM}) {
  my $cb = sub {
    print STDERR "[$$] CONNECT\n";
    $ctx = zmq_init(1);
    $log_zq = zmq_socket($ctx, ZMQ_PUB);
    zmq_connect($log_zq, 'tcp://127.0.0.1:5552');
  };
  $cb->();
  register_pid_change_callback($cb);
  die "No realtime detection of pid changes???" unless $Proc::PidChange::RT;
}


sub logger {
  my ($msg, @rest) = @_;
  return unless $log_zq;
  $msg = { pid => $$, msg => $msg, args => \@rest };
  zmq_send($log_zq, encode_json({ more => $msg })) if $log_zq;
}

logger('Ready to rumble!');

my $count = 0;
my $app   = sub {
  my ($env) = @_;
  my $req = Plack::Request->new($env);

  my $m = $req->method;
  my $p = $req->path_info;
  logger("Hit $m at $p", { ip => $req->address, method => $m, path => $p, count => ++$count });

  [200, ['Content-Type' => 'text/html'], ["OK"]];
};
