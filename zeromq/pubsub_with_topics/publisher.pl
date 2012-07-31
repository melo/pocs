#!/usr/bin/env perl

=pod

ZeroMQ publisher, will send 1 message per second with a round-robin set
of topic names.

=cut

use strict;
use warnings;

use ZeroMQ qw/:all/;

my $ctx = ZeroMQ::Context->new();

my $sock = $ctx->socket(ZMQ_PUB);
$sock->connect('tcp://127.0.0.1:5560');

my @topics = qw(a b c);
my $topic  = 0;

my $count = 1;
while (1) {
  $sock->send("t.$topics[$topic].$count", ZMQ_SNDMORE);
  $sock->send("$count $$ " . localtime);

  select(undef, undef, undef, .25);

  $count = ($count + 1) % 7;
  $topic = ($topic + 1) % @topics;
}
