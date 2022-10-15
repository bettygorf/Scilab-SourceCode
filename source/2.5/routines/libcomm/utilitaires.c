#ifndef __STDC__
#include <varargs.h>
#define Va_start(a,b) va_start(a)
#else
#include <stdarg.h>
#define Va_start(a,b) va_start(a,b)
#endif
#include <stdio.h>
#include <string.h>
#include "gestion_memoire.h"
#include "buffer_dynamiques.h"
#include "utilitaires.h"

#define TAILLE_INIT_TABLEAU 10

void liberer_tableau_de_pointeurs(tableau,taille)
char **tableau;
int taille;
{
    int compteur;
    for(compteur=0 ; compteur < taille ; compteur ++)
	liberer(tableau[compteur]);
}


/*
    il faut que, comme avec strcat, la chaine ait la
    place pour accepter le caractere supplementaire.
*/
void concat_caractere(chaine,caractere)
char *chaine;
char caractere;
{
    chaine[strlen(chaine)+1]='\0';
    chaine[strlen(chaine)]=caractere;
}

/*
   il faut que, comme avec strcat, la chaine ait la place pour 
   accepter la chaine et le caractere supplementaires
*/
void strcat_plus_caractere(chaine_a_remplir,chaine_a_copier,caractere)
char *chaine_a_remplir;
char *chaine_a_copier;
char caractere;
{
    strcat(chaine_a_remplir,chaine_a_copier);
    concat_caractere(chaine_a_remplir,caractere);
}

/* 
 * stores the set of strings coded in first + liste 
 * in a dynamically allocated array 
 */

tableau_avec_taille convertir_nombre_arbitraire_de_chaines_en_tableau(first,liste)
     char *first;
     va_list *liste;
{
    tableau_avec_taille resultat;
    char *chaine;

    resultat.taille=0;
    resultat.tableau=gbd_creer_buffer_dynamique_type(char *,TAILLE_INIT_TABLEAU,allouer,reallouer,liberer,NULL);
    resultat.tableau=gbd_augmenter_buffer_dynamique(resultat.tableau,1);

    chaine = first;
    while( chaine  != NULL)
      {
	resultat.tableau[resultat.taille++]=dupliquer_chaine(chaine);
	resultat.tableau=gbd_augmenter_buffer_dynamique(resultat.tableau,1);
	chaine=va_arg(*liste,char *);
      }
    resultat.tableau[resultat.taille]=NULL;

    return resultat;
}

/* 
 * unused function ....
 * 
 */ 

#ifdef __STDC__
char *concatenation_plusieurs_chaines_unused (char * first, ...)
#else
char *concatenation_plusieurs_chaines_unused (va_alist) va_dcl
#endif
{
    va_list liste;

    char *chaine_resultat;
    tableau_avec_taille temporaire;
    int nb_caracteres;
    int compteur;
#ifdef __STDC__
    va_start(liste,first);
#else
    char *first;
    va_start(liste);
    first = va_arg(liste, char *);
#endif

    nb_caracteres=0;

    temporaire=convertir_nombre_arbitraire_de_chaines_en_tableau(first,&liste);
    for(compteur=0;compteur<temporaire.taille;compteur++)
	nb_caracteres+=strlen(temporaire.tableau[compteur]);

    chaine_resultat=allouer_type(char,nb_caracteres+1);
    *chaine_resultat='\0';
    for(compteur=0;compteur<temporaire.taille;compteur++)
	strcat(chaine_resultat,temporaire.tableau[compteur]);

    liberer_tableau_de_pointeurs(temporaire.tableau,temporaire.taille);
    gbd_liberer_mixte(temporaire.tableau);

    va_end(liste);

    return chaine_resultat;
}


char *concatener_deux_chaines(chaine1,chaine2)
char *chaine1;
char *chaine2;
{
    char *chaine_resultat;
    chaine_resultat=allouer_type(char,strlen(chaine1)+strlen(chaine2)+1);
    strcpy(chaine_resultat,chaine1);
    strcat(chaine_resultat,chaine2);
    return chaine_resultat;
}


char *dupliquer_chaine(chaine_source)
char *chaine_source;
{
    char *chaine_resultat=allouer_type(char,strlen(chaine_source)+1);
    strcpy(chaine_resultat,chaine_source);

    return chaine_resultat;
}
