/* This Software is ( Copyright INRIA . 1998  1 )                    */
/*                                                                   */
/* INRIA  holds all the ownership rights on the Software.            */
/* The scientific community is asked to use the SOFTWARE             */
/* in order to test and evaluate it.                                 */
/*                                                                   */
/* INRIA freely grants the right to use modify the Software,         */
/* integrate it in another Software.                                 */
/* Any use or reproduction of this Software to obtain profit or      */
/* for commercial ends being subject to obtaining the prior express  */
/* authorization of INRIA.                                           */
/*                                                                   */
/* INRIA authorizes any reproduction of this Software.               */
/*                                                                   */
/*    - in limits defined in clauses 9 and 10 of the Berne           */
/*    agreement for the protection of literary and artistic works    */
/*    respectively specify in their paragraphs 2 and 3 authorizing   */
/*    only the reproduction and quoting of works on the condition    */
/*    that :                                                         */
/*                                                                   */
/*    - "this reproduction does not adversely affect the normal      */
/*    exploitation of the work or cause any unjustified prejudice    */
/*    to the legitimate interests of the author".                    */
/*                                                                   */
/*    - that the quotations given by way of illustration and/or      */
/*    tuition conform to the proper uses and that it mentions        */
/*    the source and name of the author if this name features        */
/*    in the source",                                                */
/*                                                                   */
/*    - under the condition that this file is included with          */
/*    any reproduction.                                              */
/*                                                                   */
/* Any commercial use made without obtaining the prior express       */
/* agreement of INRIA would therefore constitute a fraudulent        */
/* imitation.                                                        */
/*                                                                   */
/* The Software beeing currently developed, INRIA is assuming no     */
/* liability, and should not be responsible, in any manner or any    */
/* case, for any direct or indirect dammages sustained by the user.  */
/*                                                                   */
/* Any user of the software shall notify at INRIA any comments       */
/* concerning the use of the Sofware (e-mail : FracLab@inria.fr)     */
/*                                                                   */
/* This file is part of FracLab, a Fractal Analysis Software         */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "Koutrouvelis.h"

/********************************************************************/
#ifdef __STDC__
fcomplex stable_Complex(double re, double im)
#else
fcomplex stable_Complex(re, im)
     double re;
     double im;
#endif
{
	fcomplex c;
	c.r=re;
	c.i=im;
	return c;
}

/********************************************************************/
#ifdef __STDC__
double stable_Cabs(fcomplex z)
#else
double stable_Cabs(z)
     fcomplex z;
#endif
{
	double x,y,ans,temp;
	x=fabs(z.r);
	y=fabs(z.i);
	if (x == 0.0)
		ans=y;
	else if (y == 0.0)
		ans=x;
	else if (x > y) {
		temp=y/x;
		ans=x*sqrt(1.0+temp*temp);
	} else {
		temp=x/y;
		ans=y*sqrt(1.0+temp*temp);
	}
	return ans;
}
/********************************************************************/
#ifdef __STDC__
fcomplex stable_Cadd(fcomplex a, fcomplex b)
#else
fcomplex stable_Cadd(a, b)
     fcomplex a;
     fcomplex b;
#endif
{
	fcomplex c;
	c.r=a.r+b.r;
	c.i=a.i+b.i;
	return c;
}
/********************************************************************/
#ifdef __STDC__
fcomplex stable_Cquo(fcomplex a, double b)
#else
fcomplex stable_Cquo(a, b)
     fcomplex a;
     double b;
#endif
{
	fcomplex c;
	c.r=a.r/b;
	c.i=a.i/b;
	return c;
}
/********************************************************************/
#ifdef __STDC__
fcomplex  stable_phiemp(double t, double *data, int n)
#else
fcomplex  stable_phiemp(t, data, n)
     double t;
     double *data;
     int n;
#endif
{
  fcomplex  u;
  int j;
  double a,b;
#ifdef __STDC__
  fcomplex  sum=stable_Complex(0.0,0.0); 
#else 
  fcomplex  sum;
  sum=stable_Complex(0.0,0.0); 
#endif
  for(j=0;j<n;j++){
    a=cos(t*data[j]);
    b=sin(t*data[j]);
    sum = stable_Cadd(sum,stable_Complex(a,b));
  }
  return(stable_Cquo(sum,n));
}
/********************************************************************/
#ifdef __STDC__
void stable_reg(double x[], double y[], int ndata, int m, double *a,
	double *b, double *siga, double *sigb)
#else
void stable_reg(x, y, ndata, m, a, b, siga, sigb)
     double *x;
     double *y;
     int ndata;
     int m;
     double *a;
     double *b;
     double *siga;
     double *sigb;
#endif
{
	int i;
	double c,moyx,sumx=0.0,sumy=0.0,sumc2=0.0;

	*b=0.0;
	for (i=m;i< (ndata);i++) {
			sumx += x[i];
			sumy += y[i];
		}
	
	moyx=sumx/(double)(ndata-m);
	for (i=m;i< (ndata);i++) {
			c=x[i]-moyx;
			sumc2 += c*c;
			*b += c*y[i];
		}
	
       *b /= sumc2;
       *a=(sumy-sumx*(*b))/(double)(ndata-m);
       *siga=sqrt((1.0+sumx*sumx/((double)(ndata-m)*sumc2))/(double)(ndata-m));
       *sigb=sqrt(1.0/sumc2);
	
}
/********************************************************************/

