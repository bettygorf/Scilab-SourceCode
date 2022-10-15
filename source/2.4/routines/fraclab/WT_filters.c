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
/* module de gestion des QMF */
/* Bertrand Guiheneuf 1996 */


#include <stdio.h>
#include <string.h>
#include "WT_filters.h"

/*****************************************************************************/
/*****************************************************************************/

int lit_fichier_filtres(nomfich, numero_filtre, filtre)                      
/* DESCRIPTION: lit un filtre dans un fichier de filtres. Le filktre est     */
/* repere par son ordre d'apparition dans le fichier.                        */
/* */
/* ENTREE: nomfich contient le nom du fichier de filtres.                    */
/*         numero_filtre contient l'ordre d'apparition du filtre dans le fich*/
/*         filtre est un pointeur sur une structure filtre qui est destinee  */
/*          a recevoir le filtre lu                                          */
/* */
/* SORTIE: filtre contient le filtre lu                                      */
/*         En cas de probleme de lecture du filtre la fonction renvoie 0     */ 
/*****************************************************************************/

char *nomfich;
int numero_filtre;
t_filtre *filtre;


{
/* variables locales */

FILE *fichier;
int i, compteur_filtre;
char *chaine, *eof;


if ((fichier=fopen(nomfich,"rb")) == NULL)
	{
	/* fichier de filtre absent */	
	printf("Unreadable file : %s \n",nomfich );
	return(0);
        }
else
	{

	
	chaine=(char *)calloc(20,sizeof(char));
       	for (compteur_filtre=0; compteur_filtre<numero_filtre; compteur_filtre++)
	{ 	do
			{ eof=fgets(chaine,20,fichier); }
		while (strcmp(chaine,"new filter\n") && (eof != NULL) );
		/* on pointe sur le premier caractere apres nouveau filtre  */
		if (eof == NULL) 
			{
			printf("Unreadable Filter\n");
			return(0);
			/* on est alle trop loin dans le fichier de filtres */

		}

		/* Si on arrive la, c'est qu'on est sur le debut du nom du  */
		/* filtre. Il ne reste plus qu'a lire les donnees betement..*/
		fgets((filtre->nom),long_nom_filtre,fichier);printf("%s\n",filtre->nom);
		fscanf(fichier,"%d %d %d",&(filtre->taille), &(filtre->taille_neg), &(filtre->taille_pos));
	
		for (i=0; i<(filtre->taille); i++)
			fscanf(fichier, "%lf ",&(filtre->valeur[i]));
	}
		
	fclose(fichier);
	return(1);
        }
}




void calcul_filtre_conjugue(h,g)
/*****************************************************************************/
/*ENTREE: h est le filtre correspondant a la fonction d'echelle phi cad le   */
/*        filtre passe-bas du QMF                                            */
/*                                                                           */
/*****************************************************************************/
/*SORTIE: g contient le filtre conjugue de h, cad le filtre passe-haut       */
/*        correspondant a l'ondelette mere psi                               */
/*                                                                           */
/*****************************************************************************/

t_filtre *h, *g;



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
