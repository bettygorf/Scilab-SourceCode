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

/* arbreWT.h */
/* header module de definition des arbres de la transformee ondelette */
/* Bertrand Guiheneuf 1996 */

#ifndef INCLUDE_ARBREWT
#define INCLUDE_ARBREWT

typedef struct _arbreWT
{
  double *dataH,
         *dataG;
  int taille;

} t_arbreWT;




/*%%%%%%%%%%%%%%%%%%%% PROTOTYPES %%%%%%%%%%%%%%%%%%%*/

#ifndef __STDC__
extern void const_arbreWT();
#else /* __STDC__ */
extern void const_arbreWT(double *ptr, /* pointeur sur la premiere fluctuation */
			  t_arbreWT *arbre,  /* ptr sur la premiere feuille de l'arbre */
			  int taille, /* taille du signal de depart */
			  int nb_iter /* nb d'iterrations de la TO */
			  );
#endif /* __STDC__ */
/* description : construit l'arbre destine a recevoir les feuilles de la WT */


#endif /* INCLUDE_ARBREWT */
