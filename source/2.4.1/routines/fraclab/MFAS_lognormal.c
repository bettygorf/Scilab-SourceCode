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

#include "MFAS_lognormal.h"

#ifndef __STDC__
static void lnm1d();
static void lnm2d();
#else /* __STDC__ */
static void lnm1d(short,int,int,double,double,double,double*);
static void lnm2d(short,short,int,int,int,int,double,double,double,int,double*);
#endif /* __STDC__ */

/*****************************************************************************/

#ifndef __STDC__
int MFAS_lnm1d(n, B, m, sigma_2, mu_n)
     short int n;
     short int B;
     double m;
     double sigma_2;
     double *mu_n;
#else /* __STDC__ */
int MFAS_lnm1d(short n,short B,double m,double sigma_2,double* mu_n)
#endif /* __STDC__ */
{
  if((n>0)&&(B>0)&&(sigma_2>0.)&&(mu_n!=NULL))
  {
    int B_pow_n=(int)pow((double)B,(double)n);  
    random_seed();
    lnm1d(B,0,B_pow_n,1.,m,sigma_2,mu_n);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_lnm1d arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
static void lnm1d(B, k, nu_n, mu, m, sigma_2, mu_n)
     short int B;
     int k;
     int nu_n;
     double mu;
     double m;
     double sigma_2;
     double *mu_n;
#else /* __STDC__ */
static void lnm1d(short B,int k,int nu_n,double mu,double m,double sigma_2,double* mu_n)
#endif /* __STDC__ */
{
  if(nu_n>=B)
  {
    short i=0;
    for(i=0;i<B;i++)
      lnm1d(B,k+i*nu_n/B,nu_n/B,mu*MFAM_lognormal(m,sigma_2),m,sigma_2,mu_n);
  }
  else
    *(mu_n+k)=mu;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAS_lnm2d(n, Bx, By, m, sigma_2, mu_n)
     short int n;
     short int Bx;
     short int By;
     double m;
     double sigma_2;
     double *mu_n;
#else /* __STDC__ */
int MFAS_lnm2d(short n,short Bx,short By,double m,double sigma_2,double* mu_n)
#endif /* __STDC__ */
{
  if((n>0)&&(Bx>0)&&(By>0)&&(m!=0.)&&(mu_n!=NULL))
  {
    int Bx_pow_n=(int)pow((double)Bx,(double)n);
    int By_pow_n=(int)pow((double)By,(double)n);
    random_seed();
    lnm2d(Bx,By,0,0,Bx_pow_n,By_pow_n,m,sigma_2,1.,By_pow_n,mu_n);
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_lnm2d error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
static void lnm2d(Bx, By, i, j, nux_n, nuy_n, mu, m, sigma_2, By_pow_n, mu_n)
     short int Bx;
     short int By;
     int i;
     int j;
     int nux_n;
     int nuy_n;
     double mu;
     double m;
     double sigma_2;
     int By_pow_n;
     double *mu_n;
#else /* __STDC__ */
static void lnm2d(short Bx,short By,int i,int j,int nux_n,int nuy_n,double mu,double m,double sigma_2,int By_pow_n,double* mu_n)
#endif /* __STDC__ */
{ 
  if((nux_n>=Bx)&&(nuy_n>=By))
  {
    short bx=0,by=0;
    for(bx=0;bx<Bx;bx++)
      for(by=0;by<By;by++)
	lnm2d(Bx,By,i+bx*nux_n/Bx,j+by*nuy_n/By,nux_n/Bx,nuy_n/By,mu*MFAM_lognormal(m,sigma_2),m,sigma_2,By_pow_n,mu_n);
  }
  else
    *(mu_n+i*By_pow_n+j)=mu;
} 
