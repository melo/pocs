#!/usr/bin/env perl
=pod

Act as subscriber, republish on the other side.

Works as middleware between message sources and message sinks

=cut

use strict;
use warnings;

use ZeroMQ qw/:all/;
use ZeroMQ::Raw qw/zmq_device/;

my $context = ZeroMQ::Context->new();

# Socket facing message sources
my $frontend = $context->socket(ZMQ_SUB);
$frontend->setsockopt(ZMQ_SUBSCRIBE, '');
$frontend->bind('tcp://127.0.0.1:8888');

# Socket facing message sinks
my $backend = $context->socket(ZMQ_PUB);
$backend->bind('tcp://127.0.0.1:8889');

# Start forwarder device
zmq_device(ZMQ_FORWARDER, $frontend->socket, $backend->socket);
