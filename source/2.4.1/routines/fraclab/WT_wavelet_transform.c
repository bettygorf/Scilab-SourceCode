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

/* wavelet_transform.c */
/* module de calcul des transformee ondelettes 1D */
/* Bertrand Guiheneuf 1996 */



#include "WT_filters.h"
#include "WT_wavelet_transform.h"
#include "WT_arbre.h"



#ifndef MIN
#define MIN(a,b) (a > b ? b : a)
#endif
#undef TEST_PERIOD

#ifndef __STDC__
int WT_Periodisation(Indice, Longueur)
     int Indice;
     int Longueur;
#else /* __STDC__ */
int WT_Periodisation(int Indice,
		     int Longueur)
#endif /* __STDC__ */
{
  /* InterfError("toto"); */
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



/* PREMIERE PARTIE : D E C O M P O S I T I O N */
/***********************************************/

#ifndef __STDC__
void Filtrage(ent, sor, tailleX, filtre, period)
     double *ent;
     double *sor;
     int tailleX;
     t_filtre *filtre;
     int (*period)();
#else /* __STDC__ */
void Filtrage(double *ent, /* pointeur sur le tableau d'entree */
	      double *sor, /* pointeur sur le tableau de sortie */
	      int tailleX, /* Taille du tableau d'entree */
	      t_filtre *filtre, /* filtre passe-bas de la transformee */
	      int (*period)(int, int)
	      )
#endif /* __STDC__ */
/* description */
/* calcul d'une feuille d'un arbre, soit d'une TO standard */
/* soit d'une Transformee en paquets d'ondelettes */
/* elle sert juste a l'application d'un filtre unique */




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
for (i=0; i<MIN(filtre->taille_neg,tailleX) ; i+=2, s_ptr++)
    {
      tmp=0; 
      for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++)
	  tmp+=filtre->valeur[j+filtre->taille_neg]*ent[(*period)(i+j,tailleX)];
      *s_ptr=tmp;
    }

/* deuxieme partie, roule mon gars, roule ! */
ent_ptr=e_deb_ligne+i-filtre->taille_neg;
for (; i<tailleX-filtre->taille_pos; i+=2, s_ptr++, ent_ptr+=2)
    {
      conv_ptr=ent_ptr;
      tmp=0;
      for (j=0; j<filtre->taille; j++, conv_ptr++)
	  tmp+=filtre->valeur[j]*(*conv_ptr);
      *s_ptr=tmp;
    }


/* troisieme partie, Ouppps! ca deborde a droite */	   
for (; i<tailleX; i+=2, s_ptr++)
    {
      tmp=0;
       for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++) 
	  tmp+=filtre->valeur[j+filtre->taille_neg]*ent[(*period)(i+j,tailleX)]; 
      *s_ptr=tmp; /* printf("%p ", &(ent[(*period)(i+j,tailleX)])); */
    }


}




/***/


#ifndef __STDC__
void WT1D(arbre, ent, sor, temp, h, nb_iter, taille, period)
     t_arbreWT *arbre;
     double *ent;
     double *sor;
     double *temp;
     t_filtre *h;
     int nb_iter;
     int taille;
     int (*period)();
#else /* __STDC__ */
void WT1D(t_arbreWT *arbre,/* pointeur sur un tableau de noeuds */
	  double *ent,     /* ptr sur le signal d'entree */
	  double *sor,     /* ptr sur le signal de sortie */
	  double *temp,    /* ptr sur un tableau de double temporaire 
			    de la taille du signal d'entree */
	  t_filtre *h,     /* filtre passe bas */
	  int nb_iter,     /* nb d'iteration de l'algorithme */
	  int taille,       /* taille du signal de depart */
	  int (*period)(int,int)
)
#endif /* __STDC__ */

{
/* variables locales */
t_filtre g;
int iter;

/* routine */

/* constituer l'arbre de la transformee */ 
const_arbreWT(sor, arbre, taille, nb_iter);

/* calculer le filtre conjugue */
calcul_filtre_conjugue(h, &g);

for (iter=1; iter<nb_iter; iter++)
    {

      /* Calculer la fluctuation courante */
      Filtrage(ent, sor, taille, &g, period);
      
      /* calculer la tendance courante */
      /* Filtrage(ent, temp, taille, h, period);*/
      Filtrage(ent, temp, taille, h, period);

      /* suivant */
      arbre++;
      ent = temp;
      sor = arbre->dataG;
      taille = (taille + 1)/2;
      temp+=taille; /* CORRECTION DE BUG */
      
    
    }

Filtrage(ent, sor, taille, &g, period);
sor = arbre->dataH; 
Filtrage(ent, sor, taille, h, period);



}










/* DEUXIEME PARTIE : R E C O N S T R U C T I O N */
/*************************************************/


#ifndef __STDC__
void FiltrageInverse(ent, sor, tailleX, filtre, period, decal)
     double *ent;
     double *sor;
     int tailleX;
     t_filtre *filtre;
     int (*period)();
     int decal;
#else /* __STDC__ */
void FiltrageInverse(double *ent,      /* pointeur sur le tableau d'entree */
		     double *sor,      /* pointeur sur le tableau de sortie */
		     int tailleX,      /* Taille du tableau d'entree */
		     t_filtre *filtre, /* filtre decime */
		     int (*period)(int, int),
		     int decal         /* decalage dans la sortie */  
		     )
#endif /* __STDC__ */

/* DESCRIPTION : filtrage de la sortie d'une TO avec un filtre decime, issu soit de h */
/* soit de g. la sortie est remplie soit aux indices pairs (decal=0) soit impairs     */
/* (decal=1) */

{

/* cet algorithme reprend essentiellement les arguments algorithmiques */
/* de son pendant decomposatoire ... */    


/* Variables locales */
int i, j, ligne;
double tmp, *s_ptr, *e_deb_ligne, *s_deb_ligne, *conv_ptr, *ent_ptr;
/*-------------------------------------------------------------------------*/

/* Convention : Le prefixe e_ pour entree */
/*              Le prefixe s_ pour sortie */
	   

e_deb_ligne=ent;
s_deb_ligne=sor+decal; /* pour la lisibilite et aussi pour choisir si on */
                       /* remplit les indices pairs ou impairs           */




s_ptr=s_deb_ligne;

/* premiere partie, le filtre deborde a gauche */
for (i=0; i<MIN(filtre->taille_neg,tailleX); i++, s_ptr+=2) /* att! cette fois on convolue en */
                                              /* chaque point de l'entree */
    {
      tmp=0;
      for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++)
	  tmp+=filtre->valeur[j+filtre->taille_neg]*ent[(*period)(i+j,tailleX)];
      *s_ptr=tmp;
    }

/* deuxieme partie, roule mon gars, roule ! */
ent_ptr=e_deb_ligne+i-filtre->taille_neg;
for (; i<tailleX-filtre->taille_pos; i++, s_ptr+=2, ent_ptr++)
/* meme remarque qu'a la boucle precedente */
    {
      conv_ptr=ent_ptr;
      tmp=0;
      for (j=0; j<filtre->taille; j++, conv_ptr++)
	  tmp+=filtre->valeur[j]*(*conv_ptr);
      *s_ptr=tmp;
    }


/* troisieme partie, Ouppps! ca deborde a droite */	   
for (; i<tailleX; i++, s_ptr+=2, ent_ptr++)
  {
    tmp=0;
    for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++)
      tmp+=filtre->valeur[j+filtre->taille_neg]*ent[(*period)(i+j,tailleX)];
    *s_ptr=tmp;
  }

}




/* Attention : la meme que la precedente sauf que l,on somme sur la sortie */

#ifndef __STDC__
void FiltrageInverse_sum(ent, sor, tailleX, filtre, period, decal)
     double *ent;
     double *sor;
     int tailleX;
     t_filtre *filtre;
     int (*period)();
     int decal;
#else /* __STDC__ */
void FiltrageInverse_sum(double *ent,      /* pointeur sur le tableau d'entree */
			 double *sor,      /* pointeur sur le tableau de sortie */
			 int tailleX,      /* Taille du tableau d'entree */
			 t_filtre *filtre, /* filtre decime */
			 int (*period)(int, int),
			 int decal         /* decalage dans la sortie */  
			 )
#endif /* __STDC__ */

/* DESCRIPTION : filtrage de la sortie d'une TO avec un filtre decime, issu soit de h */
/* soit de g. la sortie est remplie soit aux indices pairs (decal=0) soit impairs     */
/* (decal=1) */

{

/* cet algorithme reprend essentiellement les arguments algorithmiques */
/* de son pendant decomposatoire ... */    


/* Variables locales */
int i, j, ligne;
double tmp, *s_ptr, *e_deb_ligne, *s_deb_ligne, *conv_ptr, *ent_ptr;
/*-------------------------------------------------------------------------*/

/* Convention : Le prefixe e_ pour entree */
/*              Le prefixe s_ pour sortie */
	   

e_deb_ligne=ent;
s_deb_ligne=sor+decal; /* pour la lisibilite et aussi pour choisir si on */
                       /* remplit les indices pairs ou impairs           */




s_ptr=s_deb_ligne;

for (i=0; i<MIN(filtre->taille_neg,tailleX); i++, s_ptr+=2) /* att! cette fois on convolue en */
                                              /* chaque point de l'entree */
    {
      tmp=0;
      for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++)
	  tmp+=filtre->valeur[j+filtre->taille_neg]*ent[(*period)(i+j,tailleX)];
      *s_ptr+=tmp;
    }

/* deuxieme partie, roule mon gars, roule ! */
ent_ptr=e_deb_ligne+i-filtre->taille_neg;
for (; i<tailleX-filtre->taille_pos; i++, s_ptr+=2, ent_ptr++)
/* meme remarque qu'a la boucle precedente */
    {
      conv_ptr=ent_ptr;
      tmp=0;
      for (j=0; j<filtre->taille; j++, conv_ptr++)
	  tmp+=filtre->valeur[j]*(*conv_ptr);
      *s_ptr+=tmp;
    }


/* troisieme partie, Ouppps! ca deborde a droite */	   
for (; i<tailleX; i++, s_ptr+=2, ent_ptr++)
  {
    tmp=0;
    for (j=-filtre->taille_neg; j<=filtre->taille_pos; j++)
      tmp+=filtre->valeur[j+filtre->taille_neg]*ent[(*period)(i+j,tailleX)];
    *s_ptr+=tmp;
  }
 
}












#ifndef __STDC__
void WT1DInverse(arbre, sor, temp, h, nb_iter, taille, period)
     t_arbreWT *arbre;
     double *sor;
     double *temp;
     t_filtre *h;
     int nb_iter;
     int taille;
     int (*period)();
#else /* __STDC__ */
void WT1DInverse(t_arbreWT *arbre,/* pointeur sur un tableau de noeuds */
		 double *sor,     /* ptr sur le signal de sortie */
		 double *temp,    /* ptr sur un tableau de double temporaire 
			             de la taille du signal d'entree */
		 t_filtre *h,     /* filtre passe bas */
		 int nb_iter,     /* nb d'iteration de l'algorithme */
		 int taille,      /* taille du signal de depart */
		 int (*period)(int, int)
		 
)
#endif /* __STDC__ */

{
/* variables locales */
t_filtre g, h1, h2, g1, g2;
int iter;
double *ent_H, *ent_G, *sor_H;
t_arbreWT *nd_cour;

int i, index;
double *h1_ptr, *h2_ptr, *h_ptr;
double *g1_ptr, *g2_ptr, *g_ptr;


/* routine */


/* calculer le filtre conjugue */
calcul_filtre_conjugue(h, &g);



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
ent_H = nd_cour->dataH;



/* DEVINETTE*/
/* comment faire pour que la derniere tendance tombe sur sor? */
/* Reponse: */
if ((nb_iter%2) == 1) sor_H = sor;
else sor_H = temp;
 

for (iter=0; iter<nb_iter; iter++) 
    {
	ent_G = nd_cour->dataG;
	FiltrageInverse(ent_G, sor_H, nd_cour->taille, &g1, period, 0);
	/* Calcul de la contribution de la fluctuat courante coefficients pairs */

	FiltrageInverse(ent_G, sor_H, nd_cour->taille, &g2, period, 1);
	/* Calcul de la contribution de la fluctuat courante coefficients impairs */

	FiltrageInverse_sum(ent_H, sor_H, nd_cour->taille, &h1, period, 0);
	/* Calcul de la contribution de la tendance courante coefficients pairs */

	FiltrageInverse_sum(ent_H, sor_H, nd_cour->taille, &h2, period, 1);
	/* Calcul de la contribution de la tendance courante coefficients impairs */
 
	



	/* tout cela tangue mais ne coule pas ... */
	/* Cependant, aucun rapport avec la mairie de Paris */

	

	/* preparation de l'iteration suivante */ 
	ent_H = sor_H;
	if (sor_H == temp) sor_H = sor;
	else sor_H = temp; /* inverser les deux */
	
	nd_cour--;
    }



}


