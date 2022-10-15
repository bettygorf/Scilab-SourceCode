#include "message.h"

extern void cerro();

void SendMsg(type,msg,msgsize)
MTYPE type;
char *msg;
int msgsize;
{
  int n,s;
  int isize = sizeof(int);
  char buf[64];

  s = 0;
  bcopy((char *)&type,buf,isize);
  s += isize;
  bcopy((char *)&msgsize,buf+s,isize);
  s += isize;
  if (write(sock,buf,s) == -1) {
    cerro("Unable to send message to Metanet");
  }
  if (write(sock,msg,msgsize) == -1) {
    cerro("Unable to send message to Metanet");
  }
}
