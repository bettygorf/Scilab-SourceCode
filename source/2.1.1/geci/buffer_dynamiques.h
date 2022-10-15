/******************************************/
/* Module de gestion de buffer dynamiques */
/******************************************/

#ifndef _BUFFER_DYNAMIQUES_
#define _BUFFER_DYNAMIQUES_

/* Macros pour ameliorer la lisibilite */
#define gbd_creer_buffer_dynamique_type(type,nb_init,allouer,reallouer,liberer,desallouer) ((type *)gbd_creer_buffer_dynamique(sizeof(type),nb_init,allouer,reallouer,liberer,desallouer))

/* Creation d'un buffer dynamique. Le premier parametres correspond 
   a la taille d'un element du buffer dynamique. Le deuxieme indique
   la taille minimum du buffer. allouer() et liberer sont les methodes
   d'allocation memoire. desallouer() est la methode appliquee a un
   element du buffer pour le liberer. */
extern void *gbd_creer_buffer_dynamique();

/* Destruction d'un buffer dynamique. */
extern int gbd_detruire_buffer_dynamique();

/* Augmentation de la taille virtuelle du buffer dynamique */
extern void *gbd_augmenter_buffer_dynamique();

/* Diminution de la taille virtuelle du buffer dynamique */
extern void *gbd_diminuer_buffer_dynamique();

/* retourne le nombre d'elements d'un buffer dynamique */
extern long gbd_taille_buffer_dynamique();

/* liberation mixte : essaye de liberer un buffer dynamique. En cas
   d'echec, applique la methode liberer() au pointeur fourni en
   parametre */
extern void gbd_liberer_mixte();

#endif
