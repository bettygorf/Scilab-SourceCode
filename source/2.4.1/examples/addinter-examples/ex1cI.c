/* Copyright INRIA */
#include "../../routines/stack-c.h"

extern int foubare2c _PARAMS((char *ch, int *a, int *ia, float *b, int *ib, double *c, int *mc, int *nc, double *d, double *w, int *err));


/**************************************************
 * An example of an hand written interface 
 * the interface is defined by the function 
 * foobar and it contains only one function 
 * foubare2c ( interfaced in function intsfoubare )
 **************************************************/

int intsfoubare(fname) 
     char *fname;
{
  int i1, i2;
  static int ierr;
  static int l1, m1, n1, m2, n2, l2, m3, n3, l3, m4, n4, l4, l5, l6;
  static int minlhs=1, minrhs=4, maxlhs=5, maxrhs=4;

  Nbvars = 0;
  
  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;

  GetRhsVar(1, "c", &m1, &n1, &l1);
  GetRhsVar(2, "i", &m2, &n2, &l2);
  GetRhsVar(3, "r", &m3, &n3, &l3);
  GetRhsVar(4, "d", &m4, &n4, &l4);
  
  CreateVar(5, "d", &m4, &n4, &l5);
  CreateVar(6, "d", &m4, &n4, &l6);

  i1 = n2 * m2;
  i2 = n3 * m3;
  foubare2c( cstk(l1),istk(l2), &i1, sstk(l3), &i2, stk(l4), 
	     &m4, &n4, stk(l5),stk(l6), &ierr);
  
  if (ierr > 0) 
    {
      sciprint("Internal Error");
      Error(999);
      return 0;
    }
  
  LhsVar(1) = 5;
  LhsVar(2) = 4;
  LhsVar(3) = 3;
  LhsVar(4) = 2;
  LhsVar(5) = 1;
  PutLhsVar();
  return 0;
}

static TabF Tab[]={ 
  {intsfoubare, "foobar"} 
} ; 

int C2F(cfoobar)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name);
  return 0;
} 





