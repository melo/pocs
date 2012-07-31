#!/usr/bin/env perl

=pod

ZeroMQ subscribers, accetps topic name to subscribe as parameter.

Try
    ./subscriber.pl - all messages
    ./subscriber.pl t. - all messages, t. prefix (topic) is common to all
    ./subscriber.pl t.a - only messages for topic t.a*
    ./subscriber.pl t.a.0 - only messages for topic t.a.0*

=cut

use strict;
use warnings;

use ZeroMQ qw/:all/;

my $ctx = ZeroMQ::Context->new();

my $sock = $ctx->socket(ZMQ_SUB);
$sock->setsockopt(ZMQ_SUBSCRIBE, shift || '');
$sock->bind('tcp://127.0.0.1:5560');

while (1) {
  my $topic = $sock->recv;
  my $msg   = $sock->recv;
  print $topic->data, ': ', $msg->data, "\n";
}
