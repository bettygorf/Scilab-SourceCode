#include <stdio.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>

#include "../machine.h"

#include "libCalCom.h"
#include "libCom.h"

int isGeci = 0;

/* Table des messages reconnus par Scilab */

static void quitter_appli_msgact();  
static void FinAppli();
static void erreur_message_msgact(); 
static void coucou();

actions_messages tb_messages[]={
    {ID_GeCI,MSG_QUITTER_APPLI,NBP_QUITTER_APPLI,quitter_appli_msgact},
    {ID_GeCI,MSG_FIN_APPLI,NBP_FIN_APPLI,FinAppli},
    {NULL,MSG_DISTRIB_LISTE_ELMNT,NBP_DISTRIB_LISTE_ELMNT,coucou},
    {NULL,NULL,0,erreur_message_msgact}};

extern void CloseNetwindow();
extern int nNetwindows;
extern char *Netwindows[];

static void coucou(message)
Message message;
{
  fprintf(stderr,"COUCOU %s %s\n",message.tableau[3],message.tableau[4]);
}

void SendMsg(type,msg)
char *type;
char *msg;
{
  envoyer_message_parametres_var(ID_GeCI,MSG_POSTER_LISTE_ELMNT,
				 type,msg,NULL);
}

void GetMsg() {
  scanner_messages();
}

static void erreur_message_msgact(message)
Message message;
{
    cerro("Message  recu incorrect !!!");
    return;
    
/*    envoyer_message_parametres_var(ID_GeCI, MSG_FIN_APPLI, NULL);
    exit(1);*/
}

static void quitter_appli_msgact(message)
Message message;
{  
    exit(0);
}

static void FinAppli(message) 
Message message;
{
  int i;

  for (i = 0; i < nNetwindows; i++) {
    if (strcmp(Netwindows[i],message.tableau[3]) == 0) {
      CloseNetwindow(i+1);
      return;
    }
  }
}

void C2F(initcom)(in,out)
int *in,*out;
{
  init_messages(tb_messages,*in,*out);
  isGeci = 1;
}


