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

#include "MFAS_spectrum.h" 

/******************/
#ifndef __STDC__
int MFAS_bm1ds(n, p0, alpha, f_alpha)
     int n;
     double p0;
     double *alpha;
     double *f_alpha;
#else /* __STDC__ */
int MFAS_bm1ds(int n,double p0,double* alpha,double* f_alpha)
#endif /* __STDC__ */
{
  if((n>0)&&(p0>0.)&&(alpha!=NULL)&&(f_alpha!=NULL))
  {
    register int i=0;
    /* modif bertrand */
    double alpha_min=-log(1-p0)/log(2.);
    double alpha_max=-log(p0)/log(2.);
    double d_alpha=(alpha_max-alpha_min)/(n-1);
    double phi_alpha=0.;  
    for(i=0;i<n;i++)
    {
      *(alpha+i)=alpha_min+i*d_alpha; 
      phi_alpha=(*(alpha+i)+log(1-p0)/log(2.))/(log((1-p0)/p0)/log(2.));
      if((fabs(phi_alpha-0.)>1e-6)&&(fabs(phi_alpha-1.)>1e-6))
	*(f_alpha+i)=-phi_alpha*log(phi_alpha)/log(2.)-(1-phi_alpha)*log(1-phi_alpha)/log(2.); 
      else
	*(f_alpha+i)=0.;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_bm1ds arguments error\n");
    return 0;
  }
}

/******************/
#ifndef __STDC__
int MFAS_sumbm1ds(n, p01, p02, alpha, f_alpha)
     int n;
     double p01;
     double p02;
     double *alpha;
     double *f_alpha;
#else /* __STDC__ */
int MFAS_sumbm1ds(int n,double p01,double p02,double* alpha,double* f_alpha)
#endif /* __STDC__ */
{
  if((n>0)&&(p01>0.)&&(p02>0.)&&(p01<p02)&&(alpha!=NULL)&&(f_alpha!=NULL))
  {
    register int i=0; 
    int toggle=1;
    double alpha_min_1=-log(1-p01)/log(2.),alpha_min_2=-log(1-p02)/log(2.),alpha_max_2=-log(p02)/log(2.);
    double d_alpha=(alpha_max_2-alpha_min_1)/(n-1),phi_alpha_1=0.,phi_alpha_2=0.,f_alpha_1=0.,f_alpha_2=0.;  
    for(i=0;i<n;i++)
    {
      *(alpha+i)=alpha_min_1+i*d_alpha; 
      if((alpha_min_1<=*(alpha+i))&&(*(alpha+i)<=alpha_min_2))
      {
	phi_alpha_1=(*(alpha+i)+log(1-p01)/log(2.))/(log((1-p01)/p01)/log(2.)); 
	if((fabs(phi_alpha_1-0.)>1e-6)&&(fabs(phi_alpha_1-1.)>1e-6))
	  f_alpha_1=-phi_alpha_1*log(phi_alpha_1)/log(2.)-(1-phi_alpha_1)*log(1-phi_alpha_1)/log(2.); 
	else
	  f_alpha_1=0.;
	*(f_alpha+i)=f_alpha_1;
      }
      else 
	if((alpha_min_2<*(alpha+i))&&(*(alpha+i)<=alpha_max_2))
	{   
	  if(toggle)
	  {
	    phi_alpha_1=(*(alpha+i)+log(1-p01)/log(2.))/(log((1-p01)/p01)/log(2.)); 
	    if((fabs(phi_alpha_1-0.)>1e-6)&&(fabs(phi_alpha_1-1.)>1e-6))
	      f_alpha_1=-phi_alpha_1*log(phi_alpha_1)/log(2.)-(1-phi_alpha_1)*log(1-phi_alpha_1)/log(2.); 
	    else
	      f_alpha_1=0.; 
	    phi_alpha_2=(*(alpha+i)+log(1-p02)/log(2.))/(log((1-p02)/p02)/log(2.));
	    if((fabs(phi_alpha_2-0.)>1e-6)&&(fabs(phi_alpha_2-1.)>1e-6))
	      f_alpha_2=-phi_alpha_2*log(phi_alpha_2)/log(2.)-(1-phi_alpha_2)*log(1-phi_alpha_2)/log(2.); 
	    else
	      f_alpha_2=0.;
	    *(f_alpha+i)=(f_alpha_1>f_alpha_2?f_alpha_1:f_alpha_2);
	    if(f_alpha_1<f_alpha_2)
	      toggle=0;
	  }   
	  else
	  {
	    phi_alpha_2=(*(alpha+i)+log(1-p02)/log(2.))/(log((1-p02)/p02)/log(2.));
	    if((fabs(phi_alpha_2-0.)>1e-6)&&(fabs(phi_alpha_2-1.)>1e-6))
	      f_alpha_2=-phi_alpha_2*log(phi_alpha_2)/log(2.)-(1-phi_alpha_2)*log(1-phi_alpha_2)/log(2.); 
	    else
	      f_alpha_2=0.;
	    *(f_alpha+i)=f_alpha_2;
	  }
	}
    }   
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAS_sumbm1ds arguments error\n");
    return 0;
  }
}

/******************/
#ifndef __STDC__
int MFAS_lumpbm1ds(n, p01, p02, alpha, f_alpha)
     int n;
     double p01;
     double p02;
     double *alpha;
     double *f_alpha;
#else /* __STDC__ */
int MFAS_lumpbm1ds(int n,double p01,double p02,double* alpha,double* f_alpha)
#endif /* __STDC__ */
{
   if((n>0)&&(p01>0.)&&(p02>0.)&&(alpha!=NULL)&&(f_alpha!=NULL))
   {
   register int i=0;
   double alpha_min_1=-log(1-p01)/log(2.),alpha_max_1=-log(p01)/log(2.),alpha_min_2=-log(1-p02)/log(2.),alpha_max_2=-log(p02)/log(2.);
   double alpha_min=(alpha_min_1<alpha_min_2?alpha_min_1:alpha_min_2),alpha_max=(alpha_max_1>alpha_max_2?alpha_max_1:alpha_max_2);
   double d_alpha=(alpha_max-alpha_min)/(n-1),phi_alpha_1=0.,phi_alpha_2=0.,f_alpha_1=0.,f_alpha_2=0.;  
   for(i=0;i<n;i++)
   {
      *(alpha+i)=alpha_min+i*d_alpha; 
      if((alpha_min_1<=*(alpha+i))&&(*(alpha+i)<=alpha_max_1))
      {
	 phi_alpha_1=(*(alpha+i)+log(1-p01)/log(2.))/(log((1-p01)/p01)/log(2.)); 
	 if((fabs(phi_alpha_1-0.)>1e-6)&&(fabs(phi_alpha_1-1.)>1e-6))
	    f_alpha_1=-phi_alpha_1*log(phi_alpha_1)/log(2.)-(1-phi_alpha_1)*log(1-phi_alpha_1)/log(2.); 
	 else
	   f_alpha_1=0.;
      }  
      else
	 f_alpha_1=0.;
      if((alpha_min_2<=*(alpha+i))&&(*(alpha+i)<=alpha_max_2))
      {  
	 phi_alpha_2=(*(alpha+i)+log(1-p02)/log(2.))/(log((1-p02)/p02)/log(2.));
	 if((fabs(phi_alpha_2-0.)>1e-6)&&(fabs(phi_alpha_2-1.)>1e-6))
	    f_alpha_2=-phi_alpha_2*log(phi_alpha_2)/log(2.)-(1-phi_alpha_2)*log(1-phi_alpha_2)/log(2.); 
	 else
	    f_alpha_2=0.;
      }   
      else
	 f_alpha_2=0.;
      *(f_alpha+i)=(f_alpha_1>f_alpha_2?f_alpha_1:f_alpha_2);
   }
   return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_lumpbm1ds arguments error\n");
      return 0;
   }
}

/******************/
#ifndef __STDC__
int MFAS_ubm1ds(n, alpha, f_alpha)
     int n;
     double *alpha;
     double *f_alpha;
#else /* __STDC__ */
int MFAS_ubm1ds(int n,double* alpha,double* f_alpha)
#endif /* __STDC__ */
{
   if((n>0)&&(alpha!=NULL)&&(f_alpha!=NULL))
   {
   register int i=0;
   double alpha_min=.3346,alpha_max=3.3864,d_alpha=(alpha_max-alpha_min)/(n-1),rho_alpha=0.,delta=log(2.);  
   for(i=0;i<n;i++)
   {
      *(alpha+i)=alpha_min+i*d_alpha;
      rho_alpha=log(*(alpha+i)*delta)/log(2.)-*(alpha+i)+1./delta;
      *(f_alpha+i)=1.+rho_alpha;
   }
   return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_ubm1ds arguments error\n");
      return 0;
   }
}

/******************/
#ifndef __STDC__
int MFAS_lnm1ds(n, nu, alpha, f_alpha)
     int n;
     double nu;
     double *alpha;
     double *f_alpha;
#else /* __STDC__ */
int MFAS_lnm1ds(int n,double nu,double* alpha,double* f_alpha)
#endif /* __STDC__ */
{
   if((n>0)&&(nu>0.)&&(alpha!=NULL)&&(f_alpha!=NULL))
   {
   register int i=0;
   /* modif bertrand : les allocations a la suite avec des virgules
      ne passent pas sur SunOS */
   double alpha_min=-3.;
   double alpha_max=7.;
   double d_alpha=(alpha_max-alpha_min)/(n-1);
   double rho_alpha=0.;  
   for(i=0;i<n;i++)
   {
      if((*(alpha+i)=alpha_min+i*d_alpha)<-1.+nu)
	 rho_alpha=*(alpha+i)/nu-1.;
      else
	 rho_alpha=-(*(alpha+i)-1.-nu)*(*(alpha+i)-1.-nu)/(4.*nu);
      *(f_alpha+i)=1.+rho_alpha;
   }
   return 1;
   }
   else
   {
      fprintf(stderr,"MFAS_lnm1ds arguments error\n");
      return 0;
   }
}

/******************/
#ifndef __STDC__
int MFAS_bmc3s(n, p0, alpha, f_alpha)
     int n;
     double p0;
     double *alpha;
     double *f_alpha;
#else /* __STDC__ */
int MFAS_bmc3s(int n,double p0,double* alpha,double* f_alpha)
#endif /* __STDC__ */
{
  if((n>0)&&(n/2!=0)&&(p0>0.)&&(p0<.5)&&(alpha!=NULL)&&(f_alpha!=NULL))
  {
    register int k=0;
    int m=(n-5)/2;
    double alpha_max=-log(pow(p0,3.))/(3*log(2.)),alpha_min=-log(pow((1.-p0),3.))/(3*log(2.)),beta_3_3=-log(pow(p0,2.)*(1.-p0))/(3*log(2.)),beta_3_1=-log(p0*pow((1.-p0),2.))/(3*log(2.)),alpha_mod=-log(.5*p0*(1.-p0))/(3*log(2.)),d_alpha=0.;
    *alpha=alpha_min;
    *f_alpha=0.;
    *(alpha+1)=beta_3_1;
    *(f_alpha+1)=0.; 
    *(alpha+2)=beta_3_1+1e-6;
    *(f_alpha+2)=log(3)/(3*log(2.));
    d_alpha=(alpha_mod-beta_3_1)/m;
    for(k=0;k<m+1;k++)
    {
      *(alpha+k+3)=beta_3_1+k*d_alpha;
      *(f_alpha+k+3)=1-1./3.*log(1+(pow(2.,-3.**(alpha+k+3))-2*pow(p0,2.)*(1-p0))/(p0*(1-p0)*(2*p0-1)))/log(2.);
    }
    *(alpha+m+1)=alpha_mod;
    *(f_alpha+m+1)=log(3)/(3*log(2.)); 
    d_alpha=(beta_3_3-alpha_mod)/m;
    for(k=0;k<m+1;k++)
    {
      *(alpha+k+m+1)=alpha_mod+k*d_alpha;
      *(f_alpha+k+m+1)=1-1./3.*log(1+(2*p0*pow((1-p0),2.))-pow(2.,-3.**(alpha+k+m+1))/(p0*(1-p0)*(2*p0-1)))/log(2.);
    }
    *(alpha+n-3)=beta_3_3-1e-6; 
    *(f_alpha+n-3)=log(3)/(3*log(2.));
    *(alpha+n-2)=beta_3_3; 
    *(f_alpha+n-2)=0.;
    *(alpha+n-1)=alpha_max; 
    *(f_alpha+n-1)=0.;
    return 1;
  }
  else 
  { 
    fprintf(stderr,"MFAS_bm3cs arguments error\n");
    return 0;
  }
}
