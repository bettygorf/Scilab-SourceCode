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
#include "WSAF_define.h"
#include "WSAF_util.h"

#define Abs(x) ((x) < 0 ? -(x) : (x))
#define carre(x) ((x)*(x))
#define Max(x,y) ((x) < (y) ? (y) : (x))

double signe(x)
double x ;
{
        if(x>=0.)
                return(1.) ;
        else
                return(-1.) ;
}

int treated(c,cmin,cmax)
double c , cmin , cmax;
{
  if( (Abs(c)>cmin) && (Abs(c)<cmax) )
    return(1) ;
  else
    return(0) ;

}
int non_vide(node)
NOEUD *node ;
{
	if((node->filsG != NULL) && (node->filsD != NULL))
		return(1) ;
	else
		return(0) ;
	
}

NOEUD *allouer_noeud(pere)
NOEUD *pere ;
{
	NOEUD *pt;
 
	pt=(NOEUD *)malloc(sizeof(NOEUD));
	if (pt==NULL){
		fprintf(stderr,"Je ne peux pas allouer le noeud \n");
		return(NULL);
	}
	pt->pere=pere; 
	pt->filsG=NULL;
	pt->filsD=NULL;

	return(pt);
}

/**** Cette fonction crée l'arbre binaire asociée à un GIFS à 2 branches ******/
/**** Elle associe à chaque noeud sa profondeur (level), son numero dans ******/
/**** l'arbre (rang), la numerotation se faisant de gauche à droite en descendant *****/
/**** puis son fils gauche (filsG) et droit (filsD) et le coefficient associe (coef).******/
NOEUD *create_tree(pr,i,j,J,Ci)
NOEUD *pr ;
int i , j , J;
double *Ci ;
{
	NOEUD *node ;
	NOEUD *allouer_noeud() ;

	
	node = allouer_noeud(pr) ;

	(node->level) = j ;
	(node->rang)  = i ;
	if(i < 0)
		(node->coef) = 0. ; 
	else 
		(node->coef) = Ci[i] ;

	if(node->level < (J-1)) {
		(node->pere)   = pr ;
		(node->filsG)  = create_tree(node,2*i+2,j+1,J,Ci) ;
		(node->filsD)  = create_tree(node,2*i+3,j+1,J,Ci) ;
	}
	else {
		(node->pere)   = pr ;
		(node->filsG)  = NULL ;
		(node->filsD)  = NULL ;
	}

	return(node) ;
}

void change_coefs(node,Ci,L0,L1,j0,j,a,b,COUNT)
int j0,j ;
NOEUD *node ;
double  *L0 , *L1 ,*Ci;
double a , b ;
int *COUNT;
{
	double coef_gauche , coef_droit , new_coef_gauche , new_coef_droit ,l0 , l1 ;
	
	if(non_vide(node)) {
		coef_gauche = (node->filsG)->coef ;
		coef_droit  = (node->filsD)->coef ;

		if(treated(coef_gauche,a,b) && ((node->filsG->level)>j0) ) {
		  (*COUNT)++;
		  l0 = L0[j] ;
		  if(l0==-1.) {
		    fprintf(stderr,"Pour le noeud %d qui est a l'echelle %d on a L0[%d]=-1 alors qu'il devrait pas\n",node->filsG->rang,node->filsG->level,j);
		    exit(1) ;
		  }
		  else
		    new_coef_gauche = signe(coef_gauche) * l0 ;
		}
		else
		  new_coef_gauche = coef_gauche ;

		if(treated(coef_droit,a,b) && ((node->filsD->level)>j0) ) {
		  (*COUNT)++;
		  l1 = L1[j] ;
		  if(l1==-1.) {
		    fprintf(stderr,"Pour le noeud %d qui est a l'echelle %d on a L1[%d]=-1 alors qu'il devrait pas\n",node->filsD->rang,node->filsD->level,j);
		    exit(1) ;
		  }
		  else
		    new_coef_droit  = signe(coef_droit) * l1 ;
		}
		else
		  new_coef_droit  = coef_droit ;

		node->filsG->coef = new_coef_gauche ; 
		node->filsD->coef = new_coef_droit ; 
		
		Ci[node->filsG->rang] = new_coef_gauche ;
		Ci[node->filsD->rang] = new_coef_droit ;
		
		change_coefs(node->filsG,Ci,L0,L1,j0,j+1,a,b,COUNT);
		change_coefs(node->filsD,Ci,L0,L1,j0,j+1,a,b,COUNT);	
	}
}	

void error_coefs(node,L0,L1,j0,j,errG,errD,a,b)
int j0,j ;
double  *L0 , *L1 ;
double *errG , *errD ;
NOEUD *node ;
double a , b ;
{
	double coef_gauche , coef_droit , new_coef_gauche , new_coef_droit , l0 , l1 ;
	
	if(non_vide(node)) {

		coef_gauche = (node->filsG)->coef ;
		coef_droit  = (node->filsD)->coef ;

		if(treated(coef_gauche,a,b) && ((node->filsG->level)>j0) ) {
		  l0 = L0[j] ;
		  if(l0==-1.) {
		    fprintf(stderr,"Pour le noeud %d qui est a l'echelle %d on a L0[%d]=-1 alors qu'il devrait pas\n",node->filsG->rang,node->filsG->level,j);
		    exit(1) ;
		  }
		  else
		    new_coef_gauche = signe(coef_gauche) * l0 ;
		}
		else
		  new_coef_gauche = coef_gauche ;

		if(treated(coef_droit,a,b) && ((node->filsD->level)>j0) ) {
		  l1 = L1[j] ;
		  if(l1==-1.) {
		    fprintf(stderr,"Pour le noeud %d qui est a l'echelle %d on a L1[%d]=-1 alors qu'il devrait pas\n",node->filsD->rang,node->filsD->level,j);
		    exit(1) ;
		  }
		  else
		    new_coef_droit  = signe(coef_droit) * l1 ;
		}
		else
		  new_coef_droit  = coef_droit ;

		(*errG) += Abs(coef_gauche - new_coef_gauche) ;
		(*errD) += Abs(coef_droit  - new_coef_droit) ;

		error_coefs(node->filsG,L0,L1,j0,j+1,errG,errD,a,b);
		error_coefs(node->filsD,L0,L1,j0,j+1,errG,errD,a,b);	
	}
}



void decoup_arbre(node,J,j0,seuil,Ci,Si,a,b,L0,L1,compteur,marks,lambda,size,COUNT)
NOEUD *node ;
int J  , j0 ;
double seuil , a , b ;
double *Ci , *Si , *L0 , *L1 , *marks , *lambda ;
int *compteur , *size ;
int *COUNT;
/*double a , b , M0 ;*/
{
	
	double errG , errD , err ;
	void construire_signal() ;
	void lambdai_compute() ;
	void lambdais() ;
	/**void print_lambdai() ; **/
	

	lambdai_compute(node,J,j0,Ci,Si,a,b,L0,L1) ;
	errG = 0. ;
	errD = 0. ;
	error_coefs(node,L0,L1,j0,0,&errG,&errD,a,b) ;

	err = (errG + errD) ;
	err /= (double)WSAF_pow_nj(4,node->level) ;
	/*fprintf(stderr,"le noeud %d a  une erreur = %f\n",node->rang,err) ; */

	if(err < seuil) {

	        construire_signal(node,J,compteur,marks) ;  
		change_coefs(node,Ci,L0,L1,j0,0,a,b,COUNT) ;
		/*** print_lambdai(node,J,L0,L1); ***/
		lambdais(node,Ci,J,a,b,lambda,size) ;
		
	}

	else {
		decoup_arbre(node->filsG,J,j0,seuil,Ci,Si,a,b,L0,L1,compteur,marks,lambda,size,COUNT) ;
		decoup_arbre(node->filsD,J,j0,seuil,Ci,Si,a,b,L0,L1,compteur,marks,lambda,size,COUNT) ;
	}

}

void construire_signal(node,J,compteur,Extremity) 
NOEUD *node ;
int J, *compteur ;
double *Extremity ;
{
	int n , Jj , left_extremity , right_extremity ;
	int tree_left_extremity() ;


	(*compteur) ++ ;
	Jj = WSAF_pow_nj(2,J-(node->level)) ;
	left_extremity = ((node->rang) - tree_left_extremity(node->level)) * Jj ;
	right_extremity = left_extremity + Jj ;

	Extremity[(*compteur)-1] = (double)left_extremity +1;

	/* 
	fprintf(stderr,"**********************************\n"); 
	fprintf(stderr,"La partie %d va de %d a %d\n",*compteur,left_extremity,right_extremity); 
	fprintf(stderr,"**********************************\n"); 
	fprintf(stderr,"Le numero du noeud correspondant est  %d\n",node->rang) ; 
	fprintf(stderr,"-------------------------------------------------\n"); 
	*/
}

	
int tree_left_extremity(j) 
int j ;
{
	int p , k=0 ;
	int WSAF_pow_nj() ;

	if(j>0) {
		for(p=1 ; p<j ; p++)
			k += WSAF_pow_nj(2,p) ;
		return(k) ;
	}
	else
		return(-1) ;
}


	
void tree_free(node)
NOEUD *node ;
{
	if(node != NULL) {
		
		tree_free(node->filsG) ;
		tree_free(node->filsD) ;
	}
	
	free(node) ;
}

void tree_print(node)
NOEUD *node ;
{
	if (node != NULL) {
		fprintf(stderr,"%d\t",node->level);
		tree_print(node->filsG);
		tree_print(node->filsD);
	}

}

void lambdai_compute(node,J,j0,Ci,Si,a,b,L0,L1)
NOEUD *node ;
int J , j0 ;
double a , b ;
double *Ci , *Si ,*L0 , *L1;
{
  int i,k,j,n,k0,p0,n0,a0,knj,knj0,bool ;
  double c,s,delta,Num , Den, c_bis,c_temp ,c0,c1,l0,l1;

  n0 = node->level ;
  k0 = (node->rang) - WSAF_pow_nj(2,n0) + 2 ;
  p0 = Max(n0,j0) ;

  if(n0 < j0) {
    for(n=n0+1 ; n<=j0 ; n++) {
      L0[n-n0-1] = -1. ;
      L1[n-n0-1] = -1. ;
    }
    n = j0+1 ;
    a0 = WSAF_pow_nj(2,n-n0-1) ;
    for(i=0 ; i<=1 ; i++) {
      Num = 0. ;
      Den = 0. ;
      bool = 0 ;
      for(k=a0*k0 ; k<a0*(k0+1) ; k++) {
	c = Ci[2*k+i + WSAF_pow_nj(2,n) - 2]; /** Ci(2*k+i,n) **/
	if(treated(c,a,b)) {
	  bool = 1 ;
	  s = carre(Si[k]) ;
	  Num += s*Abs(c) ;
	  Den += s ;
	}
      }
      if(bool) {
	if(i)
	  L1[n-n0-1] = Num/Den ;
	else
	  L0[n-n0-1] = Num/Den ;
      }
      else {
	if(i)
	  L1[n-n0-1] = -1. ;
	else
	  L0[n-n0-1] = -1. ;
      }
    }    
  }
  
  else {
    n= p0+1 ;   /** ou n0+1 **/
    c0 = Ci[2*k0 + WSAF_pow_nj(2,n) - 2] ;   /** Ci(2*k0,n) **/
    c1 = Ci[2*k0+1 + WSAF_pow_nj(2,n) - 2] ;  /** Ci(2*k0,n) **/
    if(treated(c0,a,b))
      L0[n-n0-1] = Abs(c0) ;
    else
      L0[n-n0-1] = -1. ;
    if(treated(c1,a,b))
      L1[n-n0-1] = Abs(c1) ;
    else
      L1[n-n0-1] = -1. ;
  }

  for(n=p0+2 ; n<J ; n++) {
    for(i=0 ; i<=1 ; i++) {
      Num = 0. ;
      Den = 0. ;
      bool = 0 ;
      a0 = WSAF_pow_nj(2,n-n0-1) ;
      for(k=a0*k0 ; k<a0*(k0+1) ; k++) {
	c = Ci[2*k+i + WSAF_pow_nj(2,n) - 2]; /** Ci(2*k+i,n) **/
	if (treated(c,a,b)) {
	  bool = 1 ;
	  knj0 = (int)((2*k+i)/WSAF_pow_nj(2,n-j0)) ;
	  if(knj0>=WSAF_pow_nj(2,j0)) {
	    fprintf(stderr,"Probleme\n");
	    exit(1);
	  }
	  s = carre(Si[knj0]) ;
	  delta = 1. ;
	  c_bis = 1. ;
	  for(j=j0+1 ; j<=n-1 ; j++) {
	    knj = (int)((2*k+i)/WSAF_pow_nj(2,n-j)) ;
	    c_temp = Ci[knj + WSAF_pow_nj(2,j) - 2] ; /** Ci(knj,j) **/
	    if ((!treated(c_temp,a,b)) || (j<=p0)) {
	      delta *= Abs(c_temp) ;
	    }
	    else {
	      /*delta *= lambdai_compute(knj%2,j,k0,n0,j0,Ci,Si) ;*/
	      if((knj%2)==0) {
		l0 = L0[j-n0-1] ;
		if(l0==-1.) {
		  fprintf(stderr,"Pour le noeud Ci(%d,%d) on a L0[%d]=-1 sans raison\n",k0,n0,j-n0-1) ;
		  exit(1) ;
		}
		else
		  delta *= l0 ;
	      }
	      else {
		l1 = L1[j-n0-1] ;
		if(l1==-1.) {
		  fprintf(stderr,"Pour le noeud Ci(%d,%d) on a L1[%d]=-1 sans raison\n",k0,n0,j-n0-1) ;
		  exit(1) ;
		}
		else
		  delta *= l1 ;
	      }	
	    }
	    c_bis *= Abs(c_temp) ; /** Ci(knj,j) **/
	  }
	  Num += s*delta*c_bis*Abs(c) ;
	  Den += s*carre(delta) ;
	}
      }
      if(bool){
	if(i)
	  L1[n-n0-1] = Num/Den ;
	else
	  L0[n-n0-1] = Num/Den ;
      }
      else {
	if(i)
	  L1[n-n0-1] = -1. ;
	else
	  L0[n-n0-1] = -1. ;
      }
    }
    /*if(L0[n-n0-1]==-1.)
      fprintf(stderr,"L0[%d]=-1 pour le noeud %d\n",n-n0-1,node->rang) ; 
    if(L1[n-n0-1]==-1.) 
      fprintf(stderr,"L1[%d]=-1 pour le noeud %d\n",n-n0-1,node->rang) ;*/
    
  }


}

/**
void print_lambdai(node,J,L0,L1)
NOEUD *node;
int J;
double *L0 , *L1 ;
{
  int n , n0 ;

  n0 = node->level ;

  fprintf(stdout,"%d %d\n",n0+1,J);
  for(n=0; n<J-n0-1 ; n++) 
    fprintf(stdout,"%f ",L0[n]) ;
  fprintf(stdout,"\n") ;
  for(n=0; n<J-n0-1 ; n++) 
    fprintf(stdout,"%f ",L1[n]) ;
  fprintf(stdout,"\n\n") ;
}
**/

void lambdais(node,Ci,J,a,b,Res,p)
NOEUD *node ;
int *p ;
double a , b ;
double *Ci, *Res ;
{
        int i,j,k,l,l2,size ;
	double c ;

	i = node->rang ;
	j = node->level ;
	Res[(*p)] = (double)J-j-1 ;

	for(l2=2, l=1 ; l<=J-j-1 ; l++, l2+=l2) {
	  i = 2*(i+1) ;
	  (*p)++ ;
	  Res[(*p)] = -1 ;
	  for(k=i ; k<=i+l2-1 ; k+=2) {
	    c =Abs(Ci[k]) ; 
	    if((c >a) && (c<b)) {
		Res[(*p)] = c ;
		break ;
	    }

	  }
		
	}
	i = node->rang ;
	for(l2=2, l=1 ; l<=J-j-1 ; l++, l2+=l2) {
	  i = 2*(i+1) ;
	  (*p)++ ;
	  Res[(*p)] = -1;
	  for(k=i+1 ; k<=i+l2-1 ; k+=2) {
	    c =Abs(Ci[k]) ; 
	    if((c >a) && (c<b)) {
		Res[(*p)] = c ;
		break ;
	    }

	  }
		
	}
	(*p)++ ;
}
	   

