#!/usr/bin/env perl

use v5.14;
use warnings;
use ZMQ::LibZMQ2;

say "Check lsof of $$ - before context"; <>;
my $ctx = zmq_init(1);
say "Check lsof of $$ - before fork"; <>;
my $pid = fork();
say "Check lsof of $$ - before death"; <>;
waitpid($pid, 0) if $pid;
