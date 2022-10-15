/**************************************************************/
/* Module de gestion des applications lancees par le scruteur */
/**************************************************************/

#ifndef _SCR_APPLICATIONS_
#define _SCR_APPLICATIONS_

#include "listes_chainees.h"

#include "scr_liaisons.h"

#define NB_MACHINES 30

typedef struct Application {
    char *identificateur_appli;
    int pid;
    int pipe_vers_appli;
    int pipe_vers_scruteur;
    char *nom_machine;
    ldc_liste_chainee liste_liaisons;
} application;

typedef struct _liaison_machine
{
    char *nom_machine;
    int desc;
} liaison_machine;


extern ldc_liste_chainee liste_applications;
extern application *application_suivante;
extern int nb_machines;
extern liaison_machine liste_machines[NB_MACHINES];
extern Message memorisation_message;

extern int executer_application();
extern int executer_application_a_distance();
extern void detruire_applications_scruteur();

extern void ajouter_application();
extern void supprimer_application();

extern void lancer_appli_actmsg();
extern void lancer_appli_sans_comm_actmsg();
extern void fin_xgeci_actmsg();
extern void fin_appli_actmsg();
extern void quitter_appli_actmsg();
extern void auto_destruction();
extern void changer_repertoire_actmsg();


#endif
