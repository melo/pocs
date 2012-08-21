//
// Demonstrate that zmq_init followed by fork does not die
//
// Compile/run:
//
//   cc -lzmq -o test test.c ; ./test
//
#include <zmq.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

int main (void)
{
    void *context = zmq_init (1);
    pid_t pid = fork();
    
    if (pid) {
      void *responder = zmq_socket (context, ZMQ_REP);
      //  Socket to talk to clients
      zmq_bind (responder, "ipc://xpto.sock");

      while (1) {
          //  Wait for next request from client
          zmq_msg_t request;
          zmq_msg_init (&request);
          zmq_recv (responder, &request, 0);
          
          char payload[10];
          int size = zmq_msg_size(&request);
          memcpy(payload, zmq_msg_data(&request), size);
          payload[size] = '\0';
          if (strncmp(payload, "quit", 4) == 0) {
            printf("[%d] Received '%s', sleep a bit\n", getpid(), payload);
            sleep(4);
            break;
          }
          
          printf ("[%d] Received '%s'\n", getpid(), payload);
          zmq_msg_close (&request);

          //  Do some 'work'
          sleep (1);

          //  Send reply back to client
          zmq_msg_t reply;
          zmq_msg_init_size (&reply, 5);
          memcpy (zmq_msg_data (&reply), "World", 5);
          zmq_send (responder, &reply, 0);
          zmq_msg_close (&reply);
      }
      //  We never get here but if we did, this would be how we end
      printf("[%d] Parent is cleaning up\n", getpid());
      zmq_close (responder);
      zmq_term (context);

      printf("[%d] waiting for child\n", getpid());
      int status;
      int rpid = waitpid(pid, &status, 0);
      printf("[%d] waited for pid %d, got %d status %d\n", getpid(), pid, rpid, status);
      printf("[%d] Parent is exiting\n", getpid());
    }
    else {
      context = zmq_init (1);

      //  Socket to talk to server
      printf ("[%d] Connecting to hello world server...\n", getpid());
      void *requester = zmq_socket (context, ZMQ_REQ);
      zmq_connect (requester, "ipc://xpto.sock");

      int request_nbr;
      zmq_msg_t request;
      for (request_nbr = 0; request_nbr != 2; request_nbr++) {
          zmq_msg_init_size (&request, 5);
          memcpy (zmq_msg_data (&request), "Hello", 5);
          printf ("[%d] Sending Hello %d...\n", getpid(), request_nbr);
          zmq_send (requester, &request, 0);
          zmq_msg_close (&request);

          zmq_msg_t reply;
          zmq_msg_init (&reply);
          zmq_recv (requester, &reply, 0);
          printf ("[%d] Received World %d\n", getpid(), request_nbr);
          zmq_msg_close (&reply);
      }

      zmq_msg_init_size (&request, 4);
      memcpy (zmq_msg_data (&request), "quit", 4);
      printf ("[%d] Sending quit...\n", getpid());
      zmq_send (requester, &request, 0);
      zmq_msg_close (&request);
      
      sleep(1);

      printf("[%d] Child is cleaning up\n", getpid());
      zmq_close (requester);
      zmq_term (context);
      printf("[%d] Child is exiting()\n", getpid());
      exit(0);
    }

    return 0;
}
