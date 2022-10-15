#include "../machine.h"

#include "message.h"

extern SendMsg();
extern checkcon();

void C2F(showp)(p,psize,sup)
int *p;
int *psize;
int *sup;
{
  MTYPE t; 
  if (checkcon() == 0) return;
  if (*sup) t = SHOWP1; else t = SHOWP;
  SendMsg(t,(char *)p,*psize * sizeof(int));  
}

void C2F(showns)(ns,nsize,sup)
int *ns;
int *nsize;
int *sup;
{
  MTYPE t; 
  if (checkcon() == 0) return;
  if (*sup) t = SHOWNS1; else t = SHOWNS;
  SendMsg(t,(char *)ns,*nsize * sizeof(int));  
}
