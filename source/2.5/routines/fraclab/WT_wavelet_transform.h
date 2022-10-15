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

/* wavelet_transform.h */
/* module de calcul des transformee ondelettes 1D */
/* Bertrand Guiheneuf 1996*/

#ifndef INCLUDE_WAVELET_TRANSFORM
#define INCLUDE_WAVELET_TRANSFORM


#include "WT_filters.h"
#include "WT_arbre.h"
#include "WT_filters.h"





/*%%%%%%%%%%%%%%%%%%%%%% PROTOTYPES %%%%%%%%%%%%%%%%%%%%%%*/

#ifndef __STDC__
extern void Filtrage();
#else /* __STDC__ */
extern void Filtrage(double *ent, /* pointeur sur le tableau d'entree */
		     double *sor, /* pointeur sur le tableau de sortie */
		     int tailleX, /* Taille du tableau de sortie */
		     t_filtre *filtre, /* filtre de la transformee */
		     int (*period)(int, int)
		     );
#endif /* __STDC__ */
/* description */
/* calcul d'une feuille d'un arbre, soit d'une TO standard */
/* soit d'une Transformee en paquets d'ondelettes */
/* elle sert juste a l'application d'un filtre unique */


#ifndef __STDC__
extern void WT1D();
#else /* __STDC__ */
extern void WT1D(t_arbreWT *arbre,/* pointeur sur un tableau de noeuds */
		 double *ent,     /* ptr sur le signal d'entree */
		 double *sor,     /* ptr sur le signal de sortie */
		 double *temp,    /* ptr sur un tableau de double temporaire 
				     de la taille du signal d'entree */
		 t_filtre *h,     /* filtre passe bas */
		 int nb_iter,     /* nb d'iteration de l'algorithme */
		 int taille,       /* taille du signal de depart */
		 int (*period)(int, int)
		 );
#endif /* __STDC__ */



#ifndef __STDC__
extern void WT1DInverse();
#else /* __STDC__ */
extern void WT1DInverse(t_arbreWT *arbre,/* pointeur sur un tableau de noeuds */
			double *sor,     /* ptr sur le signal de sortie */
			double *temp,    /* ptr sur un tableau de double temporaire 
					    de la taille du signal d'entree */
			t_filtre *h,     /* filtre passe bas */
			int nb_iter,     /* nb d'iteration de l'algorithme */
			int taille,       /* taille du signal de depart */
			int (*period)(int, int)
			);
#endif /* __STDC__ */
  
#ifndef __STDC__
extern int WT_Periodisation();
#else /* __STDC__ */
extern int WT_Periodisation(int Indice,
			    int Longueur
			    );
#endif /* __STDC__ */


#endif /* INCLUDE_WAVELET_TRANSFORM */
