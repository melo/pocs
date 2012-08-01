# ZeroMQ load-balancer for SUB sockets #

This code allows you to have multiple workers processing
SUBscribed messages.


## How it works ##

A forward server is created that SUBscribes the desired topics and then
forwards those messages to a PUSH socket.

Workers use a PULL socket to load-balance the work.


## Demo ##


 1. open 5 or 6 windows;
 2. on window 1, run the `load_balancer.pl`: no output is generated but
    two new named pipes will appear in the local directory;
 3. on window 2, run the `publisher.pl`: no output is generated, put
    messages will be sent and queued until a worker is launched;
 4. on all other windows, run `worker.pl` copies.

You'll see that each worker get's a message in turn.
