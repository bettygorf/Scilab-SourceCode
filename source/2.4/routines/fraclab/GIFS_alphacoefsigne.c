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

#include<stdio.h>
#include<math.h>
#include"GIFS_triangle.h"
#include "GIFS_util.h"

#define Abs(x) ((x) < 0 ? -(x) : (x))


/* la fonction  CoefandSigne_ifs donnent pour un signal entree Y de taille 2^J +1,
les coefficients de l'IFS dont l'attracteur est Y. Ces ceof. sont mis dont le tableau Ci.
Les signes de ces coef. sont mis dans le tableau Signe.*/ 

void CoefandSigne_ifs(Y,J,Ci,Signe)
int J ;
double *Y , *Ci ;
double *Signe ;
{
	int k , j , p , j_2 , N ;
	int GIFS_pow_nj() ;
	double coefs[6] ;
	TRIANGLE triangle1 , triangle2 ;
	extern void coef_triangle2triangle_map() ;

	
	N = GIFS_pow_nj(2,J) ;
	p = 0 ;

	for(j_2=2 , j=1 ; j<J ; j++ , j_2 *= 2) {

		for(k=0 ; k<j_2/2 ; k++) {
			/****************************************/
			(triangle1.som1)[0] = 2*k*(N/j_2) ;
			(triangle1.som1)[1] = Y[2*k*(N/j_2)] ;

			(triangle1.som2)[0] = (2*k+1)*(N/j_2) ;
			(triangle1.som2)[1] = Y[(2*k+1)*(N/j_2)] ;

			(triangle1.som3)[0] = (2*k+2)*(N/j_2) ;
			(triangle1.som3)[1] = Y[(2*k+2)*(N/j_2)] ;
			/*****************************************/

			triangle2.som1[0] = triangle1.som1[0] ;
			triangle2.som1[1] = triangle1.som1[1] ;

			(triangle2.som2)[0] = (4*k+1)*(N/(2*j_2)) ;
			(triangle2.som2)[1] = Y[(4*k+1)*(N/(2*j_2))] ;

			triangle2.som3[0] = triangle1.som2[0] ;
			triangle2.som3[1] = triangle1.som2[1] ;

			/***************************************/

			coef_triangle2triangle_map(&triangle1,&triangle2,coefs) ;

			Ci[p] = coefs[4] ;

			if(Ci[p] >= 0)
				Signe[p] = 1 ;
			else
				Signe[p] = -1 ;
			
			p++ ;

			/***************************************/

			triangle2.som1[0] = triangle1.som2[0] ;
			triangle2.som1[1] = triangle1.som2[1] ;

			(triangle2.som2)[0] = (4*k+3)*(N/(2*j_2)) ;
			(triangle2.som2)[1] = Y[(4*k+3)*(N/(2*j_2))] ;

			triangle2.som3[0] = triangle1.som3[0] ;
			triangle2.som3[1] = triangle1.som3[1] ;

			/***************************************/

			coef_triangle2triangle_map(&triangle1,&triangle2,coefs) ;

			Ci[p] = coefs[4] ;

			if(Ci[p] >= 0)
				Signe[p] = 1 ;
			else
				Signe[p] = -1 ;
			
			p++ ;
		}
	}


}

/* La fonction alpha_ifs calcul la fonction de Holder
   d'un signal de taille 2^J +1 en utilisant les coefficient de l'IFS qui le determinent
   et qui sont stockes dans le tableau Ci (parametre d'entree).
   Le resultat est mis dans le tabeleau H (parmetre de sortie). H[n] contiendera l'exposant
   de Holder au point n.
   Lorsque flag=1 on utilisera la formule de Cesaro pour le calcul des exposants.
   Lorsque flag=0 on donnera la derniere valeur de la suite.
*/

void alpha_ifs(Ci,J,flag,H)
int J , flag ;
double *Ci , *H ;
{		
	int k , j , n , N , nc , indice , count ;
	double alpha , c , s;
	int GIFS_pow_nj() ;

	N = GIFS_pow_nj(2,J) ;

	if(!flag)
		nc = 1 ;
	else
		nc = J-1 ;
	for(n=0 ; n<N ; n ++){
		if(n%2 >= 0) {
			alpha = 0. ;
			count = 0 ;
			for(j=nc ; j<J ; j++){
				k = n/GIFS_pow_nj(2,J-j) ;
				indice = 2*(GIFS_pow_nj(2,j-1) -1 ) + k ; /* indice dans Ci du [2^k t]ème */
				                                     /* coefficient à l'echelle j    */
				s = pow(2,-(double)k*pow(2.,-(double)j)) ;
				c = Ci[indice] ;
				if((c == 0.))
					fprintf(stderr,"J'ai un c_i dans le cul  %d\n",indice);
				
				if(Abs(c) <1 && Abs(c) >=0.5) {
					alpha += log(Abs(c))/log(2) ;
					count++ ;
				}
				else {
					if (Abs(c)<=.5) {
						alpha += -1 ;
						count++;
					}
				}
			}
			/*H[n] = -alpha/(double)count ;*/
			H[n] = -alpha/(double)(J-nc) ;
			
		}
		else {
			k = (int)(n/2) ;
			indice = 2*(GIFS_pow_nj(2,J-2) -1 ) + k ;
			alpha = -log(Abs(Ci[indice]))/log(2) ;
			H[n] = Abs(alpha) ;
		}
	}
}

void alpha_regression(Ci,J,H)
int J ;
double *Ci , *H ;
{
	int k , j , n , j0 , indice , N ,p , l;
	double r ,pente , c , absc, compteur,s;
	double *x , *y ;
	void GIFS_slope() ;
	int GIFS_pow_nj() ;

	N = GIFS_pow_nj(2,J) ;
       

	if ((x = (double *)calloc(J-1,sizeof(double))) == NULL) {
                fprintf(stderr,"Je ne peux pas alouer le tableau des abscisses de regession\n") ;
                exit(0);
        }

	if ((y = (double *)calloc(J-1,sizeof(double))) == NULL) {
                fprintf(stderr,"Je ne peux pas alouer le tableau des ordonnees de regession\n") ;
                exit(0);
        }

	for(j=0 ; j<J-1 ; j++) 
			x[j] = (double)(j+1) ;

	for(n=0 ; n<N ; n++){
		for(j0=0 ; j0<J-1 ; j0++) {
			c = 0. ;
			compteur=0 ;
			p = 1 ;
			l = n/GIFS_pow_nj(2,J-(j0+1)) ;
			for(j=p ; j<=j0+1 ; j++){
				k = n/GIFS_pow_nj(2,J-j) ;
				indice = 2*(GIFS_pow_nj(2,j-1) -1 ) + k ;
				/*s = pow(2,-(double)l*pow(2.,-(double)(j0+1))) ;*/
				absc = Abs(Ci[indice]) ;
				if (absc <1 && absc >0.5){
					compteur++ ;
					
			
					c += log(absc)/log(2) ;
				}
				else {
					if (Abs(Ci[indice]) <= .5)
						c += -1.;
				}
				
			}	
			
			
			compteur = (double)(j0+1) ;
			if (compteur==0)
				c = 0 ;
			else
				c *= (double)(j0+1)/compteur ;
			y[j0] = -(c) ;
			
		}

		GIFS_slope(x,y,J-1,&pente,&r) ;
		H[n] = pente ;
	}

	free(x) ;
	free(y) ;

}
/*
void alpha_regression(Ci,J,H)
int J ;
double *Ci , *H ;
{
	int k , j , n , j0 , indice , N ,p , l;
	double r ,pente , c , compteur,s;
	double *x , *y ;
	void GIFS_slope() ;
	int GIFS_pow_nj() ;

	N = GIFS_pow_nj(2,J) ;

	for(n=0 ; n<N ; n++){
		c = 0. ;
		compteur=0 ;
		for(j=1 ; j<J ; j++) {
			
			
			p = 1 ;
			k = n/GIFS_pow_nj(2,J-j) ;
			indice = 2*(GIFS_pow_nj(2,j-1) -1 ) + k ;
			if((Abs(Ci[indice]) < 1 && Abs(Ci[indice]) >0.)){
				c += log(Abs(Ci[indice]))/log(2) ;
				compteur++ ;
			}
		}
		if(compteur==0)
			c = -(double)n/(double)N ;
		else
			c /= compteur ;
		H[n] = -c ;
	}
}
*/

void alpha_mediane(Ci,J,H)
int J ;
double *Ci , *H ;
{
	int k , j , n , j0 , indice , N ;
	double r ,pente , c ;
	double *y ;
	void GIFS_slope() ;
	int GIFS_pow_nj() ;
	int GIFS_compare() ;

	N = GIFS_pow_nj(2,J) ;

	if ((y = (double *)calloc(J-1,sizeof(double))) == NULL) {
                fprintf(stderr,"Je ne peux pas alouer le tableau des ordonnees de regession\n") ;
                exit(0);
        }

	for(n=0 ; n<N ; n++){
		for(j0=0 ; j0<J-1 ; j0++) {
			c = 0. ;
			for(j=1 ; j<=j0+1 ; j++){
				k = n/GIFS_pow_nj(2,J-j) ;
				indice = 2*(GIFS_pow_nj(2,j-1) -1 ) + k ;
				c += log(Abs(Ci[indice]))/log(2) ;
			}	
			y[j0] = -c/(double)(j0+1) ;
			
		}

		qsort((char *)y,J-1,sizeof(double),GIFS_compare) ;

		H[n] = y[(J-1)/2] ;
	}

	free(y) ;

}




