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

/* The program culloch.c estimates parameters (alpha,beta,mu,gamma)*/
/* of a stable law using the Mc-Culloch method                     */
#include "McCulloch.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/********************************************************************/
/********************** calcul de la moyenne empirique **************/


#ifndef __STDC__
double      stable_E(tab, n)
     double *tab;
     int n;
#else /* __STDC__ */
double      stable_E(double  *tab, int n)
#endif /* __STDC__ */
{
        int        i;
        double     som = 0.0;

        for (i=0; i<n; i++){

                som += tab[i];
        }
        return(som / n);              
}
	     
/********************************************************************/
/********************************************************************/

#ifndef __STDC__
void        stable_sort(n, tab)
     int n;
     double *tab;
#else /* __STDC__ */
void        stable_sort(int n, double *tab)
#endif /* __STDC__ */
{
        int       i, j;
        double    a;

        for (j = 1; j < n; j++) {
                a=tab[j];
                i=j-1;
                while (i >= 0 && tab[i] > a ){
                        tab[i+1]=tab[i];
                        i--;
                }
                tab[i+1]=a;
        }
}

/********************************************************************/
/********************************************************************/

#ifndef __STDC__
void stable_bilint(x1a, x2a, ya, n, m, x1, x2, y)
     double *x1a;
     double *x2a;
     double **ya;
     int n;
     int m;
     double x1;
     double x2;
     double *y;
#else /* __STDC__ */
void stable_bilint(double x1a[], double x2a[], double **ya, int n, int m, 
	    double x1, double x2, double *y)
#endif /* __STDC__ */

{
  int      j,k;
  double   y1, y2, y3, y4, t, u;
  for (j=0;j<n-1;j++){
    if((x1 >= x1a[j]) && (x1 <= x1a[j+1])){
      for (k=0;k<m-1;k++){
	if((x2 >= x2a[k]) && (x2 <= x2a[k+1])){
	  y1 = ya[j][k];
	  y2 = ya[j+1][k];
	  y3 = ya[j+1][k+1];
	  y4 = ya[j][k+1];
	  t  = (x1-x1a[j])/(x1a[j+1]-x1a[j]);
	  u  = (x2-x2a[k])/(x2a[k+1]-x2a[k]);

	  *y = ((1.0-t)*(1.0-u)*y1)+(t*(1.0-u)*y2)+(t*u*y3)+((1.0-t)*u*y4);
	}
      }
    }
  }
}

/********************************************************************/
