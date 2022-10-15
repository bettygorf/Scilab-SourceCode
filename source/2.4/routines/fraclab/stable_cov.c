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
#include "stable_cov.h"
#include "stable_sm.h"
#ifndef sign
#define sign(z) (z<0 ? (-1.0) : (1.0))
#endif

#ifndef M_PI
#define M_PI  3.1415926535
#endif

/****************************************************************************/
 /*estimation empirique de la fonction de distribution de la mesure spectrale*/

#ifndef __STDC__
double  stable_dspect(X, Y, size, t, Z, k, alpha)
     double *X;
     double *Y;
     int size;
     double t;
     double *Z;
     int k;
     double alpha;
#else /* __STDC__ */
double  stable_dspect(double *X,double *Y, int size, double t, double *Z,int k,double alpha)
#endif /* __STDC__ */
{
 
	int        i;
	double som = 0.0;

	for (i=0;i<size;i++)
	  {

	  if ((stable_arg(X,Y,i) <= t)
	      && (stable_modu(X,Y,i) >= Z[size-k+1]))
	    som += 1.0 ;
	
	  }
	
	return ((double) (som * pow(Z[size-k],alpha)/size));
}


/*****************************************************************************/
/********************estimation de la covariation*****************************/


#ifndef __STDC__
double stable_cov(X, Y, size, Z, k, alpha)
     double *X;
     double *Y;
     int size;
     double *Z;
     int k;
     double alpha;
#else /* __STDC__ */
double stable_cov(double *X,double *Y,int size,double *Z,int k,double alpha)
#endif /* __STDC__ */
{

	int        l, p=100;
	double     som=0.0;
	double     t,t1;
	for (l=0;l< (p+1);l++){
	  t = 2.0*l*M_PI/(p+1);
	  t1= 2.0*(l+1)*M_PI/(p+1);
	  som+= (cos(t))*pow(abs(sin(t)),(alpha-1.0))*sign(sin(t))
	    *(stable_dspect(X,Y,size,t1,Z,k,alpha)
	      - stable_dspect(X,Y,size,t,Z,k,alpha));
			
	}
	return((double) som);
	  	      
}
/**********************************************************************/
/**********************************************************************/






