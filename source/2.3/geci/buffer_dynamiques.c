/************************************************/
/* Module de gestion de buffers dynamiques v1.0 */
/************************************************/

#include <stdio.h>
#include <stdlib.h>
/** #include "IG.h"**/
#include "gestion_memoire.h"
#include "listes_chainees.h"
#include "buffer_dynamiques.h"

/* Cette structure code un buffer dynamique.                         
   Il faut laisser cette structure et Premier_buffer_dynamique dans  
   gestion_memoire.c : c'est une structure privee.                   */
typedef struct gbd_Buffer_dynamique
{
    long taille_elements;
    long nbre_elements_initial;
    long nbre_elements_total;
    long nbre_elements_occupes;
    void *pointeur_buffer;
    void *(*allouer)();
    void *(*reallouer)();
    void (*liberer)();
    void (*desallouer)();
} gbd_buffer_dynamique;

static void gbd_desallouer_buffer();
static int gbd_chercher_buffer_dynamique();
static void *gbd_modifier_buffer_dynamique();
static long puissance_2_sup();

/* Pointeur sur le premier buffer dynamique de la liste chainee. */
/* Ce pointeur est egal a NULL au debut, car la liste est vide.  */

static ldc_liste_chainee liste_buffer_dynamiques=NULL;

/* Cette procedure ajoute un buffer dynamique dans la liste chainee.                */
/* Cette procedure peut etre appelee par la macro creer_buffer_dynamique            */
/* (cf gestion_memoire.h)                                                           */
void *gbd_creer_buffer_dynamique(taille,nbre_initial,allouer,reallouer,
				 liberer,desallouer)
long taille, nbre_initial;
void *(*allouer)();
void *(*reallouer)();
void (*liberer)();
void (*desallouer)();
{
    gbd_buffer_dynamique *nouvelle_structure;
    long nbre_initial_p2 = puissance_2_sup(nbre_initial);

    if (liste_buffer_dynamiques == NULL)
	liste_buffer_dynamiques=ldc_creer(gbd_chercher_buffer_dynamique,gbd_desallouer_buffer,liberer,allouer);
	
    nouvelle_structure = (*allouer)(sizeof(gbd_buffer_dynamique));
    nouvelle_structure -> pointeur_buffer = allouer(taille*nbre_initial_p2);
    nouvelle_structure -> taille_elements = taille;
    nouvelle_structure -> nbre_elements_initial = nbre_initial_p2;
    nouvelle_structure -> nbre_elements_total = nbre_initial_p2;
    nouvelle_structure -> nbre_elements_occupes = 0;
    nouvelle_structure -> liberer = liberer;
    nouvelle_structure -> allouer = allouer;
    nouvelle_structure -> reallouer = reallouer;
    nouvelle_structure -> desallouer = desallouer;

    ldc_ajouter_objet(liste_buffer_dynamiques,nouvelle_structure);

    return nouvelle_structure -> pointeur_buffer;
}

/* Cette procedure detruit un buffer dynamique dans la liste chainee. */
int gbd_detruire_buffer_dynamique(pointeur_buffer)
void *pointeur_buffer;
{
    return ldc_supprimer_objet(liste_buffer_dynamiques,pointeur_buffer);
}

static void gbd_desallouer_buffer(pointeur_struct_buffer_nc)
ldc_objet_liste pointeur_struct_buffer_nc;
{
    long compteur;
    char *buffer;
    gbd_buffer_dynamique *pointeur_struct_buffer = (gbd_buffer_dynamique *) pointeur_struct_buffer_nc;

    if (pointeur_struct_buffer -> desallouer != NULL)
    {
	buffer = (char *)(pointeur_struct_buffer -> pointeur_buffer);
	for(compteur = 0; compteur < pointeur_struct_buffer -> nbre_elements_occupes; compteur++)
	    (pointeur_struct_buffer -> desallouer)(buffer + (pointeur_struct_buffer -> nbre_elements_occupes) * (pointeur_struct_buffer -> taille_elements));
    }
    (pointeur_struct_buffer -> liberer)(pointeur_struct_buffer -> pointeur_buffer);
    (pointeur_struct_buffer -> liberer)(pointeur_struct_buffer);
}

/* Cette procedure permet d'augmenter la taille virtuelle d'un buffer dynamique. */
/* Si la taille virtuelle depasse la taille reelle du buffer, une reallocation   */
/* est effectuee. Le nombre d'elements apres la reallocation sera toujours egal  */
/* au nombre d'elements initial multiplie par une puissance de deux.             */
void *gbd_augmenter_buffer_dynamique(pointeur_buffer,nombre_elements)
void *pointeur_buffer;
long nombre_elements;
{
    return gbd_modifier_buffer_dynamique(pointeur_buffer,nombre_elements,1);
}

/* La taille virtuelle d'un buffer dynamique est diminuee. */
/* Aucune reallocation n'est effectuee.                    */
/** supprimer la duplication de code **/
void *gbd_diminuer_buffer_dynamique(pointeur_buffer, nombre_elements)
void *pointeur_buffer;
long nombre_elements;
{
    return gbd_modifier_buffer_dynamique(pointeur_buffer,nombre_elements,-1);
}

static void *gbd_modifier_buffer_dynamique(pointeur_buffer,nombre_elements,operation)
void *pointeur_buffer;
long nombre_elements;
int operation;
{
    long nombre_elements_a_reallouer,nombre_elements_a_reallouer_p2;
    gbd_buffer_dynamique *buffer_a_modifier;
    void *nouvelle_adresse;

    if ((buffer_a_modifier = ldc_rechercher_objet(liste_buffer_dynamiques,pointeur_buffer)) != NULL)
    {
	nombre_elements_a_reallouer = (buffer_a_modifier -> nbre_elements_occupes) + operation * nombre_elements;
	if ((operation == 1 && (nombre_elements_a_reallouer <= (buffer_a_modifier -> nbre_elements_total))) ||
	    ((operation == -1) && (nombre_elements_a_reallouer >= ((buffer_a_modifier -> nbre_elements_total) >> 1)) &&
	     (nombre_elements_a_reallouer > (buffer_a_modifier -> nbre_elements_initial))))
	     
	{
	    buffer_a_modifier -> nbre_elements_occupes += nombre_elements * operation;
	    return buffer_a_modifier -> pointeur_buffer;
	}
	else
	{
	    nombre_elements_a_reallouer_p2 = puissance_2_sup(nombre_elements_a_reallouer);

	    nouvelle_adresse = (buffer_a_modifier -> reallouer)(buffer_a_modifier -> pointeur_buffer,nombre_elements_a_reallouer_p2 * buffer_a_modifier -> taille_elements);
	    buffer_a_modifier -> nbre_elements_total = nombre_elements_a_reallouer_p2;
	    buffer_a_modifier -> pointeur_buffer = nouvelle_adresse;
	    buffer_a_modifier -> nbre_elements_occupes = nombre_elements_a_reallouer;

	    return nouvelle_adresse;
	}
    }
    return NULL;
}

/* Demande de la taille virtuelle d'un tableau dynamique */
long gbd_taille_buffer_dynamique(pointeur_buffer)
void *pointeur_buffer;
{
    gbd_buffer_dynamique *buffer_recherche;

    if ((buffer_recherche = ldc_rechercher_objet(liste_buffer_dynamiques,pointeur_buffer)) != NULL)
	return buffer_recherche -> nbre_elements_total;

    /** Erreur a gerer peut etre **/
    return 0;
}

/* Recherche de la structure d'un buffer dynamique, connaissant le pointeur    */
/* sur le buffer dynamique. Si la recherche echoue, la fonction retourne NULL. */
static int gbd_chercher_buffer_dynamique(pointeur_struct_buffer_nc,pointeur_buffer_nc)
ldc_objet_liste pointeur_struct_buffer_nc;
ldc_element_correspondance pointeur_buffer_nc;
{
    gbd_buffer_dynamique *pointeur_struct_buffer = (gbd_buffer_dynamique *) pointeur_struct_buffer_nc;
    void *pointeur_buffer = (void *) pointeur_buffer_nc;

    return (pointeur_struct_buffer -> pointeur_buffer == pointeur_buffer);
}

static long puissance_2_sup(nombre)
long nombre;
{
    long puissance = 1;

    while(puissance < nombre)
	puissance <<= 1;

    return puissance;
}

/* Liberation mixte : libere un buffer dynamique ou un buffer ordinaire */
void gbd_liberer_mixte(buffer)
void *buffer;
{
    if (!gbd_detruire_buffer_dynamique(buffer))
	liberer(buffer);
}
