#!/usr/bin/env perl

=pod

ZeroMQ workers

=cut

use strict;
use warnings;

use ZeroMQ qw/:all/;

my $ctx = ZeroMQ::Context->new();

my $sock = $ctx->socket(ZMQ_PULL);
$sock->connect('ipc://load_balancer_out.sock');

while (1) {
  my $topic = $sock->recv;
  my $msg   = $sock->recv;
  print $topic->data, ': ', $msg->data, "\n";
}
