#include <string.h>

#include "../machine.h"

#include "../comm/libCalCom.h"
#include "../comm/libCom.h"

extern void SendMsg();
extern int checkNetconnect();
extern int checkTheNetwindow();


#define mystrcat(s1,s2) istr=0;while(s2[istr]!='\0'){s1[ig++]=s2[istr++];}s1[ig++]=CHARSEP;

#define MAXNAM 80

void C2F(showp)(p,psize,sup)
int *p;
int *psize;
int *sup;
{
  char *g;
  char str[MAXNAM];
  int i,istr;
  int ig = 0;

  if (!checkNetconnect() || !checkTheNetwindow()) return;

  if ((g = (char *)malloc((unsigned)((ISIZE + 1) * *psize))) == NULL) {
    cerro("Running out of memory");
    return;
  }

  for (i = 0; i < *psize; i++) {
    sprintf(str,"%d",p[i]);
    mystrcat(g,str);
  }
  g[ig] = '\0';

  if (*sup) SendMsg(SHOWP1,g); else SendMsg(SHOWP,g);
}

void C2F(showns)(ns,nsize,sup)
int *ns;
int *nsize;
int *sup;
{
  char *g;
  char str[MAXNAM];
  int i,istr;
  int ig = 0;

  if (!checkNetconnect() || !checkTheNetwindow()) return;

  if ((g = (char *)malloc((unsigned)((ISIZE + 1) * *nsize))) == NULL) {
    cerro("Running out of memory");
    return;
  }

  for (i = 0; i < *nsize; i++) {
    sprintf(str,"%d",ns[i]);
    mystrcat(g,str);
  }
  g[ig] = '\0';

  if (*sup) SendMsg(SHOWNS1,g); else SendMsg(SHOWNS,g);
}
