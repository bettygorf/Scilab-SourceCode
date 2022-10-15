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

#include "MFAG_misc.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAG_hoelder(M, J, alpha_eta_x, N, alpha)
     int M;
     short int J;
     double *alpha_eta_x;
     int N;
     double *alpha;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_hoelder(M, J, alpha_eta_x, N, alpha)
     int M;
     short int J;
     double *alpha_eta_x;
     int N;
     double *alpha;
#else /* __STDC__ */
int MFAG_hoelder(int M,short J,double* alpha_eta_x,int N,double* alpha)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((M>0)&&(J>0)&&(alpha_eta_x!=NULL)&&(N>0)&&(alpha!=NULL))
  {
    register int j=0;
    double alpha_eta_min=HUGE,alpha_eta_max=-HUGE;
    for(j=0;j<J;j++)
    {
      double alpha_eta_min_j=HUGE,alpha_eta_max_j=-HUGE;
      if(MFAM_min_max(M,alpha_eta_x+M*j,&alpha_eta_min_j,&alpha_eta_max_j)==0)
      {
	fprintf(stderr,"MFAM_min_max error\n"); 
	return 0;
      }
      alpha_eta_min=(alpha_eta_min_j<alpha_eta_min?
		       alpha_eta_min_j:alpha_eta_min);
      alpha_eta_max=(alpha_eta_max_j>alpha_eta_max?
		       alpha_eta_max_j:alpha_eta_max);
    }
    if(MFAM_linspace(N,alpha_eta_min-1.e-5,alpha_eta_max+1.e-5,alpha)==0)
    {
      fprintf(stderr,"MFAM_linspace error\n"); 
      return 0;
    } 
    return 1;
  }
  else
  { 
    fprintf(stderr,"MFAG_hoelder arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAG_adapstr(adapstr, t_adap)
     char *adapstr;
     MFAGt_adap *t_adap;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_adapstr(adapstr, t_adap)
     char *adapstr;
     MFAGt_adap *t_adap;
#else /* __STDC__ */
int MFAG_adapstr(char* adapstr,MFAGt_adap* t_adap)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if(strcmp(MFAG_MAXDEVSTR,adapstr)==0)
    *t_adap=MFAG_MAXDEV;
  else if(strcmp(MFAG_MINDEVSTR,adapstr)==0)
    *t_adap=MFAG_MINDEV;
  else if(strcmp(MFAG_MEANDEVSTR,adapstr)==0)
    *t_adap=MFAG_MEANDEV;
  else if(strcmp(MFAG_MEANADAPTDEVSTR,adapstr)==0)
    *t_adap=MFAG_MEANADAPTDEV;   
  else if(strcmp(MFAG_MAXADAPTDEVSTR,adapstr)==0)
    *t_adap=MFAG_MAXADAPTDEV; 
  else if(strcmp(MFAG_ONEMODADAPTDEVSTR,adapstr)==0)
    *t_adap=MFAG_ONEMODADAPTDEV; 
  else 
    return 0;
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAG_adaptation(M, alpha_eta_x, N, alpha, epsilon, t_adap)
     int M;
     double *alpha_eta_x;
     int N;
     double *alpha;
     double *epsilon;
     MFAGt_adap t_adap; 
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_adaptation(M, alpha_eta_x, N, alpha, epsilon, t_adap)
     int M;
     double *alpha_eta_x;
     int N;
     double *alpha;
     double *epsilon;
     MFAGt_adap t_adap; 
#else /* __STDC__ */
int MFAG_adaptation(int M,double* alpha_eta_x,int N,double* alpha,double* epsilon,MFAGt_adap t_adap) 
#endif /* __STDC__ */
#endif /* __STDC__ */
{ 
  if((M>0)&&(alpha_eta_x!=NULL)&&(N>0)&&(alpha!=NULL)&&(epsilon!=NULL)) 
   { 
     register int m=0,n=0; 
     int number=0;
     static int (*compare)()=MFAM_compare;
     double alpha_dev=0.;
     double* alpha_tmp=NULL; 
     if((alpha_tmp=(double*)malloc((unsigned)(M*sizeof(double))))==NULL)
     {
       fprintf(stderr,"malloc error\n"); 
       return 0;
     }
     memcpy(alpha_tmp,alpha_eta_x,M*sizeof(double));
     qsort(alpha_tmp,M,sizeof(double),compare);
     switch(t_adap)
     {
       case MFAG_MAXDEV:
	 *epsilon=-HUGE;
	 for(m=0;m<M-1;m++)
	 { 
	   if((alpha_dev=*(alpha_tmp+m+1)-*(alpha_tmp+m)))
	     *epsilon=(*epsilon>alpha_dev/2.?*epsilon:alpha_dev/2.);
	 }
	 break;
       case MFAG_MINDEV:
	 *epsilon=HUGE;
	 for(m=0;m<M-1;m++)
	 { 
	   if((alpha_dev=*(alpha_tmp+m+1)-*(alpha_tmp+m)))
	     *epsilon=(*epsilon<alpha_dev/2.?*epsilon:alpha_dev/2.);
	 }
	 break;
       case MFAG_MEANDEV:
	 *epsilon=0.;
	 for(m=0;m<M-1;m++)
	 { 
	   if((alpha_dev=*(alpha_tmp+m+1)-*(alpha_tmp+m)))
	   {
	     *epsilon+=alpha_dev/2.;
	     number++;
	   }
	 }
	 *epsilon/=number;
	 break;
       case MFAG_MEANADAPTDEV:
	 for(m=0;m<M-1;m++)
	 {
	   if((*(alpha_tmp+m)<(*(alpha+1)+*alpha)/2.))
	   {
	     alpha_dev=(*(alpha_tmp+m+1)-*(alpha_tmp+m))/2.;
	     if(alpha_dev)
	       number++;
	   }     
	 }
	 if(number)
	   *epsilon=alpha_dev/number;
	 for(n=1;n<N-1;n++)
	 {
	   for(m=0;m<M-1;m++)
	   {
	     if(((*(alpha+n-1)+*(alpha+n))/2.<=*(alpha_tmp+m))&&
		((*(alpha_tmp+m)<(*(alpha+n)+*(alpha+n+1))/2.)))
	     {
	       alpha_dev=(*(alpha_tmp+m+1)-*(alpha_tmp+m))/2.;
	       if(alpha_dev)
		 number++;
	     }     
	   }
	   if(number)
	     *(epsilon+n)=alpha_dev/number;
	   else
	     *(epsilon+n)=*(epsilon+n-1);
	   number=0;
	 } 
	 for(m=0;m<M-1;m++)
	 {
	   if((*(alpha+N-2)+(*alpha+N-1))/2.<=*(alpha_tmp+m))
	   {
	     alpha_dev=(*(alpha_tmp+m+1)-*(alpha_tmp+m))/2.;
	     if(alpha_dev)
	       number++;
	   }     
	 }
	 if(number)
	   *(epsilon+N-1)=alpha_dev/number; 
	 else
	   *(epsilon+N-1)=*(epsilon+N-2);
	 break;
       case MFAG_ONEMODADAPTDEV:
       case MFAG_MAXADAPTDEV:
	 *epsilon=-HUGE;
	 for(m=0;m<M-1;m++)
	 {
	   if((*(alpha_tmp+m)<(*(alpha+1)+*alpha)/2.))
	   {
	     alpha_dev=*(alpha_tmp+m+1)-*(alpha_tmp+m);
	     *epsilon=(*epsilon>alpha_dev/2.?
		       *epsilon:alpha_dev/2.);
	     number++;
	   }     
	 } 
	 if(!number)
	   *epsilon=0;
	 for(n=1;n<N-1;n++)
	 {
	   number=0;  
	   *(epsilon+n)=-HUGE;
	   for(m=0;m<M-1;m++)
	   {
	     if(((*(alpha+n-1)+*(alpha+n))/2.<=*(alpha_tmp+m))&&
		((*(alpha_tmp+m)<(*(alpha+n)+*(alpha+n+1))/2.)))
	     {
	       alpha_dev=*(alpha_tmp+m+1)-*(alpha_tmp+m);
	       *(epsilon+n)=(*(epsilon+n)>alpha_dev/2.?
			     *(epsilon+n):alpha_dev/2.);
	       number++;
	     }   
	   } 
	   if(!number)
	     *(epsilon+n)=*(epsilon+n-1);  
	 }	
	 number=0;  
	 *(epsilon+N-1)=-HUGE; 
	 for(m=0;m<M-1;m++)
	 {
	   if((*(alpha+N-2)+(*alpha+N-1))/2.<=*(alpha_tmp+m))
	   {
	     alpha_dev=(*(alpha_tmp+m+1)-*(alpha_tmp+m));
	     *(epsilon+N-1)=(*(epsilon+N-1)>alpha_dev/2.?
			     *(epsilon+N-1):alpha_dev/2.);
	       number++;
	   }     
	 }
	 if(!number)
	   *(epsilon+N-1)=*(epsilon+N-2);  
	 break;
     }
     if((t_adap==MFAG_MAXDEV)||
	(t_adap==MFAG_MINDEV)||
	(t_adap==MFAG_MEANDEV))
       for(n=1;n<N;n++) 
	 *(epsilon+n)=*epsilon;
     if(t_adap==MFAG_ONEMODADAPTDEV)
     {
       double epsilon_min=0.,epsilon_max=0.,epsilon_mean=0.;
       if(MFAM_min_max(N,epsilon,&epsilon_min,&epsilon_max)==0)
       {
	 fprintf(stderr,"MFAM_min_max arguments error\n"); 
	 return 0;    
       }
       epsilon_mean=(epsilon_max+epsilon_min)/2.;
       for(n=0;n<N;n++)
       {
	 if(*(epsilon+n)>epsilon_mean)
	   *(epsilon+n)=epsilon_max;
	 else
	   *(epsilon+n)=epsilon_min;
       } 
     }
     free((char*)alpha_tmp);
     return 1;
   } 
   else 
   {  
     fprintf(stderr,"MFAG_adaptation arguments error\n"); 
     return 0;    
   } 
 } 

/*****************************************************************************/

#ifndef __STDC__
int MFAG_normstr(normstr, t_norm)
     char *normstr;
     MFAGt_norm *t_norm;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_normstr(normstr, t_norm)
     char *normstr;
     MFAGt_norm *t_norm;
#else /* __STDC__ */
int MFAG_normstr(char* normstr,MFAGt_norm* t_norm)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if(strcmp(MFAG_NONORMSTR,normstr)==0)
    *t_norm=MFAG_NONORM;
  else if(strcmp(MFAG_SUPPDFSTR,normstr)==0)
    *t_norm=MFAG_SUPPDF;
  else if(strcmp(MFAG_SUPFGSTR,normstr)==0)
    *t_norm=MFAG_SUPFG;
  else if(strcmp(MFAG_INFSUPPDFSTR,normstr)==0)
    *t_norm=MFAG_INFSUPPDF;   
  else if(strcmp(MFAG_INFSUPFGSTR,normstr)==0)
    *t_norm=MFAG_INFSUPFG;
  else 
    return 0;
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAG_norm(t_norm, eta, N, epsilon, p_eta_alpha, fg_eta_alpha)
     MFAGt_norm t_norm;
     double eta;
     short int N;
     double *epsilon;
     double *p_eta_alpha;
     double *fg_eta_alpha; 
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_norm(t_norm, eta, N, epsilon, p_eta_alpha, fg_eta_alpha)
     MFAGt_norm t_norm;
     double eta;
     short int N;
     double *epsilon;
     double *p_eta_alpha;
     double *fg_eta_alpha; 
#else /* __STDC__ */
int MFAG_norm(MFAGt_norm t_norm,double eta,short N,double* epsilon,double* p_eta_alpha,double* fg_eta_alpha) 
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((eta>=0.)&&(N>0)&&(p_eta_alpha!=NULL)&&(fg_eta_alpha!=NULL)) 
  {
    register int n=0;
    switch(t_norm)
    {
      case MFAG_NONORM:
	for(n=0;n<N;n++)
	  if(*(p_eta_alpha+n)>0.)
	    *(fg_eta_alpha+n)=1-log((*(p_eta_alpha+n)))/log(eta);
	  else
	    *(fg_eta_alpha+n)=0.;
	break;
      case MFAG_SUPPDF:
      {
	if((epsilon!=NULL)&&(fabs(*epsilon-*(epsilon+N-1))<1e-5))
	{
	  double sup_p_eta_alpha1=-HUGE;
	  double sup_p_eta_alpha2=-HUGE;
	  double epsilon1=*epsilon;
	  for(n=0;n<N;n++)
	  {
	    if(fabs(*(epsilon+n)-epsilon1)<1e-5)
	      sup_p_eta_alpha1=(sup_p_eta_alpha1>*(p_eta_alpha+n)?
				sup_p_eta_alpha1:*(p_eta_alpha+n));
	    else
	      sup_p_eta_alpha2=(sup_p_eta_alpha2>*(p_eta_alpha+n)?
				sup_p_eta_alpha2:*(p_eta_alpha+n));
	  }
	  if((sup_p_eta_alpha1!=0.)&&(sup_p_eta_alpha2!=0.))
	  {
	    for(n=0;n<N;n++)
	    {
	      if(fabs(*(epsilon+n)-epsilon1)<1e-5)
	     	*(p_eta_alpha+n)=*(p_eta_alpha+n)/sup_p_eta_alpha1;  
	      else
		*(p_eta_alpha+n)=*(p_eta_alpha+n)/sup_p_eta_alpha2;
	      *(fg_eta_alpha+n)=1-log((*(p_eta_alpha+n)))/log(eta); 
	    }
	  }
	}
	else
	{
	  double sup_p_eta_alpha=0.;
	  for(n=0;n<N;n++)
	    sup_p_eta_alpha=(sup_p_eta_alpha>*(p_eta_alpha+n)?
			     sup_p_eta_alpha:*(p_eta_alpha+n)); 
	  if(sup_p_eta_alpha!=0.)
	  {
	    for(n=0;n<N;n++)
	    {
	      *(p_eta_alpha+n)/=sup_p_eta_alpha;
	      if(*(p_eta_alpha+n)>eta/sup_p_eta_alpha)
		*(fg_eta_alpha+n)=1-log((*(p_eta_alpha+n)))/log(eta);
	      else
		*(fg_eta_alpha+n)=0.;
	    }
	  }
	  else
	    for(n=0;n<N;n++)
	      *(fg_eta_alpha+n)=0.;
	}
	break;
      }
      case MFAG_SUPFG:
      {
	double sup_fg_eta_alpha=0.;
	for(n=0;n<N;n++)
	{ 
	  if(*(p_eta_alpha+n)>0.)
	    *(fg_eta_alpha+n)=1-log((*(p_eta_alpha+n)))/log(eta);
	  else
	    *(fg_eta_alpha+n)=0.;
	  sup_fg_eta_alpha=(sup_fg_eta_alpha>*(fg_eta_alpha+n)?
			    sup_fg_eta_alpha:*(fg_eta_alpha+n));
	}
	if(sup_fg_eta_alpha!=0.)
	{
	  for(n=0;n<N;n++)
	    *(fg_eta_alpha+n)/=sup_fg_eta_alpha;
	}
	else
	  for(n=0;n<N;n++)
	    *(fg_eta_alpha+n)=0.;
	break;
      }
      case MFAG_INFSUPPDF:
      {
	if((epsilon!=NULL)&&(fabs(*epsilon-*(epsilon+N-1))<1e-5))
	{
	  double inf_p_eta_alpha1=HUGE,sup_p_eta_alpha1=-HUGE;
	  double inf_p_eta_alpha2=HUGE,sup_p_eta_alpha2=-HUGE;
	  double epsilon1=*epsilon;
	  for(n=0;n<N;n++)
	  {
	    if(fabs(*(epsilon+n)-epsilon1)<1e-5)
	    {
	      inf_p_eta_alpha1=(inf_p_eta_alpha1<*(p_eta_alpha+n)?
				inf_p_eta_alpha1:*(p_eta_alpha+n));
	      sup_p_eta_alpha1=(sup_p_eta_alpha1>*(p_eta_alpha+n)?
				sup_p_eta_alpha1:*(p_eta_alpha+n));
	    }
	    else
	    { 
	      inf_p_eta_alpha2=(inf_p_eta_alpha2<*(p_eta_alpha+n)?
				inf_p_eta_alpha2:*(p_eta_alpha+n));
	      sup_p_eta_alpha2=(sup_p_eta_alpha2>*(p_eta_alpha+n)?
				sup_p_eta_alpha2:*(p_eta_alpha+n));
	    }
	  }
	  if((sup_p_eta_alpha1-inf_p_eta_alpha1!=0.)&&
	     (sup_p_eta_alpha2-inf_p_eta_alpha2!=0.))
	  {
	    for(n=0;n<N;n++)
	    {
	      if(fabs(*(epsilon+n)-epsilon1)<1e-5)
	     	*(p_eta_alpha+n)=eta+
		  (*(p_eta_alpha+n)-inf_p_eta_alpha1)/
		  (sup_p_eta_alpha1-inf_p_eta_alpha1);  
	      else
		*(p_eta_alpha+n)=eta+
		  (*(p_eta_alpha+n)-inf_p_eta_alpha2)/
		  (sup_p_eta_alpha2-inf_p_eta_alpha2);
	      *(fg_eta_alpha+n)=1-log((*(p_eta_alpha+n)))/log(eta); 
	    }
	  }
	}
	else
	{
	  double inf_p_eta_alpha=HUGE,sup_p_eta_alpha=-HUGE;
	  for(n=0;n<N;n++)
	  {
	    inf_p_eta_alpha=(inf_p_eta_alpha<*(p_eta_alpha+n)?
			     inf_p_eta_alpha:*(p_eta_alpha+n));
	    sup_p_eta_alpha=(sup_p_eta_alpha>*(p_eta_alpha+n)?
			     sup_p_eta_alpha:*(p_eta_alpha+n));
	  }
	  if(sup_p_eta_alpha-inf_p_eta_alpha!=0.)
	  {
	    for(n=0;n<N;n++)
	    {
	      *(p_eta_alpha+n)=eta+
		(*(p_eta_alpha+n)-inf_p_eta_alpha)/
		(sup_p_eta_alpha-inf_p_eta_alpha);
	      *(fg_eta_alpha+n)=1-log((*(p_eta_alpha+n)))/log(eta); 
	    }
	  }
	  break;  
	}
      case MFAG_INFSUPFG:
	break;
      }
    } 
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAG_norm arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAG_alpha_eta_x_extrema(M, dx, alpha_eta_x, eta, epsilon, alpha_eta_x_minus, alpha_eta_x_plus)
     int M;
     double dx;
     double *alpha_eta_x;
     double eta;
     double epsilon;
     double *alpha_eta_x_minus;
     double *alpha_eta_x_plus;
#else /* __STDC__ */
#ifndef __STDC__
int MFAG_alpha_eta_x_extrema(M, dx, alpha_eta_x, eta, epsilon, alpha_eta_x_minus, alpha_eta_x_plus)
     int M;
     double dx;
     double *alpha_eta_x;
     double eta;
     double epsilon;
     double *alpha_eta_x_minus;
     double *alpha_eta_x_plus;
#else /* __STDC__ */
int MFAG_alpha_eta_x_extrema(int M,double dx,double* alpha_eta_x,double eta,double epsilon,double* alpha_eta_x_minus,double* alpha_eta_x_plus)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((M>0)&&(dx>0.)&&(alpha_eta_x!=NULL)&&(eta>=dx)&&(epsilon>0.)&&(alpha_eta_x_minus!=NULL)&&(alpha_eta_x_plus!=NULL))
  {
    register int k=0,l=0; 
    int n_e=(int)ceil(eta/(2.*dx)); 
    for(k=0;k<n_e;k++)
    {
      *(alpha_eta_x_minus+k)=HUGE;
      *(alpha_eta_x_plus+k)=-HUGE;
      for(l=-k;l<=n_e;l++)
      {
	*(alpha_eta_x_minus+k)=(*(alpha_eta_x+k+l)<*(alpha_eta_x_minus+k)?
				*(alpha_eta_x+k+l):*(alpha_eta_x_minus+k));
	*(alpha_eta_x_plus+k)=(*(alpha_eta_x+k+l)>*(alpha_eta_x_plus+k)?
			       *(alpha_eta_x+k+l):*(alpha_eta_x_plus+k));
      }
    }
    for(k=n_e;k<M-n_e;k++)
    {
      *(alpha_eta_x_minus+k)=HUGE;
      *(alpha_eta_x_plus+k)=-HUGE;
      for(l=-n_e;l<=n_e;l++)
      {
	*(alpha_eta_x_minus+k)=(*(alpha_eta_x+k+l)<*(alpha_eta_x_minus+k)?
				*(alpha_eta_x+k+l):*(alpha_eta_x_minus+k));
	*(alpha_eta_x_plus+k)=(*(alpha_eta_x+k+l)>*(alpha_eta_x_plus+k)?
			       *(alpha_eta_x+k+l):*(alpha_eta_x_plus+k));
      }
    } 
    for(k=M-n_e;k<M;k++)
    {
      *(alpha_eta_x_minus+k)=HUGE;
      *(alpha_eta_x_plus+k)=-HUGE;
      for(l=-n_e;l<M-k;l++)
      {
	*(alpha_eta_x_minus+k)=(*(alpha_eta_x+k+l)<*(alpha_eta_x_minus+k)?
				*(alpha_eta_x+k+l):*(alpha_eta_x_minus+k));
	*(alpha_eta_x_plus+k)=(*(alpha_eta_x+k+l)>*(alpha_eta_x_plus+k)?
			       *(alpha_eta_x+k+l):*(alpha_eta_x_plus+k));
      }
    }
    return 1;
  }
  else
  { 
    fprintf(stderr,"MFAG_alpha_eta_x_extrema arguments error\n");
    return 0;
  }
}
