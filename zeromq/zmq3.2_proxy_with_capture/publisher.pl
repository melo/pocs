#!/usr/bin/env perl

use strict;
use warnings;
use ZMQ::LibZMQ3;
use ZMQ::Constants ':all';

my $port = 5554;
($port) = @ARGV if @ARGV;

my $ctx = zmq_init();
my $sock = zmq_socket($ctx, ZMQ_PUB);

zmq_connect($sock, "tcp://127.0.0.1:$port");

print <<EOE;

Connecting to tcp://127.0.0.1:$port.

Start typing. For each message send:
 * first line will be the topic
 * follow up lines will be the payload (each on a separate part);
 * terminate with . in a single line.

Press Ctrl-D to terminate...

EOE

MSG: while (1) {
  print "Start a new message. First the topic:\n";

  my $last;
  while (<>) {
    chomp;

    unless (defined $last) { print "Topic will be '$_', type your payload, end with '.'\n" }

    if ($_ eq '.') {
      next unless defined $last;
      zmq_sendmsg($sock, $last);
      print "Message sent...\n";
      redo MSG;
    }
    else {
      zmq_sendmsg($sock, $last, ZMQ_SNDMORE) if defined $last;
      $last = $_;
    }
  }

  last;
}
