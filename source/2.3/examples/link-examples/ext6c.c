#include "../../routines/stack-c.h"

/******************************************
 *   example 6 
 *   reading a vector in scilab internal stack using ReadMatrix 
 *     -->link('ext6c.o','ext6c','C') 
 *     -->a=[1,2,3];b=[2,3,4];name=str2code('a'); 
 *     -->c=fort('ext6c',name,1,'c',b,2,'d','out',[1,3],3,'d') 
 *     -->c=a+2*b 
 ******************************************/


int ext6c(aname, b, c)
     char *aname;
     double *b, *c;
     
{   static double a[3];
  static int k, m, n;
  ReadMatrix(aname, &m, &n, a);
  /*     [m,n]=size(a)  here m=1 n=3  */

  for (k = 0; k < n; ++k) 
    c[k] = a[k] + b[k] * 2.;
  return(0);
}
