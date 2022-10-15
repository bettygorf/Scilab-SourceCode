/* Copyright INRIA */
#include <stdio.h>
#ifndef __ABSC__
#include <sys/types.h>
#endif
#if !(defined __MSC__) && !(defined __ABSC__)
#include <netinet/in.h>
#include <netdb.h>
#endif

#include "../machine.h"
#include "../intersci/cerro.h"

#include "../libcomm/libCalCom.h"
#include "../libcomm/libCom.h"

int isGeci = 0;

extern void ParseMessage();

static void quitter_appli_msgact();  
static void FinAppli();
static void erreur_message_msgact(); 

/* known messages for Scilab */
static actions_messages tb_messages[]={
    {ID_GeCI,MSG_QUITTER_APPLI,NBP_QUITTER_APPLI,quitter_appli_msgact},
    {ID_GeCI,MSG_FIN_APPLI,NBP_FIN_APPLI,FinAppli},
    {NULL,MSG_DISTRIB_LISTE_ELMNT,NBP_DISTRIB_LISTE_ELMNT,ParseMessage},
    {NULL,NULL,0,erreur_message_msgact}};

extern void CloseNetwindow();
extern int nNetwindows;
extern char *Netwindows[];

/* Send message and get messages for internal use */

void SendMsg(type,msg)
char *type;
char *msg;
{
  envoyer_message_parametres_var(ID_GeCI,MSG_POSTER_LISTE_ELMNT,
				 type,msg,NULL);
}

static void erreur_message_msgact(message)
Message message;
{
    cerro("Bad received message!!!");
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
  /* If a xmetanet application is ended, put "CLOSED" flag to 
     corresponding Metanet Window */
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
