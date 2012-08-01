#!/usr/bin/env perl

=pod

ZeroMQ publisher, will send 1 message per second with a round-robin set
of topic names.

Connects to a list of addresses given on the command line.

=cut

use strict;
use warnings;

use ZeroMQ qw/:all/;

die "Usage: publisher.pl addr [addr...]\n" unless @ARGV;

my $ctx = ZeroMQ::Context->new();

my $sock = $ctx->socket(ZMQ_PUB);

my @topics = qw(a b c);
my $topic  = 0;

my $count = 0;
while (1) {
  ## Stack connects over time
  $sock->connect(shift @ARGV) if @ARGV && $count % 7 == 0;

  $sock->send("t.$topics[$topic].".($count % 7), ZMQ_SNDMORE);
  $sock->send("$count $$ " . localtime);

  select(undef, undef, undef, .25);

  $count++;
  $topic = ($topic + 1) % @topics;
}
