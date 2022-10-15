#include <malloc.h>
#include <stdio.h>
#include <X11/Intrinsic.h>

#include "graphics.h"
#include "message.h"

extern int ComputeScilabGraph();
extern void CreateGraph();
extern int LoadNamedGraph();
extern void ShowNodeSet();
extern void ShowPath();

void GetMsg();
void SendMsg();

int sock;

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

void SendAck()
{
  int isize = sizeof(int);
  MTYPE type = ACK;
  char buf[64];
  int msgsize = 0;
  int s;

  s = 0;
  bcopy((char *)&type,buf,isize);
  s += isize;
  bcopy((char *)&msgsize,buf+s,isize);
  s += isize;
  write(sock,buf,s);
}

void ParseMessage(type,b,size)
MTYPE type;
char *b;
int size;
{
  int sizint = sizeof(int);
  int gsize;
  char *g;
  switch (type) {
  case ACK:
    break;
  case CREATE:
    CreateGraph(b,size);
    break;
  case LOAD:
    if (LoadNamedGraph(b,0)) {
      gsize = ComputeScilabGraph(&g);
      if (gsize == 0) SendAck(); 
      else SendMsg(LOAD,g,gsize);
    }
    else {
      SendAck();
    }
    break;
  case LOAD1:
    if (LoadNamedGraph(b,1)) {
      gsize = ComputeScilabGraph(&g);
      SendMsg(LOAD,g,gsize);
    }
    else {
      SendAck();
    }
    break;
  case SHOWNS:
    ShowNodeSet((int *)b,size/sizint,0);
    break;
  case SHOWP:
    ShowPath((int *)b,size/sizint,0);
    break;
  case SHOWNS1:
    ShowNodeSet((int *)b,size/sizint,1);
    break;
  case SHOWP1:
    ShowPath((int *)b,size/sizint,1);
    break;
  }
}

void GetMsg()
{
  MTYPE type;
  int isize = sizeof(int);
  int msgrest,msgsize,n,s;
  char *msg;
  char buf[BUFSIZE];

  /* to avoid blocking */
  unblock();
  n = read(sock,buf,2*isize); /* read type and size */
  if (n == 0) {
    fprintf(stderr,"Client deconnected\n");
    signal(SIGIO,GetMsg);
    return;
  }
  if (n == -1) {
    block(); 
    signal(SIGIO,GetMsg);
    return;
  }
  block();  /* for blocked read */
  bcopy(buf,(char *)&type,isize);
  bcopy(buf+isize,(char *)&msgsize,isize);

  if ((msg = (char *)malloc((unsigned)msgsize)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    signal(SIGIO,GetMsg);
    return;
  }

  /* read message */
  s = 0; msgrest = msgsize;
  while (msgrest > 0) {
    n = read(sock,buf,BUFSIZE);
    bcopy(buf,msg+s,n);
    s += n;
    msgrest -= n;
  }

  ParseMessage(type,msg,msgsize);

  free(msg);
  XFlush(theG.dpy);
  signal(SIGIO,GetMsg);
  return;
}

void CreateSocket(local)
int local;
{
  int on = 1;
  int pid;
  int port;
  struct sockaddr_in Nom;
  int Longueur;
  int sock_ecoute;
  struct sockaddr Adresse;
  int Longueur_adresse;
  FILE *fport,*fend;
  
  if((sock_ecoute=socket(AF_INET, SOCK_STREAM, 0)) == -1) {
    fprintf(stderr,"Problem to create listen socket\n");
    exit(1);
  }
  bzero((char*)&Nom, sizeof(Nom));
  Nom.sin_port = 0;  /* The system chooses port number */
  Nom.sin_addr.s_addr = INADDR_ANY;
  Nom.sin_family = AF_INET;
  
  if( bind(sock_ecoute, (struct sockaddr*)&Nom, sizeof(Nom))) {
    fprintf(stderr,"Problem for naming listen socket\n");
    exit(1);
  }

  Longueur = sizeof(Nom);
  if(getsockname(sock_ecoute, (struct sockaddr*)&Nom, &Longueur)) {
    fprintf(stderr,"Problem to get listen socket name\n");
    exit(1);
  }
  
  port = ntohs(Nom.sin_port);
  
  if (local == 0) fprintf(stderr,"Port number: %d\n",port);
  else {
    unlink("/tmp/.metanet.end");
    fport = fopen("/tmp/.metanet.port","w");
    fprintf(fport,"%d\n",port);
    fclose(fport);
    fend = fopen("/tmp/.metanet.end","w");
    fclose(fend);
  }

  listen( sock_ecoute,1);
  
  Longueur_adresse = sizeof(Adresse);
  sock = accept(sock_ecoute, &Adresse, &Longueur_adresse);
  close(sock_ecoute);

  signal(SIGIO,GetMsg);
  pid = getpid();
  ioctl(sock,SIOCSPGRP,&pid);
  ioctl(sock,FIOASYNC,&on);
}

void SendMsg(type, msg, msgsize)
MTYPE type;
char *msg;
int msgsize;
{
  int s;
  int isize = sizeof(int);
  char buf[64];

  s = 0;
  bcopy((char *)&type,buf,isize);
  s += isize;
  bcopy((char *)&msgsize,buf+s,isize);
  s += isize;
  write(sock,buf,s);
  write(sock,msg,msgsize);

  free(msg);
}
