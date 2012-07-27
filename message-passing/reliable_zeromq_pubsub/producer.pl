#!/usr/bin/env perl

use strict;
use warnings;
use Message::Passing::Output::ZeroMQ;

my $tag  = shift || $$;
my $addr = shift || 'tcp://127.0.0.1:8888';

print STDERR "Connecting producer to $addr\n";
my $out = Message::Passing::Output::ZeroMQ->new(connect => $addr);

print STDERR "Using tag '$tag', sending one message per second\n";
my $c = 1;
while (1) {
  my $m = "$tag $c";
  print STDERR " ... $m\n";
  $out->consume($m);
  sleep(1);
  $c++;
}
