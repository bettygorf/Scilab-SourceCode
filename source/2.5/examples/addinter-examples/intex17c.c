#include <string.h>

#include "stack-c.h"

typedef void (*voidf)();

typedef struct {
  char *name;
  voidf f;
} FTAB;

/*******************************************
 * Table of predefined functions f1c and f2c
 *******************************************/


#if defined(__STDC__)
#define ARGS_ex17c double,double, double *
#else
#define ARGS_ex17c 
#endif 

typedef int (*funcex)(ARGS_ex17c);
extern int f1c(ARGS_ex17c);
extern int f2c(ARGS_ex17c);
 
FTAB FTab_ex17c[] ={
  {"f1c", (voidf) f1c},
  {"f2c", (voidf) f2c},
  {(char *) 0, (voidf) 0}};

/***************************************************
 * deal with errors in scilab functions 
 ***************************************************/

#include <setjmp.h>
static  jmp_buf ex17cenv; 

/***************************************************
 * data for interface 
 ***************************************************/

static int sci_f, lhs_f, rhs_f;

/***************************************************
 * Functions 
 ***************************************************/

static int sciex17c (ARGS_ex17c);
static funcex Argex17c;

/***************************************************
 * intex17c interface for ex17c 
 ***************************************************/

int intex17c(fname) 
     char *fname;
{ 
  int returned_from_longjump ;
  int m_X,n_X,l_X,m_Y,n_Y,l_Y,m_Z,n_Z,l_Z;
  static int minlhs=1, minrhs=3, maxlhs=1, maxrhs=3;

  /*   Check rhs and lhs   */  
  CheckRhs(minrhs,maxrhs) ;
  CheckLhs(minlhs,maxlhs) ;

  /*   Variable #1 (X = real vector)   */
  GetRhsVar(1, "d", &m_X, &n_X, &l_X);

  /*   Variable #2 (Y = real vector)   */
  GetRhsVar(2, "d", &m_Y, &n_Y, &l_Y);

  /*   Variable #3 (f = "argument function")   */
  /*   ex17c(X,Y,f) ==> f = Scilab function  ==> sciex17 will be called and this function 
       requires sci_f, lhs_f, rhs_f */
  Argex17c  = (funcex) GetFuncPtr("ex17c", 3, FTab_ex17c, (voidf) sciex17c, &sci_f, &lhs_f, &rhs_f);
  if ( Argex17c == (funcex) 0 ) return 0;
  
  m_Z= m_X*n_X;  n_Z= m_Y*n_Y;
  /*  Creating the output variable Z (#4) , real matrix variable with m_Z rows and n_Z columns    */
  CreateVar(4, "d", &m_Z, &n_Z, &l_Z);
  
  /* If an error occurs while Z is calculated ... */
  if (( returned_from_longjump = setjmp(ex17cenv)) != 0 )
    {
      Error(999);
      return 0;
    } 
  
  /*  Now matrix Z is populated i.e. appropriate values are 
      assigned to stk(l_Z)[0] ( = Z(1,1) ), stk(l_Z)[1]  ( = Z(2,1) ), ... */
  ex17c(stk(l_X), m_X*n_X, stk(l_Y), m_Y*n_Y, stk(l_Z), Argex17c);

  /*  Variable #4 is returned to Scilab  */
  LhsVar(1) = 4;
  return 0;
}


static int sciex17c(x, y, z)
     /* Computing z=f(x,y), f being the Scilab argument function */
     /* C function emulating the Scilab function pointed to by sci_f  */
     double x, y, *z;
{
  int scilab_i,scilab_j, un=1;
  /* Inputs (x(i),y(j)) at positions  (5,6) */
  CreateVar(5, "d", &un, &un, &scilab_i);
  stk(scilab_i)[0] = x;

  CreateVar(6, "d", &un, &un, &scilab_j);
  stk(scilab_j)[0] = y;

  /* executes the Scilab function (f) pointed to by sci_f. 
     f has rhs_f inputs and lhs_f outputs */
  PExecSciFunction(5, &sci_f, &lhs_f, &rhs_f, "ArgFex", ex17cenv);
  /* One output at position of first input (5) */
  *z = *stk(scilab_i);
  return 0;
}

