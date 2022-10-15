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


#define Abs(x) ((x) < 0 ? -(x) : (x))

void coef_triangle2triangle_map(triangle1,triangle2,coefs)
TRIANGLE *triangle1 ;
TRIANGLE *triangle2 ;
double *coefs ;
{
	int flag1 , flag2 ;
	int count_ci_null=0 , count_ci_infty=0 , count_ci_big=0 , count_ci_mid=0, count_ci_mid2=0, cast=0 ;

	double Ix , Iy , Jx , Jy , Kx , Ky , Ux , Uy , Vx , Vy , Wx , Wy ,eps;
	int aligne() ;

	eps = .0000000001 ;

	Ix = (triangle1->som1)[0] ;
	Iy = (triangle1->som1)[1] ;

	Jx = (triangle1->som2)[0] ;
	Jy = (triangle1->som2)[1] ;

	Kx = (triangle1->som3)[0] ;
	Ky = (triangle1->som3)[1] ;

	Ux = (triangle2->som1)[0] ;
	Uy = (triangle2->som1)[1] ;

	Vx = (triangle2->som2)[0] ;
	Vy = (triangle2->som2)[1] ;

	Wx = (triangle2->som3)[0] ;
	Wy = (triangle2->som3)[1] ;

	flag1 = aligne(Ux,Uy,Vx,Vy,Wx,Wy,eps) ;
	flag2 = aligne(Ix,Iy,Jx,Jy,Kx,Ky,eps) ;
        if(flag2) {
		coefs[4] = 1. ;
		count_ci_infty++ ;
	}
	if(flag1) {
		coefs[4] = .25 ;
		count_ci_null++ ;
	}
	if(!flag1 && !flag2) {
		coefs[1] = ((Ix-Kx)*(Ux-Vx) - (Ux-Wx)*(Ix-Jx))/((Ix-Kx)*(Iy-Jy) - (Iy-Ky)*(Ix-Jx)) ;
		coefs[0] = ((Ux-Vx)-coefs[1]*(Iy-Jy))/(Ix-Jx) ;
		coefs[2] = Ux - coefs[0]*Ix - coefs[1]*Iy ;

		coefs[4] = ((Ix-Kx)*(Uy-Vy) - (Uy-Wy)*(Ix-Jx))/((Ix-Kx)*(Iy-Jy) - (Iy-Ky)*(Ix-Jx)) ;

		if(Abs(coefs[4]) >= 1)
			count_ci_big++ ;

		if(Abs(coefs[4]) < .5)
			count_ci_mid++ ;
		if( (Abs(coefs[4]) >= .5) && (Abs(coefs[4]) < 1))
			count_ci_mid2++ ;
		   
		if(cast) 
			if(Abs(coefs[4]) >= 1) {
				coefs[4] /= Abs(coefs[4]) ;
			}

		coefs[3] = ((Uy-Vy)-coefs[4]*(Iy-Jy))/(Ix-Jx) ;
		coefs[5] = Uy - coefs[3]*Ix - coefs[4]*Iy ;

		if(coefs[4] == 0.){
			fprintf(stderr,"J'ai un c_i nul %.15f\n",coefs[4]);
			fprintf(stderr,"Je mappe le triangle|%f,%f,%f| sur le triangle|%f,%f,%f|\n",Ix,Jx,Kx,Ux,Vx,Wx);
			fprintf(stderr,"                    |%f,%f,%f|                |%f,%f,%f|\n\n",Iy,Jy,Ky,Uy,Vy,Wy);
			exit(0);
		}
		      
	}
}

void print_triangle(triangle)
TRIANGLE *triangle ;
{
	fprintf(stdout,"%f %f\n",(triangle->som1)[0],(triangle->som1)[1]);
	fprintf(stdout,"%f %f\n",(triangle->som2)[0],(triangle->som2)[1]);
	fprintf(stdout,"%f %f\n",(triangle->som3)[0],(triangle->som3)[1]);
}
  
int aligne(x1,y1,x2,y2,x3,y3,eps)
double  x1,y1,x2,y2,x3,y3,eps;
{
	double a , b , ord_x2 ;

	a = (y3-y1)/(x3-x1) ;
	b = y1 - a*x1 ;
	ord_x2 = a*x2 + b ;

	if(Abs(y2-ord_x2) <= eps) 
		return(1) ;
	else
		return(0) ;
}
