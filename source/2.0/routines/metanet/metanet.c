#include "../machine.h"

#include <errno.h>
#include <strings.h>
#include <stdio.h>
#include <stdlib.h>

#include "../comm/libCalCom.h"
#include "../comm/libCom.h"

extern void SendMsg();
extern void GetMsg();
extern void LoadGraph();

extern void cerro();
extern void cout();

#define MAXNETWINDOW 512
char *Netwindows[MAXNETWINDOW];
int theNetwindow = 0;
int nNetwindows = 0;

#define MAXNAM 80

static char str[MAXNAM];

void C2F(inimet)(scr,datanet,ldatanet)
int *scr;
char *datanet;
int *ldatanet;
{
  char windowname[MAXNAM];
  char command[2 * MAXNAM];
  char warg[MAXNAM];
  char* env;
  char server[20];

  datanet[*ldatanet] = '\0';

  gethostname(server,20);
  
  nNetwindows++;

   if (nNetwindows > MAXNETWINDOW) {
    cerro("Too many windows");
    return;
  }

  sprintf(windowname,"Metanet%d", nNetwindows);

  if ((Netwindows[nNetwindows - 1] = 
       (char *)malloc((strlen(windowname)+1) * sizeof(char))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  strcpy(Netwindows[nNetwindows - 1],windowname);

  env = getenv("XMETANET");
  if (env == NULL) {
    env = getenv("SCI");
    if (env == NULL) {
      cerro("The environment variable SCI is not defined");
      return;
    }
    else sprintf(command,"%s/bin/xmetanet",env);
  }
  else sprintf(command,"%s",env);

  sprintf(warg,"%d",nNetwindows);
  if (strcmp(datanet," ") == 0) {
     envoyer_message_parametres_var(ID_GeCI,
				   MSG_LANCER_APPLI,
				   windowname,
				   server,
				   command,
				   "-w",
				   warg,
				   "__ID_PIPES__",
				   NULL);
   
  }
  else {
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_LANCER_APPLI,
				   windowname,
				   server,
				   command,
				   "-w",
				   warg,
				   "-data",
				   datanet,
				   "__ID_PIPES__",
				   NULL);
  }

  if (theNetwindow != 0) {
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_DETRUIRE_LIAISON, 
				   identificateur_appli(),
				   Netwindows[theNetwindow - 1],NULL);
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_DETRUIRE_LIAISON, 
				   Netwindows[theNetwindow - 1],
				   identificateur_appli(),NULL);

  }

  theNetwindow = nNetwindows;

  envoyer_message_parametres_var(ID_GeCI,
				 MSG_CREER_LIAISON, 
				 identificateur_appli(),
				 Netwindows[theNetwindow - 1],NULL);
  envoyer_message_parametres_var(ID_GeCI,
				 MSG_CREER_LIAISON, 
				 Netwindows[theNetwindow - 1],
				 identificateur_appli(),NULL);

  *scr = theNetwindow;
  sleep(1);
}

int checkNetconnect()
{
  if (nNetwindows == 0) {
    cerro("You must first execute Metanet");
    return 0;
  }
  return 1;
}

int checkTheNetwindow()
{
  if (theNetwindow == 0) {
    cerro("The current window is closed");
    return 0;
  }
  return 1;
}

void C2F(netwindow)(s)
int *s;
{
  char fname[MAXNAM];
  char str[MAXNAM];

  if (checkNetconnect() == 0) return;

  if (*s > nNetwindows || *s < 1) {
    sprintf(str,"Bad window number: %d",*s);
    cerro(str);
    return;
  }

  if (strcmp(Netwindows[*s - 1],"CLOSED") == 0) {
    sprintf(str,"Window number %d is closed",*s);
    cerro(str);
    return;
  }
  
  if (theNetwindow != 0) {
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_DETRUIRE_LIAISON, 
				   identificateur_appli(),
				   Netwindows[theNetwindow - 1],NULL);
    envoyer_message_parametres_var(ID_GeCI,
				   MSG_DETRUIRE_LIAISON, 
				   Netwindows[theNetwindow - 1],
				   identificateur_appli(),NULL);
  }

  theNetwindow = *s;
  envoyer_message_parametres_var(ID_GeCI,
				 MSG_CREER_LIAISON, 
				 identificateur_appli(),
				 Netwindows[theNetwindow - 1],NULL);
  envoyer_message_parametres_var(ID_GeCI,
				 MSG_CREER_LIAISON, 
				 Netwindows[theNetwindow - 1],
				 identificateur_appli(),NULL);
}

void C2F(netwindows)(vs,nvs)
int **vs;
int *nvs;
{
  char fname[MAXNAM];
  int i,j;
  int s[MAXNETWINDOW];

  if (checkNetconnect() == 0) return;

  j = 0;
  for (i = 1; i <= nNetwindows; i++ ) {
    if (strcmp(Netwindows[i - 1],"CLOSED") != 0)
      s[j++] = i;
  }

  *nvs = j;
  if (j == 0) return;

  if ((*vs = (int *)malloc(*nvs * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 0; i < *nvs; i++){
    (*vs)[i] = s[i];
  }
}

void CloseNetwindow(s)
int s;
{
  if ((Netwindows[s - 1] = 
       (char *)malloc((strlen("CLOSED")+1) * sizeof(char))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  strcpy(Netwindows[s - 1],"CLOSED");

  if (theNetwindow == s) {
    sprintf(str,"Warning: current Metanet window %d has been closed",s);
    cout(str);
    theNetwindow = 0;
  }
}
