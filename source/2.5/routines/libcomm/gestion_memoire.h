/**********************************************************/
/* Ce fichier defini les methodes d'allocation de memoire */
/**********************************************************/

#ifndef _GESTION_MEMOIRE_
#define _GESTION_MEMOIRE_

#include "../machine.h"

/* Macros ameliorants la lisibilite du programme */
#define allouer_type(type,nbre) ((type *)allouer((nbre)*sizeof(type)))
#define reallouer_type(type,buffer,nbre) ((type *)reallouer(buffer,(nbre)*sizeof(type)))

extern void *allouer _PARAMS((long int taille));
extern void *reallouer _PARAMS((void *buffer, long int taille));
extern void liberer _PARAMS((void *buffer));

#endif
