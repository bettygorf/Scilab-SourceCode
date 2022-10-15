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

/* Koutrouvelis : estimates parameters (alpha,beta,mu,gamma)
   of a stable law using the Koutrouvelis method*/
/* Lotfi Belkacem 1997 */
#include "C-LAB_Interf.h"
#include <math.h>
#include <stdio.h>
#include "McCulloch.h"
#include "Koutrouvelis.h"
#ifndef MAX
#define MAX(a,b) (max1=(a),max2=(b),(max1) > (max2) ? (max1) : (max2))
#endif
#ifndef sign
#define sign(z) (z<0 ? (-1.0) : (1.0))
#endif
#ifndef M_PI
#define M_PI 3.1415927
#endif
#ifndef ROUND
#define ROUND(x) ((((x)-floor((double)(x)))<0.5)?floor((double)(x)):(ceil((double)(x))))
#endif                   

void LAB_Koutrouvelis()
{
  /* Input */ 
  
  Matrix *Mdata;
  double *data1;
  double *data; 

  /* Output */

  Matrix *Malpha, *Mbeta, *Mmu, *Mgamma;
  double *alpha, *beta, *mu, *gamma;

  /* Work */

#ifdef __STDC__
#define DDDouble double 
#else 
#define DDDouble static double 
#endif 

  DDDouble alphaK[8]  = {0.30, 0.50, 0.70, 0.9, 1.10, 1.30, 1.50, 1.90};
  DDDouble alphaL[7]  = {0.30, 0.50, 0.70, 0.9, 1.10, 1.50, 1.90};
  DDDouble    nv[3]      = {200, 800, 1600};
  DDDouble Kopt[8][3] = {134, 124.0, 118,
			   86, 38, 56,
			   30, 24, 20,
			   28, 22, 18,
			   24, 18, 15,
			   22, 16, 14,
			   11, 11, 11,
			   9, 9, 10};
  DDDouble Lopt[7][3] = {70, 68, 66,
			   40, 38, 36,
			   24, 16, 16,
			   14, 14, 14,
			   16, 18, 17,
			   12, 14, 15,
			   9, 10, 11};

  int        i, j, k,q1,q2, K, L,l, lin, col,n;
  double     q72, q28, s,mu0,gamma0,tk,a,b,
  siga, sigb, alpha0, K1,alpha0i, ni, alpha1,L1,
  alpha1i, ul,  gamma1;
  double     *y, *w, z, u, v,r, mubar; 
  double        **X1, **X2, **covar;
  double     su2=0.0, sv2=0.0, suv=0.0, suz=0.0, svz=0.0, det, inv11,
  inv12,inv22;

	
  
  Mdata = (Matrix *)(Interf.Param[0]);

  data1 = MatrixGetPr(Mdata);

  if (Interf.NbParamIn != 1)
    {
      InterfError("Koutrouvelis : you must give 1 input parameters\n");
      return;
    }
  lin = MatrixGetHeight(Mdata) ;
  col = MatrixGetWidth(Mdata) ;


  if( (lin != 1) && (col != 1)) {
    InterfError(" Koutrouvelis : The dimension of the first input must be  n*1 or 1*n") ;
    return;
  }

  n = MAX(lin,col) ;

  data = (double *)malloc(n*sizeof(double));
  for (i=0; i<n; i++) data[i]=data1[i];

  Malpha = MatrixCreate(1,1,"real");
  alpha = MatrixGetPr(Malpha); 

  Mbeta = MatrixCreate(1,1,"real");
  beta = MatrixGetPr(Mbeta); 

  Mmu = MatrixCreate(1,1,"real");
  mu = MatrixGetPr(Mmu); 

  Mgamma = MatrixCreate(1,1,"real");
  gamma = MatrixGetPr(Mgamma); 

  
  K=11;
  /********************************************************************/
  /*Allocation de memoire*/
  /********************************************************************/

  y = (double *) malloc (sizeof (double) * K);
  w = (double *) malloc (sizeof (double) * K);
  X1 = (double **) calloc (8, sizeof(double *));
  for (k=0; k<8; k++)
    X1[k] = (double *) calloc (3, sizeof(double));

  X2 = (double **) calloc (7, sizeof(double *));
  for (k=0; k<7; k++)
    X2[k] = (double *) calloc (3, sizeof(double));

  covar = (double **) calloc (2, sizeof(double *));
  for (k=0; k<2; k++)
    covar[k] = (double *) calloc (2, sizeof(double));
  /********************************************************************/
  for(j=0;j<8;j++) {
    for(k=0;k<3;k++) {
      X1[j][k]=Kopt[j][k];
    }
  }

  for(j=0;j<7;j++) {
    for(k=0;k<3;k++) {
      X2[j][k]=Lopt[j][k];
    }
  }
        
  mubar=stable_E(data,n);
  stable_sort(n,data);

  q1=ROUND(n*0.28);
  q2=ROUND(n*0.72);

  q72=data[q2];
  q28=data[q1];
  /************************first step****************************/
  s=0.0;
  for(i=q1;i<=q2;i++)
    s += data[i];
  mu0=s/((q2-q1)+1);
  gamma0=(q72-q28)/1.654;
	
  for(i=0;i<n;i++)
    data[i]=(data[i]-mu0)/gamma0;
	
  for(k=0;k<K;k++){
    tk=(double)(k+1)*M_PI/25.0;
    y[k]=log(-log(stable_Cabs(stable_phiemp(tk,data,n))
		  *stable_Cabs(stable_phiemp(tk,data,n))));
    w[k]=log(fabs(tk));
  }
  stable_reg(w, y, K, 0,&a, &alpha0, &siga, &sigb);
  alpha0i=alpha0;
  if(alpha0>1.9) alpha0i=1.9;
  if(alpha0<0.3) alpha0i=0.3;
  ni= (double) n;
  if(n>1600) ni=1600.0;
  if(n<200) ni=200.0;
		 
  stable_bilint(alphaK, nv, X1, 8, 3, alpha0i, ni, &K1);


  K= ROUND(K1);

  y = (double *) realloc (y,sizeof (double) * K);
  w = (double *) realloc (w,sizeof (double) * K);

  for(k=0;k< K;k++){
    tk=(double)(k+1)*M_PI/25.0;
    y[k]=log(-log(stable_Cabs(stable_phiemp(tk,data,n))
		  *stable_Cabs(stable_phiemp(tk,data,n))));
    w[k]=log(fabs(tk));
  }
  stable_reg(w, y, K, 0, &a, &alpha1, &siga, &sigb);
  *alpha=alpha1;
  gamma1=pow((exp(a)/2.0),(1.0/(*alpha)));
  *gamma= gamma0*gamma1;
	
  for(i=0;i<n;i++)
    data[i]=(data[i])/gamma1;
	
  alpha1i= *alpha;
  if((*alpha)>1.9) alpha1i=1.9;
  if((*alpha)<0.3) alpha1i=0.3;
  ni= (double) n;
  if(n>1600) ni=1600.0;
  if(n<200) ni=200.0;

  stable_bilint(alphaL, nv, X2, 7, 3, alpha1i, ni, &L1);


  L= ROUND(L1);

  for(l=1;l<= L;l++){
    ul=(double)l*M_PI/50.0;
    z=atan(stable_phiemp(ul,data,n).i / stable_phiemp(ul,data,n).r);
    u=(double)l*M_PI/50.0;
    v=pow(fabs(u), alpha1i)*sign(u);
    su2 += u*u;
    sv2 += v*v;
    suv += v*u;
    suz += u*z;
    svz += v*z;
  }
  det=(su2*sv2)-(suv*suv);
  if (det){
    inv11=sv2/det;
    inv22=su2/det;
    inv12=-suv/det;
  }
  *mu = inv11*suz+inv12*svz;
  *beta = inv12*suz+inv22*svz;
  if((*beta) > 1.0) *beta = 1.0;
  if((*beta) < -1.0) *beta = -1.0;
  if((*alpha) > 1.0) *mu = mubar;
	
  free(data);
  free(y);free(w);free(X1); free(X2); free(covar);
  ReturnParam(Malpha);
  ReturnParam(Mbeta);
  ReturnParam(Mmu);
  ReturnParam(Mgamma);
}
