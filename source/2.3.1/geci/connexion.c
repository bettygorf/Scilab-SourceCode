#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

/*
#if defined (sun) && defined (SYSV)
#define bcopy(b1,b2,len) memmove(b2, b1, (size_t)(len))
#endif
*/

#include "connexion.h"

int connexion(machine)
char *machine;
{
    struct sockaddr_in nom;
    struct hostent *hp;
    int desc;
    
    char *display_ok;
    
    /* on autorise la machine distante a ecrire sur notre display 
       display_ok=(char *) malloc (64);
       sprintf(display_ok,"xhost +%s >/dev/null",machine);
       system(display_ok);
       free(display_ok);
       */

    /* Creation de la socket de type SOCK_STREAM (mode connecte), dans le
       domaine INternet (AF_INET) */
    if ((desc=socket(AF_INET,SOCK_STREAM,0)) == -1){
	fprintf(stderr,"Impossible to create socket\n");
	return -1;
    }
     
    /* Recherche de l'adresse Internet du serveur a partir du nom de la 
       machine */
    if ((hp=gethostbyname(machine))==NULL){
	fprintf(stderr,"Unknown host address: %s\n",machine);
	return -1;
    }

    /* Preparation de l'adresse de la socket destinataire */
    /* bcopy(hp->h_addr,&nom.sin_addr,hp->h_length); */
    strncpy(&nom.sin_addr,hp->h_addr,hp->h_length);
    nom.sin_family=AF_INET;
    nom.sin_port=htons(PORT);  
    
     /* Demande de connexion au demon */
    if (connect(desc,(struct sockaddr *)&nom,sizeof(nom))== -1){
      fprintf(stderr,"Connexion error\n");
      return -1;
    }

    return desc;
}

