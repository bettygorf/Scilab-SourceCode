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
#include "GIFS_util.h"
#include"GIFS_alphacoefsigne.h"
#include <string.h>
void LAB_alphagifs()
{
  
        /*** Inputs****/

	Matrix *Msig ;  /*** Matrice contenant le signal ***/
	double *sig ;   /*** Tableau pointant sur le signal lui meme ***/

	Matrix *Moption ;
	char *option ;

        /*** Outputs ***/

	Matrix *MCi ; /*** Matrice contenant les ci ***/
	double *Ci ;  /*** Tableau pointant sur les ci ***/
	Matrix *MSigne ; /*** Matrice contenant les signes ***/
	double *Signe ; /*** Tableau pointant sur les signes ***/
	Matrix *MAlpha ; /*** Matrice contenant les exposants de Holder ***/
	double *Alpha ; /*** Tableau pointant sur les exposants de Holder ***/

	/*** Autres variables ***/
	int i , j , SizeSig , lin , col , scale, test_size, flag=0 , new_SizeSig, new_scale; 
	double *new_sig ;
	
	if(Interf.NbParamIn != 2) {
	  InterfError(" alphagifs : You must give 2 input parameters") ;
	  return;
	}
	
	Msig = Interf.Param[0] ;
	Moption = Interf.Param[1];

	if(Interf.NbParamOut > 2) {
	  InterfError(" alphagifs : You must give at most 2 output parameters") ;
	  return;
	}
	
	if( !(MatrixIsNumeric(Msig) && MatrixIsReal(Msig))) {
	  InterfError(" alphagifs : The first Input must be a real matrix") ;
	  return;
	}
	
	if( !MatrixIsString(Moption) ) {
	  InterfError(" alphagifs : The second Input must be a string") ;
	  return;
	}

	sig = MatrixGetPr(Msig) ;
	lin = MatrixGetHeight(Msig) ;
	col = MatrixGetWidth(Msig) ;

	if( (lin != 1) && (col != 1)) {
	  InterfError(" alphagifs : The dimension of the input signal must be  n*1 or 1*n") ;
	  return;
	}

	option = MatrixReadString(Moption) ;
	if(strcmp(option,"slope") && strcmp(option,"cesaro") && strcmp(option,"nocesaro")) {
	  InterfError(" alphagifs : The limit type must be slope, cesaro or nocesaro");
	  return;
	}

	SizeSig = MAX(lin,col) ;
	new_SizeSig = SizeSig ;
	scale = (int)(log((double)SizeSig)/log(2.)) ;
	new_scale = scale ;
	test_size = GIFS_pow_nj(2,scale) ;
	if(SizeSig != (test_size+1)) {
	  flag=1;
	  if(SizeSig > test_size + test_size/2) {
	    new_SizeSig = 2*test_size + 1;
	    new_scale = scale + 1 ;
	    if ((new_sig = (double *)calloc(new_SizeSig,sizeof(double))) == NULL) {
	      InterfError("Je ne peux pas alouer le nouveau signal input\n") ;
	      return;
	    }
	    for(i=0 ; i<SizeSig ; i++)
	      new_sig[i] = sig[i] ;
	  }
	  else {
	    new_SizeSig = test_size + 1;
	    new_scale = scale ;
	    if ((new_sig = (double *)calloc(new_SizeSig,sizeof(double))) == NULL) {
	      InterfError("Je ne peux pas alouer le nouveau signal input\n") ;
	      return;
	    }
	    for(i=0 ; i<new_SizeSig-1 ; i++)
	      new_sig[i] = sig[i] ;
	    if(SizeSig > test_size)
	      new_sig[new_SizeSig-1] = sig[new_SizeSig-1] ;	      
	  }
	}


	MCi = MatrixCreate(new_SizeSig-3,1,"real") ;
	MSigne = MatrixCreate(new_SizeSig-3,1,"real") ;
	MAlpha = MatrixCreate(new_SizeSig-1,1,"real") ;

	Ci = MatrixGetPr(MCi) ;
	Signe = MatrixGetPr(MSigne) ;
	Alpha = MatrixGetPr(MAlpha) ;

	if(flag)
	  CoefandSigne_ifs(new_sig,new_scale,Ci,Signe) ;
	else
	  CoefandSigne_ifs(sig,new_scale,Ci,Signe) ;


	for(j=0 ; j<=0 ; j++) {
	  if(!strcmp(option,"slope"))
	  alpha_regression(Ci,new_scale-j,Alpha) ;
	  if(!strcmp(option,"cesaro"))
	    alpha_ifs(Ci,new_scale-j,0,Alpha) ;
	  if(!strcmp(option,"nocesaro"))
	    alpha_ifs(Ci,new_scale-j,1,Alpha) ;
	}
	

	free(option) ;
	if(flag)
	  free(new_sig) ;

	ReturnParam(MAlpha) ;
	ReturnParam(MCi) ;
	/*ReturnParam(MSigne) ;*/
	
}
