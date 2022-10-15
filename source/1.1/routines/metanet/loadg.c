#include "../machine.h"

#include "message.h"
#include "stdio.h"

extern int SendMsg();
extern int checkcon();
extern void block();
extern void unblock();
extern void cerro();

int GetGraph(msg)
char **msg;
{
  MTYPE type;
  int isize = sizeof(int);
  int i,msgrest,msgsize,n,s;
  char buf[BUFSIZE];
  int nn = 0;

  n = read(sock,buf,2*isize);
  bcopy(buf,(char *)&type,isize);
  bcopy(buf+isize,(char *)&msgsize,isize);

  if (type == ACK) return 0;

  if ((*msg = (char *)malloc(msgsize)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  s = 0; msgrest = msgsize;
  while (msgrest > 0) {
    n = read(sock,buf,BUFSIZE); nn++;
    bcopy(buf,(*msg)+s,n);
    s += n;
    msgrest -= n;
  }

  return msgsize;
}

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
  char *g;
  int dsize,ip,isize,s,size;
  int lo,vint;
  int lnname, laname;

  isize = sizeof(int);
  dsize = sizeof(double);
  if (checkcon() == 0) return;
  name[*lname] = '\0';
  if (*sup == 0) lo = LOAD; else lo = LOAD1; 
  if (SendMsg(lo,name,*lname + 1) == 0) return;

  size = GetGraph(&g);
  if (size == 0) {
    cerro("Graph not received");
    return;
  }

  ip = *lname + 1;

  s = isize;
  bcopy(g+ip,(char *)&vint,s);
  *direct = vint;
  ip += s;

  s = isize;
  bcopy(g+ip,(char *)&vint,s);
  *m = vint;
  ip += s;

  s = isize;
  bcopy(g+ip,(char *)&vint,s);
  *n = vint;
  ip += s;

  s = isize;
  bcopy(g+ip,(char *)&vint,s);
  *ma = vint;
  ip += s;

  s = isize;
  bcopy(g+ip,(char *)&vint,s);
  *mm = vint;
  ip += s;

  s = isize * *m;
  if ((*la1 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*la1,s);
  ip += s;
  
  s = isize * (*n + 1);
  if ((*lp1 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*lp1,s);
  ip += s;
  
  s = isize * *m;
  if ((*ls1 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*ls1,s);
  ip += s;
  
  s = isize * *mm;
  if ((*la2 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*la2,s);
  ip += s;
  
  s = isize * (*n + 1);
  if ((*lp2 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*lp2,s);
  ip += s;
  
  s = isize * *mm;
  if ((*ls2 = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*ls2,s);
  ip += s;

  s = isize * *ma;
  if ((*he = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*he,s);
  ip += s;

  s = isize * *ma;
  if ((*ta = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*ta,s);
  ip += s;

  s = isize;
  bcopy(g+ip,(char *)&vint,s);
  lnname = vint;
  ip += s;

  s = lnname;
  ip += s;

  s = isize * *n;
  if ((*ntype = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*ntype,s);
  ip += s;

  s = isize * *n;
  if ((*xnode = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*xnode,s);
  ip += s;

  s = isize * *n;
  if ((*ynode = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*ynode,s);
  ip += s;

  s = isize * *n;
  if ((*ncolor = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*ncolor,s);
  ip += s;

  s = dsize * *n;
  if ((*demand = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*demand,s);
  ip += s;

  s = isize;
  bcopy(g+ip,(char *)&vint,s);
  laname = vint;
  ip += s;

  s = laname;
  ip += s;

  s = isize * *ma;
  if ((*acolor = (int *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*acolor,s);
  ip += s;

  s = dsize * *ma;
  if ((*length = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*length,s);
  ip += s;

  s = dsize * *ma;
  if ((*cost = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*cost,s);
  ip += s;

  s = dsize * *ma;
  if ((*mincap = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*mincap,s);
  ip += s;

  s = dsize * *ma;
  if ((*maxcap = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*maxcap,s);
  ip += s;

  s = dsize * *ma;
  if ((*qweight = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*qweight,s);
  ip += s;

  s = dsize * *ma;
  if ((*qorig = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*qorig,s);
  ip += s;

  s = dsize * *ma;
  if ((*weight = (double *)malloc(s)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  bcopy(g+ip,(char *)*weight,s);
  ip += s;

  *n1 = *n + 1;
  *mdim = *m;
  *ndim = *n;
  *mmdim = *mm;
  *madim = *ma;

  free(g);

  if (ip != size) {
    cerro("Internal error: bad graph size");
    return;
  }
}
