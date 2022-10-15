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

/* Module de gestion de l'ondelettes continue */

/* Bertrand GUIHENEUF - FRACTALES 10/1996 */ 


#include "CWT1D_Filter.h"
#include "CWT1D_Wavelet.h"
#include <math.h>



void CWT1D_CreerFiltreReel(Psi, Filtre, a)
     CWT1D_t_Ondelette *Psi;
     CWT1D_t_Filtre *Filtre;
     double a;
 
{
  
  int i_min, i_max; /* indices min et max du filtre */
  double x;
  int i_filtre = 0;
  int i; 
  
  i_min = (int)floor(a * Psi->xmin); /* premier indice du filtre */
  i_max = (int)ceil(a * Psi->xmax); /* dernier indice du filtre */
  
  
  x = (double)i_min;


  for (i=i_min; i<=i_max; i++)
      {     
	Filtre->valeur[i_filtre++] = 1.0/a * (*Psi->ValeurReelle)(x/a);
	x += 1.0;
      }

  Filtre->taille_neg = -i_min;
  Filtre->taille_pos = i_max;
  Filtre->taille = i_max - i_min + 1;

}



void CWT1D_CreerFiltreComplexe(Psi, Filtre, a)
     CWT1D_t_Ondelette *Psi;
     CWT1D_t_Filtre *Filtre;
     double a;
  
{
  
  int i_min, i_max; /* indices min et max du filtre */
  double x;
  int i_filtre = 0;
  int i; 
  
  i_min = (int)floor(a * Psi->xmin); /* premier indice du filtre */
  i_max = (int)ceil(a * Psi->xmax); /* dernier indice du filtre */


  x = (double)i_min;


  for (i=i_min; i<=i_max; i++)
      {     
	Filtre->valeur[i_filtre++] = 1.0/a * (*Psi->ValeurComplexe)(x/a);
	x += 1.0;
      }

  Filtre->taille_neg = -i_min;
  Filtre->taille_pos = i_max;
  Filtre->taille = i_max - i_min + 1;

}




