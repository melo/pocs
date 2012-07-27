#!/usr/bin/env perl

use strict;
use warnings;
use Message::Passing::DSL;

my $addr = shift || 'tcp://127.0.0.1:8888';

print STDERR "Starting consumer at $addr\n";
run_message_server message_chain {
  error_log(class => 'STDERR');
  output output => (class => 'STDOUT');
  input input => (
    socket_bind => $addr,
    class       => 'ZeroMQ',
    output_to   => 'output',
  );
};
