/**********************************************/
/* Gestion de listes doublement chainees v1.0 */
/**********************************************/

#include <stdio.h>
#include "listes_chainees.h"

static ldc_element_liste ldc_rechercher_element();

static ldc_liste_chainee temp1;
ldc_liste_chainee ldc_creer(correspondre,desallouer,liberer,allouer)
int (*correspondre)();
void (*desallouer)();
void (*liberer)();
void *(*allouer)();
{
    temp1 = (ldc_liste_chainee)(*allouer)(sizeof(struct ldc_Liste_chainee));
    temp1 -> correspondre = correspondre;
    temp1 -> desallouer = desallouer;
    temp1 -> liberer = liberer;
    temp1 -> allouer = allouer;
    temp1 -> premier_element = NULL;

    return temp1;
}

void ldc_detruire(liste)
ldc_liste_chainee liste;
{
    ldc_element_liste pointeur,temp;

    pointeur = liste -> premier_element;
    while(pointeur != NULL)
    {
	temp = pointeur -> suivant;
	(*(liste -> desallouer))(pointeur -> objet);
	(*(liste -> liberer))(pointeur);
	pointeur = temp;
    }
    (*(liste -> liberer))(liste);
}

void ldc_ajouter_objet(liste,objet)
ldc_liste_chainee liste;
ldc_objet_liste objet;
{
    ldc_element_liste nouvel_element;

    nouvel_element = (*(liste -> allouer))(sizeof(struct ldc_Element_liste));

    if (liste -> premier_element != NULL)
	(liste -> premier_element) -> precedent = nouvel_element;
    nouvel_element -> suivant = liste -> premier_element;
    nouvel_element -> precedent = NULL;
    liste -> premier_element = nouvel_element;
    nouvel_element -> objet = objet;
}

int ldc_supprimer_objet(liste,objet)
ldc_liste_chainee liste;
ldc_objet_liste objet;
{
    ldc_element_liste element_a_supprimer;
    
    element_a_supprimer = ldc_rechercher_element(liste,objet);
    
    if (element_a_supprimer == NULL) 
	    return 0;
    
/* QU'EST CE QUE CELA FAIT ? */
    if (liste -> desallouer != NULL) 
	    (liste -> desallouer)(element_a_supprimer -> objet);
    /**/
    
    if (element_a_supprimer == liste -> premier_element)
	    liste -> premier_element = element_a_supprimer -> suivant;
    else
	    (element_a_supprimer -> precedent) -> suivant = element_a_supprimer -> suivant;
    
    if ((element_a_supprimer -> suivant) != NULL)
	    (element_a_supprimer -> suivant) -> precedent = element_a_supprimer -> precedent;
    
    (liste -> liberer)(element_a_supprimer);
    
    return 1;
    
}

static ldc_element_liste element1;
ldc_objet_liste ldc_objet_suivant(liste,correspondance)
ldc_liste_chainee liste;
ldc_element_correspondance correspondance;
{
    element1 = ldc_rechercher_element(liste,correspondance);

    if ((element1 == NULL) || (element1 -> suivant == NULL))
	return NULL;

    return (element1 -> suivant) -> objet;
}

static ldc_element_liste element2;
ldc_objet_liste ldc_objet_precedent(liste,correspondance)
ldc_liste_chainee liste;
ldc_element_correspondance correspondance;
{
    element2 = ldc_rechercher_element(liste,correspondance);

    if ((element2 == NULL) || (element2 -> precedent == NULL))
	return NULL;

    return (element2 -> precedent) -> objet;
}

static ldc_element_liste element_a_chercher;
static ldc_element_liste ldc_rechercher_element(liste,correspondance)
ldc_liste_chainee liste;
ldc_element_correspondance correspondance;
{
    element_a_chercher = liste -> premier_element;
    while(element_a_chercher != NULL)
    {
	if ((*(liste -> correspondre))(element_a_chercher -> objet,correspondance))
	    break;
	element_a_chercher = element_a_chercher -> suivant;
    }

    return element_a_chercher;
}

static ldc_element_liste element3;
ldc_objet_liste ldc_rechercher_objet(liste,correspondance)
ldc_liste_chainee liste;
ldc_element_correspondance correspondance;
{

    element3 = ldc_rechercher_element(liste,correspondance);
    if (element3 == NULL)
	    return NULL;
    return element3 -> objet;
}

void ldc_appliquer_liste(liste,fonction_sur_objet)
ldc_liste_chainee liste;
void (*fonction_sur_objet)();
{
    ldc_element_liste element;

    element = liste -> premier_element;
    while(element != NULL)
    {
	(*fonction_sur_objet)(element -> objet);
	element = element -> suivant;
    }
}
