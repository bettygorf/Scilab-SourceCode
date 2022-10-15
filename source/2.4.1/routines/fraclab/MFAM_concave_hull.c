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

#include "MFAM_concave_hull.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAM_slope(n, x, u_x, s_x)
     int n;
     double *x;
     double *u_x;
     double *s_x;
#else /* __STDC__ */
int MFAM_slope(int n,double* x,double* u_x,double* s_x)
#endif /* __STDC__ */
{
  int i,k=0;
  for(i=0;i<n-1;i++)
  {    
    *(s_x+k)=(*(u_x+i+1)-*(u_x+i))/(*(x+i+1)-*(x+i));
    k++;
  }
  return(k+1);
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_bb(s_x, n, x, u_x, bool)
     double *s_x;
     int n;
     double *x;
     double *u_x;
     int *bool;
#else /* __STDC__ */
int MFAM_bb(double* s_x,int n,double* x,double* u_x,int* bool)
#endif /* __STDC__ */
{
  int i=0,j=0,k=n-2;
  while((*bool)&&(i<k))
  {
    if(*(s_x+i+1)>*(s_x+i)) 
    {
      for(j=i+1;j<=k;j++)
      {
	*(x+j)=*(x+j+1);
	*(u_x+j)=*(u_x+j+1);
      }
      *bool=0;
      k--;
    }
    else i++;    
  }
  return(k+2);  
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_bb_concave_hull(n, x, u_x, rn)
     int n;
     double *x;
     double *u_x;
     int *rn;
#else /* __STDC__ */
int MFAM_bb_concave_hull(int n,double* x,double* u_x,int* rn)
#endif /* __STDC__ */
{
  int eliminated_pt=0;
  double *s_x=NULL;
  if((s_x=(double*)malloc((unsigned)(n*sizeof(double))))==NULL)
  {
    fprintf(stderr,"malloc error\n");
    return 0; 
  }
  *rn=n;
  while(!eliminated_pt)
  {
    eliminated_pt=1;
    *rn=MFAM_slope(*rn,x,u_x,s_x);
    *rn=MFAM_bb(s_x,*rn,x,u_x,&eliminated_pt);
  }
  free((char*)s_x);
  return 1;    
}
