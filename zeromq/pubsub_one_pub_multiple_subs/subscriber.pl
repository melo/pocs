#!/usr/bin/env perl

=pod

ZeroMQ subscribers, accetps topic name to subscribe as parameter.

Also accepts addrs to bind

=cut

use strict;
use warnings;

use ZeroMQ qw/:all/;

my $ctx = ZeroMQ::Context->new();

my @addr = grep { m/^\w+:\/\// } @ARGV;
die "Usage: subscriber.pl addr [addr...] [topic_filter...]\n" unless @addr;

my @topic_filters = grep { ! m/^\w+:\/\// } @ARGV;
@topic_filters = ('') unless @topic_filters;

my $sock = $ctx->socket(ZMQ_SUB);
$sock->setsockopt(ZMQ_SUBSCRIBE, $_) for @topic_filters;
$sock->bind($_) for @addr;

while (1) {
  my $topic = $sock->recv;
  my $msg   = $sock->recv;
  print $topic->data, ': ', $msg->data, "\n";
}
