#!/usr/bin/env perl

use strict;
use warnings;
use Mason;

my $interp = Mason->new(
  comp_root => '.',
  plugins => ['Defer'],
);

print $interp->run('/')->output();
