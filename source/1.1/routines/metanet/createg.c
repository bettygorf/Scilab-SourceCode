#include "../machine.h"

#include "message.h"

void C2F(createg)(name,lname,
	      direct,m,n,ma,mm,la1,lp1,ls1,la2,lp2,ls2,he,ta,
	      ntype,xnode,ynode,ncolor,demand,acolor,
	      length,cost,mincap,maxcap,qweight,qorig,weight)
char *name; int *lname;
int *direct,*m,*n,*ma,*mm,*la1,*lp1,*ls1,*la2,*lp2,*ls2,*he,*ta;
int *ntype,*xnode,*ynode,*ncolor,*acolor; double *demand;
double *length,*cost,*mincap,*maxcap,*qweight,*qorig,*weight;
{
  int dsize,isize,s,bsize,mem;
  int lnname,laname;
  char str[80];
  char *b;
  int i;

  if (checkcon() == 0) return;

  isize = sizeof(int);
  dsize = sizeof(double);

  mem = *lname + 1;
  mem +=  isize * (8 + (2 * *m) + (2 * (*n + 1)) + (2 * *mm) + (3 * *ma) +
		     (4 * *n));
  mem += dsize * (*n + (7 * *ma));

  lnname = 0;
  for (i = 1; i <= *n; i++) {
    sprintf(str,"%d",i);
    lnname += strlen(str) + 1;
  }
  mem += lnname;
  laname = 0;
  for (i = 1; i <= *ma; i++) {
    sprintf(str,"%d",i);
    laname += strlen(str) + 1;
  }  
  mem += laname;  

  if ((b = (char *)malloc(mem)) == NULL) {
    cerro("Running out of memory");
    return;
  }

  name[*lname] = '\0';

  bsize = 0;

  s = isize;
  bcopy((char *)lname,b,s);
  bsize += s;

  s = *lname + 1;
  bcopy(name,b+bsize,s);
  bsize += s;

  s = isize;
  bcopy((char *)direct,b+bsize,s);
  bsize +=s;

  s = isize;
  bcopy((char *)m,b+bsize,s);
  bsize +=s;

  s = isize;
  bcopy((char *)n,b+bsize,s);
  bsize +=s;

  s = isize;
  bcopy((char *)ma,b+bsize,s);
  bsize +=s;

  s = isize;
  bcopy((char *)mm,b+bsize,s);
  bsize +=s;

  s = *m * isize;
  bcopy((char *)la1,b+bsize,s);
  bsize +=s;

  s = (*n + 1) * isize;
  bcopy((char *)lp1,b+bsize,s);
  bsize +=s;

  s = *m * isize;
  bcopy((char *)ls1,b+bsize,s);
  bsize +=s;

  s = *mm * isize;
  bcopy((char *)la2,b+bsize,s);
  bsize +=s;

  s = (*n + 1) * isize;
  bcopy((char *)lp2,b+bsize,s);
  bsize +=s;

  s = *mm * isize;
  bcopy((char *)ls2,b+bsize,s);
  bsize +=s;

  s = *ma * isize;
  bcopy((char *)he,b+bsize,s);
  bsize +=s;

  s = *ma * isize;
  bcopy((char *)ta,b+bsize,s);
  bsize +=s;

  s = isize;
  bcopy((char*)&lnname,b+bsize,s);
  bsize +=s;

  for (i = 1; i <= *n; i++) {
    sprintf(str,"%d",i);
    s = strlen(str) + 1;
    bcopy(str,b+bsize,s);
    bsize +=s;
  }

  s = *n * isize;
  bcopy((char *)ntype,b+bsize,s);
  bsize += s;

  s = *n * isize;
  bcopy((char *)xnode,b+bsize,s);
  bsize += s;

  s = *n * isize;
  bcopy((char *)ynode,b+bsize,s);
  bsize += s;

  s = *n * isize;
  bcopy((char *)ncolor,b+bsize,s);
  bsize += s;

  s = *n * dsize;
  bcopy((char *)demand,b+bsize,s);
  bsize +=s;

  s = isize;
  bcopy((char*)&laname,b+bsize,s);
  bsize +=s;

  for (i = 1; i <= *ma; i++) {
    sprintf(str,"%d",i);
    s = strlen(str) + 1;
    bcopy(str,b+bsize,s);
    bsize +=s;
  }

  s = *ma * isize;
  bcopy((char *)acolor,b+bsize,s);
  bsize += s;

  s = *ma * dsize;
  bcopy((char *)length,b+bsize,s);
  bsize +=s;

  s = *ma * dsize;
  bcopy((char *)cost,b+bsize,s);
  bsize +=s;

  s = *ma * dsize;
  bcopy((char *)mincap,b+bsize,s);
  bsize +=s;
  
  s = *ma * dsize;
  bcopy((char *)maxcap,b+bsize,s);
  bsize +=s;
  
  s = *ma * dsize;
  bcopy((char *)qweight,b+bsize,s);
  bsize +=s;
  
  s = *ma * dsize;
  bcopy((char *)qorig,b+bsize,s);
  bsize +=s;

  s = *ma * dsize;
  bcopy((char *)weight,b+bsize,s);
  bsize +=s;

  if (bsize != mem) {
    cerro("Internal error: bad graph size");
    return;
  }

  SendMsg(CREATE,b,bsize);
}
