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

void LAB_gifs2wave()
{

        /*** Inputs****/
	Matrix *MCi ; /*** Matrice contenant les ci ***/
	double *Ci ;  /*** Tableau pointant sur les ci ***/
	Matrix *Mwave_coef ;  /*** Matrice contenant les coefficients en ondelettes du  signal ***/
	double *wave_coef ; 
	Matrix *Mwave_indx ;  /*** Matrice contenant les indices coefficients en ondelettes du  signal ***/
	double *wave_indx ;   /*** Tableau pointant sur ces coefficients ***/
	Matrix *Mwave_size ;  /*** Matrice contenant les tailles coefficients en ondelettes du  signal a cahque echelle***/
	double *wave_size ;   /*** Tableau pointant sur ces tailles ***/

        /*** Outputs ***/

	Matrix *Mwave_coef_new ;  /*** Matrice contenant les coefficients en ondelettes du  signal ***/
	double *wave_coef_new;
	
	/*** Autres variables ***/
	int lin_wave , col_wave, lin_Ci, col_Ci  ;
	int i ,k , j , j0 , J , taille_j , shift, newk , indice , SizeCi, Sizewave;
	double W_k_j , c ;

	if(Interf.NbParamIn != 4) {
	  InterfError(" gifs2wave : You must give 4 input parameters") ;
	  return;
	}	
	
	MCi = Interf.Param[0] ;
	Mwave_coef = Interf.Param[1];
	Mwave_indx = Interf.Param[2];
	Mwave_size = Interf.Param[3]; 

	if(Interf.NbParamOut > 1) {
	  InterfError(" gifs2wave : You must give 1 output parameter") ;
	  return;
	}
	if( !(MatrixIsNumeric(MCi) && MatrixIsReal(MCi))) {
	  InterfError(" gifs2wave : The first Input must be a real matrix") ;
	  return;
	}
	if( !(MatrixIsNumeric(Mwave_coef) && MatrixIsReal(Mwave_coef))) {
	  InterfError(" gifs2wave : The second Input must be a real matrix") ;
	  return;
	}
	if( !(MatrixIsNumeric(Mwave_indx) && MatrixIsReal(Mwave_indx))) {
	  InterfError(" gifs2wave : The second Input must be a real matrix") ;
	  return;
	}
	if( !(MatrixIsNumeric(Mwave_size) && MatrixIsReal(Mwave_size))) {
	  InterfError(" gifs2wave : The third Input must be a real matrix") ;
	  return;
	}

	Ci = MatrixGetPr(MCi) ;
	wave_coef = MatrixGetPr(Mwave_coef) ;
	wave_indx = MatrixGetPr(Mwave_indx) ;
	wave_size = MatrixGetPr(Mwave_size) ;

	lin_wave = MatrixGetHeight(Mwave_coef) ;
	col_wave = MatrixGetWidth(Mwave_coef) ;
	Sizewave = MAX(lin_wave,col_wave) ;
	lin_Ci = MatrixGetHeight(MCi) ;
	col_Ci = MatrixGetWidth(MCi) ;
	SizeCi = MAX(lin_Ci,col_Ci) ;

	if( SizeCi !=  ((int)wave_coef[0]) ) {
	  InterfError(" wave2gifs : The length of the input signal must be a power of 2") ;
	  return;
	}

	Mwave_coef_new = MatrixCreate(lin_wave*col_wave,1,"real") ;
	wave_coef_new = MatrixGetPr(Mwave_coef_new) ;

	memcpy(wave_coef_new,wave_coef,lin_wave*col_wave*sizeof(double)) ;

	J = (int)Ci[SizeCi-1] ;
	j0 = (int)Ci[SizeCi-2] ;
	shift = 0 ;

	for(j=j0-2 ; j>=0 ; j--) {
		taille_j = WSAF_pow_nj(2,J-(j+1)) ;
		/*if(taille_j > arbre[j].taille)
			fprintf(stderr,"Il y a un pb...\n");*/
		for(k=0 ; k<taille_j ; k++) {
			W_k_j = 1. ;
			newk = k ;
			for(i=j ; i<=j0-2 ; i++) {

				indice = WSAF_pow_nj(2,J-j0+1) * ( WSAF_pow_nj(2,j0-i-2) - 1 ) ;
				indice += WSAF_pow_nj(2,J-j0+1) - 2 ;
				c = Ci[indice + newk + shift] ;

				W_k_j *= c ;
				newk /= 2 ;
			}

			/*if(newk > arbre[j0-1].taille)
				fprintf(stderr,"Il y a un pb...\n");*/

			/*W_k_j *= (arbre[j0-1].dataG)[newk];*/
			W_k_j *= wave_coef[(int)wave_indx[j0-1]-1 + newk] ;
			/*(arbre[j].dataG)[k] = W_k_j ;*/
			wave_coef_new[(int)wave_indx[j]-1 + k] = W_k_j ;
		}

	}

        ReturnParam(Mwave_coef_new) ;

}
