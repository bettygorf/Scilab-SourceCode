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

/* module de calcul des transformee ondelettes 1D */
/* Bertrand Guiheneuf 1997 */

#ifndef INCLUDE_WAVELET_TRANSFORM2D
#define INCLUDE_WAVELET_TRANSFORM2D


#include "WT2D_filters.h"
#include "WT2D_arbre.h"


/*%%%%%%%%%%%%%%%%%%%%%% PROTOTYPES %%%%%%%%%%%%%%%%%%%%%%*/

#ifndef __STDC__
extern int WT2D_Periodisation();


extern void Filtrage2D();
#else /* __STDC__ */
extern int WT2D_Periodisation(int Indice,
			    int Longueur
			    );


extern void Filtrage2D(double *ent,                     /* entree du filtrage */
		       double *sor1,                    /* sortie de la combinaison h puis v1 */
		       double *sor2,                    /* sortie de la combinaison h puis v2 */
		       double *temp,                    /* temporaire de la taille de ent */
		       int tailleX,                     /* largeur de l'entree */
		       int tailleY,                     /* hauteur de l'entree */
		       t_filtre_WT2D *filtre_h,         /* filtre en horizontal */
		       t_filtre_WT2D *filtre_v1,        /* filtre en vertical pour sor1 */
		       t_filtre_WT2D *filtre_v2,        /* filtre en vertical pour sor2 */
		       int (*period)(int, int)
		       );
#endif /* __STDC__ */

/* calcul dans sor1 la sortie des filtres h et v1 resp. en horiz. et en vert. */
/* calcul dans sor2 la sortie des filtres h et v2 resp. en horiz. et en vert. */
/* temp est un tableau de temporaire qui doit etre de la taille de ent */



#ifndef __STDC__
extern void WT2D();
#else /* __STDC__ */
extern void WT2D(t_arbreWT2D *arbre,      /* pointeur su un arbre non construit mais dont la place est deja allouee */
		 double *ent,             /* pointeur su l'image d'entree */
		 double *sor,             /* pointeur de sortie */
		 double *temp1,           /* pointeur sur un tableau de double temporaire */
		 double *temp2,           /* pointeur sur un autre tab de double de la meme taille */
		 t_filtre_WT2D *h,        /* fltre passe bas de la transformee */
		 int nb_iter,             /* nombre d'iterations de l'algorithme */
		 int tailleX,             /* largeur de l'image de depart */
		 int tailleY,             /* hauteur de l'image de depart */
		 int (*period)(int, int)
		 );
#endif /* __STDC__ */

/* Rq: temp1 et temp2 sont deux tableaux de temporaires qui doivent avoir la taille de       */
/* l'image de depart. On aurait ou faire des economies, a revoir en cas de necessite absolue */



#ifndef __STDC__
void WT2DInverse();
#else /* __STDC__ */
void WT2DInverse(t_arbreWT2D *arbre,  /* pointeur sur un tableau de noeuds */
		 double *sor,         /* ptr sur l'image de sortie*/
		 double *temp,        /* ptr sur un tableau de double temporaire 
			                 de la taille de l'image d'entree */
		 t_filtre_WT2D *h,         /* filtre passe bas */
		 int nb_iter,         /* nb d'iteration de l'algorithme */
		 int tailleX,         /* largeur de l'image de depart */
		 int tailleY,         /* hauteur de l'image */
		 int (*period)(int, int)
);
#endif /* __STDC__ */

/* ATTENTION, il faut pour l'instant reserver un peu plus de place pour sor et temp */


#endif /* INCLUDE_WAVELET_TRANSFORM2D */



