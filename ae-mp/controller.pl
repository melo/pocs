#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;
use AnyEvent;
use AnyEvent::MP;
use AnyEvent::MP::Global;

configure ;

my $port = port;
grp_reg my_ctrls => $port;

rcv $port, alive => sub {
  my ($data) = @_;
  
  use Data::Dump qw(pp); say STDERR ">>>>>> Worker is alive ", pp($data);
};

say "[$$] Controller starting at port '$port'";
AE::cv->recv;
