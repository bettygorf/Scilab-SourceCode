/*****************************************/
/* Gestion de listes doublement chainees */
/*****************************************/

#ifndef _LISTES_D_CHAINEES_
#define _LISTES_D_CHAINEES_

typedef void *ldc_objet_liste;
typedef void *ldc_element_correspondance;

typedef struct ldc_Liste_chainee *ldc_liste_chainee;
typedef struct ldc_Element_liste *ldc_element_liste;

struct ldc_Liste_chainee
{
    ldc_element_liste premier_element;
    int (*correspondre)();
    void (*desallouer)();
    void (*liberer)();
    void *(*allouer)();
};

struct ldc_Element_liste
{
    ldc_objet_liste objet;
    ldc_element_liste precedent;
    ldc_element_liste suivant;
};

/* Creation d'une liste doublement chainee. correspondance() est une procedure 
   qui verifie une relation entre un objet de la liste et un parametre defini.
   desallouer() libere un objet. liberer() libere un bloc memoire. allouer()
   en alloue un. Les erreurs d'allocations doivent etre traitees par allouer() */
extern ldc_liste_chainee ldc_creer();

/* Destruction d'une liste chainee. La destruction appelle la procedure desallouer()
   pour chaque element de la liste. */
extern void ldc_detruire();

ldc_objet_liste ldc_objet_suivant();

ldc_objet_liste ldc_objet_precedent();

extern void ldc_ajouter_objet();

/* Suppresion d'un objet de la liste. La supression entraine l'appel a la procedure
  desallouer(). Si l'objet n'a pu etre trouve, la fonction renvoie 0 */
int ldc_supprimer_objet();

/* Recherche d'un objet dans la liste. L'objet retourne correspondra au premier objet
   de la liste sur lequel l'application de la fonction correspondre appelee avec le
   paramettre correspondance retournera 1 */
ldc_objet_liste ldc_rechercher_objet();

/* Application d'une fonction sur l'ensemble des objets d'une liste */
void ldc_appliquer_liste();

#endif

