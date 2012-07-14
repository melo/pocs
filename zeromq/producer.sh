#!/bin/sh

perl -E '$|++; my $c = 0; while (1) { say qq({"id":$c,"pid":$$}); sleep(1); $c++ }' |
  message-pass --input STDIN \
               --output ZeroMQ --output_options '{"connect":"tcp://127.0.0.1:5559"}'
