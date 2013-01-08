#!/usr/bin/env perl

use strict;
use ZMQ::LibZMQ3;
use ZMQ::Constants ':all';

my $base = 5554;
($base) = @ARGV if @ARGV;

my $in_addr  = 'tcp://127.0.0.1:' . ($base + 0);
my $out_addr = 'tcp://127.0.0.1:' . ($base + 1);
my $cap_addr = 'tcp://127.0.0.1:' . ($base + 2);

my $ctx     = zmq_init(1);
my $sub_in  = zmq_socket($ctx, ZMQ_SUB);
my $pub_out = zmq_socket($ctx, ZMQ_PUB);
my $cap_out = zmq_socket($ctx, ZMQ_PUB);

zmq_setsockopt($sub_in, ZMQ_SUBSCRIBE, '');
zmq_bind($sub_in,  $in_addr);
zmq_bind($pub_out, $out_addr);
zmq_bind($cap_out, $cap_addr);

print <<EOE;
Starting PubSub proxy. Use zmq_connect() to:

 * publish: $in_addr;
 * subscribe: $out_addr;
 * capture: $cap_addr.

Type Ctrl-C to terminate...

EOE

zmq_proxy($sub_in, $pub_out, $cap_out);
print "Oops: zmq_proxy() failed to start: $!\n";
