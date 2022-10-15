/* Copyright INRIA */
#include "../../routines/stack-c.h"

/** external functions to be called through this interface **/

extern int intarrayc _PARAMS((int **a, int *m, int *n,int *err));
extern int dblearrayc _PARAMS((double **a, int *m, int *n,int *err));
extern int crestrc _PARAMS((char **a, int *m,int *err));

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
  FreePtr(&l1);
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
  FreePtr(&l1);
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
  FreePtr(&l1);
  LhsVar(1) = 1;
  PutLhsVar();
  return(0);
}


int intfce4c(fname)
  char* fname;
{ 
  /** l1 is used to store adresses it must be an unsigned long **/
  unsigned long l1,l2,l3;
  int m1,n1,m2,n2,m3,n3,ierr=0;
  int minlhs=1, minrhs=0, maxlhs=4, maxrhs=0;

  Nbvars = 0;

  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;

  crestrc((char **) &l1,&m1,&ierr);
  intarrayc((int **) &l2,&m2,&n2,&ierr);
  dblearrayc((double **) &l3,&m3,&n3,&ierr);

  if ( ierr > 0 ) 
    {
      sciprint("%s Internal Error",fname); Error(999); return(0);
    }
  n1=1;
  CreateVarFromPtr( 1, "c", &m1, &n1, &l1);
  CreateVarFromPtr( 2, "i", &m2, &n2, &l2);
  CreateVarFromPtr( 3, "d", &m3, &n3, &l3);
  FreePtr(&l1);  FreePtr(&l2);   FreePtr(&l3);

  LhsVar(1) = 1;
  LhsVar(2) = 2;
  LhsVar(3) = 3;
  PutLhsVar();
  return(0);
}


static TabF Tab[]={ 
  {intfce1c, "funcc1"},
  {intfce2c, "funcc2"}, 
  {intfce3c, "funcc3"}, 
  {intfce4c, "funcc4"}, 
};


int C2F(testcentry3)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name);
  return 0;
}





