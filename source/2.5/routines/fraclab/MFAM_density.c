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

#include "MFAM_density.h" 

#ifndef __STDC__
static double mfam_stddev();
#else /* __STDC__ */
static double mfam_stddev(int,double*);
#endif /* __STDC__ */

/*****************************************************************************/

#ifndef __STDC__
static double mfam_stddev(n, n_sample)
     int n;
     double *n_sample;
#else /* __STDC__ */
static double mfam_stddev(int n,double* n_sample)
#endif /* __STDC__ */
{
  register int k=0;
  double mean_n=0.,sigma2_n=0.;
  for(k=0;k<n;k++)
    mean_n+=*(n_sample+k);
  mean_n/=(double)n;
  for(k=0;k<n;k++) 
    sigma2_n+=(*(n_sample+k)-mean_n)*(*(n_sample+k)-mean_n);
  sigma2_n/=(double)n;
  return sqrt(sigma2_n);
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_widthstr(widthstr, t_width)
     char *widthstr;
     MFAMt_width *t_width;
#else /* __STDC__ */
int MFAM_widthstr(char* widthstr,MFAMt_width* t_width)
#endif /* __STDC__ */
{
  if((widthstr!=NULL)&&(t_width!=NULL))
  {
    if(strcmp(MFAM_HNSSTR,widthstr)==0)
      *t_width=MFAM_HNS;
    else if(strcmp(MFAM_MINDEVSTR,widthstr)==0)
      *t_width=MFAM_MINDEV;
    else if(strcmp(MFAM_MAXDEVSTR,widthstr)==0)
      *t_width=MFAM_MAXDEV;
    else if(strcmp(MFAM_MEANDEVSTR,widthstr)==0)
      *t_width=MFAM_MEANDEV;
    else if(strcmp(MFAM_ADAPTDEVSTR,widthstr)==0)
      *t_width=MFAM_ADAPTDEV;
    else
      return 0;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_widthstr arguments error\n");
    return 0; 
  }
}
 
/*****************************************************************************/
 
#ifndef __STDC__
int MFAM_adaptation(n, n_sample, K, dev_x, N, h, t_width, x, p_x)
     int n;
     double *n_sample;
     int K;
     double *dev_x;
     int N;
     double *h;
     MFAMt_width t_width;
     double *x;
     double *p_x;
#else /* __STDC__ */
int MFAM_adaptation(int n,double *n_sample,int K,double* dev_x,int N,double* h,MFAMt_width t_width,double* x,double* p_x)
#endif /* __STDC__ */
{
  if((n>0)&&(n_sample!=NULL)&&(N>0)&&(h!=NULL)&&(x!=NULL)&&(p_x!=NULL)) 
  {
    register int i=0,k=0;
    double h_n=0.,dev=0.,dev_x_min=HUGE,dev_x_max=-HUGE,dev_x_mean=0.;
    switch(t_width)
    {
      case MFAM_HNS:
	h_n=1.06*mfam_stddev(n,n_sample)/pow(n,.2);
	break;
      case MFAM_MINDEV: 
	h_n=HUGE;
	if((K>0)&&(dev_x!=NULL))
 	  for(k=1;k<K;k++) 
 	    h_n=(*(dev_x+k)<h_n?*(dev_x+k):h_n); 
 	else 
	  for(i=1;i<n;i++)
	  {
	    dev=*(n_sample+i)-*(n_sample+i-1);
	    if(dev)
	      h_n=(dev<h_n?dev:h_n);
	  }
	break;
      case MFAM_MAXDEV: 
	h_n=-HUGE;
	if((K>0)&&(dev_x!=NULL)) 
	  for(k=1;k<K;k++)
	    h_n=(*(dev_x+k)>h_n?*(dev_x+k):h_n);
	else 
	  for(i=1;i<n;i++)
	  {
	    dev=*(n_sample+i)-*(n_sample+i-1);
	    if(dev)
	      h_n=(dev>h_n?dev:h_n);
	  }
	break;
      case MFAM_MEANDEV:
	h_n=0.;
	if((K>0)&&(dev_x!=NULL))
	{
	  for(k=1;k<K;k++)
	    h_n+=*(dev_x+k);
	  h_n/=(K-1);
	}
	else
	{
	  for(i=1;i<n;i++)
	  {
	    dev=*(n_sample+i)-*(n_sample+i-1);
	    h_n+=dev; 
	    if(dev)
	      K++;
	  }
	  h_n/=K;
	}
	break;
      case MFAM_ADAPTDEV:
	if((K>0)&&(dev_x!=NULL))
	{
	  if(MFAM_min_max(K-1,dev_x+1,&dev_x_min,&dev_x_max)==0)
	  {
	    fprintf(stderr,"MFAM_min_max error\n");
	    return 0;   
	  } 
	  dev_x_mean=(dev_x_max+dev_x_min)/2.;
	  fprintf(stderr,"%f %f %f\n",dev_x_min,dev_x_max,dev_x_mean);
	  for(k=0;k<K;k++)
	  {
	    if(*(dev_x+k)>dev_x_mean)
	      *(dev_x+k)=dev_x_max;
	    else
	      *(dev_x+k)=dev_x_min;
	  } 
	}
	else
	{
	  for(i=1;i<n;i++)
	  {
	    dev=*(n_sample+i)-*(n_sample+i-1);
	    if(dev)
	    {
	      dev_x_max=(dev>dev_x_max?dev:dev_x_max);
	      dev_x_min=(dev<dev_x_min?dev:dev_x_min);
	    }
	  }
	  dev_x_mean=(dev_x_max+dev_x_min)/2.;
	  fprintf(stderr,"%f %f %f\n",dev_x_min,dev_x_max,dev_x_mean);
	  i=0;
	  do
	  {
	    i++;
	    dev=*(n_sample+i)-*(n_sample+i-1);   
	  }
	  while((i<n)&&(dev<=dev_x_mean));
	  for(k=0;k<N;k++)
	  {
	    if(*(x+k)<*(n_sample+i))
	      *(h+k)=dev_x_max;
	    else
	      *(h+k)=dev_x_min;
	  }
	}
	break;
      default: 
	fprintf(stderr,"MFAM_adaptation arguments error\n");
	return 0;
    }
    if(t_width!=MFAM_ADAPTDEV)
      for(k=0;k<N;k++)
	*(h+k)=h_n;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_adaptation arguments error\n");
    return 0; 
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_kpdf(n, n_sample, t_kern, N, h, t_width, x, p_x)
     int n;
     double *n_sample;
     MFAMt_kern t_kern;
     int N;
     double *h;
     MFAMt_width t_width;
     double *x;
     double *p_x;
#else /* __STDC__ */
int MFAM_kpdf(int n,double* n_sample,MFAMt_kern t_kern,int N,double* h,MFAMt_width t_width,double* x,double* p_x)
#endif /* __STDC__ */
{
  if((n>0)&&(n_sample!=NULL)&&(N>0)&&(h!=NULL)&&(x!=NULL)&&(p_x!=NULL))
  { 
    register int k=0,i=0;
    static int (*compare)()=MFAM_compare; 
    /* modif Bertrand 13/05/98 */
#ifndef __STDC__
    double (*kern)()=NULL; 
#else /*   __STDC__ */
    double (*kern)(double)=NULL; 
#endif /*   __STDC__ */

    qsort(n_sample,n,sizeof(double),compare);  
    if(MFAM_linspace(N,*n_sample,*(n_sample+n-1),x)==0)
    {
      fprintf(stderr,"MFAM_linspace error\n");
      return 0;
    } 
    switch(t_kern)
    {  
      case MFAM_BOXCAR:
	kern=MFAM_boxcar;
	break; 
      case MFAM_TRIANGLE:
	kern=MFAM_triangle;
	break; 
      case MFAM_GAUSSIAN:
	kern=MFAM_gauss;
	break;
      case MFAM_MOLLIFIER:
	kern=MFAM_mol;
	break; 
      case MFAM_EPANECHNIKOV:
	kern=MFAM_epa;
	break;   
      case MFAM_INTEGRATED:
      default:
	fprintf(stderr,"MFAM_kpdf arguments error\n");
	return 0;
    }
    if(MFAM_adaptation(n,n_sample,0,NULL,N,h,t_width,x,p_x)==0)
    {
      fprintf(stderr,"MFAM_adaptation error\n");
      return 0;
    }
    *p_x=0.;
    for(i=0;i<n;i++)
      *p_x+=kern((*(n_sample+i)-*x)/(*h));
    *p_x/=(*h)*(double)n;
    for(k=1;k<N-1;k++)
    {
      *(p_x+k)=0.;
      if(*(x+k)-*n_sample<(*(h+k)))
      {
	for(i=0;i<n;i++)
	  if(*(n_sample+i)>*(x+k))  
	    *(p_x+k)+=kern((*(n_sample+i)-*(x+k))/(*(h+k)));
	  else
	    *(p_x+k)+=kern((*(n_sample+i)-*(x+k))/(*(x+k)-*n_sample));
      }
      else if(*(n_sample+n-1)-*(x+k)<(*(h+k)))
      {
	for(i=0;i<n;i++)
	  if(*(n_sample+i)<*(x+k))  
	    *(p_x+k)+=kern((*(n_sample+i)-*(x+k))/(*(h+k)));
	  else
	    *(p_x+k)+=kern((*(n_sample+i)-*(x+k))/(*(n_sample+N-1)-*(x+k)));
      }
      else
	for(i=0;i<n;i++)
	  *(p_x+k)+=kern((*(n_sample+i)-*(x+k))/(*(h+k)));
      *(p_x+k)/=(*(h+k))*(double)n;
    } 
    *(p_x+N-1)=0.;
    for(i=0;i<n;i++)
      *(p_x+N-1)+=kern((*(n_sample+i)-*(x+N-1))/(*(h+N-1)));
    *(p_x+N-1)/=(*(h+N-1))*(double)n;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_kpdf arguments error\n");
    return 0;   
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_histogram(n, n_sample, K, bin_x, h_x, dev_x)
     int n;
     double *n_sample;
     int *K;
     double *bin_x;
     int *h_x;
     double *dev_x;
#else /* __STDC__ */
int MFAM_histogram(int n,double* n_sample,int* K,double* bin_x,int* h_x,double* dev_x)
#endif /* __STDC__ */
{ 
  if((n>0)&&(n_sample!=NULL)&&(K!=NULL)&&(bin_x!=NULL)&&(h_x!=NULL)&&(dev_x!=NULL))
  {
    register int k=0,l=0;
    static int (*compare)()=MFAM_compare;
    qsort(n_sample,n,sizeof(double),compare);
    *bin_x=*n_sample;
    *h_x=0.;
    *dev_x=0.;
    while(k<n)
    {
      if((*(bin_x+l)!=HUGE)&&(*(bin_x+l)!=*(n_sample+k)))
      {
	l++;
	*(bin_x+l)=*(n_sample+k);
	*(h_x+l)=0.;
	*(dev_x+l)=*(bin_x+l)-*(bin_x+l-1);
      }
      *(h_x+l)+=1;
      k++; 
    }
    *K=l+1;
    return 1;
  }
  else
  { 
    fprintf(stderr,"MFAM_histogram arguments error\n");
    return 0;   
  } 
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_khistogram(n, n_sample, t_kern, N, h, t_width, x, p_x)
     int n;
     double *n_sample;
     MFAMt_kern t_kern;
     int N;
     double *h;
     MFAMt_width t_width;
     double *x;
     double *p_x;
#else /* __STDC__ */
int MFAM_khistogram(int n,double* n_sample,MFAMt_kern t_kern,int N,double* h,MFAMt_width t_width,double* x,double* p_x)
#endif /* __STDC__ */
{
  if((n>0)&&(n_sample!=NULL)&&(N>0)&&(h!=NULL)&&(x!=NULL)&&(p_x!=NULL))
  { 
    register int k=0,l=0;
    double h_n=.1;
    int K=n;
    int* h_x=NULL;
    double* bin_x=NULL;
    double* dev_x=NULL;
    /* modif Bertrand 13/05/98 */
#ifndef __STDC__
    double (*kern)(); 
#else /*   __STDC__ */
    double (*kern)(double); 
#endif /*   __STDC__ */
    if((bin_x=(double*)malloc((unsigned)(K*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      return 0;
    }
    if((h_x=(int*)malloc((unsigned)(K*sizeof(int))))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      return 0;
    }
    if((dev_x=(double*)malloc((unsigned)(K*sizeof(double))))==NULL)
    {
      fprintf(stderr,"malloc error\n");
      return 0;
    } 
    if(MFAM_histogram(n,n_sample,&K,bin_x,h_x,dev_x)==0)
    { 
      fprintf(stderr,"MFAM_histogram error\n");
      return 0;
    } 
    if((bin_x=(double*)realloc(bin_x,(unsigned)(K*sizeof(double))))==NULL)
    {
      fprintf(stderr,"realloc error\n");
      return 0;
    }
    if((h_x=(int*)realloc(h_x,(unsigned)(K*sizeof(int))))==NULL)
    {
      fprintf(stderr,"realloc error\n");
      return 0;
    }
    if((dev_x=(double*)realloc(dev_x,(unsigned)(K*sizeof(double))))==NULL)
    {
      fprintf(stderr,"realloc error\n");
      return 0;
    }
    if(MFAM_linspace(N,*bin_x,*(bin_x+K-1),x)==0)
    { 
      fprintf(stderr,"MFAM_linspace error\n");
      return 0;
    }
    switch(t_kern)
    {  
      case MFAM_BOXCAR:
	kern=MFAM_boxcar;
	break; 
      case MFAM_TRIANGLE:
	kern=MFAM_triangle;
	break; 
      case MFAM_GAUSSIAN:
	kern=MFAM_gauss;
	break;
      case MFAM_MOLLIFIER:
	kern=MFAM_mol;
	break; 
      case MFAM_EPANECHNIKOV:
	kern=MFAM_epa;
	break;  
      case MFAM_INTEGRATED: 
      default:
	fprintf(stderr,"MFAM_khistogram arguments error\n");
	break;
    }
    if(MFAM_adaptation(n,n_sample,K,dev_x,N,h,t_width,x,p_x)==0)
    {
      fprintf(stderr,"MFAM_adaptation error\n");
      return 0;
    }
    for(l=0;l<N;l++)
    {
      *(p_x+l)=0.;
      /* first value */
      /* n-2 values */
      for(k=1;k<K-1;k++)
      {
	if (t_width==MFAM_ADAPTDEV)
	  fprintf(stderr,"%f\n",h_n=*(dev_x+k));
	else
	  h_n=*(h+l);
	*(p_x+l)+=*(h_x+k)*kern((*(x+l)-*(bin_x+k))/h_n)/(n*h_n);
      }
      /* last value */
    }
    free((char*)bin_x);
    free((char*)h_x);
    free((char*)dev_x);
    return 1;   
  }
  else
  {
    fprintf(stderr,"MFAM_khistogram arguments error\n");
    return 0;   
  }
}
