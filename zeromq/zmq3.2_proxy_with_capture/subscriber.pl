#!/usr/bin/env perl

use strict;
use warnings;
use ZMQ::LibZMQ3;
use ZMQ::Constants ':all';

my $port = 5555;
($port) = @ARGV if @ARGV;

my $ctx = zmq_init();
my $sock = zmq_socket($ctx, ZMQ_SUB);

zmq_setsockopt($sock, ZMQ_SUBSCRIBE, '');
zmq_connect($sock, "tcp://127.0.0.1:$port");

print <<EOE;

Connecting to tcp://127.0.0.1:$port, listening to all topics.

Press Ctrl-C to terminate...

EOE

my $count = 1;
while (1) {
  my $msg = zmq_recvmsg($sock);
  print "[$$/$count] recv message:\n";

  my $part = 1;
PART: while ($msg) {
    my $size = zmq_msg_size($msg);
    my $data = zmq_msg_data($msg);
    print "\t$part ($size): <<$data>>\n";

    last PART unless zmq_getsockopt($sock, ZMQ_RCVMORE);
    $part++;
    $msg = zmq_recvmsg($sock);
  }

  $count++;
}
