#!/usr/bin/env perl

use strict;
use warnings;
use ZeroMQ::Raw;
use ZeroMQ::Constants ':all';


my $ctx = ZeroMQ::Raw::zmq_init(1); ## Move this line after the fork, and no assertion
my $pid = fork();

if ($pid) {    ## parent
  my $sub = ZeroMQ::Raw::zmq_socket($ctx, ZMQ_SUB);
  ZeroMQ::Raw::zmq_setsockopt($sub, ZMQ_SUBSCRIBE, '');
  ZeroMQ::Raw::zmq_bind($sub, 'ipc://x.sock');

  while (1) {
    l("## Checking for messages");
    my $msg = ZeroMQ::Raw::zmq_recv($sub, ZMQ_NOBLOCK);
    if ($msg) {
      my $t = ZeroMQ::Raw::zmq_msg_data($msg);
      l("Topic '$t'");
      $msg = ZeroMQ::Raw::zmq_recv($sub, 0);
      my $p = ZeroMQ::Raw::zmq_msg_data($msg);
      l("Payload '$p'");
      last if $p eq 'quit';
    }
    l("## No message, sleep a bit");
    sleep(3);
  }
  l("And we are done...");
  ZeroMQ::Raw::zmq_close($sub);
  ZeroMQ::Raw::zmq_term($ctx);
  
  waitpid($pid, 0);
  END { unlink('x.sock') }
}
else {
  l('Wait a bit to start publisher...');
  sleep(1);

  my $ctx = ZeroMQ::Raw::zmq_init(1);
  my $pub = ZeroMQ::Raw::zmq_socket($ctx, ZMQ_PUB);
  ZeroMQ::Raw::zmq_connect($pub, 'ipc://x.sock');

  ZeroMQ::Raw::zmq_send($pub, 't1', ZMQ_SNDMORE);
  ZeroMQ::Raw::zmq_send($pub, '1', 0);
  sleep(1);
  ZeroMQ::Raw::zmq_send($pub, 't4', ZMQ_SNDMORE);
  ZeroMQ::Raw::zmq_send($pub, '2 one thousand', 0);
  sleep(1);
  ZeroMQ::Raw::zmq_send($pub, 't3', ZMQ_SNDMORE);
  ZeroMQ::Raw::zmq_send($pub, '3 is done', 0);
  sleep(1);
  ZeroMQ::Raw::zmq_send($pub, 't2', ZMQ_SNDMORE);
  ZeroMQ::Raw::zmq_send($pub, 'quit', 0);
  sleep(1);

  l("Publisher is done...");
  ZeroMQ::Raw::zmq_close($pub);
  ZeroMQ::Raw::zmq_term($ctx);
  l("Publisher exits, stage left");
}

#sub l {}
sub l { print STDERR "## [$$] ", @_, "\n" }
