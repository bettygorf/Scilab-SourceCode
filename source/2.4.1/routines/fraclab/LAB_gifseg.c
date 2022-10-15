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
#include <string.h>
#include "WSAF_define.h"
#include "WSAF_util.h"
#include "FRACLAB_compat.h" 
  
void LAB_gifseg()
{
        /*** Inputs****/

        Matrix *MCi ;  /*** Matrice contenant les Ci ***/
        double *Ci ;   /*** Tableau pointant sur les Ci ***/
	Matrix *Mc_min ; 
	double c_min ;
	Matrix *Mc_max ; 
	double c_max ;
	Matrix *Mseuil ;/*** Matrice  contenant l'erreur voulue ***/
        double seuil ;

        /*** Outputs ***/

        Matrix *MCi_new ; /*** Matrice contenant les noveaux Ci ***/
        double *Ci_new ;  /*** Tableau pointant sur les nouveaux Ci ***/
	Matrix *Mmarks ;
	double *marks ;
	Matrix *Mlambda ;
	double *lambda ;
	Matrix *Mcount ;
	double *count ;
        /*** Autres variables ***/
        int SizeCi , lin , col ,n , i , k , N, J ,compteur=0, scale, size=0 , COUNT=0;
	int j0 ;
	double a , b ;
	double *L0 ,*L1 , *marks_temp, *lambda_temp , *Si; 
	NOEUD *root ;

        if(Interf.NbParamIn > 4) {
          InterfError(" gifseg : You must give at most 4 input parameters") ;
          return;
        }
        if(Interf.NbParamOut > 4) {
          InterfError(" gifseg : You must give at most 4 output parameters") ;
          return;
        }

	MCi = Interf.Param[0] ;

        if( !(MatrixIsNumeric(MCi) && MatrixIsReal(MCi)) ) {
          InterfError(" gifseg : The first input must be a real matrix") ;
          return;
        }

        lin = MatrixGetHeight(MCi) ;
        col = MatrixGetWidth(MCi) ;

        if( (lin != 1) && (col != 1)) {
          InterfError(" gifseg : The dimension of the input Ci's must be  n*1 or 1*n") ;
          return;
        }

	Ci = MatrixGetPr(MCi) ;

	if(Interf.NbParamIn == 4) {	
	  Mc_min = Interf.Param[1];
	  Mc_max = Interf.Param[2];
	  Mseuil = Interf.Param[3];

	  if( !(MatrixIsScalar(Mc_min)) ) {
	    InterfError(" gifseg : The second input must be a real scalar") ;
	    return;
	  }
	  if( !(MatrixIsScalar(Mc_max)) ) {
	    InterfError(" gifseg : The third input must be a real scalar") ;
	    return;
	  }

	  if( !(MatrixIsScalar(Mseuil)) ) {
	    InterfError(" gifseg : The fourth Input must be a real scalar") ;
	    return;
	  }

	  c_min   = MatrixGetScalar(Mc_min) ;
	  c_max   = MatrixGetScalar(Mc_max) ;
	  seuil   = MatrixGetScalar(Mseuil) ;
	}

	if(Interf.NbParamIn == 3) {
	  Mc_min = Interf.Param[1];
	  Mc_max = Interf.Param[2];
	
	  if( !(MatrixIsScalar(Mc_min)) ) {
	    InterfError(" gifseg : The second input must be a real scalar") ;
	    return;
	  }
	  if( !(MatrixIsScalar(Mc_max)) ) {
	    InterfError(" gifseg : The third input must be a real scalar") ;
	    return;
	  }

	  c_min   = MatrixGetScalar(Mc_min) ;
	  c_max   = MatrixGetScalar(Mc_max) ;
	  seuil   = 10. ;
	}

	if(Interf.NbParamIn == 2) {
	  Mc_min = Interf.Param[1];

	  if( !(MatrixIsScalar(Mc_min)) ) {
	    InterfError(" gifseg : The second input must be a real scalar") ;
	    return;
	  }
	
	  c_min   = MatrixGetScalar(Mc_min) ;
	  c_max   = 1. ;
	  seuil   = 10. ;
	}
	if(Interf.NbParamIn == 1) {	
	  c_min   = 0. ;
	  c_max   = 1. ;
	  seuil   = 10. ;
	}

	a = MIN(c_min,c_max) ;
	b = MAX(c_min,c_max) ;

	SizeCi = MAX(lin,col) ; 
	scale = (int)Ci[SizeCi-1] ;
	j0 = (int)Ci[SizeCi-2] ; /** ce j0 est en fait le nombre d'iter dans la TO **/
	if( j0 < 3 ) {
	  InterfError(" gifseg : The wavelet analysis depth must be strictly greater than 2") ;
	  return;
	}
	if( j0 >= scale ) {
	  InterfError(" wave2gifs : The wavelet analysis depth must be strictly smaller than the maximale resolution") ;
	  return;
	}

	j0 = scale - j0 ; /** ici je le remplace par ce que signifie j0 pour moi **/
	N = WSAF_pow_nj(2,scale) ;
	J = scale ;

	if( SizeCi != N ) {
	  InterfError(" wave2gifs : The length of the input signal must be a power of 2") ;
	  return;
	}

        /****Allocation memoire******/

        if ((Si = (double *)malloc(WSAF_pow_nj(2,j0)*sizeof(double))) == NULL) {
                fprintf(stderr,"Je ne peux pas alouer le tableau des Si\n") ;
                exit(0);
	}
        if ((L0 = (double *)malloc((J-1)*sizeof(double))) == NULL) {
                fprintf(stderr,"Je ne peux pas alouer le tableau des lambdas gauches\n") ;
                exit(0);
        }
        if ((L1 = (double *)malloc((J-1)*sizeof(double))) == NULL) {
                fprintf(stderr,"Je ne peux pas alouer le tableau des lambdas droits\n") ;
                exit(0);
        } 
        if ((marks_temp = (double *)calloc(N/2,sizeof(double))) == NULL) {
                fprintf(stderr,"Je ne peux pas alouer le tableau des marques\n") ;

                exit(0);
        }
        if ((lambda_temp = (double *)calloc(N/2,sizeof(double))) == NULL) {
                fprintf(stderr,"Je ne peux pas alouer le tableau des lambdas\n") ;

                exit(0);
        }       /****************************/

        MCi_new = MatrixCreate(SizeCi,1,"real") ;
	Ci_new = MatrixGetPr(MCi_new) ;
	memcpy(Ci_new,Ci,lin*col*sizeof(double)) ;

	if(j0==0)
	  Si[0] = 1. ;
	else {
	  k=0 ;
	  for(i=WSAF_pow_nj(2,j0)-2 ; i<=WSAF_pow_nj(2,j0+1)-3 ; i++) {
	    Si[k] = Ci_new[i] ;
	    k++;
	  }
	}

	root = (NOEUD *)NULL ; 
	root = (NOEUD *)create_tree(root,-1,0,scale,Ci_new) ;

        decoup_arbre(root,scale,j0,seuil,Ci_new,Si,a,b,L0,L1,&compteur,marks_temp,lambda_temp,&size,&COUNT) ;

	Mmarks = MatrixCreate(compteur+1,1,"real") ;
	marks =  MatrixGetPr(Mmarks) ;
	Mlambda = MatrixCreate(size,1,"real") ;
	lambda =  MatrixGetPr(Mlambda) ;
	Mcount = MatrixCreate(1,1,"real") ;
	count = MatrixGetPr(Mcount) ;

	for(i=0 ; i < compteur ; i++)
	  marks[i] = marks_temp[i] ;
	marks[compteur] = (double)N ;

	for(i=0 ; i < size ; i++)
	  lambda[i] = lambda_temp[i] ;

	*count = (double)COUNT*100./(double)N;

	free(Si) ;
	free(L0) ;
	free(L1) ;
	free(marks_temp) ;
	free(lambda_temp) ;

	Ci_new[N-2] = Ci[N-2] ;
	Ci_new[N-1] = Ci[N-1] ;

	ReturnParam(MCi_new) ;
	ReturnParam(Mmarks) ; 
	ReturnParam(Mlambda) ; 
	ReturnParam(Mcount);
}


