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

#include "sim_stable.h"
#include <stdio.h>
#include <math.h>
#include "FRACLAB_compat.h"
#ifndef M_PI
#define M_PI 3.1415926535
#endif
#ifndef M_PI_2
#define M_PI_2 9.86960440052517
#endif

/***************************************************************************/
/*simulation d'une loi uniforme sur [-pi/2 , pi/2]*/
/***************************************************************************/
double stable_uniform()
{
	double u,v;	
	u=drand48();	
	return(M_PI * (u - 0.5));
}
/***************************************************************************/
/*simulation d'une loi exponentielle*/
/***************************************************************************/
double stable_expo()
{
	double u;
        u=drand48();
	return(-log (1.0-u));
}
/***************************************************************************/
#ifndef __STDC__
double stable_s(alpha, beta, n)
     double alpha;
     double beta;
     int n;
#else /* __STDC__ */
double stable_s(double alpha, double beta, int n)
#endif /* __STDC__ */
{
        
	double          V, W, C, D,Y,ka,b,V0,Z;
	
	ka=1.0-fabs(1.0 - alpha);
	V0=(-(M_PI_2*beta*ka/alpha));

	V=stable_uniform();
	W=stable_expo();

	Z= (sin(alpha*(V))/pow(cos(V),(1.0/alpha)))
	  *pow(cos(V-alpha*(V))/W,((1.0-alpha)/alpha));

	Y=sin(alpha*(V-V0))/pow(cos(V),(1.0/alpha))
	  *pow(cos(V-alpha*(V-V0))/W,((1.0-alpha)/alpha));
	
	if (alpha == 2.0)
	  return(2.0*sqrt(W)*sin(V));

	if(alpha == 1.0)
	  return((2.0/M_PI)*((M_PI_2+beta*V))*tan(V)
			      -beta*log(M_PI_2*W*cos(V)/(M_PI_2+(beta*V))));
	return ((beta==0.0 ? (Z) : Y));
}

/***************************************************************************/






