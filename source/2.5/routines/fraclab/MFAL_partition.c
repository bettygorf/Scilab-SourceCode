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

#include "MFAL_partition.h"

/*****************************************************************************/

#ifndef __STDC__
int MFAL_mdZSq1d(N_n, mu_n, J, S, Q, q, Z_S_q)
     int N_n;
     double *mu_n;
     short int J;
     double *S;
     short int Q;
     double *q;
     double *Z_S_q;
#else /* __STDC__ */
#ifndef __STDC__
int MFAL_mdZSq1d(N_n, mu_n, J, S, Q, q, Z_S_q)
     int N_n;
     double *mu_n;
     short int J;
     double *S;
     short int Q;
     double *q;
     double *Z_S_q;
#else /* __STDC__ */
int MFAL_mdZSq1d(int N_n,double* mu_n,short J,double* S,short Q,double* q,double* Z_S_q)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((N_n>0)&&(mu_n!=NULL)&&(J>0)&&(S!=NULL)&&(Q>0)&&(q!=NULL)&&(Z_S_q!=NULL))
  {
    register int j=0,k=0,l=0;
    double mu_S1d=0.;
    for(j=0;j<J;j++)
    {
      for(k=0;k<Q;k++)
      {
	*(Z_S_q+Q*j+k)=0.;
	for(l=0;l<N_n;l+=(int)*(S+j))
	{
	  mu_S1d=MFAM_mu_S1d(mu_n+l,(int)*(S+j));
	  *(Z_S_q+Q*j+k)+=(mu_S1d!=0.?pow(mu_S1d,*(q+k)):0);
	}
      }
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAL_mdZSq1d arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAL_mdZPq1d(N_n, mu_n, J, P, Q, q, Z_P_q)
     int N_n;
     double *mu_n;
     short int J;
     double *P;
     short int Q;
     double *q;
     double *Z_P_q;
#else /* __STDC__ */
#ifndef __STDC__
int MFAL_mdZPq1d(N_n, mu_n, J, P, Q, q, Z_P_q)
     int N_n;
     double *mu_n;
     short int J;
     double *P;
     short int Q;
     double *q;
     double *Z_P_q;
#else /* __STDC__ */
int MFAL_mdZPq1d(int N_n,double* mu_n,short J,double* P,short Q,double* q,double* Z_P_q)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((N_n>0)&&(mu_n!=NULL)&&(J>0)&&(P!=NULL)&&(Q>0)&&(q!=NULL)&&(Z_P_q!=NULL))
  {
    register int k=0,j=0,l=0;  
    double mu_P1d=0.;
    for(j=0;j<J;j++)
    {
      for(k=0;k<Q;k++)
      {
	*(Z_P_q+Q*j+k)=0.;
	for(l=0;l<(int)*(P+j);l++)
	{
	  FRflg=(l==0);
	  mu_P1d=MFAM_mu_P1d(N_n,mu_n,(int)*(P+j));
	  *(Z_P_q+Q*j+k)+=(mu_P1d!=0.?pow(mu_P1d,*(q+k)):0);
	}
      }
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAL_mdZPq1d arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAL_mdZq1d(N_n, mu_n, t_part, J, S_min, S_max, P_min, P_max, a, Q, q, Z_q)
     int N_n;
     double *mu_n;
     MFAMt_part t_part;
     short int J;
     double S_min;
     double S_max;
     double P_min;
     double P_max;
     double *a;
     short int Q;
     double *q;
     double *Z_q;
#else /* __STDC__ */
#ifndef __STDC__
int MFAL_mdZq1d(N_n, mu_n, t_part, J, S_min, S_max, P_min, P_max, a, Q, q, Z_q)
     int N_n;
     double *mu_n;
     MFAMt_part t_part;
     short int J;
     double S_min;
     double S_max;
     double P_min;
     double P_max;
     double *a;
     short int Q;
     double *q;
     double *Z_q;
#else /* __STDC__ */
int MFAL_mdZq1d(int N_n,double* mu_n,MFAMt_part t_part,short J,double S_min,double S_max,double P_min,double P_max,double* a,short Q,double* q,double* Z_q)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((N_n>0)&&(mu_n!=NULL)&&(J>0)&&(a!=NULL)&&(S_min>=1.)&&(S_min<=S_max)&&(S_max<=N_n/2.)&&(P_min>=1.)&&(P_min<=P_max)&&(P_max<=N_n/2.)&&(Q>0)&&(q!=NULL)&&(Z_q!=NULL))
  {
    register int j=0;
    if(t_part==MFAM_DECSIZE)
    {
      double* S=a;
      if(MFAM_decsizespace(N_n,J,S_min,S_max,S)==0) 
      { 
	fprintf(stderr,"MFAM_decsizespace error\n");  
	return 0; 
      }
      if(MFAL_mdZSq1d(N_n,mu_n,J,S,Q,q,Z_q)==0)
      {
	fprintf(stderr,"MFAL_mdZSq1d error\n");
	return 0;
      } 
      for(j=0;j<J;j++)
	*(a+j)=(*(S+j)/S_min);
      S=NULL;
    }
    else
    {  
      double* P=a;
      if(MFAM_partspace(N_n,t_part,J,P_min,P_max,P)==0) 
      { 
	fprintf(stderr,"MFAM_partspace error\n");  
	return 0; 
      }  
      if(MFAL_mdZPq1d(N_n,mu_n,J,P,Q,q,Z_q)==0)
      {
	fprintf(stderr,"MFAL_mdZPq1d error\n");
	return 0;
      }
      for(j=0;j<J;j++)
	*(a+j)=(P_max/(*(P+j)));
      P=NULL;
    }
  return 1;
  }
  else
  {
    fprintf(stderr,"MFAL_mdZq1d arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAL_mdZSq2d(Nx_n, Ny_n, mu_n, J, S, Q, q, Z_S_q)
     int Nx_n;
     int Ny_n;
     double *mu_n;
     int J;
     double *S;
     int Q;
     double *q;
     double *Z_S_q;
#else /* __STDC__ */
#ifndef __STDC__
int MFAL_mdZSq2d(Nx_n, Ny_n, mu_n, J, S, Q, q, Z_S_q)
     int Nx_n;
     int Ny_n;
     double *mu_n;
     int J;
     double *S;
     int Q;
     double *q;
     double *Z_S_q;
#else /* __STDC__ */
int MFAL_mdZSq2d(int Nx_n,int Ny_n,double* mu_n,int J,double* S,int Q,double* q,double* Z_S_q)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((Nx_n>0)&&(Ny_n>0)&&(mu_n!=NULL)&&(J>0)&&(S!=NULL)&&(Q>0)&&(q!=NULL)&&(Z_S_q!=NULL))
  {
    register int j=0,k=0,lx=0,ly=0;
    double mu_S2d=0;
    for(j=0;j<J;j++)
    {
      for(k=0;k<Q;k++)
      {
	*(Z_S_q+Q*j+k)=0.;
	for(ly=0;ly<Ny_n;ly+=(int)*(S+j))
	  for(lx=0;lx<Nx_n;lx+=(int)*(S+j))
	  {
	    mu_S2d=MFAM_mu_S2d(mu_n+ly*Nx_n+lx,(int)*(S+j),(int)*(S+j),Nx_n);
	    *(Z_S_q+Q*j+k)+=(mu_S2d!=0.?pow(mu_S2d,*(q+k)):0);
	  }
      }
    }
    return 1;
  }
  else
  {
    fprintf(stderr,"MFAL_mdZSq2d arguments error\n");
    return 0;
  }
}

/*****************************************************************************/

#ifndef __STDC__
int MFAL_mdZq2d(Nx_n, Ny_n, mu_n, t_part, J, S_min, S_max, P_min, P_max, a, Q, q, Z_q)
     int Nx_n;
     int Ny_n;
     double *mu_n;
     MFAMt_part t_part;
     short int J;
     double S_min;
     double S_max;
     double P_min;
     double P_max;
     double *a;
     short int Q;
     double *q;
     double *Z_q;
#else /* __STDC__ */
#ifndef __STDC__
int MFAL_mdZq2d(Nx_n, Ny_n, mu_n, t_part, J, S_min, S_max, P_min, P_max, a, Q, q, Z_q)
     int Nx_n;
     int Ny_n;
     double *mu_n;
     MFAMt_part t_part;
     short int J;
     double S_min;
     double S_max;
     double P_min;
     double P_max;
     double *a;
     short int Q;
     double *q;
     double *Z_q;
#else /* __STDC__ */
int MFAL_mdZq2d(int Nx_n,int Ny_n,double* mu_n,MFAMt_part t_part,short J,double S_min,double S_max,double P_min,double P_max,double* a,short Q,double* q,double* Z_q)
#endif /* __STDC__ */
#endif /* __STDC__ */
{
  if((Nx_n>0)&&(Ny_n>0)&&(mu_n!=NULL)&&(J>0)&&(S_min>=1.)&&(S_min<=S_max)&&(S_max<=Nx_n/2.)&&(P_min>=1.)&&(P_min<=P_max)&&(P_max<=Nx_n/2.)&&(a!=NULL)&&(Q>0)&&(q!=NULL)&&(Z_q!=NULL))
  {
    register int j=0;
    if(t_part==MFAM_DECSIZE)
    {
      double* S=a;
      if(MFAM_decsizespace(Nx_n,J,S_min,S_max,S)==0) 
      { 
	fprintf(stderr,"MFAM_decsizespace error\n");  
	return 0; 
      }
      if(MFAL_mdZSq2d(Nx_n,Ny_n,mu_n,J,S,Q,q,Z_q)==0)
      {
	fprintf(stderr,"MFAL_mdZSq2d error\n");
	return 0;
      } 
      for(j=0;j<J;j++)
	*(a+j)=(*(S+j)/S_min);
      S=NULL;
    }
    else
    {  
      double* P=a;
      if(MFAM_partspace(Nx_n,t_part,J,P_min,P_max,P)==0) 
      { 
	fprintf(stderr,"MFAM_partspace error\n");  
	return 0; 
      }  
     /*  if(MFAL_mdZPq1d(Nx_n,Ny_n,mu_n,J,P,Q,q,Z_q)==0) */
/*       { */
/* 	fprintf(stderr,"MFAL_mdZPq1d error\n"); */
/* 	return 0; */
/*       } */
      for(j=0;j<J;j++)
	*(a+j)=(P_max/(*(P+j)));
      P=NULL;
    }
  return 1;
  }
  else
  {
    fprintf(stderr,"MFAL_mdZq2d arguments error\n");
    return 0;
  }
}
