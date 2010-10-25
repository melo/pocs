#!/usr/bin/env perl

use strict;
use warnings;
use 5.12;
use AnyEvent;
use AnyEvent::MP;

configure;

my $port = port;
grp_reg my_ctrls => $port;

recv $port, alive => sub {
  my ($data) = @_;
  
  use Data::Dump qw(pp); say STDERR ">>>>>> Worker is alive ", pp($data);
};

AE::cv->recv;
