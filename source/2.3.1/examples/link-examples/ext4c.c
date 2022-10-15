#include <math.h>
#include "../../routines/stack-c.h"

/************************************
 *     simple example 4 (reading a scilab chain) 
 *     -->link('ext4c.o','ext4c','C'); 
 *     -->a=[1,2,3];b=[4,5,6];n=3;yes='yes' 
 *     -->c=fort('ext4c',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d') 
 *     -->c=sin(a)+cos(b) 
 *     -->yes='no' 
 *     -->c=a+b 
 *     -->clear yes  --> undefined variable : yes 
 ************************************/

int ext4c(n, a, b, c)
     int *n;
     double *a, *b, *c;
{
  static int k;
  static char ch[10];
  static int lch;
  ReadString("yes", &lch, ch);
  /******************************/
  if (strcmp(ch, "yes") == 0) 
    {
      for (k = 0; k < *n; ++k) 
	c[k] = sin(a[k]) + cos(b[k]);
    } 
  else 
    {
      for (k = 0; k < *n; ++k) 
	c[k] = a[k] + b[k];
    }
  return(0);
}

