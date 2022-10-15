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

#include "MFAM_regression.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAM_lrstr(lrstr, t_lr)
     char *lrstr;
     MFAMt_lr *t_lr;
#else /* __STDC__ */
int MFAM_lrstr(char* lrstr,MFAMt_lr* t_lr)
#endif /* __STDC__ */
{
  if(strcmp(MFAM_LSLRSTR,lrstr)==0)
    *t_lr=MFAM_LSLR;
  else if(strcmp(MFAM_WLSLRSTR,lrstr)==0)
    *t_lr=MFAM_WLSLR; 
  else if(strcmp(MFAM_PLSLRSTR,lrstr)==0)
    *t_lr=MFAM_PLSLR;
  else if(strcmp(MFAM_MLSLRSTR,lrstr)==0)
    *t_lr=MFAM_MLSLR;   
  else if(strcmp(MFAM_MLLRSTR,lrstr)==0)
    *t_lr=MFAM_MLLR; 
  else if(strcmp(MFAM_LAPLSSTR,lrstr)==0)
    *t_lr=MFAM_LAPLSLR; 
  else 
    return 0;
  return 1;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_lr(J, x, y, t_lr, K, sigma2, w, I, m, s, a_hat, b_hat, y_hat, e_hat, sigma2_e_hat, K_star, j_hat, I_c_min, I_c_max, a_j_hat_min, a_j_hat_max)
     int J;
     double *x;
     double *y;
     MFAMt_lr t_lr;
     double K;
     double *sigma2;
     double *w;
     short int I;
     double m;
     double s;
     double *a_hat;
     double *b_hat;
     double *y_hat;
     double *e_hat;
     double *sigma2_e_hat;
     double *K_star;
     double *j_hat;
     double *I_c_min;
     double *I_c_max;
     double *a_j_hat_min;
     double *a_j_hat_max;
#else /* __STDC__ */
int MFAM_lr(int J,double* x,double* y,MFAMt_lr t_lr,double K,double* sigma2,double* w,short I,double m,double s,double* a_hat,double* b_hat,double* y_hat,double* e_hat,double* sigma2_e_hat,double* K_star,double* j_hat,double* I_c_min,double* I_c_max,double* a_j_hat_min,double* a_j_hat_max)
#endif /* __STDC__ */
{      
  if((J>0)&&(x!=NULL)&&(y!=NULL)&&(a_hat!=NULL)&&(b_hat!=NULL)&&(e_hat!=NULL)&&(y_hat!=NULL)&&(sigma2_e_hat!=NULL))
  {
    switch(t_lr)
    {
      case MFAM_LSLR:
	if(MFAM_lslr(J,x,y,a_hat,b_hat,y_hat,e_hat,sigma2_e_hat)==0)
	{ 
	  fprintf(stderr,"MFAM_lslr error\n");  
	  return 0; 
	}
	break;  
      case MFAM_WLSLR:
	if(MFAM_iszeros(J,w)==1)
	{
	  if(MFAM_uniform_w(J,w)==0)
	  {
	    fprintf(stderr,"MFAM_uniform_w error\n"); 
	    return 0;
	  }
	}
	if(MFAM_wlslr(J,x,y,a_hat,b_hat,y_hat,e_hat,sigma2_e_hat,w)==0)
	{ 
	  fprintf(stderr,"MFAM_wlslr error\n");  
	  return 0; 
	}
	break; 
      case MFAM_PLSLR:
	if(MFAM_plslr(J,x,y,a_hat,b_hat,y_hat,e_hat,sigma2_e_hat,w,I,m,s)==0)
	{ 
	  fprintf(stderr,"MFAM_plslr error\n");  
	  return 0; 
	}
	break;  
      case MFAM_MLSLR:
	if(MFAM_mlslr(J,x,y,a_hat,b_hat,y_hat,e_hat,sigma2_e_hat)==0)
	{ 
	  fprintf(stderr,"MFAM_mlslr error\n");  
	  return 0; 
	}
	break; 
      case MFAM_MLLR:
	if(MFAM_mllr(J,x,y,a_hat,b_hat,y_hat,e_hat,sigma2_e_hat,w,sigma2)==0)
	{ 
	  fprintf(stderr,"MFAM_mllr error\n");  
	  return 0; 
	}
	break;
      case MFAM_LAPLSLR:
	if(MFAM_laplslr(J,x,y,a_hat,b_hat,y_hat,e_hat,sigma2_e_hat,K,sigma2,K_star,j_hat,I_c_min,I_c_max,a_j_hat_min,a_j_hat_max)==0)
	{ 
	  fprintf(stderr,"MFAM_laplslr error\n");  
	  return 0; 
	}
	break; 
    default:
	fprintf(stderr,"MFAM_lr arguments error\n");
	return 0;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_lr arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_lslr(J, x, y, a_hat, b_hat, y_hat, e_hat, sigma2_e_hat)
     int J;
     double *x;
     double *y;
     double *a_hat;
     double *b_hat;
     double *y_hat;
     double *e_hat;
     double *sigma2_e_hat;
#else /* __STDC__ */
int MFAM_lslr(int J,double* x,double* y,double* a_hat,double* b_hat,double* y_hat,double* e_hat,double* sigma2_e_hat)
#endif /* __STDC__ */
{      
  if((J>1)&&(x!=NULL)&&(y!=NULL)&&(a_hat!=NULL)&&(b_hat!=NULL)&&(y_hat!=NULL)&&(e_hat!=NULL)&&(sigma2_e_hat!=NULL))
  { 
    register int j=0;
    double sum_x=0.,sum_y=0.,sum_x2=0.,sum_xy=0.;  
    for(j=0;j<J;j++)
    {
      sum_x+=*(x+j);	 
      sum_y+=*(y+j);
      sum_xy+=*(x+j)**(y+j);
      sum_x2+=*(x+j)**(x+j);
    }
    *a_hat=(J*sum_xy-sum_x*sum_y)/(J*sum_x2-sum_x*sum_x);      
    *b_hat=(sum_y-*a_hat*sum_x)/J; 
    *sigma2_e_hat=0.;
    for(j=0;j<J;j++)         
    {	 
      *(y_hat+j)=*a_hat**(x+j)+*b_hat; 
      *(e_hat+j)=*(y+j)-*(y_hat+j);	 
      *sigma2_e_hat+=*(e_hat+j)**(e_hat+j);  	            
    }
    *sigma2_e_hat/=J;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_lslr arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_wlslr(J, x, y, a_hat, b_hat, y_hat, e_hat, sigma2_e_hat, w)
     int J;
     double *x;
     double *y;
     double *a_hat;
     double *b_hat;
     double *y_hat;
     double *e_hat;
     double *sigma2_e_hat;
     double *w;
#else /* __STDC__ */
int MFAM_wlslr(int J,double* x,double* y,double* a_hat,double* b_hat,double* y_hat,double* e_hat,double* sigma2_e_hat,double* w)
#endif /* __STDC__ */
{      
  if((J>1)&&(x!=NULL)&&(y!=NULL)&&(a_hat!=NULL)&&(b_hat!=NULL)&&(y_hat!=NULL)&&(e_hat!=NULL)&&(sigma2_e_hat!=NULL)&&(w!=NULL))
  { 
    register int j=0;
    double sum_wx=0.,sum_wy=0.,sum_wx2=0.,sum_wxy=0.;
    for(j=0;j<J;j++)
    {
      sum_wx+=*(w+j)**(x+j);	 
      sum_wy+=*(w+j)**(y+j);
      sum_wxy+=*(w+j)**(x+j)**(y+j);
      sum_wx2+=*(w+j)**(x+j)**(x+j);
    }
    *a_hat=(sum_wxy-sum_wx*sum_wy)/(sum_wx2-sum_wx*sum_wx);      
    *b_hat=sum_wy-*a_hat*sum_wx;
    *sigma2_e_hat=0.;
    for(j=0;j<J;j++)         
    {	 
      *(y_hat+j)=*a_hat**(x+j)+*b_hat; 
      *(e_hat+j)=*(y+j)-*(y_hat+j);	 
      *sigma2_e_hat+=*(e_hat+j)**(e_hat+j);  	            
    }
    *sigma2_e_hat/=J;
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_wlslr arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_uniform_w(J, w)
     int J;
     double *w;
#else /* __STDC__ */
int MFAM_uniform_w(int J,double* w)
#endif /* __STDC__ */
{
  if((J>0)&&(w!=NULL))
  {
    register int j=0;
    for(j=0;j<J;j++)
      *(w+j)=1./J;
    return 1.;
  }
  else
  {
    fprintf(stderr,"MFAM_uniform_w arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_plslr(J, x, y, a_hat, b_hat, y_hat, e_hat, sigma2_e_hat, w, I, m, s)
     int J;
     double *x;
     double *y;
     double *a_hat;
     double *b_hat;
     double *y_hat;
     double *e_hat;
     double *sigma2_e_hat;
     double *w;
     short int I;
     double m;
     double s;
#else /* __STDC__ */
int MFAM_plslr(int J,double* x,double* y,double* a_hat,double* b_hat,double* y_hat,double* e_hat,double* sigma2_e_hat,double* w,short I,double m,double s)
#endif /* __STDC__ */
{      
  if((J>1)&&(x!=NULL)&&(y!=NULL)&&(a_hat!=NULL)&&(b_hat!=NULL)&&(y_hat!=NULL)&&(sigma2_e_hat!=NULL)&&(w!=NULL)&&(I>1)&&(s>0.))
  { 
    register int i=0;
    if(MFAM_uniform_w(J,w)==0)
    {
      fprintf(stderr,"MFAM_uniform_w error\n"); 
      return 0;
    }
    for(i=0;i<I;i++)
    {
      if(MFAM_wlslr(J,x,y,a_hat+i,b_hat+i,y_hat+J*i,e_hat,sigma2_e_hat,w)==0)
      { 
	fprintf(stderr,"MFAM_wlslr error\n");  
	return 0; 
      }
      if(MFAM_normal_w(J,e_hat,m,s,w)==0)
      {
	fprintf(stderr,"MFAM_uniform_w error\n"); 
	return 0;
      }
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_plslr arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_normal_w(J, e, m, s, w)
     int J;
     double *e;
     double m;
     double s;
     double *w;
#else /* __STDC__ */
int MFAM_normal_w(int J,double* e,double m,double s,double* w)
#endif /* __STDC__ */
{
  if((J>0)&&(w!=NULL))
  {
    register int j=0;
    double sum_w=0.;
    for(j=0;j<J;j++)
      sum_w+=*(w+j)=exp(-(*(e+j)-m)*(*(e+j)-m)/(2.*s));
    for(j=0;j<J;j++)
      *(w+j)/=sum_w;
    return 1.;
  }
  else
  {
    fprintf(stderr,"MFAM_uniform_w arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_mlslr(J, x, y, a_hat, b_hat, y_hat, e_hat, sigma2_e_hat)
     int J;
     double *x;
     double *y;
     double *a_hat;
     double *b_hat;
     double *y_hat;
     double *e_hat;
     double *sigma2_e_hat;
#else /* __STDC__ */
int MFAM_mlslr(int J,double* x,double* y,double* a_hat,double* b_hat,double* y_hat,double* e_hat,double* sigma2_e_hat)
#endif /* __STDC__ */
{      
  if((J>1)&&(x!=NULL)&&(y!=NULL)&&(a_hat!=NULL)&&(b_hat!=NULL)&&(y_hat!=NULL)&&(e_hat!=NULL)&&(sigma2_e_hat!=NULL))
  {
    register int j=1; 
    int start_j=0;
    *a_hat=(*x==0.?0.:*y/(*x));
    *b_hat=0.;
    *sigma2_e_hat=0.;
    for(j=1;j<J;j++)
    {
      if(MFAM_lslr(j+1,x,y,a_hat+j,b_hat+j,y_hat+start_j,e_hat+start_j,sigma2_e_hat+j)==0)
      { 
	fprintf(stderr,"MFAM_lslr error\n");  
	return 0; 
      }
      start_j+=j+1;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_mlslr arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_mllr(J, x, y, a_hat, b_hat, y_hat, e_hat, sigma2_e_hat, w, sigma2_j)
     int J;
     double *x;
     double *y;
     double *a_hat;
     double *b_hat;
     double *y_hat;
     double *e_hat;
     double *sigma2_e_hat;
     double *w;
     double *sigma2_j;
#else /* __STDC__ */
int MFAM_mllr(int J,double* x,double* y,double* a_hat,double* b_hat,double* y_hat,double* e_hat,double* sigma2_e_hat,double* w,double* sigma2_j)
#endif /* __STDC__ */
{      
  if((J>1)&&(x!=NULL)&&(y!=NULL)&&(a_hat!=NULL)&&(b_hat!=NULL)&&(y_hat!=NULL)&&(e_hat!=NULL)&&(sigma2_e_hat!=NULL)&&(w!=NULL)&&(sigma2_j!=NULL))
  { 
    if(MFAM_iszeros(J,sigma2_j)==1)
    {
      if(MFAM_mlslr(J,x,y,a_hat,b_hat,y_hat,e_hat,sigma2_e_hat)==0)
      { 
	fprintf(stderr,"MFAM_mlslr error\n");  
	return 0; 
      }
      if(MFAM_ml_w(J,sigma2_e_hat,w)==0)
      {
	fprintf(stderr,"MFAM_ml_w error\n"); 
	return 0;
      }
    }
    else
    {
      if(MFAM_ml_w(J,sigma2_j,w)==0)
      {
	fprintf(stderr,"MFAM_ml_w error\n"); 
	return 0;
      }
    } 
    if(MFAM_wlslr(J,x,y,a_hat,b_hat,y_hat,e_hat,sigma2_e_hat,w)==0)
    { 
      fprintf(stderr,"MFAM_wlslr error\n");  
      return 0; 
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_mllr arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_ml_w(J, sigma2_j, w)
     int J;
     double *sigma2_j;
     double *w;
#else /* __STDC__ */
int MFAM_ml_w(int J,double* sigma2_j,double* w)
#endif /* __STDC__ */
{
  if((J>0)&&(w!=NULL))
  {
    register int j=0;
    double sum_w=0.;
    for(j=0;j<J;j++)
      sum_w+=*(w+j)=pow(*(sigma2_j+j),.5);
    for(j=0;j<J;j++)
      *(w+j)/=sum_w;
    return 1.;
  }
  else
  {
    fprintf(stderr,"MFAM_ml_w arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_laplslr(J, x, y, a_hat, b_hat, y_hat, e_hat, sigma2_e_hat, K, sigma2_j, K_star, j_hat, I_c_j_min, I_c_j_max, E_c_j_hat_min, E_c_j_hat_max)
     int J;
     double *x;
     double *y;
     double *a_hat;
     double *b_hat;
     double *y_hat;
     double *e_hat;
     double *sigma2_e_hat;
     double K;
     double *sigma2_j;
     double *K_star;
     double *j_hat;
     double *I_c_j_min;
     double *I_c_j_max;
     double *E_c_j_hat_min;
     double *E_c_j_hat_max;
#else /* __STDC__ */
int MFAM_laplslr(int J,double* x,double* y,double* a_hat,double* b_hat,double* y_hat,double* e_hat,double* sigma2_e_hat,double K,double* sigma2_j,double* K_star,double* j_hat,double* I_c_j_min,double* I_c_j_max,double* E_c_j_hat_min,double* E_c_j_hat_max)
#endif /* __STDC__ */
{      
  if((J>1)&&(x!=NULL)&&(y!=NULL)&&(a_hat!=NULL)&&(b_hat!=NULL)&&(y_hat!=NULL)&&(e_hat!=NULL)&&(sigma2_e_hat!=NULL)&&(K>=0.)&&(sigma2_j!=NULL)&&(K_star!=NULL)&&(j_hat!=NULL)&&(I_c_j_min!=NULL)&&(I_c_j_max!=NULL)&&(E_c_j_hat_min!=NULL)&&(E_c_j_hat_max!=NULL))
  {
    register int j=0;
    int start_j=0;
    if(MFAM_mlslr(J,x,y,a_hat,b_hat,y_hat,e_hat,sigma2_e_hat)==0)
    { 
      fprintf(stderr,"MFAM_mlslr error\n");  
      return 0; 
    }
    if(MFAM_lap(J-1,a_hat+1,sigma2_j+1,K,K_star,j_hat,I_c_j_min,I_c_j_max,E_c_j_hat_min,E_c_j_hat_max)==0)
    {
      fprintf(stderr,"MFAM_lap error\n");
      return 0;
    }
    *j_hat=*j_hat+1;
    *a_hat=*(a_hat+(int)*j_hat);
    *b_hat=*(b_hat+(int)*j_hat);
    *sigma2_e_hat=*(sigma2_e_hat+(int)*j_hat);
    start_j=((int)*j_hat+1)*((int)*j_hat-2)/2;
    for(j=0;j<(int)*j_hat;j++)
    { 
      *(y_hat+j)=*(y_hat+j+start_j);
      *(e_hat+j)=*(e_hat+j+start_j);
    }
    for(j=(int)*j_hat;j<(J+2)/(J-1);j++)
    {
      *(y_hat+j)=0.; 
      *(e_hat+j)=0.;
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_laplslr arguments error\n");
    return 0;
  }
}
