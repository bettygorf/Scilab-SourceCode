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
#include <string.h>
#include<stdio.h>
#include<math.h>
#define pi 3.1416

void LAB_prescalpha()
{

        /*** Inputs****/

        Matrix *MInt ;  /*** Matrice contenant les points d'interpolation ***/
        double *Int ;  
	Matrix *Mcoefs ;  /*** Matrice contenant les coefficients de contractions***/
        double *coefs ; 
        Matrix *MIter ;  /*** Matrice contenant le nombre d'iterations ***/
        double Iter ; 

        /*** Outputs ***/

        Matrix *Mx ;  /*** Matrice contenant les abscisses de l'attracteur du GIFS ***/
        double *x ;  
        Matrix *My ;  /*** Matrice contenant les ordonnees de l'attracteur du GIFS ***/
        double *y ;



        /*** Autres variables ***/
	int lin_Int , col_Int , size_Int , lin_coefs , col_coefs , size_coefs ;
	int i , k , j , n , m , J , N , j_N  , a_j , Numero_Fonct , flag=0 , p=0 ;
	double a , b , c , e , f , pt1_abs , pt1_ord , pt2_abs, pt2_ord , imag_pt1_abs , imag_pt1_ord , imag_pt2_abs , imag_pt2_ord , xd , yd , t;

        if(Interf.NbParamIn < 2) {
          InterfError(" prescalpha : You must give at least 2 input parameters") ;
          return;
        }
        if(Interf.NbParamIn > 3) {
          InterfError(" prescalpha : You must give at most 3 input parameters") ;
          return;
        }
        if(Interf.NbParamOut > 2) {
          InterfError(" prescalpha : You must give at most 2 output parameters") ;
          return;
        }

	MInt = Interf.Param[0] ;
	Mcoefs = Interf.Param[1] ;

        if( !(MatrixIsNumeric(MInt) && MatrixIsReal(MInt))) {
          InterfError(" prescalpha : The first Input must be a real matrix") ;
          return;
        }
        if( !(MatrixIsNumeric(Mcoefs) && MatrixIsReal(Mcoefs))) {
          InterfError(" prescalpha : The second Input must be a real vector") ;
          return;
        }

        lin_Int = MatrixGetHeight(MInt) ;
        col_Int = MatrixGetWidth(MInt) ;
	size_Int = lin_Int ;
        if( col_Int != 2) {
          InterfError("prescalpha : The dimension of the first input must be 3*2") ;
          return;
        }
        if(lin_Int != 3) {
          InterfError("prescalpha : The dimension of the first input must be 3*2") ;
          return;
        }

        lin_coefs = MatrixGetHeight(Mcoefs) ;
        col_coefs = MatrixGetWidth(Mcoefs) ;
        size_coefs = MAX(lin_coefs,col_coefs) ;
        if( (lin_coefs != 1) && (col_coefs != 1) ) {
          InterfError("presclapha : The dimension of the second input must be n*1 or 1*n") ;
          return;
        }


        if(Interf.NbParamIn == 2) {
          Iter = 10 ;
	}

        if(Interf.NbParamIn == 3) {
          MIter = Interf.Param[2];
          if( !(MatrixIsScalar(MIter)) ) {
            InterfError(" prescalpha : The third input must be a real scalar") ;
            return;
          }
	  Iter = MatrixGetScalar(MIter) ;

        }

	Int = MatrixGetPr(MInt) ;
	coefs = MatrixGetPr(Mcoefs) ;

	if((Int[0] >= Int[1]) || (Int[0] >= Int[2]) || (Int[1] >= Int[2])) {
          InterfError("prescalpha : The abscissa of the interpolation points must be in a strict increasing order") ;
          return;
	}
	/***** Pour se remettre dans les notations du programme originale ***/
	N = size_Int ;
	J = (int)Iter ;
	
	if(size_coefs != (GIFS_pow_nj(N-1,J)-2)){
          InterfError("prescalpha : The length of the coefficients matrix must be 2^Iter - 2") ;
          return;
	}

	Mx = MatrixCreate(GIFS_pow_nj(N-1,J)+1,1,"real") ;
	x = MatrixGetPr(Mx) ;
	My = MatrixCreate(GIFS_pow_nj(N-1,J)+1,1,"real") ;
	y = MatrixGetPr(My) ;

        for(m=0 ; m<N ; m++) {
	  x[m*GIFS_pow_nj(N-1,J-1)] = Int[m] ;
	  y[m*GIFS_pow_nj(N-1,J-1)] = Int[m+N] ;
	}

	N = N-1 ; /***** N devient le nombre de fonctions a la premiere iteration *****/

	for(j_N=N , j=1 ; j<J ; j++ , j_N *= N) {
		a_j = GIFS_pow_nj(N,J-j) ;

		for(k=0 ; k<j_N ; k++) {
			if((k%N)==0){
				pt1_abs  = x[k*a_j] ;
				pt1_ord  = y[k*a_j] ;
				pt2_abs  = x[(k+2)*a_j] ;
				pt2_ord  = y[(k+2)*a_j] ;
				imag_pt1_abs = pt1_abs ;
				imag_pt1_ord = pt1_ord ;
				imag_pt2_abs = x[(k+1)*a_j] ;
				imag_pt2_ord = y[(k+1)*a_j] ;
				xd = imag_pt2_abs ;
				yd = imag_pt2_ord ;
			}
			else{
				pt1_abs  = x[(k-1)*a_j] ;
				pt1_ord  = y[(k-1)*a_j] ;
				pt2_abs  = x[(k+1)*a_j] ;
				pt2_ord  = y[(k+1)*a_j] ;
				imag_pt1_abs = x[k*a_j] ;
				imag_pt1_ord = y[k*a_j] ;
				imag_pt2_abs = pt2_abs ;
				imag_pt2_ord = pt2_ord ;
				xd = imag_pt1_abs ;
				yd = imag_pt1_ord ;				

			}				
			a = (imag_pt1_abs - imag_pt2_abs)/(pt1_abs-pt2_abs) ;
			e = imag_pt1_abs - a*pt1_abs ;

			/******** Determination des c_k^j selon la fonction choisie ****/
			
			c = coefs[p] ;
			p++ ;
			
			c = pow(-1,k)/pow((double)N,c) ;
			
			b = (imag_pt1_ord-imag_pt2_ord - c*(pt1_ord-pt2_ord))/(pt1_abs-pt2_abs) ;
			f = imag_pt1_ord - b*pt1_abs - c*pt1_ord ;
			x[k*a_j + a_j/N] = a*xd + e ;
			y[k*a_j + a_j/N] = b*xd + c*yd + f ;
			
			
		}
	}
	
	ReturnParam(Mx) ;
	ReturnParam(My) ;

}


