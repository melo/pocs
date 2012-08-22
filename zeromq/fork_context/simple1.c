//
// Demonstrate that zmq_init followed by fork does not die
//
// Compile/run:
//
//   cc -lzmq -o simple1 simple1.c ; ./simple1
//
#include <zmq.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

void wait_for_key (char *msg) {
  printf("[%d] %s\n", getpid(), msg);
  
  char buffer[5];
  read(0, buffer, 1);
}

int main (void)
{
  // wait_for_key("before zmq_init");
  void *context = zmq_init (1);
  // wait_for_key("before fork");
  pid_t pid = fork();
  
  if (pid) {
    // wait_for_key("in parent");
    int status;
    int rpid = waitpid(pid, &status, 0);
    printf("[%d] waited for pid %d, got %d status %d\n", getpid(), pid, rpid, status);
    printf("[%d] Parent is exiting\n", getpid());
  }
  else {
    zmq_term(context);
    // wait_for_key("in child");
    exit(0);
  }
  
  return 0;
}
