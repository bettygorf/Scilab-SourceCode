#include "../machine.h"

#include "message.h"
#include <errno.h>
#include <strings.h>
#include <stdio.h>
#include <stdlib.h>

extern void SendMsg();
extern void GetMsg();
extern void LoadGraph();

extern void cerro();
extern void cout();

#define MAXSOCK 10

static int lsock[MAXSOCK];
static int nsock = 0;

int sock = 0;

void block()
{
  int on = 0;
  ioctl(sock,FIONBIO,&on);  
}

void unblock()
{
  int on = 1;
  ioctl(sock,FIONBIO,&on);  
}

void C2F(inisoc)(server,lserver,port,s)
char *server;
int *lserver;
int *port;
int *s;
{
  struct hostent *gethostbyname();
  struct sockaddr_in Nom;
  struct hostent *hp;

  server[*lserver] = '\0';

  if((*s = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
    cerro("Impossible to create socket associated to xmetanet\n");
    return;
  }

  if((hp = gethostbyname(server)) == NULL) {
    cerro("%s: unknown host\n", server);
    return;
  }

  bcopy(hp->h_addr, &Nom.sin_addr, hp->h_length);
  Nom.sin_family = AF_INET;
  Nom.sin_port = htons(*port); 

  if(connect(*s, &Nom, sizeof(Nom)) == -1) {
    cerro("Problem for connexion\n");
    return;
  }

  cout("Connected to host \"%s\" on port %d",server,*port);

  if (nsock == MAXSOCK) {
    cerro("Too many screen\n");
    return;
  }
  lsock[nsock++] = *s;

  sock = *s;
}

void C2F(inimet)(s)
int *s;
{
  struct hostent *gethostbyname();
  struct sockaddr_in Nom;
  struct hostent *hp;
  char server[64];
  char command[128];
  int port;
  FILE *fport;
  char* env;

  if((*s = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
    cerro("Impossible to create socket associated to xmetanet\n");
    return;
  }

  if((gethostname(server,64)) == -1) {
    cerro("impossible to get host name\n");
    return;
  }

  if((hp = gethostbyname(server)) == NULL) {
    cerro("%s: unknown host\n", server);
    return;
  }

  env = getenv("XMETANET");
  if (env == NULL) {
    env = getenv("SCI");
    if (env == NULL) {
      cerro("The environment variable SCI is not defined");
      return;
    }
    else sprintf(command,"%s/bin/xmetanet -l&",env);
  }
  else sprintf(command,"%s -l&",env);

  unlink("/tmp/.metanet.end");
  system(command);
  while (fopen("/tmp/.metanet.end","r") == NULL) {};
  fport = fopen("/tmp/.metanet.port","r");
  fscanf(fport,"%d",&port);
  unlink("/tmp/.metanet.end");
  unlink("/tmp/.metanet.port");

  bcopy(hp->h_addr, &Nom.sin_addr, hp->h_length);
  Nom.sin_family = AF_INET;
  Nom.sin_port = htons(port); 

  if(connect(*s, &Nom, sizeof(Nom)) == -1) {
    cerro("Problem for connexion\n");
    return;
  }

  cout("Connected to METANET on port %d",port);

  if (nsock == MAXSOCK) {
    cerro("Too many screen\n");
    return;
  }
  lsock[nsock++] = *s;
  sock = *s;
}

int checkcon()
{
  if (nsock == 0) {
    cerro("You must first connect to METANET");
    return 0;
  }
  else {
    return 1;
  }
}

void C2F(screen)(s)
int *s;
{
  int find,i;

  checkcon();
  find = 0;
  for (i = 0; i < nsock; i++) {
    if (*s == lsock[i]) {find = 1; break;}
  }
  if (find == 0) {
    cerro("Bad screen number");
    return;
  }
  sock = *s;
}
