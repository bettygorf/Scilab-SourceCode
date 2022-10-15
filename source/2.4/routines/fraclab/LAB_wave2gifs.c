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

#include "C-LAB_Interf.h"
#include<stdio.h>
#include<math.h>
#include "WSAF_util.h" 
#include "FRACLAB_compat.h"

void LAB_wave2gifs()
{
  
        /*** Inputs****/

	Matrix *Mwave_coef ;  /*** Matrice contenant les coefficients en ondelettes du  signal ***/
	double *wave_coef ;   /*** Tableau pointant sur ces coefficients ***/
	Matrix *Mwave_indx ;  /*** Matrice contenant les indices coefficients en ondelettes du  signal ***/
	double *wave_indx ;   /*** Tableau pointant sur ces coefficients ***/
	Matrix *Mwave_size ;  /*** Matrice contenant les tailles coefficients en ondelettes du  signal a cahque echelle***/
	double *wave_size ;   /*** Tableau pointant sur ces tailles ***/
		
	Matrix *Mm0 ;/*** Matrice  contenant la valeur pour laquelle on remplace tous les ci entre 1 et m0 par .99 ***/
	double m0 ; 
	Matrix *Ma ;/*** Matrice  contenant l'extremite gauche de l'intrevalle dans lequel on veut faire des statistiques sur les ci ***/
	double a ;
	Matrix *Mb ;/*** Matrice  contenant l'extremite droite de l'intrevalle dans lequel on veut faire des statistiques sur les ci ***/
	double b ;

        /*** Outputs ***/

	Matrix *MCi ; /*** Matrice contenant les ci ***/
	double *Ci ;  /*** Tableau pointant sur les ci ***/
	Matrix *MCindx ; /*** Matrice contenant les premiers indices ***/
	double *Cindx ;  /*** Tableau pointant sur les ci ***/	
	Matrix *MCisize ; /*** Matrice contenant les premiers indices ***/
	double *Cisize ;  /*** Tableau pointant sur les ci ***/
	Matrix *Mpc0 ; /**** Matrice pointant sur le nombre de ci nuls ***/
	double *pc0 ;
	Matrix *Mpc1 ; /**** Matrice pointant sur le nombre ce ci entre a et b ***/
	double *pc1 ;
	/*** Autres variables ***/
	int SizeCi , lin , col , scale;
	int i ,k , j , j0 , J , taille_j , count , count0 , count1 ;
	double W_k_j , W_k2_j , C_k_j ;
	
	if(Interf.NbParamIn > 6) {
	  InterfError(" wave2gifs : You must give at most 6 input parameters") ;
	  return;
	}
	if(Interf.NbParamIn < 5) {
	  InterfError(" wave2gifs : You must give at least 5 input parameters") ;
	  return;
	}	
	
	Mwave_coef = Interf.Param[0] ;
	Mwave_indx = Interf.Param[1];
	Mwave_size = Interf.Param[2];

	if(Interf.NbParamOut > 5) {
	  InterfError(" wave2gifs : You must give at most 5 output parameter") ;
	  return;
	}
	
	if( !(MatrixIsNumeric(Mwave_coef) && MatrixIsReal(Mwave_coef))) {
	  InterfError(" wave2gifs : The first Input must be a real matrix") ;
	  return;
	}

	if( !(MatrixIsNumeric(Mwave_indx) && MatrixIsReal(Mwave_indx))) {
	  InterfError(" wave2gifs : The second Input must be a real matrix") ;
	  return;
	}
	if( !(MatrixIsNumeric(Mwave_size) && MatrixIsReal(Mwave_size))) {
	  InterfError(" wave2gifs : The third Input must be a real matrix") ;
	  return;
	}


	lin = MatrixGetHeight(Mwave_coef) ;
	col = MatrixGetWidth(Mwave_coef) ;


	if( (lin != 1) && (col != 1)) {
	  InterfError(" wave2gifs : The dimension of the first input must be  n*1 or 1*n") ;
	  return;
	}

	if(Interf.NbParamIn == 3) {
	  m0      = 1. ;
	  a       = 0. ;
	  b       = 2. ;
	}
	
	if(Interf.NbParamIn == 4) {
	  Mm0        = Interf.Param[3];

	  if( !(MatrixIsScalar(Mm0)) ) {
	    InterfError(" wave2gifs : The fourth Input must be a real scalar") ;
	    return;
	  }

	  m0      = MatrixGetScalar(Mm0) ;
	  a       = 0. ;
	  b       = 2. ;
	}
	if(Interf.NbParamIn == 5) {
	  Mm0        = Interf.Param[3];
	  Ma         = Interf.Param[4];

	  if( !(MatrixIsScalar(Mm0)) ) {
	    InterfError(" wave2gifs : The fourth Input must be a real scalar") ;
	    return;
	  }
	  if( !(MatrixIsScalar(Ma)) ) {
	    InterfError(" wave2gifs : The fifth Input must be a real scalar") ;
	    return;
	  }

	  m0      = MatrixGetScalar(Mm0) ;
	  a       = MatrixGetScalar(Ma) ;
	  b       = 2. ;
	}

	if(Interf.NbParamIn == 6) {
	  Mm0        = Interf.Param[3];
	  Ma         = Interf.Param[4];
	  Mb         = Interf.Param[5];
	
	  if( !(MatrixIsScalar(Mm0)) ) {
	    InterfError(" wave2gifs : The fourth Input must be a real scalar") ;
	    return;
	  }
	  if( !(MatrixIsScalar(Ma)) ) {
	    InterfError(" wave2gifs : The fifth Input must be a real scalar") ;
	    return;
	  }
	  if( !(MatrixIsScalar(Mb)) ) {
	    InterfError(" wave2gifs : The sixth Input must be a real scalar") ;
	    return;
	  }

	  m0      = MatrixGetScalar(Mm0) ;
	  a       = MatrixGetScalar(Ma) ;
	  b       = MatrixGetScalar(Mb) ;
	}

	wave_coef = MatrixGetPr(Mwave_coef) ;
	wave_indx = MatrixGetPr(Mwave_indx) ;
	wave_size = MatrixGetPr(Mwave_size) ;

	scale = (int)(log(wave_coef[0])/log(2)) ;
	j0 = (int)(wave_coef[1]) ;

	if( j0 < 3 ) {
	  InterfError(" wave2gifs : The wavelet analysis depth must be strictly greater than 2") ;
	  return;
	}
	if( j0 >= scale ) {
	  InterfError(" wave2gifs : The wavelet analysis depth must be strictly smaller than the maximale resolution") ;
	  return;
	}

	J = scale ;
	SizeCi = WSAF_pow_nj(2,J) ;

	if( SizeCi !=  ((int)wave_coef[0]) ) {
	  InterfError(" wave2gifs : The length of the input is still not a power of 2") ;
	  return;
	}

	MCi = MatrixCreate(SizeCi,1,"real") ;
	Ci = MatrixGetPr(MCi) ;
	MCindx = MatrixCreate(j0-1,1,"real") ;
	Cindx = MatrixGetPr(MCindx) ;
	MCisize = MatrixCreate(j0-1,1,"real") ;
	Cisize = MatrixGetPr(MCisize) ;
	Mpc0 = MatrixCreate(1,1,"real") ;
	pc0 = MatrixGetPr(Mpc0) ;
	Mpc1 = MatrixCreate(1,1,"real") ;
	pc1 = MatrixGetPr(Mpc1) ;


	/*********** Creation des coefficients du GIFS **********/

	count = 0 ;
	count0 = 0 ;
	count1 = 0 ;
	i = 0 ;
	for(j=J-2 ; j>j0-1 ;j--) {
		taille_j = WSAF_pow_nj(2,J-(j+1)) ;
		for(k=0 ; k<taille_j ; k++) {
			Ci[i] = 1. ;
			i++ ;
		}

	}
	j=j0-1 ;
	taille_j = WSAF_pow_nj(2,J-(j+1)) ;
	for(k=0 ; k<taille_j ; k++) {
	  /*Ci[i] = (arbre[j].dataG)[k] ;*/
	  Ci[i] = wave_coef[(int)wave_indx[j]-1 + k] ;
	  i++;
	}

	for(j=j0-2 ; j>=0 ; j--) {
		taille_j = WSAF_pow_nj(2,J-(j+1)) ;
		/*taille_j = arbre[j].taille ;*/
		if(taille_j > (int)wave_size[j]) {
			InterfError("The size of you input signal must be a power of 2");
			return ;
		}

		Cindx[j] =(double)(i+1) ;
		Cisize[j] = (double)taille_j ;

		for(k=0 ; k<taille_j ; k++) {
			count ++ ;
			/*W_k_j = (arbre[j].dataG)[k];*/
			W_k_j = wave_coef[(int)wave_indx[j]-1 + k] ;
			/*W_k2_j = (arbre[j+1].dataG)[k/2];*/
			W_k2_j = wave_coef[(int)wave_indx[j+1]-1 + k/2] ;

			if(W_k2_j != 0.) {
				C_k_j = W_k_j / W_k2_j ;
				if((fabs(C_k_j) > a) && (fabs(C_k_j) < b))
					count1 ++ ;
			}
			else {
				C_k_j = 1. ;
				count0 ++;
			}
			if((fabs(C_k_j) > 1) && (fabs(C_k_j) < m0)){
				Ci[i] = C_k_j/fabs(C_k_j)*.99 ;
				i++ ;
			}
			else {
				Ci[i] = C_k_j ;
				i++ ;
			}
			

		}

	} 

	Ci[i] = (double)j0 ; 
	Ci[i+1] = (double)J ; 

	*pc0 = (double)count0*100./(double)count ;
	*pc1 = (double)count1*100./(double)count ;

	/*      
	fprintf(stderr,"%.2f%% of coefficients equal 0\n",(double)count0*100./(double)count);
	fprintf(stderr,"%.2f%% of coefficients belong to ]%.2f,%.2f[\n",(double)count1*100./(double)count,a,b);
	*/

	ReturnParam(MCi) ;
	ReturnParam(MCindx) ;
	ReturnParam(MCisize) ;
	ReturnParam(Mpc0) ;
	ReturnParam(Mpc1) ;
}
