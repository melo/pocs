= Pub/Sub sockets: multiple connects =

This example shows the possibility of a PUB socket (actually any kind of
socket would do...) doing several `connect()` to a set of SUB sockets.

You should balance the use of multiple connects with the fact that using
this will put the topology specification in your code. It's usually
better to keep your nodes as simple as possible (one connect or one
bind) and use device nodes to design your topology.

= Demo =

 1. open at least 4 windows;
 2. on window 1 to N-1, run `./subscriber.pl ipc://subN.sock` where N is
    the window number;
 3. on window N, run `./publisher.pl ipc://sub1.sock ipc://sub2.sock ...
    ipc://subN.sock`
 4. watch as messages start flowing to subscribers. The publisher
    will stack the connects so every 7 messages a new subscriber will
    come alive.

