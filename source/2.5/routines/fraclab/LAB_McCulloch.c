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

/* McCulloch : estimates parameters (alpha,beta,mu,gamma)
of a stable law using the McCulloch method*/
/* Lotfi Belkacem 1997 */
#include "C-LAB_Interf.h"
#include <math.h>
#include <stdio.h>
#include "McCulloch.h"
#define ROUND(x) ((((x)-floor((double)(x)))<0.5)?floor((double)(x)):(ceil((double)(x))))
#ifndef MAX
#define MAX(a,b) (max1=(a),max2=(b),(max1) > (max2) ? (max1) : (max2))
#endif
#ifndef M_PI
#define M_PI  3.1415926535
#endif

void LAB_McCulloch()
{
   /* Input */ 
  
 Matrix *Mdata;
 double *data1;
 double *data; 

   /* Output */

 Matrix *Mparameters;
 double *parameters;

 Matrix *Msd_parameters;
 double *sd_parameters;
 
  /* Work */

#ifdef __STDC__
#define DDDouble double 
#else 
#define DDDouble static double 
#endif 

DDDouble nualpha[15] = {2.439, 2.5, 2.6, 2.7, 2.8, 3.0, 3.2, 3.5, 4.0, 
	       5.0, 6.0, 8.0, 10.0, 15.0, 25.0}; 

DDDouble nubeta[7] = {0.0, 0.1, 0.2, 0.3, 0.5, 0.7, 1.0};

DDDouble alphav[16] = {0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 
		     1.5, 1.6, 1.7, 1.8, 1.9, 2.0};

DDDouble betav[5] = {0.0, 0.25, 0.50, 0.75, 1.00};

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

DDDouble psi2[15][7] = {0.0, 2.160, 1.0, 1.0, 1.0, 1.0, 1.0,
	       0.0, 1.592, 3.390, 1.0, 1.0, 1.0, 1.0,
	       0.0, 0.759, 1.800, 1.0, 1.0, 1.0, 1.0,
	       0.0, 0.482, 1.048, 1.694, 1.0, 1.0, 1.0,
	       0.0, 0.360, 0.760, 1.232, 2.229, 1.0, 1.0,
	       0.0, 0.253, 0.518, 0.823, 1.575, 1.0, 1.0,
	       0.0, 0.203, 0.410, 0.632, 1.244, 1.906, 1.0,
	       0.0, 0.165, 0.332, 0.499, 0.943, 1.560, 1.0,
	       0.0, 0.136, 0.271, 0.404, 0.689, 1.230, 2.195,
	       0.0, 0.109, 0.216, 0.323, 0.539, 0.827, 1.917,
	       0.0, 0.096, 0.190, 0.284, 0.472, 0.693, 1.759,
	       0.0, 0.082, 0.163, 0.243, 0.412, 0.601, 1.596,
	       0.0, 0.074, 0.147, 0.220, 0.377, 0.546, 1.482,
	       0.0, 0.064, 0.128, 0.191, 0.330, 0.478, 1.362,
	       0.0, 0.056, 0.112, 0.167, 0.285, 0.428, 1.274};


DDDouble phi3[16][5]= {2.588, 3.073, 4.534, 6.636, 9.144,
		     2.337, 2.635, 3.542, 4.808, 6.247,
		     2.189, 2.392, 3.004, 3.844, 4.775,
		     2.098, 2.244, 2.676, 3.265, 3.912,
		     2.040, 2.149, 2.461, 2.886, 3.356,
		     2.000, 2.085, 2.311, 2.624, 2.973,
		     1.980, 2.040, 2.205, 2.435, 2.696,
		     1.965, 2.007, 2.125, 2.294, 2.491,
		     1.955, 1.984, 2.067, 2.188, 2.333,
		     1.946, 1.967, 2.022, 2.106, 2.211,
		     1.939, 1.952, 1.988, 2.045, 2.116,
		     1.933, 1.940, 1.962, 1.997, 2.043,
		     1.927, 1.930, 1.943, 1.961, 1.987,
		     1.921, 1.922, 1.927, 1.936, 1.947,
		     1.914, 1.915, 1.916, 1.918, 1.921,
		     1.908, 1.908, 1.908, 1.908, 1.908};


DDDouble phi5[16][5]= {0.0, -0.061, -0.279, -0.659, -1.198,
		     0.0, -0.078, -0.272, -0.581, -0.997,
		     0.0, -0.089, -0.262, -0.520, -0.853,
		     0.0, -0.096, -0.250, -0.469, -0.742,
		     0.0, -0.099, -0.237, -0.424, -0.652,
		     0.0, -0.098, -0.223, -0.383, -0.576,
		     0.0, -0.095, -0.208, -0.346, -0.508,
		     0.0, -0.090, -0.192, -0.310, -0.447,
		     0.0, -0.084, -0.173, -0.276, -0.390,
		     0.0, -0.075, -0.154, -0.241, -0.335,
		     0.0, -0.066, -0.134, -0.206, -0.283,
		     0.0, -0.056, -0.111, -0.170, -0.232,
		     0.0, -0.043, -0.088, -0.132, -0.179,
		     0.0, -0.030, -0.061, -0.092, -0.123,
		     0.0, -0.017, -0.032, -0.049, -0.064,
		     0.0, 0.0, 0.0, 0.0,  0.0};
/********************************************************************/
/********************************************************************/

DDDouble alphavv[7] = {0.50, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0};

DDDouble stdalpha[7][5]={1.32, 1.54, 1.73, 1.70, 1.75,
		       1.13, 1.41, 1.53, 1.77, 1.65,
		       1.42, 1.56, 1.87, 2.16, 2.16,
		       1.65, 1.79, 2.03, 2.42, 2.55,
		       1.97, 2.07, 2.33, 2.64, 2.85,
		       2.81, 2.85, 2.93, 3.05, 3.17,
		       4.02, 4.02, 4.02, 4.02, 4.02};

DDDouble stdbeta[7][5]={3.38, 3.21, 2.57, 3.55, 1.94,
		      3.02, 2.65, 1.91, 2.28, 2.16,
		      2.93, 2.62, 2.09, 2.12, 2.70,
		      3.05, 2.77, 2.37, 3.30, 3.91,
		      3.46, 3.15, 3.23, 4.95, 6.31,
		      6.22, 6.92, 8.75, 11.59, 14.42,
		      999999, 999999, 999999, 999999, 999999};

DDDouble stdgamma[7][5]={3.36, 6.30, 6.46, 4.95, 4.89,
		       2.15, 3.29, 3.36, 2.63, 2.95,
		       1.65, 1.86, 2.37, 3.18, 2.08,
		       1.38, 1.48, 1.55, 1.44, 1.56,
		       1.28, 1.31, 1.38, 1.27, 1.36,
		       1.25, 1.24, 1.23, 1.22, 1.30,
		       1.26, 1.26, 1.26, 1.26, 1.26};

DDDouble stdmu[7][5]={4.03, 3.85, 6.41, 12.60, 17.32,
		    8.28, 6.39, 11.77, 23.09, 29.33,
		    1.70, 1.74, 1.87, 2.35, 2.87,
		    6.71, 8.09, 11.01, 14.75, 18.71,
		    3.06, 3.03, 3.81, 3.84, 4.36,
		    2.09, 2.09, 2.13, 2.20, 2.28,
		    1.77, 1.77, 1.77, 1.77, 1.77};
/*********************************************************************/

int        i, j, k, q1, q2, q3, q4, q5,lin, col,n;
double     q95, q75, q50, q25, q05, nalpha, nbeta, ngamma, nmu, absnbeta, 
	   absbeta, zeta;
double     **X1, **X2, **X3, **X5, **Y1, **Y2, **Y3, **Y4;
double     alpha, beta, mu, gamma, sd_alpha, sd_beta, sd_mu, sd_gamma; 

        Mdata = (Matrix *)(Interf.Param[0]);

        data1 = MatrixGetPr(Mdata);

	if (Interf.NbParamIn != 1)
	  {
      InterfError("McCulloch : you must give 1 input parameters\n");
      return;
    }
	lin = MatrixGetHeight(Mdata) ;
        col = MatrixGetWidth(Mdata) ;


        if( (lin != 1) && (col != 1)) {
          InterfError(" McCulloch : The dimension of the first input must be  n*1 or 1*n") ;
          return;
        }

	n = MAX(lin,col) ;
	data = (double *)malloc(n*sizeof(double));
	for (i=0; i<n; i++) data[i]=data1[i];
  
  Mparameters = MatrixCreate(4,1,"real");
  parameters = MatrixGetPr(Mparameters); 

  Msd_parameters = MatrixCreate(4,1,"real");
  sd_parameters = MatrixGetPr(Msd_parameters); 

   
/********************************************************************/
	            /*Allocation de memoire*/
/********************************************************************/


        X1 = (double **) calloc (15, sizeof(double *));
        for (k=0; k<15; k++)
                X1[k] = (double *) calloc (7, sizeof(double));

	X2 = (double **) calloc (15, sizeof(double *));
        for (k=0; k<15; k++)
                X2[k] = (double *) calloc (7, sizeof(double));

	X3 = (double **) calloc (16, sizeof(double *));
        for (k=0; k<16; k++)
                X3[k] = (double *) calloc (5, sizeof(double));

	X5 = (double **) calloc (16, sizeof(double *));
        for (k=0; k<16; k++)
                X5[k] = (double *) calloc (5, sizeof(double));
	
	Y1 = (double **) calloc (7, sizeof(double *));
        for (k=0; k<7; k++)
                Y1[k] = (double *) calloc (5, sizeof(double));

	Y2 = (double **) calloc (7, sizeof(double *));
        for (k=0; k<7; k++)
                Y2[k] = (double *) calloc (5, sizeof(double));

	Y3 = (double **) calloc (7, sizeof(double *));
        for (k=0; k<7; k++)
                Y3[k] = (double *) calloc (5, sizeof(double));

	Y4 = (double **) calloc (7, sizeof(double *));
        for (k=0; k<7; k++)
                Y4[k] = (double *) calloc (5, sizeof(double));

/********************************************************************/

	for(j=0;j<15;j++) {
	  for(k=0;k<7;k++) {
	    X1[j][k]=psi1[j][k];
	  }
	}

	for(j=0;j<15;j++) {
	  for(k=0;k<7;k++) {
	    X2[j][k]=psi2[j][k];
	  }
	}

	for(j=0;j<16;j++) {
	  for(k=0;k<5;k++) {
	    X3[j][k]=phi3[j][k];
	  }
	}
	
	for(j=0;j<16;j++) {
	  for(k=0;k<5;k++) {
	    X5[j][k]=phi5[j][k];
	  }
	}

	for(j=0;j<7;j++) {
	  for(k=0;k<5;k++) {
	    Y1[j][k]=stdalpha[j][k];
	  }
	}
	
	for(j=0;j<7;j++) {
	  for(k=0;k<5;k++) {
	    Y2[j][k]=stdbeta[j][k];
	  }
	}

	for(j=0;j<7;j++) {
	  for(k=0;k<5;k++) {
	    Y3[j][k]=stdgamma[j][k];
	  }
	}

	for(j=0;j<7;j++) {
	  for(k=0;k<5;k++) {
	    Y4[j][k]=stdmu[j][k];
	  }
	}

/********************************************************************/

	stable_sort(n,data);
	

	q1=ROUND(n*0.95);
	q2=ROUND(n*0.75);
	q3=ROUND(n*0.50);
	q4=ROUND(n*0.25);
	q5=ROUND(n*0.05);

	q95=data[q1];
	q75=data[q2];
	q50=data[q3];
	q25=data[q4];
	q05=data[q5];

	nalpha = (q95-q05)/(q75-q25);

	nbeta  = (q95+q05-2*q50)/(q95-q05);

	ngamma = 0.00;
	
	if(nalpha < 2.439)  nalpha = 2.439;
	if(nalpha > 25.0)  nalpha = 25.0;
	


/********************************************************************/
	/*Estimation of the stability index alpha*/
/********************************************************************/

	if(nbeta > 1.0)  nbeta = 1.0;
	if(nbeta < -1.0)  nbeta = -1.0;
	absnbeta=fabs(nbeta);
	
	stable_bilint(nualpha, nubeta, X1, 15, 7, nalpha, absnbeta, &alpha) ;
	stable_bilint(nualpha, nubeta, X2, 15, 7, nalpha, absnbeta, &beta) ;
	
	if((beta) > 1.0) (beta) = 1.0;

	if(nbeta < 0.0) (beta) = - (beta);
	absbeta=fabs(beta);
	
	stable_bilint(alphav, betav, X3, 16, 5, alpha, absbeta, &ngamma) ;
	
	gamma = (q75-q25)/ngamma;

	stable_bilint(alphav, betav, X5, 16, 5, alpha, absbeta, &nmu) ;
	
	if(beta < 0.0) nmu = - nmu;

	zeta = q50 + ((gamma) * nmu);

	if(alpha == 1.0) mu = zeta;
	if(alpha > 1.0) mu=stable_E(data,n);
	mu = zeta - (beta) * (gamma) * tan((M_PI * (alpha))/2.0);
	
	stable_bilint(alphavv, betav, Y1, 7, 5, alpha, absbeta, &sd_alpha);
	sd_alpha = (sd_alpha) * 1.0/(double)(pow((double)n,0.5));

	stable_bilint(alphavv, betav, Y2, 7, 5, alpha, absbeta, &sd_beta);
	sd_beta = (sd_beta) * 1.0/(double)(pow((double) n,0.5));

	stable_bilint(alphavv, betav, Y3, 7, 5, alpha, absbeta, &sd_gamma);
	sd_gamma = (sd_gamma) * gamma * 1.0/(double)(pow((double)n,0.5));

	stable_bilint(alphavv, betav, Y4, 7, 5, alpha, absbeta, &sd_mu);
	sd_mu = (sd_mu) * gamma * 1.0/(double)(pow((double) n,0.5));

	parameters[0]=alpha;
	parameters[1]=beta;
	parameters[2]=mu;
	parameters[3]=gamma;
	
	sd_parameters[0]=sd_alpha;
	sd_parameters[1]=sd_beta;
	sd_parameters[2]=sd_mu;
	sd_parameters[3]=sd_gamma;

	free(data);
	free(X1); free(X2); free(X3); free(X5); free(Y1); free(Y2);
	free(Y3); free(Y4);
	ReturnParam(Mparameters);
	ReturnParam(Msd_parameters);	

}


