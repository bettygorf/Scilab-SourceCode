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

/* Module de calcul de la transformee ondelettes continue */

/* Bertrand GUIHENEUF - FRACTALES 10/1996 */ 

#include "CWT1D_WTransform.h"
#include "CWT1D_Filter.h"
#include "CWT1D_Wavelet.h"
#include "CWT1D_Convol.h"
#include <math.h>

#ifndef NULL
#define NULL 0
#endif


void CWT1D_WT(ent, taille, sor_reel, sor_complex, Psi, Filtre, a_min, a_max, nb_a)
     double *ent;
     int taille;
     double *sor_reel;
     double *sor_complex;
     CWT1D_t_Ondelette *Psi;
     CWT1D_t_Filtre *Filtre;
     double a_min;
     double a_max;
     int nb_a;
/* calcul de la trasformee a toutes les echelles */
{

    double a, a_inc, la, lamin, lamax;
    int ech; /* compteur de l'echelle */

    
    lamin = log(a_min);
    lamax = log(a_max);
    a_inc = (lamax-lamin)/(double)(nb_a-1); /* increment entre deux echelles */
    la = lamin;a = exp(la);

    for (ech=0; ech<nb_a; ech++)
	{
	  a = exp(la);
	    /* d'abord creer le filtre de l'echelle courante */
	    CWT1D_CreerFiltreReel( Psi, Filtre, a ); 
	    /* ensuite on convolue sur toute la ligne */
	    CWT1D_Filtrage( ent, &(sor_reel[ech*taille]), taille, Filtre, CWT1D_Periodisation );
	    /* passage a l'ehelle suivante */
	    la += a_inc;
	}


    if (sor_complex != NULL)
	{

	   la = lamin; /* echelle courante */ 

	  for (ech=0; ech<nb_a; ech++)
	      {
		a = exp(la);
		/* d'abord creer le filtre de l'echelle courante */
		CWT1D_CreerFiltreComplexe( Psi, Filtre, a ); 
		/* ensuite on convolue sur toute la ligne */
		CWT1D_Filtrage( ent, &(sor_complex[ech*taille]), taille, Filtre, CWT1D_Periodisation );
		/* passage a l'ehelle suivante */
		la += a_inc;
	      }
	  
	}
}




long CWT1D_Taille_WT(Taille, nb_a)
     int Taille;
     int nb_a;
/* Renvoie la taille de la transformee ondelettes */
{

    return( (long)Taille * (long)nb_a);

}


    


