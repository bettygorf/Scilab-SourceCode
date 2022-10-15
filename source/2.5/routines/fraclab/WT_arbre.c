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

/* arbreWT.c */
/* module de gestin des arbres contenant la Transformee ondelette */
/* Bertrand Guiheneuf 1996 */


#include "WT_arbre.h"
#include <math.h> 
#include "WT_const.h"


#ifndef __STDC__
void const_arbreWT(ptr, arbre, taille, nb_iter)
     double *ptr;
     t_arbreWT *arbre;
     int taille;
     int nb_iter;
#else /* __STDC__ */
void const_arbreWT(double *ptr, /* pointeur sur la premiere fluctuation */
		   t_arbreWT *arbre,  /* ptr sur la premiere feuille de l'arbre */
		   int taille, /* taille du signal de depart */
		   int nb_iter /* nb d'iterrations de la TO */
		   )
#endif /* __STDC__ */

/* description : construit l'arbre destine a recevoir les feuilles de la WT */

{

/* variables locales */
int sz, /* taille de la feuille courante */
    iter; /* iterration courante */

  
double *ptr_crt; /* pointeur sur le data courant */  


/* routine */

/* initialisation des diverses variables */
sz = taille;
ptr_crt = ptr;

for (iter = 1; iter < nb_iter; iter++)
    {
      
      sz = (sz + 1)/2;

      arbre->dataG = ptr_crt;
      arbre->dataH = NULL;
      ptr_crt += sz;

      arbre->taille = sz;

      arbre++;
      
    }

/* la derniere feuille, on stoke tendance et fluctuation */

      sz = (sz + 1)/2;

      arbre->dataG = ptr_crt;
      ptr_crt += sz;
      arbre->dataH = ptr_crt;

      arbre->taille = sz;

}





