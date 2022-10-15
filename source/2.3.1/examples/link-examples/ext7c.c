#include "../../routines/machine.h"

extern int matz();

/******************************************
 *     example 7 
 *     creating vector c in scilab internal stack 
 *     -->link('ext7c.o','ext7c','C') 
 *     -->a=[1,2,3]; b=[2,3,4]; 
 *     c does not exist (c made by the call to matz) 
 *     -->fort('ext7c',a,1,'d',b,2,'d','out',1); 
 *     c now exists 
 *     -->c=a+2*b 
 ******************************************/

static int c1 = 1;
static int c3 = 3;

int ext7c(a, b)
     double *a, *b;
{
  static double c[3];
  static int k;
  static double w;
  for (k = 0; k < 3; ++k) 
    c[k] = a[k] + b[k] * 2.;
  C2F(matz)(c, &w, &c1, &c1, &c3, "c", &c1);
  /*     [m,n]=size(a)  here m=1 n=3 */
  return(0);
}

