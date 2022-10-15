/************************************************************
 CalICo Project 1993  (N. Rouillon)
 INRIA Scilab Group 1997

 gecid.c (GeCI daemon) 
 last change: March 1997
************************************************************/
#include <stdio.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <signal.h>

#define PORT 2001

/* executable name of GeCI with path */
#define GECI "/usr/local/lib/scilab-2.3/bin/geci"   

void service();

main()
{
  int sock_ecoute, sock_service;
  struct sockaddr_in adr;
  int lgadr;
    
  signal(SIGQUIT,SIG_IGN);
  signal(SIGINT,SIG_IGN);
  signal(SIGHUP,SIG_IGN);

  /* Creation de la socket d'ecoute et attachement d'une adresse Internet */
  if((sock_ecoute=socket(AF_INET,SOCK_STREAM,0)) == -1) {
    fprintf(stderr,"gecid: impossible to create socket\n");
    exit(1);
  }
  adr.sin_family=AF_INET;
  adr.sin_port=htons(PORT);                    
  adr.sin_addr.s_addr=INADDR_ANY;
  strcpy(adr.sin_zero,"00000000");
    
  /* Nommage de la socket */
  if(bind(sock_ecoute,&adr,sizeof(adr)) == -1) {
    fprintf(stderr,"gecid: impossible to name socket\n");
    exit(2);
  }
  /* Creation de la file de Connexions pendantes (nb max = 1) */
  listen(sock_ecoute,5);

  lgadr=sizeof(adr);

  while(1) {
    /* Acceptation de la connexion */
    sock_service=accept(sock_ecoute,&adr,&lgadr);
    if (sock_service==-1) {
      perror("accept");
      exit(1);
    }
        
    /* Execution du service attendu */
    service(sock_service);   
    close(sock_service);
  }
}

void service(sock,sock_ecoute) 
     int sock,sock_ecoute;
{
  char buf;
  int vr, vr2;
  char char_sock[5];
  
  sprintf(char_sock,"%.4d",sock);
  
  if ((vr=fork()) == 0) { /* Dans le fils */
    close(sock_ecoute);
    vr2 = execl(GECI, GECI, char_sock, (char *)0);
    if (vr2 == -1)
      fprintf(stderr, "gecid: %s not found on this system\n", GECI);
    exit(0);
  }
  else if (vr==-1) fprintf(stderr,"gecid: fork failed\n");
}
