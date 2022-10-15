#ifndef _UTILITAIRES_
#define _UTILITAIRES_

#include <varargs.h>

typedef struct Tableau_avec_taille
{
    char **tableau;
    int taille;
} tableau_avec_taille;


extern void liberer_tableau_de_pointeurs();

/*
    concat_caractere et strcat_plus_caractere :
    il faut que la chaine passee en premier argument ait 
    la place d'accueillir ce qui leur sera concatene.
*/
extern void concat_caractere();
extern void strcat_plus_caractere();


extern char *concatener_deux_chaines();
extern tableau_avec_taille convertir_nombre_arbitraire_de_chaines_en_tableau();
extern char *concatenation_plusieurs_chaines();

/*
    dupliquer_chaine est l'equivalent de strdup mais utilise allouer_type
    du module de gesation memoire.
*/
extern char *dupliquer_chaine();

#endif
