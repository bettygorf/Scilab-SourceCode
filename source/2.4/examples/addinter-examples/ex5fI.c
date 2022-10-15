/* Copyright INRIA */
#include <string.h>

#include "../../routines/stack-c.h"
#include "../../routines/default/FTables0.h"
#include "../../routines/sun/link.h"

/***********************************
 * Table of predefined functions 
 ***********************************/

#include "ex5f.h"
 
FTAB FTab_FuncEx[] ={
  {"fp1", (voidf) C2F(fp1)},
  {"fp2", (voidf) C2F(fp2)},
  {(char *) 0, (voidf) 0}};

/***************************************************
 * deal with errors in scilab functions 
 ***************************************************/

#include <setjmp.h>
static  jmp_buf FuncExenv; 

/***************************************************
 * data for interface 
 ***************************************************/

static int sci_f, lhs_f, rhs_f;

/***************************************************
 * Functions 
 ***************************************************/

static int sciFuncEx (ARGS_FuncEx);
static funcex ArgFuncEx;

/***************************************************
 * cintFuncEx : interface for FuncEx 
 ***************************************************/

int cintFuncEx(fname) 
     char *fname;
{ 
  int returned_from_longjump ;
  int m_x,n_x,l_x,m_y,n_y,l_y,m_res,n_res,l_res;
  static int minlhs=1, minrhs=3, maxlhs=1, maxrhs=3;
  Nbvars = 0;
  /*   Check rhs and lhs   */  
  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;

  /*   Variable 1 (x)   */
  GetRhsVar(1, "d", &m_x, &n_x, &l_x);

  /*   Variable 2 (y)   */
  GetRhsVar(2, "d", &m_y, &n_y, &l_y);

  /*   Variable 3 (function)   */

  ArgFuncEx  = (funcex) GetFuncPtr("ffuncex",3,FTab_FuncEx,
				       (voidf) sciFuncEx,&sci_f,&lhs_f,&rhs_f);
  if ( ArgFuncEx == (funcex) 0 ) return 0;
  
  m_res= m_x*n_x;
  n_res= m_y*n_y;
  CreateVar(4, "d", &m_res, &n_res, &l_res);

  if (( returned_from_longjump = setjmp(FuncExenv)) != 0 )
    {
      Error(999);
      return 0;
    }
  
  C2F(ffuncex)(stk(l_x),&m_res,stk(l_y),&n_res,stk(l_res),ArgFuncEx);

  LhsVar(1) = 4;
  PutLhsVar();
  return 0;
}

static TabF Tab[]={{cintFuncEx, "ffuncex"}};

int C2F(cfunc)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name);
  return 0;
} 

static int sciFuncEx(x,y,res)
     double *x,*y,*res;
{
  int scilab_i,scilab_j, un=1;
  /* Inputs (x(i),y(j)) at positions */
  CreateVar(5,"d",&un,&un,&scilab_i);
  stk(scilab_i)[0] = *x;

  CreateVar(6,"d",&un,&un,&scilab_j);
  stk(scilab_j)[0] = *y;

  PExecSciFunction(5, &sci_f,&lhs_f,&rhs_f,"ArgFex",FuncExenv);
  /* One output at position of first input (5) */
  *res = *stk(scilab_i);
  return 0;
}









