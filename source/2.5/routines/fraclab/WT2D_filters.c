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

/* filtres.c */
/* Bertrand Guiheneuf 1997 */

#include <stdio.h>
#include <string.h>
#include "WT2D_filters.h"

/*****************************************************************************/
/*****************************************************************************/

void WT2D_calcul_filtre_conjugue(h,g)
/*****************************************************************************/
/*ENTREE: h est le filtre correspondant a la fonction d'echelle phi cad le   */
/*        filtre passe-bas du QMF                                            */
/*                                                                           */
/*****************************************************************************/
/*SORTIE: g contient le filtre conjugue de h, cad le filtre passe-haut       */
/*        correspondant a l'ondelette mere psi                               */
/*                                                                           */
/*****************************************************************************/

t_filtre_WT2D *h, *g;



{
int i,n,signe;

/*****************************************************************************/

if ((h->taille_pos-1)%2) signe=(-1);
	else signe=1;
for (i=0; i<(h->taille); i++, signe*=(-1))
	g->valeur[i]=(double)signe*(h->valeur[(h->taille)-1-i]);
/* g[n]=(-1)^n*h[1-n] selon la formule de I. Daubechies */

g->taille=h->taille; /* on ajuste alors les tailles du nouveau filtre */
g->taille_neg=(h->taille_pos)-1;
g->taille_pos=1+(h->taille_neg);


/*****************************************************************************/
}
