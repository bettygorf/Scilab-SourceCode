/*****************************************/
/* Module de gestion de la memoire. V1.0 */
/*****************************************/

#include <stdio.h>
#include <stdlib.h>

#include "gestion_memoire.h"

static void erreur_allocation();

/* Les encapsulations qui vont suivre permettent d'eviter    */
/* des erreurs graves de type segmentation fault, sans avoir */
/* a repeter des tests sur le resultat du malloc.            */

/* Il est possible d'implementer une restauration de contexte */
/* afin d'eviter une erreur mortelle.                         */

/* Encapsulation du malloc. En cas d'echec de la demande, un appel */
/* a IG_erreur_mortelle est effectue.                              */

void *allouer(taille)
long taille;
{
    void *pointeur_buffer;

    if ((pointeur_buffer=(void *)malloc(taille)) == NULL)
	erreur_allocation();

    return pointeur_buffer;
}

/* Encapsulation du realloc. En cas d'echec de la demande, un appel */
/* a IG_erreur_mortelle est effectue.                               */

void *reallouer(buffer,taille)
void *buffer;
long taille;
{
    void *pointeur_buffer;

    if ((pointeur_buffer=(void *)realloc(buffer,taille)) == NULL)
	erreur_allocation();

    return pointeur_buffer;
}

void liberer(buffer)
void *buffer;
{
    free(buffer);
}

/** IG ??? **/
static void erreur_allocation()
{
    fprintf(stderr,"<gestion_memoire> : Pas assez de memoire disponible.\n");
    exit(1);
}
