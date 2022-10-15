#include <varargs.h>
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

static tableau_avec_taille tat_resultat;

tableau_avec_taille convertir_nombre_arbitraire_de_chaines_en_tableau(liste)
va_list *liste;
{
    char *chaine;

    tat_resultat.taille=0;
    tat_resultat.tableau=gbd_creer_buffer_dynamique_type(char *,TAILLE_INIT_TABLEAU,allouer,reallouer,liberer,NULL);
    tat_resultat.tableau=gbd_augmenter_buffer_dynamique(tat_resultat.tableau,1);

    while((chaine=va_arg(*liste,char *)) != NULL)
    {
	tat_resultat.tableau[tat_resultat.taille++]=dupliquer_chaine(chaine);
	tat_resultat.tableau=gbd_augmenter_buffer_dynamique(tat_resultat.tableau,1);
    }
    tat_resultat.tableau[tat_resultat.taille]=NULL;

    return tat_resultat;
}


char *concatenation_plusieurs_chaines(va_alist)
va_dcl
{
    va_list liste;

    char *chaine_resultat;
    tableau_avec_taille temporaire;
    int nb_caracteres;
    int compteur;

    va_start(liste);

    nb_caracteres=0;

    temporaire=convertir_nombre_arbitraire_de_chaines_en_tableau(&liste);
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
