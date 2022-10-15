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

void LAB_fif()
{

        /*** Inputs****/

        Matrix *MInt ;  /*** Matrice contenant les points d'interpolation ***/
        double *Int ;
        Matrix *Mcoefs ;  /*** Matrice contenant les coefficients de contractions***/
        double *coefs ;
        Matrix *MIter ;  /*** Matrice contenant le nombre d'iterations ***/
        double Iter ;
	Matrix *Mtype;
	char *type;

        /*** Outputs ***/
        Matrix *Mabs ;  /*** Matrice contenant les abscisses de l'attracteur du FIF ***/
        double *abs ;
        Matrix *Mord ;  /*** Matrice contenant les ordonnees de l'attracteur du FIF ***/
        double *ord ;

        /*** Autres variables ***/

	int        lin_Int , col_Int , size_Int , lin_coefs , col_coefs , size_coefs ;
	int             i, n, N , M ,flag=0,p;
	double           a, h, b, k, x, y, r, s;
	double          *X , *Y ;

        if(Interf.NbParamIn < 2) {
          InterfError(" fif : You must give at least 2 input parameters") ;
          return;
        }
        if(Interf.NbParamIn > 4) {
          InterfError(" fif : You must give at most 4 input parameters") ;
          return;
        }
        if(Interf.NbParamOut > 2) {
          InterfError(" fif : You must give at most 2 output parameters") ;
          return;
        }

	MInt = Interf.Param[0] ;
	Mcoefs = Interf.Param[1] ;

        if( !(MatrixIsNumeric(MInt) && MatrixIsReal(MInt))) {
          InterfError(" fif : The first Input must be a real matrix") ;
          return;
        }
        if( !(MatrixIsNumeric(Mcoefs) && MatrixIsReal(Mcoefs))) {
          InterfError(" fif : The second Input must be a real matrix") ;
          return;
        }

        lin_Int = MatrixGetHeight(MInt) ;
        col_Int = MatrixGetWidth(MInt) ;
	size_Int = lin_Int ;
        if( col_Int != 2) {
          InterfError("fif : The dimension of the first input must be n*2") ;
          return;
        }

        lin_coefs = MatrixGetHeight(Mcoefs) ;
        col_coefs = MatrixGetWidth(Mcoefs) ;
	size_coefs = MAX(lin_coefs,col_coefs) ;
        if( (lin_coefs != 1) && (col_coefs != 1) ) {
          InterfError("fif : The dimension of the second input must be n*1 or 1*n") ;
          return;
        }

	if(size_coefs !=(size_Int -1) ) {
          InterfError("fif : The number of interpolation points must equal the number of contraction coefficients plus 1") ;
          return;
        }

        if(Interf.NbParamIn == 2) {
          Iter = 2048 ;
	  type = "affine" ;
        }

        if(Interf.NbParamIn == 3) {
          MIter = Interf.Param[2];
          if( !(MatrixIsScalar(MIter)) ) {
            InterfError(" fif : The third input must be a real scalar") ;
            return;
          }
	  Iter = MatrixGetScalar(MIter) ;

	  type ="affine" ;

        }
        if(Interf.NbParamIn == 4) {
          MIter = Interf.Param[2];
          if( !(MatrixIsScalar(MIter)) ) {
            InterfError(" fif : The third input must be a real scalar") ;
            return;
          }
	  Iter = MatrixGetScalar(MIter) ;

          Mtype  = Interf.Param[3];
	  if( !MatrixIsString(Mtype) ) {
	    InterfError("fif : The fourth Input must be a string") ;
	    return;
	  }
	  type = MatrixReadString(Mtype) ;

	}



	Int = MatrixGetPr(MInt) ;
	coefs = MatrixGetPr(Mcoefs) ;

	/*---------------------------------------------------------*/
	N = size_Int-1 ;

	Mabs = MatrixCreate((int)Iter,1,"real") ;
	abs = MatrixGetPr(Mabs) ;
	Mord = MatrixCreate((int)Iter,1,"real") ;
	ord = MatrixGetPr(Mord) ;

        X = (double *) malloc ((N + 1) * sizeof (double));
        Y = (double *) malloc ((N + 1) * sizeof (double));

	for(i = 0; i <size_Int; i++) {
	  X[i] = Int[i] ;
	  Y[i] = Int[i+size_Int] ;
	}
	for(i = 1; i <size_Int; i++) {
	  if(X[i] <= X[i-1]) {
	    InterfError("fif : The abscissa of the interpolation points must be in a strict increasing order") ;
	    return;
	  }
	}

	p=0 ;
	x = X[0];
	y = Y[0];

	srand48 (time (0));
	

	for (i = 0; i < (int)Iter; i++) {

		n = (int) (((double) lrand48 () / maxaleatoire) * (double) N) + 1;
		while (n == N + 1)
			n = (int) (((double) lrand48 () / maxaleatoire) * (double) N) + 1;
		a = (X[n - 1] - X[n]) / (X[0] - X[N]);
		h = X[n] - a * X[N];

		if (!strcmp(type,"affine")) { /*-----Interpolation lineaire---*/

			b = (Y[n] - Y[n - 1] - coefs[n - 1] * (Y[N] - Y[0])) / (X[N] - X[0]);
			k = Y[n - 1] - coefs[n - 1] * Y[0] - b * X[0];

			y = b * x + coefs[n - 1] * y + k;
			x = a * x + h;

			abs[p] = x ;
			ord[p] = y ;
			p++;
			
		}

		if (!strcmp(type,"sinusoidal")) { /*-----Interpolation en sinus---*/

			b = (Y[n] - Y[n - 1] - coefs[n - 1] * (sin(Y[N]) - sin(Y[0]))) / (sin(X[N]) - sin(X[0]));
			k = Y[n - 1] - coefs[n - 1] * sin(Y[0]) - b * sin(X[0]) ;

			y = b * sin(x) + coefs[n - 1] * sin(y) + k;
			x = a * x + h;

			abs[p] = x ;
			ord[p] = y ;
			p++;
			
		}	
	}
			

	free(X);
	free(Y);

	ReturnParam(Mabs) ;
	ReturnParam(Mord) ;

} 	

