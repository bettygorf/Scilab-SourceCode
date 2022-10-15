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

#include "MFAM_oscillation.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAM_osc_eta_x(M, dx, f_x, eta, osc_eta_x)
     int M;
     double dx;
     double *f_x;
     double eta;
     double *osc_eta_x;
#else /* __STDC__ */
int MFAM_osc_eta_x(int M,double dx,double* f_x,double eta,double* osc_eta_x)
#endif /* __STDC__ */
{
  if((M>0)&&(dx>0.)&&(f_x!=NULL)&&(eta>=dx)&&(osc_eta_x!=NULL))
  {
    register int m=0,n=0;
    int n_e=(int)floor(eta/(2*dx));
    double f_x_plus=-HUGE,f_x_minus=HUGE;
    for(m=0;m<n_e;m++)
    {
      for(n=0;n<=n_e;n++)
      {
	f_x_minus=(*(f_x+m+n)<f_x_minus?*(f_x+m+n):f_x_minus);
	f_x_plus=(*(f_x+m+n)>f_x_plus?*(f_x+m+n):f_x_plus);
      }
      if(eta/(2.*dx)-n_e!=0.) 
      { 
	if(f_x_minus>
	   *(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e))
	  f_x_minus=
	    *(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e);
	else if(f_x_plus<
		*(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e)) 
	  f_x_plus=*(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e);
       } 
       *(osc_eta_x+m)=fabs(f_x_plus-f_x_minus);  
       f_x_minus=HUGE;
       f_x_plus=-HUGE;
    }
    for(m=n_e;m<=M-n_e;m++)
    {
      for(n=-n_e;n<=n_e;n++)
      {
	f_x_minus=(*(f_x+m+n)<f_x_minus?*(f_x+m+n):f_x_minus);
	f_x_plus=(*(f_x+m+n)>f_x_plus?*(f_x+m+n):f_x_plus);
      }
      if((eta/(2.*dx)-n_e!=0.)&&(m>0)) 
      { 
	if(f_x_minus>
	   *(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e)) 
	  f_x_minus=
	    *(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e);
	else if(f_x_plus<
		*(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e))
	  f_x_plus=*(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e);
      }  
      if((eta/(2.*dx)-n_e!=0.)&&(m<M-1)) 
      {
	if(f_x_minus>
	   *(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e))
	  f_x_minus=
	    *(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e);
	else if(f_x_plus<
		*(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e)) 
	  f_x_plus=*(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e);
      } 
      *(osc_eta_x+m)=fabs(f_x_plus-f_x_minus);  
      f_x_minus=HUGE;
      f_x_plus=-HUGE;
    }
    for(m=M-n_e;m<M;m++) 
    {
      for(n=-n_e;n<=0;n++)
      {
	f_x_minus=(*(f_x+m+n)<f_x_minus?*(f_x+m+n):f_x_minus);
	f_x_plus=(*(f_x+m+n)>f_x_plus?*(f_x+m+n):f_x_plus);
      }
      if(eta/(2.*dx)-n_e!=0.) 
      { 
	if(f_x_minus>
	   *(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e)) 
	  f_x_minus=
	    *(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e);
	else if(f_x_plus<
		*(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e))
	  f_x_plus=*(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e);
      } 
      *(osc_eta_x+m)=fabs(f_x_plus-f_x_minus);  
      f_x_minus=HUGE;
      f_x_plus=-HUGE;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_osc_eta_x arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_osc_eta_deltax(M, dx, f_x, eta, deltax, osc_eta_x)
     int M;
     double dx;
     double *f_x;
     double eta;
     double *deltax;
     double *osc_eta_x;
#else /* __STDC__ */
int MFAM_osc_eta_deltax(int M,double dx,double* f_x,double eta,double* deltax,double* osc_eta_x)
#endif /* __STDC__ */
{
  if((M>0)&&(dx>0.)&&(f_x!=NULL)&&(eta>=dx)&&(deltax!=NULL)&&(osc_eta_x!=NULL))
  {
    register int m=0,n=0;
    int n_e=(int)floor(eta/(2.*dx));
    double x_minus=0.,x_plus=0.,f_x_minus=HUGE,f_x_plus=-HUGE;
    for(m=0;m<n_e;m++) 
    {
      for(n=0;n<=n_e;n++)
      {
	if(*(f_x+m+n)<f_x_minus)
	{
	  x_minus=(m+n)*dx;
	  f_x_minus=*(f_x+m+n);
	}
	if(*(f_x+m+n)>f_x_plus)
	{
	  x_plus=(m+n)*dx;
	  f_x_plus=*(f_x+m+n);
	}
      } 
      if(eta/(2.*dx)-n_e!=0.) 
      { 
	if(f_x_minus>
	   *(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e))
	{
	  x_minus=m*dx+eta/2.;
	  f_x_minus=
	    *(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e);
	}
	else if(f_x_plus<
		*(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e))
	{ 
	  x_plus=m*dx+eta/2.;
	  f_x_plus=*(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e);
	}
       } 
      *(osc_eta_x+m)=fabs(f_x_plus-f_x_minus);
      *(deltax+m)=fabs(x_plus-x_minus);
      f_x_minus=HUGE;
      f_x_plus=-HUGE; 
    }
    for(m=n_e;m<M-n_e;m++)
    {
      for(n=-n_e;n<=n_e;n++)
      {
	if(*(f_x+m+n)<f_x_minus)
	{
	  x_minus=(m+n)*dx;
	  f_x_minus=*(f_x+m+n);
	}
	if(*(f_x+m+n)>f_x_plus)
	{
	  x_plus=(m+n)*dx;
	  f_x_plus=*(f_x+m+n);
	} 
      } 
      if((eta/(2.*dx)-n_e!=0.)&&(m>0)) 
      { 
	if(f_x_minus>
	   *(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e)) 
	{
	  x_minus=m*dx-eta/2.;
	  f_x_minus=
	    *(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e);
	}
	else if(f_x_plus<
		*(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e))
	{
	  x_plus=m*dx-eta/2.;
	  f_x_plus=*(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e);
	}
      } 
      if((eta/(2.*dx)-n_e!=0.)&&(m<M-1)) 
      { 
	if(f_x_minus>
	   *(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e))
	{
	  x_minus=m*dx+eta/2.;
	  f_x_minus=
	    *(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e);
	}
	else if(f_x_plus<
		*(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e))
	{ 
	  x_plus=m*dx+eta/2.;
	  f_x_plus=*(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e);
	}
      } 
      *(osc_eta_x+m)=fabs(f_x_plus-f_x_minus);
      *(deltax+m)=fabs(x_plus-x_minus);
      f_x_minus=HUGE;
      f_x_plus=-HUGE; 
    }
    for(m=M-n_e;m<M;m++)
    {
      for(n=-n_e;n<=0;n++)
      {
	if(*(f_x+m+n)<f_x_minus)
	{
	  x_minus=(m+n)*dx;
	  f_x_minus=*(f_x+m+n);
	}
	if(*(f_x+m+n)>f_x_plus)
	{
	  x_plus=(m+n)*dx;
	  f_x_plus=*(f_x+m+n);
	}
      }
      if(eta/(2.*dx)-n_e!=0.)
      { 
	if(f_x_minus>
	   *(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e)) 
	{
	  x_minus=m*dx-eta/2.;
	  f_x_minus=
	    *(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e);
	}
	else if(f_x_plus<
		*(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e))
	{
	  x_plus=m*dx-eta/2.;
	  f_x_plus=*(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e);
	}
      }
      *(osc_eta_x+m)=fabs(f_x_plus-f_x_minus);
      *(deltax+m)=fabs(x_plus-x_minus);
      f_x_minus=HUGE;
      f_x_plus=-HUGE; 
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_osc_eta_deltax arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_Linfty_eta_x(M, dx, f_x, eta, Linfty_eta_x)
     int M;
     double dx;
     double *f_x;
     double eta;
     double *Linfty_eta_x;
#else /* __STDC__ */
int MFAM_Linfty_eta_x(int M,double dx,double* f_x,double eta,double* Linfty_eta_x)
#endif /* __STDC__ */
{
  if((M>0)&&(dx>0.)&&(f_x!=NULL)&&(eta>=dx)&&(Linfty_eta_x!=NULL))
  {
    register int m=0,n=0;
    int n_e=(int)floor(eta/(2*dx));
    double diff_ball_eta=0.,sup_diff_ball_eta=-HUGE;
    for(m=0;m<=n_e;m++)
    {
      for(n=0;n<n_e;n++)
      {
	diff_ball_eta=fabs(*(f_x+m)-*(f_x+m+n));
	sup_diff_ball_eta=(diff_ball_eta>sup_diff_ball_eta?diff_ball_eta:sup_diff_ball_eta);
      }
      *(Linfty_eta_x+m)=sup_diff_ball_eta;
      sup_diff_ball_eta=-HUGE;
    }
    for(m=n_e;m<M-n_e;m++)
    {
      for(n=-n_e;n<=n_e;n++)
      {
	diff_ball_eta=fabs(*(f_x+m)-*(f_x+m+n));
	sup_diff_ball_eta=(diff_ball_eta>sup_diff_ball_eta?diff_ball_eta:sup_diff_ball_eta);
      }
      *(Linfty_eta_x+m)=sup_diff_ball_eta;
      sup_diff_ball_eta=-HUGE;
    }
    for(m=M-n_e;m<M;m++)
      {
      for(n=-n_e;n<=0;n++)
      {
	diff_ball_eta=fabs(*(f_x+m)-*(f_x+m+n));
	sup_diff_ball_eta=(diff_ball_eta>sup_diff_ball_eta?diff_ball_eta:sup_diff_ball_eta);
      }
      *(Linfty_eta_x+m)=sup_diff_ball_eta;
      sup_diff_ball_eta=-HUGE;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_Linfty_eta_x arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_Lp_eta_x(M, dx, f_x, p, eta, Lp_eta_x)
     int M;
     double dx;
     double *f_x;
     double p;
     double eta;
     double *Lp_eta_x;
#else /* __STDC__ */
int MFAM_Lp_eta_x(int M,double dx,double* f_x,double p,double eta,double* Lp_eta_x)
#endif /* __STDC__ */
{
  if((M>0)&&(dx>0.)&&(f_x!=NULL)&&(eta>=dx)&&(Lp_eta_x!=NULL))
  {
    register int m=0,n=0;
    int n_e=(int)floor(eta/(2*dx));
    for(m=0;m<n_e;m++)
    {
      *(Lp_eta_x+m)=0.;
      for(n=0;n<=n_e;n++)
	*(Lp_eta_x+m)+=(pow(fabs(*(f_x+m)-*(f_x+m+n)),p)*dx)/eta;
      *(Lp_eta_x+m)=pow(*(Lp_eta_x+m)*2,1./p);
    } 
    for(m=n_e;m<M-n_e;m++)
    {
      *(Lp_eta_x+m)=0.;
      for(n=-n_e;n<=n_e;n++)
	*(Lp_eta_x+m)+=(pow(fabs(*(f_x+m)-*(f_x+m+n)),p)*dx)/eta;
      if(m-n_e-1>=0)
	*(Lp_eta_x+m)+=(pow(fabs(*(f_x+m)-(*(f_x+m-n_e)+(*(f_x+m-n_e-1)-*(f_x+m-n_e))*(eta/(2*dx)-n_e))),p)*dx)/eta;
      if(m+n_e+1<M)
	*(Lp_eta_x+m)+=(pow(fabs(*(f_x+m)-(*(f_x+m+n_e)+(*(f_x+m+n_e+1)-*(f_x+m+n_e))*(eta/(2*dx)-n_e))),p)*dx)/eta;
      *(Lp_eta_x+m)=pow(*(Lp_eta_x+m),1./p);
    }
    for(m=M-n_e;m<M;m++) 
    {
      *(Lp_eta_x+m)=0.;
      for(n=-n_e;n<=0;n++)
	*(Lp_eta_x+m)+=(pow(fabs(*(f_x+m)-*(f_x+m+n)),p)*dx)/eta;
      *(Lp_eta_x+m)=pow(*(Lp_eta_x+m)*2,1./p);
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_Lp_eta_x arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_oscstr(oscstr, t_osc, p)
     char *oscstr;
     MFAMt_osc *t_osc;
     double *p;
#else /* __STDC__ */
int MFAM_oscstr(char* oscstr,MFAMt_osc* t_osc,double *p)
#endif /* __STDC__ */
{
  if(strcmp(MFAM_OSCSTR,oscstr)==0)
    *t_osc=MFAM_OSC;
  else if(strcmp(MFAM_OSCDELTASTR,oscstr)==0)
    *t_osc=MFAM_OSCDELTA;
  else if(strcmp(MFAM_LINFTYSTR,oscstr)==0)
    *t_osc=MFAM_LINFTY;
  else if(strncmp(MFAM_LPSTR,oscstr,1)==0)
  {
    *t_osc=MFAM_LP;
    *p=atof(oscstr+1);
  }
  else 
    return 0;
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_osc_eta_xy(M, N, f_xy, eta, osc_eta_xy)
     int M;
     int N;
     double *f_xy;
     double eta;
     double *osc_eta_xy;
#else /* __STDC__ */
int MFAM_osc_eta_xy(int M,int N,double* f_xy,double eta,double* osc_eta_xy)
#endif /* __STDC__ */
{
  double dx=1./N;
  double dy=1./M;
  if((M>0)&&(N>0)&&(f_xy!=NULL)&&(eta>=dx)&&(eta>=dy)&&(osc_eta_xy!=NULL))
  {
    register int k=0,l=0,m=0,n=0;
    int m_e=(int)floor(eta/(2*dy)),n_e=(int)floor(eta/(2*dx));
    double f_xy_plus=-HUGE,f_xy_minus=HUGE;
    { 
      for(k=m_e;k<M-m_e;k++)
      {
	for(l=n_e;l<N-n_e;l++)
	{
	  for(m=-m_e;m<m_e;m++)
	  {
	    for(n=-n_e;n<n_e;n++)
	    {
	      f_xy_minus=(*(f_xy+(k+m)*N+l+n)<f_xy_minus?
			  *(f_xy+(k+m)*N+l+n):f_xy_minus);
	      f_xy_plus=(*(f_xy+(k+m)*N+l+n)>f_xy_plus?
			 *(f_xy+(k+m)*N+l+n):f_xy_plus);
	    }
	  }
	  *(osc_eta_xy+k*N+l)=fabs(f_xy_plus-f_xy_minus);  
	  f_xy_minus=HUGE;
	  f_xy_plus=-HUGE; 
	}
      }
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_osc_eta_xy arguments error\n");
    return 0;
  }
}
