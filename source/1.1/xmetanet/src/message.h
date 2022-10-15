typedef enum rtype {ACK,CREATE,LOAD,LOAD1,SHOWNS,SHOWP,SHOWNS1,SHOWP1} MTYPE;

#define BUFSIZE 1024

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <netdb.h>
#include <signal.h>

#include <unistd.h>
#include <fcntl.h>

extern int sock;
