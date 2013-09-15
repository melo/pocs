#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;
use AnyEvent;
use AnyEvent::MP;
use AnyEvent::MP::Global;
use List::Util

configure;

my $port = port;
grp_reg my_workers => $port;

recv $port, work_upcase => sub {
  my ($data, $reply_port) = @_;

  $data = uc($data);
  say "[$$] got '$data'";

  ## TODO: how to use reply_port to get an answer back?
};

my $timer;
$timer = AE::timer after => 0, interval => 1, sub {
  
};

AE::cv->recv;
