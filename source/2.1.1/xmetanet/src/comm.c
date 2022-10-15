#include <malloc.h>
#include <stdio.h>
#include <X11/Intrinsic.h>

#include "list.h"
#include "graph.h"
#include "graphics.h"
#include "menus.h"
#include "metadir.h"

#include "libCalCom.h"
#include "libCom.h"

extern int ComputeScilabGraph();
extern void CreateGraph();
extern int LoadNamedGraph();
extern void ShowNodeSet();
extern void ShowPath();

void GetMsg();
void SendMsg();

void ParseMessage(type,b)
char *type;
char *b;
{
  int gsize;
  char *g;
  if (!strcmp(type,ACK)) {
  } else if (!strcmp(type,CREATE)) {
    CreateGraph(b);
  } else if (!strcmp(type,LOAD)) {
    if (LoadNamedGraph(b,0)) {
      gsize = ComputeScilabGraph(&g);
      if (gsize == 0) SendMsg(ACK,""); 
      else {
	SendMsg(LOAD,g);
	free(g);
      }
    }
    else SendMsg(ACK,"");
  } else if (!strcmp(type,LOAD1)) {
    if (LoadNamedGraph(b,1)) {
      gsize = ComputeScilabGraph(&g);
      if (gsize == 0) SendMsg(ACK,""); 
      else {
	SendMsg(LOAD,g);
	free(g);
      }
    }
    else SendMsg(ACK,"");
  } else if (!strcmp(type,SHOWNS)) {
    ShowNodeSet(b,0);
  } else if (!strcmp(type,SHOWP)) {
    ShowPath(b,0);
  } else if (!strcmp(type,SHOWNS1)) {
    ShowNodeSet(b,1);
  } else if (!strcmp(type,SHOWP1)) {
    ShowPath(b,1);
  }
}

void GetMsg(message)
Message message;
{
  ParseMessage(message.tableau[3],message.tableau[4]);
}

void SendMsg(type, msg)
char *type;
char *msg;
{
  envoyer_message_parametres_var(ID_GeCI,MSG_POSTER_LISTE_ELMNT,
				 type,msg,NULL);
}
