#!/usr/bin/env perl

use strict;
use warnings;
use ZMQ::LibZMQ2;
use ZMQ::Constants ':v2.1.11', ':all';


my $pid = fork();
my $ctx = zmq_init(1); ## Move this line after the fork, and no assertion

if ($pid) {    ## parent
  my $sub = zmq_socket($ctx, ZMQ_SUB);
  zmq_setsockopt($sub, ZMQ_SUBSCRIBE, '');
  zmq_bind($sub, 'ipc://x.sock');

  while (1) {
    l("## Checking for messages");
    my $msg = zmq_recv($sub, ZMQ_NOBLOCK);
    if ($msg) {
      my $t = zmq_msg_data($msg);
      l("Topic '$t'");
      $msg = zmq_recv($sub, 0);
      my $p = zmq_msg_data($msg);
      l("Payload '$p'");
      last if $p eq 'quit';
    }
    l("## No message, sleep a bit");
    sleep(3);
  }
  l("And we are done...");
  zmq_close($sub);
  zmq_term($ctx);
  
  waitpid($pid, 0);
  END { unlink('x.sock') }
}
else {
  l('Wait a bit to start publisher...');
  sleep(1);

  my $ctx = zmq_init(1);
  my $pub = zmq_socket($ctx, ZMQ_PUB);
  zmq_connect($pub, 'ipc://x.sock');

  zmq_send($pub, 't1', ZMQ_SNDMORE);
  zmq_send($pub, '1', 0);
  sleep(1);
  zmq_send($pub, 't4', ZMQ_SNDMORE);
  zmq_send($pub, '2 one thousand', 0);
  sleep(1);
  zmq_send($pub, 't3', ZMQ_SNDMORE);
  zmq_send($pub, '3 is done', 0);
  sleep(1);
  zmq_send($pub, 't2', ZMQ_SNDMORE);
  zmq_send($pub, 'quit', 0);
  sleep(1);

  l("Publisher is done...");
  zmq_close($pub);
  zmq_term($ctx);
  l("Publisher exits, stage left");
}

#sub l {}
sub l { print STDERR "## [$$] ", @_, "\n" }
