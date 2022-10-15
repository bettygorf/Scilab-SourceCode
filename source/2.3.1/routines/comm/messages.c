
#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif
#include <stdio.h>

#include "../machine.h"
#include "../intersci/cerro.h"
#include "../libcomm/libCalCom.h"
#include "../libcomm/libCom.h"

static char *TheAppli;
static char *TheType;
static char *TheMsg;

/* Called when a message comes: see initcom.c */
void ParseMessage(message)
Message message;
{
  int lappli, ltype, lmsg;

  lappli = strlen(message.tableau[0]);
  if ((TheAppli = (char *)malloc((unsigned)sizeof(char)*(lappli + 1)))
      == NULL) {
    cerro("Running out of memory");
    return;
  }
  strcpy(TheAppli,message.tableau[0]);

  ltype = strlen(message.tableau[3]);
  if ((TheType = (char *)malloc((unsigned)sizeof(char)*(ltype + 1)))
      == NULL) {
    cerro("Running out of memory");
    return;
  }
  strcpy(TheType,message.tableau[3]);

  lmsg = strlen(message.tableau[4]);
  if ((TheMsg = (char *)malloc((unsigned)sizeof(char)*(lmsg + 1)))
      == NULL) {
    cerro("Running out of memory");
    return;
  }
  strcpy(TheMsg,message.tableau[4]);
}

/* Communication functions for Scilab toplevel */

/* sends a message "msg" of type "type" */
void C2F(sendmsg)(type,ltype,msg,lmsg)
     char *type; int *ltype;
     char *msg; int *lmsg;
{
  type[*ltype] = '\0';
  msg[*lmsg] = '\0';
  envoyer_message_parametres_var(ID_GeCI,MSG_POSTER_LISTE_ELMNT,
				 type,msg,NULL);
}

/* gets a message "msg" of type "type" from the application "appli" */
void C2F(getmsg)(appli,lappli,type,ltype,msg,lmsg)
     char **appli; int *lappli;
     char **type; int *ltype;
     char ** msg; int *lmsg;
{
  TheAppli = ""; TheType = ""; TheMsg = "";
  scanner_messages();
  
  *lappli = strlen(TheAppli);
  *appli = TheAppli;
  *ltype = strlen(TheType);
  *type = TheType;
  *lmsg = strlen(TheMsg);
  *msg = TheMsg;
}

#define MAXNAM 126
#define MAXARGS 11

/* executes the application "appli" on host "host" 
   the command line is "command" */
void C2F(execappli)(command,lcommand,host,lhost,appli,lappli)
     char *command; int *lcommand;
     char *host; int *lhost;
     char *appli; int *lappli;
{
  int nargs = 0;
  char w[MAXNAM];
  int inword = 1;
  int i = 0;
  char *args[MAXARGS];
  
  command[*lcommand] = '\0';
  host[*lhost] = '\0';
  appli[*lappli] = '\0';

  /* cut the string "command" into "nargs" "args" */
  if (*command == ' ' || *command == '\t') inword = 0;
  while (*command) {
    if (inword) {
      w[i++] = *command++;
      if (*command == ' ' || *command == '\t' || *command == '\0') {
	w[i] = '\0';
	args[nargs] = (char *)malloc((unsigned)(i+1));
	strcpy(args[nargs],w);
	nargs++;
	inword = 0;
      }
    }
    else {
      command++; /** jpc : I remove * in  *command++ cause it's unused **/
      if (*command != ' ' && *command != '\t') {
	i = 0;
	inword = 1;
      }
    }
  }
  
  switch (nargs) {
  case 0:
    return;
  case 1:
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   NULL);
    break;
  case 2:
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   args[1],
				   NULL);
    break;
  case 3:
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   args[1],args[2],
				   NULL);
    break;
  case 4:
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   args[1],args[2],args[3],
				   NULL);
    break;
  case 5:
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   args[1],args[2],args[3],args[4],
				   NULL);
    break;
  case 6:
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   args[1],args[2],args[3],args[4],args[5],
				   NULL);
    break;
  case 7:
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   args[1],args[2],args[3],args[4],args[5],
				   args[6],
				   NULL);
    break;
  case 8:
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   args[1],args[2],args[3],args[4],args[5],
				   args[6],args[7],
				   NULL);
    break;
  case 9:
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   args[1],args[2],args[3],args[4],args[5],
				   args[6],args[7],args[8],
				   NULL);
    break;
  case 10:
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   args[1],args[2],args[3],args[4],args[5],
				   args[6],args[7],args[8],args[9],
				   NULL);
    break;
  default:
    /* if more than MAXARGS arguments, discard them! */
    envoyer_message_parametres_var(ID_GeCI,MSG_LANCER_APPLI,
				   appli,host,args[0],
				   INS_ID_PIPES,
				   args[1],args[2],args[3],args[4],args[5],
				   args[6],args[7],args[8],args[9],args[10],
				   NULL);
    break;
  }
}

/* creates a link from application "appli1" to application "appli2" */
void C2F(createlink)(appli1,lappli1,appli2,lappli2)
     char *appli1; int *lappli1;
     char *appli2; int *lappli2;
{
  appli1[*lappli1] = '\0';
  appli2[*lappli2] = '\0';
  if (!strcmp(appli1,"SELF"))
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_CREER_LIAISON, 
				   identificateur_appli(),
				   appli2,
				   NULL);
  else if (!strcmp(appli2,"SELF"))
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_CREER_LIAISON, 
				   appli1,
				   identificateur_appli(),
				   NULL);

  else
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_CREER_LIAISON, 
				   appli1,
				   appli2,
				   NULL);
}

/* destroys a link from application "appli1" to application "appli2" */
void C2F(destroylink)(appli1,lappli1,appli2,lappli2)
     char *appli1; int *lappli1;
     char *appli2; int *lappli2;
{
  appli1[*lappli1] = '\0';
  appli2[*lappli2] = '\0';
  if (!strcmp(appli1,"SELF"))
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_DETRUIRE_LIAISON, 
				   identificateur_appli(),
				   appli2,
				   NULL);
  else if (!strcmp(appli2,"SELF"))
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_DETRUIRE_LIAISON, 
				   appli1,
				   identificateur_appli(),
				   NULL);

  else
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_DETRUIRE_LIAISON, 
				   appli1,
				   appli2,
				   NULL);
}

/* waits for a message coming from the application "appli" 
     this message is "msg" with type "type" */
void C2F(waitmsg)(appli,lappli,type,ltype,msg,lmsg)
     char *appli; int *lappli;
     char **type; int *ltype;
     char ** msg; int *lmsg;
{
  Message message;

  appli[*lappli] = '\0';
  message = attendre_reponse(appli,
			     MSG_DISTRIB_LISTE_ELMNT,
			     NBP_DISTRIB_LISTE_ELMNT);
  TheAppli = ""; TheType = ""; TheMsg = "";
  ParseMessage(message);
  *ltype = strlen(TheType);
  *type = TheType;
  *lmsg = strlen(TheMsg);
  *msg = TheMsg;
}
