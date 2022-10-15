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

#include "MFAM_stats.h"

/*****************************************************************************/

#ifndef __STDC__
double MFAM_mean(n, x)
     int n;
     double *x;
#else /* __STDC__ */
double MFAM_mean(int n,double* x)
#endif /* __STDC__ */
{
  if((n>0)&&(x!=NULL))
  {
    register int k=0;
    double m_x=0.;
    for(k=0;k<n;k++)
      m_x+=*(x+k);
    m_x*=1./(double)n; /* biased estimator */
    return m_x;
  }
  else
  {
    fprintf(stderr,"MFAM_mean arguments error\n");
    return HUGE;
  }
}

/*****************************************************************************/

#ifndef __STDC__
double MFAM_variance(n, x, m_x)
     int n;
     double *x;
     double m_x;
#else /* __STDC__ */
double MFAM_variance(int n,double* x,double m_x)
#endif /* __STDC__ */
{
  if((n>0)&&(x!=NULL)&&(m_x!=HUGE))
  {
    register int k=0;
    double sigma_2_x=0.;
    for(k=0;k<n;k++) 
      sigma_2_x+=(*(x+k)-m_x)*(*(x+k)-m_x); 
    sigma_2_x*=1./(double)n; /* biased estimator */
    return sigma_2_x;
  }
  else
  {
    fprintf(stderr,"MFAM_variance arguments error\n");
    return HUGE;
  }
}

/*****************************************************************************/
#ifndef __STDC__
double MFAM_covariance(n, x, y, m_x, m_y)
     int n;
     double *x;
     double *y;
     double m_x;
     double m_y;
#else /* __STDC__ */
double MFAM_covariance(int n,double* x,double* y,double m_x,double m_y)
#endif /* __STDC__ */
{
  if((n>0)&&(x!=NULL)&&(y!=NULL)&&(m_x!=HUGE)&&(m_y!=HUGE))
  {
    register int k=0;
    double sigma_2_xy=0.;
    for(k=0;k<n;k++)
      sigma_2_xy+=(*(x+k)-m_x)*(*(y+k)-m_y);
    sigma_2_xy*=1./(double)n; /* biased estimator */
    return sigma_2_xy;
  }
  else
  {
    fprintf(stderr,"MFAM_covariance arguments error\n");
    return HUGE;
  }
}

/*****************************************************************************/
#ifndef __STDC__
double MFAM_bias(n, theta_hat, theta)
     int n;
     double *theta_hat;
     double theta;
#else /* __STDC__ */
double MFAM_bias(int n,double* theta_hat,double theta)
#endif /* __STDC__ */
{
  if((n>0)&&(theta_hat!=NULL)&&(theta!=HUGE))
  {
    double bias_n=MFAM_mean(n,theta_hat)-theta;
    return bias_n;
  }
  else
  {
    fprintf(stderr,"MFAM_bias arguments error\n");
    return HUGE;
  }
}

/*****************************************************************************/
#ifndef __STDC__
double MFAM_generalized_bias(n, theta_hat, theta)
     int n;
     double *theta_hat;
     double theta;
#else /* __STDC__ */
double MFAM_generalized_bias(int n,double* theta_hat,double theta)
#endif /* __STDC__ */
{
  if((n>0)&&(theta_hat!=NULL)&&(theta!=HUGE))
  {
    double generalized_bias_n=MFAM_variance(n,theta_hat,theta);
    return generalized_bias_n;
  }
  else
  {
    fprintf(stderr,"MFAM_generalized_bias arguments error\n");
    return HUGE;
  }
}
