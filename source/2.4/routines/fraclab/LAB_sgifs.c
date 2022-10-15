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
#include "FRACLAB_compat.h"

double uniform(mean,var)
double mean, var ;
{
  double u , v , c ;

  u = mean - sqrt(12.*var)/2. ;
  v = mean + sqrt(12.*var)/2. ;
  c = (double) lrand48 () / maxaleatoire  ;
  c = (v-u)*c + u ;
  return(c) ;

}

double normal(mean,var)
{
  double u , v=1. , w;

  u= (double) lrand48 () / maxaleatoire  ;
  u = PI * (u - 0.5) ;

  while(v==1.)
    v = (double) lrand48 () / maxaleatoire  ;
  v = -log (1.-v) ;

  w = sqrt(2*v) * sin(u) ;

  return(w) ;

}

/*double normal(mean,var)
double mean , var ;
{
  double u=0. , v;

  while(u==0.0)
    u = (double)lrand48()/maxaleatoire ;
  
  v = (double)lrand48()/maxaleatoire ;
  v = sqrt(-2*log(u))*cos(2*PI*v);
  v = mean*v + sqrt(var) ;
  return(v) ;
}
*/


/*double normal(mean,var)
double mean, var ;
{
  int i ;
  double c , c0=0. ;

  srand48 (time (0));
  for(i=0 ; i<15 ; i++) {
     c0 += (double) lrand48 () / (maxaleatoire+1.)  ;
  }
  c0 = c0/15. ;
  c = (c0 - .5)*var + mean ;
  return(c) ;
}
*/
void LAB_sgifs()
{

        /*** Inputs****/

        Matrix *MInt ;  /*** Matrice contenant les points d'interpolation ***/
        double *Int ;  
	Matrix *Mcoefs ;  /*** Matrice contenant les coefficients de contractions***/
        double *coefs ; 
        Matrix *MIter ;  /*** Matrice contenant le nombre d'iterations ***/
        double Iter ; 
        Matrix *Mtype ;
        char *type ;
	Matrix *Mbeta ;
	double beta ;

        /*** Outputs ***/
        Matrix *Mx ;  /*** Matrice contenant les abscisses de l'attracteur du GIFS ***/
        double *x ;  
        Matrix *My ;  /*** Matrice contenant les ordonnees de l'attracteur du GIFS ***/
        double *y ;
        Matrix *MCi ; /*** Matrice contenant les ci choisis***/
        double *Ci ;  /*** Tableau pointant sur ces ci ***/


        /*** Autres variables ***/
	int lin_Int , col_Int , size_Int , lin_coefs , col_coefs , size_coefs ;
	int i , k , j , n , m , J , N , j_N  , a_j , Numero_Fonct , flag=0 , p=0 ;
	double a , b , c , e , f , pt1_abs , pt1_ord , pt2_abs, pt2_ord , imag_pt1_abs , imag_pt1_ord , imag_pt2_abs , imag_pt2_ord , xd , yd , mean , var;

        if(Interf.NbParamIn < 2) {
          InterfError(" sgifs : You must give at least 2 input parameters") ;
          return;
        }
        if(Interf.NbParamIn > 5) {
          InterfError(" sgifs : You must give at most 5 input parameters") ;
          return;
        }
        if(Interf.NbParamOut > 3) {
          InterfError(" sgifs : You must give at most 3 output parameters") ;
          return;
        }

	MInt = Interf.Param[0] ;
	Mcoefs = Interf.Param[1] ;

        if( !(MatrixIsNumeric(MInt) && MatrixIsReal(MInt))) {
          InterfError(" sgifs : The first Input must be a real matrix") ;
          return;
        }
        if( !(MatrixIsNumeric(Mcoefs) && MatrixIsReal(Mcoefs))) {
          InterfError(" sgifs : The second Input must be a real matrix") ;
          return;
        }

        lin_Int = MatrixGetHeight(MInt) ;
        col_Int = MatrixGetWidth(MInt) ;
	size_Int = lin_Int ;
        if( (col_Int != 2) || (lin_Int != 3)) {
          InterfError("sgifs : The dimension of the first input must be 3*2") ;
          return;
        }

        lin_coefs = MatrixGetHeight(Mcoefs) ;
        col_coefs = MatrixGetWidth(Mcoefs) ;
	size_coefs = MAX(lin_coefs,col_coefs) ;
        if( (lin_coefs != 1) && (col_coefs != 1) ) {
          InterfError("gifs : The dimension of the second input must be n*1 or 1*n") ;
          return;
        }

	if(size_coefs !=(size_Int -1) ) {
          InterfError("sgifs : The number of interpolation points must equal the number of contraction coefficients plus 1") ;
          return;
        }
        if(Interf.NbParamIn == 2) {
          Iter = 10 ;
	  type = "uniform" ;
	  beta = 1. ;

        }

        if(Interf.NbParamIn == 3) {
          MIter = Interf.Param[2];
          if( !(MatrixIsScalar(MIter)) ) {
            InterfError(" sgifs : The third input must be a real scalar") ;
            return;
          }
	  Iter = MatrixGetScalar(MIter) ;

	  type = "uniform" ;
	  beta = 1. ;
        }

        if(Interf.NbParamIn == 4) {
          MIter = Interf.Param[2];
          if( !(MatrixIsScalar(MIter)) ) {
            InterfError(" sgifs : The third input must be a real scalar") ;
            return;
          }
	  Iter = MatrixGetScalar(MIter) ;

          Mtype  = Interf.Param[3];
	  if( !MatrixIsString(Mtype) ) {
	    InterfError("sgifs : The fourth Input must be a string") ;
	    return;
	  }
	  type = MatrixReadString(Mtype) ;

	  beta = 1. ;
	}


        if(Interf.NbParamIn == 5) {
          MIter = Interf.Param[2];
          if( !(MatrixIsScalar(MIter)) ) {
            InterfError(" sgifs : The third input must be a real scalar") ;
            return;
          }
	  Iter = MatrixGetScalar(MIter) ;

          Mtype  = Interf.Param[3];
	  if( !MatrixIsString(Mtype) ) {
	    InterfError("sgifs : The fourth Input must be a string") ;
	    return;
	  }
	  type = MatrixReadString(Mtype) ;

	  Mbeta  = Interf.Param[4];
          if( !(MatrixIsScalar(Mbeta)) ) {
            InterfError(" sgifs : The fifth input must be a real scalar") ;
            return;
          }
	  beta = MatrixGetScalar(Mbeta) ;
	  
	}
	if(strcmp(type,"uniform") && strcmp(type,"normal") ){
	  InterfError("sgifs : The law type must be uniform or normal") ;
	  return;
	}

	Int = MatrixGetPr(MInt) ;
	coefs = MatrixGetPr(Mcoefs) ;

	if((Int[0] >= Int[1]) || (Int[0] >= Int[2]) || (Int[1] >= Int[2])) {
          InterfError(" sgifs : The abscissa of the interpolation points must be in a strict increasing order") ;
          return;
	}
	/***** Pour se remettre dans les notations du programme originale ***/
	N = size_Int ;
	J = (int)Iter ;

	Mx = MatrixCreate(GIFS_pow_nj(N-1,J)+1,1,"real") ;
	x = MatrixGetPr(Mx) ;
	My = MatrixCreate(GIFS_pow_nj(N-1,J)+1,1,"real") ;
	y = MatrixGetPr(My) ;
	MCi = MatrixCreate(GIFS_pow_nj(N-1,J)-N+1,1,"real") ;
	Ci = MatrixGetPr(MCi) ;

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

			/******** Determination des c_k^j selon la loi choisie ****/
			mean = coefs[k%N] ;
			var = 1./pow((double)j,beta) ;

			if(!strcmp(type,"uniform")) {
			  c = uniform(mean,var) ; 
			}
			if(!strcmp(type,"normal")) {
			  c = normal(mean,var) ; 
			}
			/*if(!strcmp(type,"lognormal")) {
			  c = lognormal(mean,var) ; 
			}
			*/
			
			b = (imag_pt1_ord-imag_pt2_ord - c*(pt1_ord-pt2_ord))/(pt1_abs-pt2_abs) ;
			f = imag_pt1_ord - b*pt1_abs - c*pt1_ord ;
			x[k*a_j + a_j/N] = a*xd + e ;
			y[k*a_j + a_j/N] = b*xd + c*yd + f ;
			
			Ci[p] = (c) ;
			p++ ;
			
		}
	}

	ReturnParam(Mx) ;
	ReturnParam(My) ;
	ReturnParam(MCi) ;

}


