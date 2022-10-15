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

/* Christophe Canus 1996-97-98 */

#include "MFAM_random.h"

int seed;
#ifndef __STDC__
static double normal_1();
#else /* __STDC__ */
static double normal_1(void);
#endif /* __STDC__ */

/* random seed */
#ifndef __STDC__
void random_seed() 
#else /* __STDC__ */
void random_seed(void) 
#endif /* __STDC__ */
{
  time_t t=0;
  time(&t);
  seed=t;
  srand(seed);
}

/* normal r.v. with expected value 0. and variance 1.*/
#ifndef __STDC__
static double normal_1() 
#else /* __STDC__ */
static double normal_1(void) 
#endif /* __STDC__ */
{
  double u=0.,v=1.,w=0.;
  u=rand()/(RAND_MAX+1.);
  u=M_PI*(u-0.5);
  while(v==1.)
    v=rand()/(RAND_MAX+1.);
  v=-log(1.-v);
  w=sqrt(2*v)*sin(u);
  return(w);
}

/* uniform r.v. in [a,b] */
#ifndef __STDC__
double MFAM_uniform(a, b)
     double a;
     double b;
#else /* __STDC__ */
double MFAM_uniform(double a,double b)
#endif /* __STDC__ */
{
  return (a+b)*.5+(rand()/(RAND_MAX+1.)-.5)*(b-a);
}

/* Rayleigh r.v.*/
#ifndef __STDC__
double MFAM_Rayleigh(c)
     double c; 
#else /* __STDC__ */
double MFAM_Rayleigh(double c) 
#endif /* __STDC__ */
{
  return sqrt((double)(-2.*c*c)*log((double)(1.-rand()/(RAND_MAX+1.))));
}

/* normal r.v. with mean 0. and variance sigma_2 */
#ifndef __STDC__
double MFAM_normal(m, sigma_2)
     double m;
     double sigma_2; 
#else /* __STDC__ */
double MFAM_normal(double m,double sigma_2) 
#endif /* __STDC__ */
{    
  return m+sigma_2*normal_1();
}

/* lognormal r.v with mean m and variance sigma_2 */
#ifndef __STDC__
double MFAM_lognormal(m, sigma_2)
     double m;
     double sigma_2;
#else /* __STDC__ */
double MFAM_lognormal(double m,double sigma_2)
#endif /* __STDC__ */
{ 
  return exp((double)MFAM_normal(m,sigma_2));
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_shuffle(data_nb, data)
     int data_nb;
     double *data;
#else /* __STDC__ */
int MFAM_shuffle(int data_nb,double *data)
#endif /* __STDC__ */
{
  if((data_nb>0)&&(data!=NULL))
  {
    int k=data_nb-1,tmp_k=0;
    register int l=0;
    double tmp_data=0.;  
    time_t time_seed=time(NULL);
    srand((unsigned int)time_seed);
    while(k>=0)
    {
      tmp_k=MFAM_uniform_integer(k+1);
      tmp_data=*(data+tmp_k);  
      for(l=tmp_k;l<k;l++)
	*(data+l)=*(data+l+1);
      *(data+k)=tmp_data;
      k--;  
    } 
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAM_shuffle arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_uniform_integer(N)
     int N;
#else /* __STDC__ */
int MFAM_uniform_integer(int N)
#endif /* __STDC__ */
{
  return (int)(N*(double)rand()/((double)RAND_MAX));
}



