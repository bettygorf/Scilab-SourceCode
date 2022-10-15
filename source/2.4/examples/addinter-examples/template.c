/* Copyright INRIA */

/***************************************************************************
 * Template of Scilab C interface
 * usage: 
 * addinter(['template.o','Croutine1.o','Croutine2.o,...'],
 *           'interfacename',
 *           ['scilabfunctionname1','scilabfunctionname2,...'])
 *  addinter(a set of object files (thisinterfaceroutine.o + your C objectfiles.o),
 *           one entry point (the name of interface function as it appears below) , 
 *          the name of scilab functions)
 *
 *  [y1,y2,...y_maxlhs1]=scilabfunctionname1(x1,x2,...,x_maxrhs1)
 *
 * [y1,y2,...y_maxlhs2]=scilabfunctionname2(x1,x2,...,x_maxrhs2 )
 *
 ************************************************************************/

#include "SCIDIR/routines/stack-c.h"

int interface1(fname) 
     char *fname;
{
  /* Declare a number of variables */
  int i1, i2, ierr;
  int l1, m1, n1, m2, n2, l2, m3, n3, l3, m4, n4, l4, l5, l6;
  /*    Define minls=1, maxlhs, minrhs, maxrhs   */
  int minlhs=?, minrhs=?, maxlhs=?, maxrhs=?;
  
  Nbvars = 0;
  /*       Check Rhs and lhs  (see stack-c.h)  */  
  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;

  /**************************************************************
   *        1-Get rhs parameters   "c": char                    *
   *                               "i": int                     *
   *                               "r": float                   *
   *                               "d": double                  *
   **************************************************************/
  GetRhsVar(1, "?", &m1, &n1, &l1);
  GetRhsVar(2, "?", &m2, &n2, &l2);
  GetRhsVar(3, "?", &m3, &n3, &l3);
  .
  .
  . 
  GetRhsVar(maxrhs,"?",&m_maxrhs,&n_maxrhs,&l_maxrhs);

  /*****************************************************
   *      2-If necessary, create additional variables  *
   *          (working arrays, default values, ...)    *
   *****************************************************/

  k=maxrhs+1;
  CreateVar(k, "?", &mk, &nk, &lk);
  CreateVar(k+1, "?", &m(k+1), &n(k+1), &l(k+1));
  ....

  i1 =   ;
  i2 =   ;
  /******************************************************
   *      3 - Routine call                              *
   *	    stk  <-> double                             *
   *	    sstk <-> real                               *
   *	    istk <-> integer                            *
   *        cstk <-> character                          *
   ******************************************************/

  Croutine1(...,stk(l?),..., &i1, cstk(l?:l?+?),...,istk(l?),.
  ...,sstk(l?), &i2, ..., &ierr)

  /*    4- Error message  */
    if (ierr > 0) 
      {
	sciprint(error-format,error-arguments); Error(999); return(0);
	return; 
      }
  
  /*      5- Define output variables  ? = variable number */ 
  LhsVar(1) = ?;
  LhsVar(2) = ?;
  .
  .
  LhsVar(maxlhs) = ?;
  PutLhsVar();
  return(0);
}



int interface2(fname) 
     char *fname;
{ 
  ...
  Croutine2(....);
  ...
  PutLhsVar();
  return(0);
}

/* Table of interfaced functions */

static TabF Tab[]={
  { interface1, "scilabfunction1"}, 
  { interface2, "scilabfunction2",}};

/*  interfacename = second argument of addinter  */   

int C2F(interfacename)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name);
  return 0;
} 



