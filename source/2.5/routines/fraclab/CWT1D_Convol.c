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

/* Module de convolution de la transformee ondelettes continue */

/* Bertrand GUIHENEUF - FRACTALES 10/1996 */ 



#include "CWT1D_Filter.h"

#ifndef MIN
#define MIN(a,b) (a>b ? b : a)
#endif

#undef TEST_PERIOD
int CWT1D_Periodisation(Indice, Longueur)
     int Indice;
     int Longueur;
{
  
#ifdef TEST_PERIOD
  if (Indice>=0)
    printf("%d ",(Indice%Longueur));
  else
    printf("%d ",(Longueur -1 - ((-Indice-1)%Longueur)));
#endif
  
  if (Indice>=0)
    return(Indice%Longueur);
  else
    return(Longueur -1 - ((-Indice-1)%Longueur));
}






#undef OLD_FASHION_FILTERING
#ifdef OLD_FASHION_FILTERING
void CWT1D_Filtrage(double *ent, /* pointeur sur le tableau d'entree */
		    double *sor, /* pointeur sur le tableau de sortie */
		    int tailleX, /* Taille du tableau d'entree */
		    CWT1D_t_Filtre *filtre /* filtre de la convolution  */
		    )
  /* Convolution entre un signal et un filtre discret */
{
  
  /* Variables locales */
  int i, j, ligne;
  double tmp, *s_ptr, *e_deb_ligne, *s_deb_ligne, *conv_ptr, *ent_ptr, mirroir;
  /*-------------------------------------------------------------------------*/
  
  /* Convention : Le prefixe e_ pour entree */
  /*              Le prefixe s_ pour sortie */

  /* i est le point ou se fait la convolution dans  */
  /* le signal d'entree */
  
  
  e_deb_ligne=ent;
  s_deb_ligne=sor; /* pour la lisibilite */
  
  
  
  
  s_ptr=s_deb_ligne;
  /* premiere partie, le filtre deborde a gauche */
  for (i=0; i<filtre->taille_neg; i++, s_ptr++)
    {
      conv_ptr=e_deb_ligne+(filtre->taille_neg-i);
      tmp=0;
      
      for (j=0; j<filtre->taille_neg-i; j++, conv_ptr--)
	  tmp+=filtre->valeur[j]*((*conv_ptr));
      
      for (j=filtre->taille_neg-i; j<filtre->taille; j++, conv_ptr++)
	  tmp+=filtre->valeur[j]*(*conv_ptr);
      *s_ptr=tmp;
    }
  
  
  /* deuxieme partie, roule mon gars, roule ! */
  ent_ptr=e_deb_ligne+i-filtre->taille_neg;
  for (; i<tailleX-filtre->taille_pos; i++, s_ptr++, ent_ptr++)
      {
	conv_ptr=ent_ptr;
	tmp=0;
	for (j=0; j<filtre->taille; j++, conv_ptr++)
	    tmp+=filtre->valeur[j]*(*conv_ptr);
	*s_ptr=tmp;
      }
  
  
  /* troisieme partie, Ouppps! ca deborde a droite */	   
  for (; i<tailleX; i++, s_ptr++, ent_ptr++)
      {
	conv_ptr=ent_ptr;
	tmp=0;
	for (j=0; j<(tailleX-i+filtre->taille_neg); j++, conv_ptr++)
	    tmp+=filtre->valeur[j]*(*conv_ptr);
	
	conv_ptr-=2;
	
	for (j=(tailleX-i+filtre->taille_neg); j<(filtre->taille); j++, conv_ptr--)
	    tmp+=filtre->valeur[j]*((*conv_ptr));
	
	*s_ptr=tmp;
      }
  
}


#else /* OLD_FASHION_FILTERING */




void CWT1D_Filtrage(ent, sor, tailleX, filtre, period)
     double *ent;
     double *sor;
     int tailleX;
     CWT1D_t_Filtre *filtre;
     int (*period)();



{

/* Variables locales */
int i, j, ligne;
double tmp, *s_ptr, *e_deb_ligne, *s_deb_ligne, *conv_ptr, *ent_ptr, mirroir;
/*-------------------------------------------------------------------------*/

/* Convention : Le prefixe e_ pour entree */
/*              Le prefixe s_ pour sortie */
	   

e_deb_ligne=ent;
s_deb_ligne=sor; /* pour la lisibilite */


/* printf("\n%d %d %d %d \n",tailleX, filtre->taille_neg, filtre->taille, filtre->taille_pos); */

/* printf("Filtrage : ent=%p, sor=%p, taille=%d\n",ent,sor,tailleX); */

s_ptr=s_deb_ligne; /* printf("s_deb_ligne %p\n", s_ptr); */
/* premiere partie, le filtre deborde a gauche */
for (i=0; i<MIN(filtre->taille_neg,tailleX) ; i++, s_ptr++)
    {
      tmp=0; 
      for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++)
	  tmp+=filtre->valeur[j+filtre->taille_neg]*ent[(*period)(i+j,tailleX)];
      *s_ptr=tmp;
    }

/* deuxieme partie, roule mon gars, roule ! */
ent_ptr=e_deb_ligne+i-filtre->taille_neg;
for (; i<tailleX-filtre->taille_pos; i++, s_ptr++, ent_ptr++)
    {
      conv_ptr=ent_ptr;
      tmp=0;
      for (j=0; j<filtre->taille; j++, conv_ptr++)
	  tmp+=filtre->valeur[j]*(*conv_ptr);
      *s_ptr=tmp;
    }


/* troisieme partie, Ouppps! ca deborde a droite */	   
for (; i<tailleX; i++, s_ptr++)
    {
      tmp=0;
       for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++) 
	  tmp+=filtre->valeur[j+filtre->taille_neg]*ent[(*period)(i+j,tailleX)]; 
      *s_ptr=tmp; /* printf("%p ", &(ent[(*period)(i+j,tailleX)])); */
    }


}

#endif /* OLD_FASHION_FILTERING */
