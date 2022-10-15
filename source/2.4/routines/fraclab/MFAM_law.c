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

#include "MFAM_law.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAM_normal_law(m, sigma, n, n_sample)
     double m;
     double sigma;
     int n;
     double *n_sample;
#else /* __STDC__ */
int MFAM_normal_law(double m,double sigma,int n,double* n_sample)
#endif /* __STDC__ */
{
  if((m>=0.)&&(sigma>0.)&&(n>0.)&&(n_sample!=NULL))
  {  
    register int k=0;
    random_seed();
    /* normal r.v.'s with mean m and standard deviation sigma */
    for(k=0;k<n;k++)
      *(n_sample+k)=MFAM_normal(m,sigma*sigma);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_normal_law arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_Rayleigh_law(c, n, n_sample)
     double c;
     int n;
     double *n_sample;
#else /* __STDC__ */
int MFAM_Rayleigh_law(double c,int n,double* n_sample)
#endif /* __STDC__ */
{
  if((c>0.)&&(n>0)&&(n_sample!=NULL))
  {  
    register int k=0;
    random_seed();
    /* Rayleigh r.v.'s with coefficient c */
    for(k=0;k<n;k++)
      *(n_sample+k)=MFAM_Rayleigh(c);  
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_Rayleigh_law arguments error\n");
    return 0;
  }
}
 
/*****************************************************************************/

#ifndef __STDC__
int MFAM_uniform_law(a, b, n, n_sample)
     double a;
     double b;
     int n;
     double *n_sample;
#else /* __STDC__ */
int MFAM_uniform_law(double a,double b,int n,double* n_sample)
#endif /* __STDC__ */
{
  if((a>=0.)&&(b>a)&&(n>0)&&(n_sample!=NULL))
  {  
    register int k=0;
    random_seed();
    /* uniform r.v.'s in [a,b] */
    for(k=0;k<n;k++)
      *(n_sample+k)=MFAM_uniform(a,b);  
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_uniform_law arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_lognormal_law(m, sigma, n, n_sample)
     double m;
     double sigma;
     int n;
     double *n_sample;
#else /* __STDC__ */
int MFAM_lognormal_law(double m, double sigma,int n,double* n_sample)
#endif /* __STDC__ */
{
  if((m>=0.)&&(sigma>0.)&&(n>0)&&(n_sample!=NULL))
  {  
    register int k=0;
    random_seed();
    /* lognormal r.v.'s with mean m and standard deviation sigma */
    for(k=0;k<n;k++)
      *(n_sample+k)=MFAM_lognormal(m,sigma*sigma);  
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_lognormal_law arguments error\n");
    return 0;
  }
} 

