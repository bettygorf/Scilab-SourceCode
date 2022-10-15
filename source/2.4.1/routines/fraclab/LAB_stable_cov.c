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

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "C-LAB_Interf.h"
#include "McCulloch.h"
#include "Koutrouvelis.h"
#include "stable_sm.h"
#include "stable_cov.h"

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

void LAB_stable_cov()
{
  /* Input */ 
  
  Matrix *Mdata1, *Mdata2;
  double *data1, *data2; 
 
  /* Output */

  Matrix  *MCOV;
  double *COV;

  /* Work */
  int i, j, l,k, kopt,n2,lin, col,n,q1, q2, q3, q4, q5;
  double *rho,*rhoo,*valpha, **X1,*datao1,*datao2, mindiff,alpha,q95, q75, q50, 
  q25, q05, q95bis, q75bis, q50bis, alpha1,alpha2, seuil, som=0.0,t,t1, 
  q25bis, q05bis,nalpha,nbeta,absnbeta,nalphabis,nbetabis,absnbetabis;

#ifdef __STDC__
#define DDDouble double 
#else 
#define DDDouble static double 
#endif 

  DDDouble nualpha[15] = {2.439, 2.5, 2.6, 2.7, 2.8, 3.0, 3.2, 3.5, 4.0, 
			  5.0, 6.0, 8.0, 10.0, 15.0, 25.0}; 

  DDDouble nubeta[7] = {0.0, 0.1, 0.2, 0.3, 0.5, 0.7, 1.0};

  DDDouble psi1[15][7] = {2.0,   2.0,   2.0,   2.0,   2.0,   2.0,   2.0,
			  1.916, 1.924, 1.924, 1.924, 1.924, 1.924, 1.924,
			  1.808, 1.813, 1.829, 1.829, 1.829, 1.829, 1.829,
			  1.729, 1.730, 1.737, 1.745, 1.745, 1.745, 1.745,
			  1.664, 1.663, 1.663, 1.668, 1.676, 1.676, 1.676,
			  1.563, 1.560, 1.553, 1.548, 1.547, 1.547, 1.547,
			  1.484, 1.480, 1.471, 1.460, 1.448, 1.438, 1.438,
			  1.391, 1.386, 1.378, 1.364, 1.337, 1.318, 1.318,
			  1.279, 1.273, 1.266, 1.250, 1.210, 1.184, 1.150,
			  1.128, 1.121, 1.114, 1.101, 1.067, 1.027, 0.973,
			  1.029, 1.021, 1.014, 1.004, 0.974, 0.935, 0.874,
			  0.896, 0.892, 0.887, 0.883, 0.855, 0.823, 0.769,
			  0.818, 0.812, 0.806, 0.801, 0.780, 0.756, 0.691,
			  0.698, 0.695, 0.692, 0.689, 0.676, 0.656, 0.595,
			  0.593, 0.590, 0.588, 0.586, 0.579, 0.563, 0.513};

  /********************************************************************/

  Mdata1 = (Matrix *)(Interf.Param[0]);
  Mdata2 = (Matrix *)(Interf.Param[1]);
   
  /* get and verify the input parameters */

  data1 = MatrixGetPr(Mdata1);
  data2 = MatrixGetPr(Mdata2);
   

  if (Interf.NbParamIn != 2)
    {
      InterfError("stable_sm : you must give 2 input parameters\n");
      return;
    }
  lin = MatrixGetHeight(Mdata1) ;
  col = MatrixGetWidth(Mdata1) ;


  if( (lin != 1) && (col != 1)) {
    InterfError("stable_cov  : The dimension of the first input must be  n*1 or 1*n") ;
    return;
  }

  n = MAX(lin,col) ;

  n2= n/2;

  MCOV = MatrixCreate(1,1,"real");
  COV = MatrixGetPr(MCOV);

  
  /*************************Allocation de memoire*****************************/	       X1 = (double **) calloc (15, sizeof(double *));
  for (k=0; k<15; k++)
    X1[k] = (double *) calloc (7, sizeof(double));
	
  rho = (double *) malloc (sizeof (double) * n);
  rhoo = (double *) malloc (sizeof (double) * n);
  valpha = (double *) malloc (sizeof (double) * (n2-3));

  datao1 = (double *) malloc (sizeof (double) * n);
  datao2 = (double *) malloc (sizeof (double) * n);
  /****************************************************************/
	
  for(j=0;j<15;j++) {
    for(k=0;k<7;k++) {
      X1[j][k]=psi1[j][k];
    }
  }

  for(j=0;j<n;j++){
    datao1[j]=data1[j];
    datao2[j]=data2[j];
  }
  stable_sort(n,datao1);
  stable_sort(n,datao2);
	

  q1=ROUND(n*0.95);
  q2=ROUND(n*0.75);
  q3=ROUND(n*0.50);
  q4=ROUND(n*0.25);
  q5=ROUND(n*0.05);

  q95=datao1[q1];
  q75=datao1[q2];
  q50=datao1[q3];
  q25=datao1[q4];
  q05=datao1[q5];

  nalpha = (q95-q05)/(q75-q25);

  nbeta  = (q95+q05-2.0*q50)/(q95-q05);

  if(nalpha < 2.439)  nalpha = 2.439;
  if(nalpha > 25.0)  nalpha = 25.0;
	

  q95bis=datao2[q1];
  q75bis=datao2[q2];
  q50bis=datao2[q3];
  q25bis=datao2[q4];
  q05bis=datao2[q5];

  nalphabis = (q95bis-q05bis)/(q75bis-q25bis);

  nbetabis  = (q95bis+q05bis-2.0*q50bis)/(q95bis-q05bis);

  if(nalphabis < 2.439)  nalphabis = 2.439;
  if(nalphabis > 25.0)  nalphabis = 25.0;
	

  /********************************************************************/
  /*Estimation of the stability index alpha*/
  /********************************************************************/

  if(nbeta > 1.0)  nbeta = 1.0;
  if(nbeta < -1.0)  nbeta = -1.0;
  absnbeta=fabs(nbeta);
	
  stable_bilint(nualpha, nubeta, X1, 15, 7, nalpha, absnbeta, &alpha1) ;	
  if(nbetabis > 1.0)  nbetabis = 1.0;
  if(nbetabis < -1.0)  nbetabis = -1.0;
  absnbetabis=fabs(nbetabis);

  stable_bilint(nualpha, nubeta, X1, 15, 7, nalphabis, absnbetabis, &alpha2) ;
	
  seuil=0.1;
  if(fabs(alpha2-alpha1)<=seuil) 
    alpha=(alpha1+alpha2)/2.0;
  else
    {InterfError(" stable_sm : The data vectors have not the same characteristic exponent") ;
     return;
   }
	
  /*************************On calcule le vecteur du module*******************/

	
  for(i=0;i<n;i++) {
    rho[i] = stable_modu(data1,data2,i);
    rhoo[i]=rho[i];
  }
  stable_sort(n,rhoo);

	
  /***********************finding optimal k *********************************/
  for(k=0;k< (n2-3);k++) {
    valpha[k]=stable_alpha(rhoo, k+3, n);
		
  }
  stable_root(valpha, n2-3, alpha, &mindiff, &kopt);
	
  kopt=kopt+3;
	
	
  *COV = stable_cov(data1,data2,n,rhoo,kopt,alpha);

  free(rho);free(rhoo);free(valpha);free(X1); free(datao1);free(datao2);
  ReturnParam(MCOV);
	
}

/***************************************************************************/



