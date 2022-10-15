#include "../../routines/stack-c.h"

/** external functions to be called through this interface **/

extern int intarrayc _PARAMS((int **a, int *m, int *n,int *err));
extern int dblearrayc _PARAMS((double **a, int *m, int *n,int *err));
extern int crestrc _PARAMS((char **a, int *m,int *err));
extern int as2osc  _PARAMS((char *thechain));

/**************************************************
 * An example of an hand written interface 
 * the interface is defined by the function 
 * testcentry and it contains three functions 
 **************************************************/


int intfce1c(fname)
  char* fname;
{ 
  /** l1 is used to store adresses it must be an unsigned long **/
  unsigned long l1;
  int m1,n1,ierr=0;
  static int minlhs=1, minrhs=0, maxlhs=1, maxrhs=0;
  Nbvars = 0;
  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;
  dblearrayc((double **) &l1,&m1,&n1,&ierr);
  if ( ierr > 0 ) 
    {
      sciprint("%s Internal Error",fname); Error(999); return(0);
    }
  CreateVarFromPtr( 1, "d", &m1, &n1, &l1);
  LhsVar(1) = 1;
  PutLhsVar();
  return(0);
}

int intfce2c(fname)
  char* fname;
{ 
  /** l1 is used to store adresses it must be an unsigned long **/
  unsigned long l1;
  int m1,n1,ierr=0;
  static int minlhs=1, minrhs=0, maxlhs=1, maxrhs=0;
  Nbvars = 0;
  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;
  intarrayc((int **) &l1,&m1,&n1,&ierr);
  if ( ierr > 0 ) 
    {
      sciprint("%s Internal Error",fname); Error(999); return(0);
    }
  CreateVarFromPtr( 1, "i", &m1, &n1, &l1);
  LhsVar(1) = 1;
  PutLhsVar();
  return(0);
}

int intfce3c(fname)
  char* fname;
{ 
  /** l1 is used to store adresses it must be an unsigned long **/
  unsigned long l1;
  int m1,n1,ierr=0;
  static int minlhs=1, minrhs=0, maxlhs=1, maxrhs=0;

  Nbvars = 0;

  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;
  crestrc((char **) &l1,&m1,&ierr);
  if ( ierr > 0 ) 
    {
      sciprint("%s Internal Error",fname); Error(999); return(0);
    }
  n1=1;
  CreateVarFromPtr( 1, "c", &m1, &n1, &l1);
  LhsVar(1) = 1;
  PutLhsVar();
  return(0);
}

int intfce4c(fname)
     char* fname;
{ 
  int l1,m1,n1;
  static int minlhs=1, minrhs=1, maxlhs=1, maxrhs=1;
  Nbvars = 0;

  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;

  GetRhsVar( 1, "c", &m1, &n1, &l1);

  as2osc(cstk(l1)); 

  LhsVar(1) = 1;
  PutLhsVar();
  return(0);
}

int intfce5c(fname)
     char* fname;
{ 
  int l1;
  static int minlhs=1, minrhs=0, maxlhs=1, maxrhs=0;
  static int m, n, lp;
  int k;
  Nbvars = 0;

  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;

  GetMatrixptr("param", &m, &n, &lp);
  CreateVar(1, "d",  &m, &n, &l1);

  for (k = 0; k <= 10; ++k) 
    { 
      (*stk(l1+k)) = (*stk(lp+k));
    }
  
  LhsVar(1) = 1;
  PutLhsVar();
  return(0);
}


static TabF Tab[]={ 
  {intfce1c, "funcc1"},
  {intfce2c, "funcc2"}, 
  {intfce3c, "funcc3"}, 
  {intfce4c, "funcc4"},
  {intfce5c, "funcc5"}
};


int C2F(testcentry)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name);
  return 0;
}





