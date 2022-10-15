#include <stdio.h>

#include "../machine.h"

#include "../comm/libCalCom.h"
#include "../comm/libCom.h"

extern void SendMsg();
extern int checkNetconnect();
extern int checkTheNetwindow();

#define mystrcat(s1,s2) istr=0;while(s2[istr]!='\0'){s1[ib++]=s2[istr++];}s1[ib++]=CHARSEP;

void C2F(createg)(name,lname,
	      direct,m,n,ma,mm,la1,lp1,ls1,la2,lp2,ls2,he,ta,
	      ntype,xnode,ynode,ncolor,demand,acolor,
	      length,cost,mincap,maxcap,qweight,qorig,weight)
char *name; int *lname;
int *direct,*m,*n,*ma,*mm,*la1,*lp1,*ls1,*la2,*lp2,*ls2,*he,*ta;
int *ntype,*xnode,*ynode,*ncolor,*acolor; double *demand;
double *length,*cost,*mincap,*maxcap,*qweight,*qorig,*weight;
{
  int bsize,i,istr,mem,nitem,salloc;
  int lnname,laname;
  char str[80];
  char *b;
  int ib = 0;

  if (!checkNetconnect() || !checkTheNetwindow()) return;

  nitem = 1; mem = *lname + 1;
  nitem += 8 + (2 * *m) + (2 * (*n + 1)) + (2 * *mm) + (3 * *ma) + (4 * *n);
  mem +=  ISIZE * (8 + (2 * *m) + (2 * (*n + 1)) + (2 * *mm) + (3 * *ma) +
		   (4 * *n));
  nitem += *n + (7 * *ma);
  mem += DSIZE * (*n + (7 * *ma));

  lnname = 0;
  for (i = 1; i <= *n; i++) {
    sprintf(str,"%d",i);
    lnname += strlen(str) + 1;
  }
  nitem += *n;
  mem += lnname;
  laname = 0;
  for (i = 1; i <= *ma; i++) {
    sprintf(str,"%d",i);
    laname += strlen(str) + 1;
  }  
  nitem += *ma;
  mem += laname;  

  salloc = mem + nitem;
  if ((b = (char *)malloc((unsigned)salloc)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  
  name[*lname] = '\0';

  strcpy(str,name);
  mystrcat(b,str);

  sprintf(str,"%d",*direct);
  mystrcat(b,str);

  sprintf(str,"%d",*m);
  mystrcat(b,str);

  sprintf(str,"%d",*n);
  mystrcat(b,str);

  sprintf(str,"%d",*ma);
  mystrcat(b,str);

  sprintf(str,"%d",*mm);
  mystrcat(b,str);

  for (i = 0; i < *m; i++) {
    sprintf(str,"%d",la1[i]);
    mystrcat(b,str);
  }
 
  for (i = 0; i < *n + 1; i++) {
    sprintf(str,"%d",lp1[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *m; i++) {
    sprintf(str,"%d",ls1[i]);
    mystrcat(b,str);
  }
  
  for (i = 0; i < *mm; i++) {
    sprintf(str,"%d",la2[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *n + 1; i++) {
    sprintf(str,"%d",lp2[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *mm; i++) {
    sprintf(str,"%d",ls2[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *ma; i++) {
    sprintf(str,"%d",he[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *ma; i++) {
    sprintf(str,"%d",ta[i]);
    mystrcat(b,str);
  }

  for (i = 1; i <= *n; i++) {
    sprintf(str,"%d",i);
    mystrcat(b,str);
  }

  for (i = 0; i < *n; i++) {
    sprintf(str,"%d",ntype[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *n; i++) {
    sprintf(str,"%d",xnode[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *n; i++) {
    sprintf(str,"%d",ynode[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *n; i++) {
    sprintf(str,"%d",ncolor[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *n; i++) {
    sprintf(str,"%e",demand[i]);
    mystrcat(b,str);
  }

  for (i = 1; i <= *ma; i++) {
    sprintf(str,"%d",i);
    mystrcat(b,str);
  }

  for (i = 0; i < *ma; i++) {
    sprintf(str,"%d",acolor[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *ma; i++) {
    sprintf(str,"%e",length[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *ma; i++) {
    sprintf(str,"%e",cost[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *ma; i++) {
    sprintf(str,"%e",mincap[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *ma; i++) {
    sprintf(str,"%e",maxcap[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *ma; i++) {
    sprintf(str,"%e",qweight[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *ma; i++) {
    sprintf(str,"%e",qorig[i]);
    mystrcat(b,str);
  }

  for (i = 0; i < *ma; i++) {
    sprintf(str,"%e",weight[i]);
    mystrcat(b,str);
  }

  b[ib] = '\0';
  bsize = ib;

  if (bsize > salloc) {
    cerro("Internal error: bad graph size");
    return;
  }

  SendMsg(CREATE,b);
  free(b);
}
