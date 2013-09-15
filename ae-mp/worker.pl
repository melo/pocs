#!/usr/bin/env perl

use strict;
use warnings;
use 5.012;
use AnyEvent;
use AnyEvent::MP;
use AnyEvent::MP::Global;
use List::Util 'shuffle';

configure;

my $port = port;
grp_reg my_workers => $port;

rcv $port, work_upcase => sub {
  my ($data, $reply_port) = @_;

  $data = uc($data);
  say "[$$] got '$data'";

  ## TODO: how to use reply_port to get an answer back?
};

my $timer;
$timer = AE::timer 0, 1, sub {
  say "[$$] Try and get the ctrls group";
  my $grp_ports = grp_get 'my_ctrls' or return;
  
  my $ctrl_port = pick($grp_ports);
  snd $ctrl_port, alive => { pid => $$, port => $port };
  say "[$$] Sent alive to ctrl port $ctrl_port";

  undef $timer; ## no more
};

say "[$$] Worker started at port '$port'";
AE::cv->recv;

sub pick {
  return shuffle(@{$_[0]});
}
