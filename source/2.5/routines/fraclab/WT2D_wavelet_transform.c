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

/* Bertrand Guiheneuf 1997 */


#include "WT2D_filters.h"
#include "WT2D_wavelet_transform.h"
#include "WT2D_arbre.h"
#include <math.h>

#ifndef MIN
#define MIN(a,b) (a > b ? b : a)
#endif
#undef TEST_PERIOD

#ifndef __STDC__
int WT2D_Periodisation(Indice, Longueur)
     int Indice;
     int Longueur;
#else /* __STDC__ */
int WT2D_Periodisation(int Indice,
		       int Longueur)
#endif /* __STDC__ */
{
  
  
  
  if (Indice>=0)
    return(Indice%Longueur);
  else
    return(Longueur -1 - ((-Indice-1)%Longueur));
  


}


/* PREMIERE PARTIE : D E C O M P O S I T I O N */
/***********************************************/

#ifndef __STDC__
void Filtrage2D(ent, sor1, sor2, temp, tailleX, tailleY, filtre_h, filtre_v1, filtre_v2, period)
     double *ent;
     double *sor1;
     double *sor2;
     double *temp;
     int tailleX;
     int tailleY;
     t_filtre_WT2D *filtre_h;
     t_filtre_WT2D *filtre_v1;
     t_filtre_WT2D *filtre_v2;
     int (*period)();
#else /* __STDC__ */
void Filtrage2D(double *ent,                     /* entree du filtrage */
		double *sor1,                    /* sortie de la combinaison h puis v1 */
		double *sor2,                    /* sortie de la combinaison h puis v2 */
		double *temp,                    /* temporaire de la taille de ent */
		int tailleX,                     /* largeur de l'entree */
		int tailleY,                     /* hauteur de l'entree */
		t_filtre_WT2D *filtre_h,              /* filtre en horizontal */
		t_filtre_WT2D *filtre_v1,             /* filtre en vertical pour sor1 */
		t_filtre_WT2D *filtre_v2,             /* filtre en vertical pour sor2 */
		int (*period)(int, int)
		)
#endif /* __STDC__ */

/* calcul dans sor1 la sortie des filtres h et v1 resp. en horiz. et en vert. */
/* calcul dans sor2 la sortie des filtres h et v2 resp. en horiz. et en vert. */
/* temp est un tableau de temporaire qui doit etre de la taille de ent */

{

/* Variables locales */
int i, j, ligne, longx, longy;
double tmp, *s_ptr, *e_deb_ligne, *s_deb_ligne, *conv_ptr, *ent_ptr;
/*-------------------------------------------------------------------------*/

/* Routine */


/* premiere partie de l'algorithme                                           */
/*                                                                           */
/* on applique le filtre_h sur l'horizontal                                  */
/* le resultat est la transpose de la transformee                            */


	   
longx=(tailleX+1)/2;
longy=(tailleY+1)/2;
e_deb_ligne=ent;
s_deb_ligne=temp;


/* Voir les conmmentaires sur la deuxieme partie qui en tout point         */
/* semblable a celle si!                                                   */

for (ligne=0; ligne<tailleY; ligne++)
{
	   
	   s_ptr=s_deb_ligne;
	   for (i=0; i<MIN(filtre_h->taille_neg,tailleX) ; i+=2, s_ptr+=tailleY)
	     {
	       tmp=0; 
	       for (j=-filtre_h->taille_neg; j<=filtre_h->taille_pos; j++)
		 tmp+=filtre_h->valeur[j+filtre_h->taille_neg]*e_deb_ligne[(*period)(i+j,tailleX)];
	       *s_ptr=tmp;
	     }


	   ent_ptr=e_deb_ligne+i-filtre_h->taille_neg;
	   for (; i<tailleX-filtre_h->taille_pos; i+=2, s_ptr+=tailleY, ent_ptr+=2)
	   {
			 conv_ptr=ent_ptr;
			 tmp=0;
			 for (j=0; j<filtre_h->taille; j++, conv_ptr++)
				    tmp+=filtre_h->valeur[j]*(*conv_ptr);
			 *s_ptr=tmp;
	   }
	   

	   for (; i<tailleX; i+=2, s_ptr+=tailleY)
	     {
	       tmp=0;
	       for (j=-filtre_h->taille_neg; j<=filtre_h->taille_pos; j++) 
		 tmp+=filtre_h->valeur[j+filtre_h->taille_neg]*e_deb_ligne[(*period)(i+j,tailleX)]; 
	       *s_ptr=tmp; 
	     }

	   
	   e_deb_ligne+=tailleX;
	   s_deb_ligne++;
}


/* deuxieme partie de l'algorithme                                           */
/*                                                                           */
/* moyennant quelques petites modif, en particulier au niveau de la taille   */
/* des tableaux, et des tableaux d'entree et de sortie,(ouf!) on reprend     */
/* le principe du premier algorithme                                         */
/*                                                                           */
/*                                                                           */

	   
    
e_deb_ligne=temp;
s_deb_ligne=sor1;



for (ligne=0; ligne<longx; ligne++)
{
	   
	   s_ptr=s_deb_ligne;
	   
	   for (i=0; i<MIN(filtre_v1->taille_neg,tailleY) ; i+=2, s_ptr+=longx)
	     {
	       tmp=0; 
	       for (j=-filtre_v1->taille_neg; j<=filtre_v1->taille_pos; j++)
		 tmp+=filtre_v1->valeur[j+filtre_v1->taille_neg]*e_deb_ligne[(*period)(i+j,tailleY)];
	       *s_ptr=tmp;
	     }


	   ent_ptr=e_deb_ligne+i-filtre_v1->taille_neg;
	   for (; i<tailleY-filtre_v1->taille_pos; i+=2, s_ptr+=longx, ent_ptr+=2)
	   {
			 conv_ptr=ent_ptr;
			 tmp=0;
			 for (j=0; j<filtre_v1->taille; j++, conv_ptr++)
				    tmp+=filtre_v1->valeur[j]*(*conv_ptr);
			 *s_ptr=(tmp);
	   }
	   
	   for (; i<tailleY; i+=2, s_ptr+=longx)
	     {
	       tmp=0;
	       for (j=-filtre_v1->taille_neg; j<=filtre_v1->taille_pos; j++) 
		 tmp+=filtre_v1->valeur[j+filtre_v1->taille_neg]*e_deb_ligne[(*period)(i+j,tailleY)]; 
	       *s_ptr=tmp; 
	     }

	   

	   
	   e_deb_ligne+=tailleY;
	   s_deb_ligne++;

} 
 
	   
 
e_deb_ligne=temp;
s_deb_ligne=sor2;

for (ligne=0; ligne<longx; ligne++)
{
  
  s_ptr=s_deb_ligne;
  
  for (i=0; i<MIN(filtre_v2->taille_neg,tailleY) ; i+=2, s_ptr+=longx)
    {
      tmp=0; 
      for (j=-filtre_v2->taille_neg; j<=filtre_v2->taille_pos; j++)
	tmp+=filtre_v2->valeur[j+filtre_v2->taille_neg]*e_deb_ligne[(*period)(i+j,tailleY)];
      *s_ptr=tmp;
    }
  
  
  ent_ptr=e_deb_ligne+i-filtre_v2->taille_neg;
  for (; i<tailleY-filtre_v2->taille_pos; i+=2, s_ptr+=longx, ent_ptr+=2)
    {
      conv_ptr=ent_ptr;
      tmp=0;
      for (j=0; j<filtre_v2->taille; j++, conv_ptr++)
	tmp+=filtre_v2->valeur[j]*(*conv_ptr);
      *s_ptr=(tmp);
    }
     
  for (; i<tailleY; i+=2, s_ptr+=longx)
    {
      tmp=0;
      for (j=-filtre_v2->taille_neg; j<=filtre_v2->taille_pos; j++) 
	tmp+=filtre_v2->valeur[j+filtre_v2->taille_neg]*e_deb_ligne[(*period)(i+j,tailleY)]; 
      *s_ptr=tmp; 
    }
  
  
  
  
  e_deb_ligne+=tailleY;
  s_deb_ligne++;
  
} 




}







#ifndef __STDC__
void WT2D(arbre, ent, sor, temp1, temp2, h, nb_iter, tailleX, tailleY, period)
     t_arbreWT2D *arbre;
     double *ent;
     double *sor;
     double *temp1;
     double *temp2;
     t_filtre_WT2D *h;
     int nb_iter;
     int tailleX;
     int tailleY;
     int (*period)();
#else /* __STDC__ */
void WT2D(t_arbreWT2D *arbre,      /* pointeur su un arbre non construit mais dont la place est deja allouee */
          double *ent,             /* pointeur su l'image d'entree */
          double *sor,             /* pointeur de sortie */
          double *temp1,           /* pointeur sur un tableau de double temporaire */
          double *temp2,           /* pointeur sur un autre tab de double de la meme taille */
          t_filtre_WT2D *h,             /* fltre passe bas de la transformee */
          int nb_iter,             /* nombre d'iterations de l'algorithme */
          int tailleX,             /* largeur de l'image de depart */
          int tailleY,              /* hauteur de l'image de depart */
	  int (*period)(int,int)
)
#endif /* __STDC__ */

/* Rq: temp1 et temp2 sont deux tableaux de temporaires qui doivent avoir la taille de       */
/* l'image de depart. On aurait ou faire des economies, a revoir en cas de necessite absolue */


{

/* Variables locales */
/*-------------------*/

t_filtre_WT2D g;
int iter;
double *entree;



/* Routine */
/*---------*/


/* construire l'arbre */
const_arbreWT2D( sor, arbre, tailleX, tailleY, nb_iter);

/* calculer g */
WT2D_calcul_filtre_conjugue(h, &g);



/* Allez!!!! */

entree = ent;
for (iter=1; iter<nb_iter; iter++)
    { 
      /* Calculer les sorties HH HG GH GG */
      Filtrage2D(entree, arbre->dataGH, arbre->dataGG, temp1, tailleX, tailleY, &g, h, &g, period);
      Filtrage2D(entree, arbre->dataHG, temp2, temp1, tailleX, tailleY, h, &g, h, period);

      /* attention a l'ordre du filtrage. On peut ecraser temp2 pour effectuer le second */
      /* filtrage puisque dans l'algo c'est temp1 qui sert d'entree */
      /* MAIS ATTENTION A TOUTE MODIFICATION */




      arbre++;
      entree = temp2;
      tailleX = (tailleX + 1)/2;
      tailleY = (tailleY + 1)/2;
    
    }

/* puis le dernier etage: stocker tout le monde */

Filtrage2D(entree, arbre->dataGH, arbre->dataGG, temp1, tailleX, tailleY, &g, h, &g, period);
Filtrage2D(entree, arbre->dataHG, arbre->dataHH, temp1, tailleX, tailleY, h, &g, h, period);
      
}
  






/* DEUXIEME PARTIE : R E C O N S T R U C T I O N */
/*************************************************/


#ifndef __STDC__
void FiltrageInverse2D(ent, sor, tailleX, tailleY, filtre, period, decal)
     double *ent;
     double *sor;
     int tailleX;
     int tailleY;
     t_filtre_WT2D *filtre;
     int (*period)();
     int decal;
#else /* __STDC__ */
void FiltrageInverse2D(double *ent,            /* entree du filtrage */
		       double *sor,            /* sortie de 2 fois la taille de ent */
		       int tailleX,            /* largeur de l'entree */
		       int tailleY,            /* hauteur de l'entree */
		       t_filtre_WT2D *filtre,       /* filtre en horizontal */
		       int (*period)(int,int),
		       int decal               /* decalage de la sortie: 0 ou 1 */
		       )
#endif /* __STDC__ */

/* calcul dans sor la sortie transposee du filtre en horizontal */

{

/* Variables locales */
/*-------------------*/

int i, j, ligne, saut;
double tmp, *s_ptr, *e_deb_ligne, *s_deb_ligne, *conv_ptr, *ent_ptr;




/* Routine */


/* on applique le filtre_h sur l'horizontal                                  */
/* le resultat est la transpose de la transformee                            */


	   
e_deb_ligne=ent;
s_deb_ligne=sor + decal * tailleY;

saut = 2 * tailleY; /* pour sauter deux lignes dans la sortie */
for (ligne=0; ligne<tailleY; ligne++)
  {
    
    s_ptr=s_deb_ligne;
    
    /* premiere partie, le filtre deborde a gauche */
    for (i=0; i<MIN(filtre->taille_neg,tailleX); i++, s_ptr+=saut) /* att! cette fois on convolue en */
      /* chaque point de l'entree */
      {
	tmp=0;
	for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++)
	  tmp+=filtre->valeur[j+filtre->taille_neg]*e_deb_ligne[(*period)(i+j,tailleX)];
	*s_ptr=tmp; 

      } 
    
    
    
    ent_ptr=e_deb_ligne+i-filtre->taille_neg;
    for (; i<tailleX-filtre->taille_pos; i++, s_ptr+=saut, ent_ptr++)
      {
	conv_ptr=ent_ptr;
	tmp=0;
	for (j=0; j<filtre->taille; j++, conv_ptr++)
	  tmp+=filtre->valeur[j]*(*conv_ptr);
	*s_ptr=tmp;
	
      }
    
    
    for (; i<tailleX; i++, s_ptr+=saut)
      {
	tmp=0;
	for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++)
	  tmp+=filtre->valeur[j+filtre->taille_neg]*e_deb_ligne[(*period)(i+j,tailleX)];
	*s_ptr=tmp;
      }

     
    e_deb_ligne+=tailleX;
    s_deb_ligne++;
  }


}







#ifndef __STDC__
void FiltrageInverse2D_sum(ent, sor, tailleX, tailleY, filtre, period, decal)
     double *ent;
     double *sor;
     int tailleX;
     int tailleY;
     t_filtre_WT2D *filtre;
     int (*period)();
     int decal;
#else /* __STDC__ */
void FiltrageInverse2D_sum(double *ent,            /* entree du filtrage */
			   double *sor,            /* sortie de 2 fois la taille de ent */
			   int tailleX,            /* largeur de l'entree */
			   int tailleY,            /* hauteur de l'entree */
			   t_filtre_WT2D *filtre,       /* filtre en horizontal */
			   int (*period)(int,int),
			   int decal               /* decalage de la sortie: 0 ou 1 */
			   )
#endif /* __STDC__ */

/* somme  dans sor la sortie transposee du filtre en horizontal */

{

/* Variables locales */
/*-------------------*/

int i, j, ligne, saut;
double tmp, *s_ptr, *e_deb_ligne, *s_deb_ligne, *conv_ptr, *ent_ptr;




/* Routine */


/* on applique le filtre_h sur l'horizontal                                  */
/* le resultat est la transpose de la transformee                            */


	   
e_deb_ligne=ent;
s_deb_ligne=sor + decal * tailleY;


saut = 2 * tailleY; /* pour sauter deux lignes dans la sortie */
for (ligne=0; ligne<tailleY; ligne++)
  {
    
    s_ptr=s_deb_ligne;
    
    /* premiere partie, le filtre deborde a gauche */
    for (i=0; i<MIN(filtre->taille_neg,tailleX); i++, s_ptr+=saut) /* att! cette fois on convolue en */
      /* chaque point de l'entree */
      {
	tmp=0;
	for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++)
	  tmp+=filtre->valeur[j+filtre->taille_neg]*e_deb_ligne[(*period)(i+j,tailleX)];
	*s_ptr+=tmp;
	   
	 
      } 
    
    
    
    
    ent_ptr=e_deb_ligne+i-filtre->taille_neg;
    for (; i<tailleX-filtre->taille_pos; i++, s_ptr+=saut, ent_ptr++)
      {
	conv_ptr=ent_ptr;
	tmp=0;
	for (j=0; j<filtre->taille; j++, conv_ptr++)
	  tmp+=filtre->valeur[j]*(*conv_ptr);
	*s_ptr+=tmp;
      }
    
    for (; i<tailleX; i++, s_ptr+=saut)
      {
	tmp=0;
	for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++)
	  tmp+=filtre->valeur[j+filtre->taille_neg]*e_deb_ligne[(*period)(i+j,tailleX)];
	*s_ptr+=tmp;
      }
    
   
	   
    e_deb_ligne+=tailleX;
    s_deb_ligne++;
  }


}






#ifndef __STDC__
void WT2DInverse(arbre, sor, temp, h, nb_iter, tailleX, tailleY, period)
     t_arbreWT2D *arbre;
     double *sor;
     double *temp;
     t_filtre_WT2D *h;
     int nb_iter;
     int tailleX;
     int tailleY;
     int (*period)();
#else /* __STDC__ */
void WT2DInverse(t_arbreWT2D *arbre,  /* pointeur sur un tableau de noeuds */
		 double *sor,         /* ptr sur l'image de sortie*/
		 double *temp,        /* ptr sur un tableau de double temporaire 
			                 de la taille de l'image d'entree */
		 t_filtre_WT2D *h,         /* filtre passe bas */
		 int nb_iter,         /* nb d'iteration de l'algorithme */
		 int tailleX,         /* largeur de l'image de depart */
		 int tailleY,          /* hauteur de l'image */
		 int (*period)(int,int)
)
#endif /* __STDC__ */



{
/* variables locales */
/*-------------------*/


t_filtre_WT2D g, h1, h2, g1, g2;
int iter;
double *ent_HH, *ent_HG, *ent_GH, *ent_GG, *sor_Ht, *sor_Gt, *sor_HH;
t_arbreWT2D *nd_cour;
int tx_corrigee;
int i, index;
double *h1_ptr, *h2_ptr, *h_ptr;
double *g1_ptr, *g2_ptr, *g_ptr;


/* routine */
/*---------*/

/* calculer le filtre conjugue */
WT2D_calcul_filtre_conjugue(h, &g);



/* Calcul des filtres decimes */

h1_ptr = h1.valeur;
h2_ptr = h2.valeur;
index = h->taille_pos; /* pour savoir si l'indice de h est pair ou non */
h_ptr = h->valeur + h->taille - 1; /* dernier element de h */
for (i=0; i<h->taille; i++)
    if (index++%2 == 0) *(h1_ptr++)=*(h_ptr--); /* indice pairs */
    else *(h2_ptr++)=*(h_ptr--); /* indices impairs */
h1.taille_pos = h->taille_neg / 2;
h1.taille_neg = h->taille_pos / 2;
h1.taille = h1.taille_pos + h1.taille_neg +1;
h2.taille_pos = (h->taille_neg+1) / 2;
h2.taille_neg = ((h->taille_pos-1) / 2);
h2.taille = h2.taille_pos + h2.taille_neg +1;


g1_ptr = g1.valeur;
g2_ptr = g2.valeur;
index = g.taille_pos; /* pour savoir si l'indice de g est pair ou non */
g_ptr = g.valeur + g.taille - 1; /* dernier element de g */
for (i=0; i<g.taille; i++)
    if (index++%2 == 0) *(g1_ptr++)=*(g_ptr--); /* indice pairs */
    else *(g2_ptr++)=*(g_ptr--); /* indices impairs */
g1.taille_pos = g.taille_neg / 2;
g1.taille_neg = g.taille_pos / 2;
g1.taille = g1.taille_pos + g1.taille_neg +1;
g2.taille_pos = (g.taille_neg+1) / 2;
g2.taille_neg = ((g.taille_pos-1) / 2);
g2.taille = g2.taille_pos + g2.taille_neg +1;

	
/* pfioulala!!! */	
	


nd_cour = &arbre[nb_iter-1];
ent_HH = nd_cour->dataHH;
sor_HH = sor;
sor_Ht = temp;
sor_Gt = temp;



/* attention par rapport a la synthese, on garde le meme ordre de convolution */
/* horizontal d'abord, vertical ensuite , les filtres 2D etant separables,    */
/* on peut normalement se le permettre */


for (iter=0; iter<nb_iter; iter++) 
    {
	ent_HG = nd_cour->dataHG;
	ent_GH = nd_cour->dataGH;
	ent_GG = nd_cour->dataGG;

	if (iter < (nb_iter-1) ) tx_corrigee = (nd_cour - 1)->tailleX;
	else tx_corrigee = tailleX;
	
	
	
	FiltrageInverse2D(ent_HH, sor_Ht, nd_cour->tailleX, nd_cour->tailleY, &h1, period, 0);
	FiltrageInverse2D(ent_HH, sor_Ht, nd_cour->tailleX, nd_cour->tailleY, &h2, period, 1);

	FiltrageInverse2D_sum(ent_GH, sor_Ht, nd_cour->tailleX, nd_cour->tailleY, &g1, period, 0);
	FiltrageInverse2D_sum(ent_GH, sor_Ht, nd_cour->tailleX, nd_cour->tailleY, &g2, period, 1);
	

	/* on a obtenu Ht de largeur tailleY et de hauteur 2*tailleX */

	FiltrageInverse2D(sor_Ht, sor_HH, nd_cour->tailleY, tx_corrigee, &h1, period, 0);
	
	FiltrageInverse2D(sor_Ht, sor_HH, nd_cour->tailleY, tx_corrigee, &h2, period, 1);
	

	/* on a obtenu une premiere contribution a Sor_HH */
 
	FiltrageInverse2D(ent_HG, sor_Gt, nd_cour->tailleX, nd_cour->tailleY, &h1, period, 0);
	FiltrageInverse2D(ent_HG, sor_Gt, nd_cour->tailleX, nd_cour->tailleY, &h2, period, 1);
	FiltrageInverse2D_sum(ent_GG, sor_Gt, nd_cour->tailleX, nd_cour->tailleY, &g1, period, 0);
	FiltrageInverse2D_sum(ent_GG, sor_Gt, nd_cour->tailleX, nd_cour->tailleY, &g2, period, 1);
	

	/* on a obtenu Gt de largeur tailleY et de hauteur 2*tailleX */

	FiltrageInverse2D_sum(sor_Gt, sor_HH, nd_cour->tailleY, tx_corrigee, &g1, period, 0);
	FiltrageInverse2D_sum(sor_Gt, sor_HH, nd_cour->tailleY, tx_corrigee, &g2, period, 1);
	

	/* preparation pour l'etage suivant */
	ent_HH = sor_HH;
	nd_cour--;
    }
	
	

}

















