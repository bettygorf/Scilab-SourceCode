#include "../machine.h"

#define NULL 0

void C2F(maxcpl)(c,ex,la2,lp2,ma,mm,n,or,x,z)
int *ex,*la2,*lp2,*ma,*mm,*n,*or,*x;
double *c,*z;
{
  int *alphi,*beta,*deg,*hp1,*hp2,*ihp1,*ihp2,*imin;
  int *ind,*l1,*l2,*nlp2,*m1,*m2,*q,*s1,*s2,*sat;
  double *p1w,*p2w,*pimin,*pivw,*r;
  int i,ndim,n1dim;
  int isize = sizeof(int);
  int dsize = sizeof(double);
  
  ndim = 3 * *n / 2 + 1;
  n1dim = ndim + 1;
  
  if ((alphi = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((beta = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((deg = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((hp1 = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((hp2 = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((ihp1 = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((ihp2 = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((imin = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((ind = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((l1 = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((l2 = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((nlp2 = (int *)malloc(n1dim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 0; i < (*n + 1); i++) nlp2[i]=lp2[i];
  if ((m1 = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((m2 = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   if ((p1w = (double *)malloc(ndim * dsize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   if ((p2w = (double *)malloc(ndim * dsize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   if ((pimin = (double *)malloc(ndim * dsize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   if ((pivw = (double *)malloc(ndim * dsize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((q = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
   if ((r = (double *)malloc(ndim * dsize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((s1 = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((s2 = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((sat = (int *)malloc(ndim * isize)) == NULL) {
    cerro("Running out of memory");
    return;
  }

  F2C(cplmax)(alphi,beta,c,deg,ex,hp1,hp2,ihp1,ihp2,imin,
	  ind,l1,l2,la2,nlp2,m1,m2,ma,mm,n,&n1dim,&ndim,or,
	  p1w,p2w,pimin,pivw,q,r,s1,s2,sat,x,z);

  free(alphi); free(beta); free(deg); free(hp1); free(hp2);
  free(ihp1); free(ihp2); free(imin); free(ind); free(l1);
  free(l2); free(nlp2); free(m1); free(m2); free(p1w);
  free(p2w); free(pimin); free(pivw); free(q); free(r);
  free(s1); free(s2); free(sat);
}
