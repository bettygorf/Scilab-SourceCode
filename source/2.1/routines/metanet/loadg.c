#include <stdio.h>
#include <signal.h>
#include <string.h>
#include <malloc.h>

#include "../machine.h"

#include "../comm/libCom.h"
#include "../comm/libCalCom.h"

extern double atof();

extern void cerro();
extern void GetMsg();
extern void SendMsg();
extern int checkNetconnect();
extern int checkTheNetwindow();

extern char *Netwindows[];
extern int theNetwindow;

void C2F(loadg)(sup,name,lname,
            direct,m,n,ma,mm,la1,lp1,ls1,la2,lp2,ls2,he,ta,
	    ntype,xnode,ynode,ncolor,demand,acolor,
	    length,cost,mincap,maxcap,qweight,qorig,weight,
	    n1,mdim,ndim,mmdim,madim)
char *name; int *sup,*lname;
int *direct,*m,*n,*ma,*mm,**la1,**lp1,**ls1,**la2,**lp2,**ls2,**he,**ta;
int **ntype,**xnode,**ynode,**ncolor,**acolor; double **demand;
double **length,**cost,**mincap,**maxcap,**qweight,**qorig,**weight;
int *n1,*mdim,*ndim,*mmdim,*madim;
{
  int dsize,i,isize,s;
  Message message;

  if (!checkNetconnect() || !checkTheNetwindow()) return;

  isize = sizeof(int);
  dsize = sizeof(double);

  name[*lname] = '\0';
  if (*sup == 0) SendMsg(LOAD,name); else SendMsg(LOAD1,name);

  message = attendre_reponse(Netwindows[theNetwindow-1],
			     MSG_DISTRIB_LISTE_ELMNT,NBP_DISTRIB_LISTE_ELMNT);

  if (strtok(message.tableau[4],STRINGSEP) == NULL) {
    cerro("Graph not received");
    return;
  }

  *direct = atoi(strtok(NULL,STRINGSEP));

  *m = atoi(strtok(NULL,STRINGSEP));

  *n = atoi(strtok(NULL,STRINGSEP));

  *ma = atoi(strtok(NULL,STRINGSEP));

  *mm = atoi(strtok(NULL,STRINGSEP));

  s = isize * *m;
  if ((*la1 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 0; i < *m; i++) {
    (*la1)[i] = atoi(strtok(NULL,STRINGSEP));
  }
  
  s = isize * (*n + 1);
  if ((*lp1 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 0; i < *n + 1; i++) {
    (*lp1)[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * *m;
  if ((*ls1 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 0; i < *m; i++) {
    (*ls1)[i] = atoi(strtok(NULL,STRINGSEP));
  }
  
  s = isize * *mm;
  if ((*la2 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 0; i < *mm; i++) {
    (*la2)[i] = atoi(strtok(NULL,STRINGSEP));
  }
  
  s = isize * (*n + 1);
  if ((*lp2 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *n + 1; i++) {
    (*lp2)[i] = atoi(strtok(NULL,STRINGSEP));
  }
  
  s = isize * *mm;
  if ((*ls2 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *mm; i++) {
    (*ls2)[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * *ma;
  if ((*he = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *ma; i++) {
    (*he)[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * *ma;
  if ((*ta = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *ma; i++) {
    (*ta)[i] = atoi(strtok(NULL,STRINGSEP));
  }


  for (i = 0; i < *n; i++) {
    strtok(NULL,STRINGSEP);
  }
  
  s = isize * *n;
  if ((*ntype = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *n; i++) {
    (*ntype)[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * *n;
  if ((*xnode = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *n; i++) {
    (*xnode)[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * *n;
  if ((*ynode = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *n; i++) {
    (*ynode)[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = isize * *n;
  if ((*ncolor = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *n; i++) {
    (*ncolor)[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = dsize * *n;
  if ((*demand = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *n; i++) {
    (*demand)[i] = atof(strtok(NULL,STRINGSEP));
  }

  for (i = 0; i < *ma; i++) {
    strtok(NULL,STRINGSEP);
  }
 
  s = isize * *ma;
  if ((*acolor = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *ma; i++) {
    (*acolor)[i] = atoi(strtok(NULL,STRINGSEP));
  }

  s = dsize * *ma;
  if ((*length = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *ma; i++) {
    (*length)[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * *ma;
  if ((*cost = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *ma; i++) {
    (*cost)[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * *ma;
  if ((*mincap = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *ma; i++) {
    (*mincap)[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * *ma;
  if ((*maxcap = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *ma; i++) {
    (*maxcap)[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * *ma;
  if ((*qweight = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *ma; i++) {
    (*qweight)[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * *ma;
  if ((*qorig = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *ma; i++) {
    (*qorig)[i] = atof(strtok(NULL,STRINGSEP));
  }

  s = dsize * *ma;
  if ((*weight = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   for (i = 0; i < *ma; i++) {
    (*weight)[i] = atof(strtok(NULL,STRINGSEP));
  }

  *n1 = *n + 1;
  *mdim = *m;
  *ndim = *n;
  *mmdim = *mm;
  *madim = *ma;
}
