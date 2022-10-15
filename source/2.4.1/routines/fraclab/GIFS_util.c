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
#include "FRACLAB_compat.h"


/* La fonction GIFS_pow_nj calcul n^j pour deux entiers n et j
*/
int GIFS_pow_nj(n,j)
register int n , j ;
{
	register int res = 1;

	if (j <= 0)
		return 1;

	while (j--)
		res *= n;
	return res;
}

int GIFS_compare(a,b)
double *a , *b ;
{
	if(*a > *b)
		return 1 ;
	else {
		if(*a < *b)
			return -1 ;
		else
			return 0 ;
	}
}

/*#define Infinity infinity()*/

void GIFS_slope(x,y,N,pente,r)
double *x,*y;
double *pente,*r;
int N;
{

	double EX=0,EY=0,EX2=0,EY2=0,EXY=0,sigX,sigY,CovXY;
	int i;



	for (i=0;i<N;i++) {
		EX+=x[i];
		EY+=y[i];
		EX2+=x[i]*x[i];
		EY2+=y[i]*y[i];
		EXY+=x[i]*y[i];
	}

	EX/=N;
	EY/=N;
	EX2/=N;
	EY2/=N;
	EXY/=N;

	CovXY=EXY-EX*EY;
	sigX=sqrt(fabs(EX2-EX*EX));
	sigY=sqrt(fabs(EY2-EY*EY));



	*r=CovXY/(sigX*sigY);

	if (fabs(sigX) < 1e-16)
		*pente = 0; /*Infinity;*/
	else
		if (fabs(sigY)<1e-16)
			*pente=0;
	else
		*pente=CovXY/(sigX*sigX);
	
}




