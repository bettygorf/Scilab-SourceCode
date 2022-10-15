#include <malloc.h>
#include <string.h>

#include "metadir.h"
#include "list.h"
#include "graph.h"
#include "metio.h"

void CreateGraph(b,bsize)
char *b;
int bsize;
{
  char *name;
  int lname,lnname,laname;
  int directed,m,n,ma,mm,*la1,*lp1,*ls1,*la2,*lp2,*ls2,*he,*ta;
  int *ntype,*xnode,*ynode,*ncolor,*acolor; double *demand;
  double *length,*cost,*mincap,*maxcap,*qweight,*qorig,*weight;
  int dsize,ip,isize,iscoord,s,vint;
  FILE* f;
  char fname[2 * MAXNAM];
  int i;
  char *nnames,*anames;
  char **nameEdgeArray,**nameNodeArray;

  isize = sizeof(int);
  dsize = sizeof(double);
  ip = 0;

  s = isize;
  bcopy(b,(char*)&vint,s);
  lname = vint;
  ip += s;

  s = lname + 1;
  if ((name = (char*)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,name,s);
  ip += s;

  FindGraphNames();
  if (FindInLarray(name,graphNames)) {
    MetanetAlert("Graph %s already exists",name);
    return;
  }

  s = isize;
  bcopy(b+ip,(char*)&vint,s);
  directed = vint;
  ip += s;

  s = isize;
  bcopy(b+ip,(char*)&vint,s);
  m = vint;
  ip += s;

  s = isize;
  bcopy(b+ip,(char*)&vint,s);
  n = vint;
  ip += s;

  s = isize;
  bcopy(b+ip,(char*)&vint,s);
  ma = vint;
  ip += s;

  s = isize;
  bcopy(b+ip,(char*)&vint,s);
  mm = vint;
  ip += s;

  s = isize * m;
  if ((la1 = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)la1,s);
  ip += s;
  
  s = isize * (n + 1);
  if ((lp1 = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)lp1,s);
  ip += s;
  
  s = isize * m;
  if ((ls1 = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)ls1,s);
  ip += s;
  
  s = isize * mm;
  if ((la2 = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)la2,s);
  ip += s;
  
  s = isize * (n + 1);
  if ((lp2 = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)lp2,s);
  ip += s;
  
  s = isize * mm;
  if ((ls2 = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)ls2,s);
  ip += s;

  s = isize * ma;
  if ((he = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)he,s);
  ip += s;

  s = isize * ma;
  if ((ta = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)ta,s);
  ip += s;

  s = isize;
  bcopy(b+ip,(char*)&vint,s);
  lnname = vint;
  ip += s;

  s = lnname;
  if ((nnames = (char *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,nnames,s);
  ip += s;

  s = isize * n;
  if ((ntype = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)ntype,s);
  ip += s;

  s = isize * n;
  if ((xnode = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)xnode,s);
  ip += s;

  s = isize * n;
  if ((ynode = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)ynode,s);
  ip += s;

  s = isize * n;
  if ((ncolor = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)ncolor,s);
  ip += s;

  s = dsize * n;
  if ((demand = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)demand,s);
  ip += s;

  s = isize;
  bcopy(b+ip,(char*)&vint,s);
  laname = vint;
  ip += s;

  s = laname;
  if ((anames = (char *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,anames,s);
  ip += s;

  s = isize * ma;
  if ((acolor = (int *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)acolor,s);
  ip += s;

  s = dsize * ma;
  if ((length = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)length,s);
  ip += s;

  s = dsize * ma;
  if ((cost = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)cost,s);
  ip += s;

  s = dsize * ma;
  if ((mincap = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)mincap,s);
  ip += s;

  s = dsize * ma;
  if ((maxcap = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)maxcap,s);
  ip += s;

  s = dsize * ma;
  if ((qweight = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)qweight,s);
  ip += s;

  s = dsize * ma;
  if ((qorig = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)qorig,s);
  ip += s;

  s = dsize * ma;
  if ((weight = (double *)malloc((unsigned)s)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  bcopy(b+ip,(char*)weight,s);
  ip += s;

  if (ip != bsize) {
    MetanetAlert("Internal error: bad graph size");
    return;
  }

  if ((nameNodeArray = 
       (char**)malloc((unsigned)(n + 1)*sizeof(char*))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  for (i = 1; i <= n; i++) {
    nameNodeArray[i] = nnames;
    while (*nnames++ != '\0') {}
  }

  if ((nameEdgeArray = 
       (char**)malloc((unsigned)(ma + 1)*sizeof(char*))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  for (i = 1; i <= ma; i++) {
    nameEdgeArray[i] = anames;
    while (*anames++ != '\0') {}
  }

  strcpy(fname,datanet);
  strcat(fname,"/");
  strcat(fname,name);
  strcat(fname,".graph");
  f = fopen(fname,"w");

  fprintf(f,"GRAPH TYPE (0 = UNDIRECTED, 1 = DIRECTED) :\n");
  fprintf(f,"%d\n",directed);
  if (directed) {
    fprintf(f,"NUMBER OF ARCS :\n");
    fprintf(f,"%d\n",m);
  }
  else {
    fprintf(f,"NUMBER OF EDGES :\n");
    fprintf(f,"%d\n",ma);
  }
  fprintf(f,"NUMBER OF NODES :\n");
  fprintf(f,"%d\n",n);
  fprintf(f,"****************************************\n");
  if (directed) {
    fprintf(f,"DESCRIPTION OF ARCS :\n");
    fprintf(f,"ARC NAME, TAIL NODE NAME, HEAD NODE NAME, COLOR\n");
  }
  else {
    fprintf(f,"DESCRIPTION OF EDGES :\n");
    fprintf(f,"EDGE NAME, NODE NAME, NODE NAME, COLOR\n");
  }
  fprintf
    (f,"COST, MIN CAP, MAX CAP, LENGTH, Q WEIGHT, Q ORIGIN, WEIGHT\n");
  fprintf(f,"\n");
  for (i = 1; i <= ma; i++) {
    fprintf(f,"%s %s %s %d\n",nameEdgeArray[i],nameNodeArray[ta[i-1]],
	    nameNodeArray[he[i-1]],acolor[i-1]);
    fprintf(f,"%e %e %e %e %e %e %e\n",
	    cost[i-1],mincap[i-1],maxcap[i-1],
	    length[i-1],qweight[i-1],qorig[i-1],weight[i-1]);
  }
  fprintf(f,"****************************************\n");
  fprintf(f,"DESCRIPTION OF NODES :\n");
  fprintf(f,"NODE NAME, POSSIBLE TYPE (1 = SINK, 2 = SOURCE)\n");
  fprintf(f,"X, Y, COLOR\n");
  fprintf(f,"DEMAND\n");
  fprintf(f,"\n");
  iscoord = 0;
  for (i = 1; i <= n; i++) {
    if ((xnode[i-1] != 0) || (ynode[i-1] != 0)) {
      iscoord = 1;
      break;
    }
  }  
  for (i = 1; i <= n; i++) {
    if (ntype[i-1] == PLAIN)
      fprintf(f,"%s\n",nameNodeArray[i]);
    else fprintf(f,"%s %d\n",nameNodeArray[i],ntype[i-1]);
    if (iscoord)
      fprintf(f,"%d %d %d\n",xnode[i-1],ynode[i-1],ncolor[i-1]);
    else
      fprintf(f,"%d %d %d\n",xnode[i-1],ynode[i-1],ncolor[i-1]);
    fprintf(f,"%e\n",demand[i-1]);
  }

  fclose(f);
  
  AddMessage("Graph %s saved\n",name);

  free((char*)name); free((char*)la1); free((char*)lp1); free((char*)ls1); 
  free((char*)la2); free((char*)lp2); free((char*)ls2); free((char*)he); 
  free((char*)ta); free((char*)nameNodeArray); 
  free((char*)ntype);
  free((char*)xnode); free((char*)ynode); free((char*)ncolor); 
  free((char*)demand); free((char*)nameEdgeArray);
  free((char*)acolor); free((char*)length); 
  free((char*)cost); free((char*)mincap); free((char*)maxcap); 
  free((char*)qweight);  free((char*)qorig); free((char*)weight);
}
