#include "spmatrix.h"
#include "../machine.h"

#define NULL 0

void C2F(lufact1)(val,rc,n,k,fmat)
double *val;
int **fmat;
int *n,*rc,*k;
{
  int error;
  int i;
  spREAL *pelement;
  char *matrix;

  *fmat = (int*)spCreate(*n,0,&error);
    if (error != spOKAY) cerro("Unable to create matrix");

  for (i = 0; i < *k; i++) {
    pelement = spGetElement((char*)*fmat,(rc)[i],(rc)[*k + i]);
    if (pelement == NULL) cerro("Not enough memory to create element");
    spADD_REAL_ELEMENT(pelement,(spREAL)(val[i]));
  }

  error = spFactor((char*)*fmat);
  switch (error) {
  case spZERO_DIAG:
    cerro("Zero pivot");
    break;
  case spNO_MEMORY:
    cerro("Not enough memory");
    break;
  case spSINGULAR:
    cerro("Singular matrix");
    break;
  case spSMALL_PIVOT:
    cerro("Ill conditionned matrix");
    break;
  }
}

void C2F(lusolve1)(fmat,b,x)
double *b, *x;
int **fmat;
{
  spSolve((char*)*fmat,(spREAL*)b,(spREAL*)x);
}

void C2F(ludel1)(fmat)
int **fmat;
{
  spDestroy((char*)*fmat);
}
