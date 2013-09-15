# Example of ZMQ + Perl: `zmq_proxy` with capture socket #

This test requires an unreleased version of ZMQ::LibZMQ3. Track
[issue 16][] if you wish to know what is going on.

To test, you'll need 4 terminals:

  1. start `proxy.pl` on terminal 1;
  2. start `subscriber.pl 5556` on terminal 2 - this will be your
     capture/sniffer;
  3. start `subscriber.pl` on terminal 3;
  4. start `publisher.pl` on terminal 4 and follow the instructions.


git browsers
[issue 16]: https://github.com/lestrrat/p5-ZMQ/issues/16
