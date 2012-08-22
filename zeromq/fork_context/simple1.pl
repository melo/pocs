#!/usr/bin/env perl

use v5.14;
use warnings;
use ZMQ::LibZMQ2;
use ZMQ::Constants ':v2.1.11', ':all';

my $ctx = zmq_init(1);
my $sock = zmq_socket($ctx, ZMQ_PUB);
#my $msg = zmq_msg_init_data('hello');
my $pid = fork();
waitpid($pid, 0) if $pid;
