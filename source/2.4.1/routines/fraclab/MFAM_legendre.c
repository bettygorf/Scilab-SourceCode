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

/* Christophe Canus 1997-98 */

#include "MFAM_legendre.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAM_llt(n, x, u_x, s, u_star_s)
     int n;
     double *x;
     double *u_x;
     double *s;
     double *u_star_s;
#else /* __STDC__ */
int MFAM_llt(int n,double* x,double* u_x,double* s,double* u_star_s)
#endif /* __STDC__ */
{
  if((n>0)&&(x!=NULL)&&(u_x!=NULL)&&(s!=NULL)&&(u_star_s!=NULL))
  {
    register int i=0;
    *s=(*(u_x+n-1)-*(u_x+n-2))/(*(x+n-1)-*(x+n-2));
    *u_star_s=*s**(x+n-1)-*(u_x+n-1); 
    for (i=1;i<n-1;i++)
    {
      *(s+i)=(*(u_x+n-i)-*(u_x+n-2-i))/(*(x+n-i)-*(x+n-2-i));
      *(u_star_s+i)=s[i]*x[n-1-i]-u_x[n-1-i];
    }
    *(s+n-1)=(u_x[1]-u_x[0])/(x[1]-x[0]);
    *(u_star_s+n-1)=*(s+n-1)**x-*u_x;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_llt arguments error\n");
    return 0;
  }
}
