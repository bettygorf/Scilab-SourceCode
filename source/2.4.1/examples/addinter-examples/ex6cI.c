/* Copyright INRIA */
#include "../../routines/stack-c.h"

/** external functions to be called through this interface **/

extern int as2osc  _PARAMS((char *thechain));


/*****************************************
 * Using a Scilab string 
 *****************************************/

int intstr1c(fname)
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


/*****************************************
 *  Accessing the Scilab Stack 
 *****************************************/

int intstr2c(fname)
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
  {intstr1c, "modstr"},
  {intstr2c, "stacc"}, 
};


int C2F(intex6c)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name);
  return 0;
}





