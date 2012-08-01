#!/usr/bin/env perl
=pod

Act as subscriber, push on the other side.

Works as middleware between publishers and pool of workers

=cut

use strict;
use warnings;

use ZeroMQ qw/:all/;

my $context = ZeroMQ::Context->new();

# Socket facing publishers
my $in = $context->socket(ZMQ_SUB);
$in->setsockopt(ZMQ_SUBSCRIBE, '');
$in->bind('ipc://load_balancer_in.sock');

# Socket facing workers
my $out = $context->socket(ZMQ_PUSH);
$out->bind('ipc://load_balancer_out.sock');

while (1) {
  ## FIXME: hardcoded to two part messages, should be generic, need to
  ## port to ::Raw
  my $t = $in->recv();
  $out->send($t->data, ZMQ_SNDMORE);
  my $p = $in->recv();
  $out->send($p->data);
}
