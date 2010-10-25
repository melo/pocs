#!/usr/bin/env perl

use strict;
use warnings;
use 5.12;
use AnyEvent;
use AnyEvent::MP;

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
  my $grp_ports = grp_get 'my_ctrls' or return;
  
  my $ctrl_port = pick($grp_ports);
  snd $ctrl_port, alive => { pid => $$, port => $port };
  say "[$$] Sent alive to ctrl port $ctrl_port";

  undef $timer; ## no more
};

say "[$$] Worker started";
AE::cv->recv;

sub pick {
  return shuffle(@{$_[0]});
}
