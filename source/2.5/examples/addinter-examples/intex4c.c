#include "stack-c.h"

extern int intarrayc _PARAMS((int **a, int *m, int *n,int *err));

/*      Creating a scilab variable from a pointer
       l1 is a pointer to an int array created 
       by the C function intarrayc (in file pgmsc.c)   */

int intex4c(fname)
  char* fname;
{ 
  /** l1 is used to store adresses it must be an unsigned long **/
  unsigned long l1;

  int m1,n1,ierr=0;
  static int minlhs=1, minrhs=0, maxlhs=1, maxrhs=0;

  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;

  intarrayc((int **) &l1, &m1, &n1, &ierr);
  if ( ierr > 0 ) 
    {
      sciprint("%s Internal Error",fname); Error(999); return(0);
    }

  CreateVarFromPtr( 1, "i", &m1, &n1, &l1);
  FreePtr(&l1);
  LhsVar(1) = 1;
  return(0);
}
