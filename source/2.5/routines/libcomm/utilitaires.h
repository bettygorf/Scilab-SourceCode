#ifndef _UTILITAIRES_
#define _UTILITAIRES_

#include "../machine.h"

#ifndef __STDC__
#include <varargs.h>
#else
#include <stdarg.h>
#endif

typedef struct Tableau_avec_taille
{
    char **tableau;
    int taille;
} tableau_avec_taille;


extern void liberer_tableau_de_pointeurs _PARAMS((char **tableau, int taille));

/*
    concat_caractere et strcat_plus_caractere :
    il faut que la chaine passee en premier argument ait 
    la place d'accueillir ce qui leur sera concatene.
*/
extern void concat_caractere _PARAMS((char *chaine, char caractere));
extern void strcat_plus_caractere _PARAMS((char *chaine_a_remplir, char *chaine_a_copier, char caractere));


extern char *concatener_deux_chaines _PARAMS((char *chaine1, char *chaine2));

extern tableau_avec_taille convertir_nombre_arbitraire_de_chaines_en_tableau _PARAMS((char *first,  va_list * liste));
extern char *concatenation_plusieurs_chaines _PARAMS((char * fmt, ...));

/*
    dupliquer_chaine est l'equivalent de strdup mais utilise allouer_type
    du module de gesation memoire.
*/
extern char *dupliquer_chaine _PARAMS((char *chaine_source));

#endif
