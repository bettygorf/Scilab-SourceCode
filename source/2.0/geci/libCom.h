/*****************************/
/* Format des messages v0.24 */
/*****************************/

#ifndef _FORMAT_MSG_
#define _FORMAT_MSG_

#define CARACTERE_COMMANDE '#'
#define DEBUT_DE_TRAME "#DDT"
#define FIN_DE_TRAME   "#FDT"
#define MSG_SEPARATEUR ' '

#define ID_SCRUTEUR    "SCRUT"
#define ID_PIG         "PIG"
#define ID_XGeCI       "XGeCI"
#define ID_NOYAU       "NOYAU"
#define ID_GeCI_local  "SCRUT"

/* message d'identification initial (SCRUT->APPLI/PIG/NOYAU) */
#define MSG_IDENT_APPLI           "APPLI_ID"
#define NBP_IDENT_APPLI            3

/* fin de la PIG (PIG->SCRUT) */
#define MSG_FIN_XGeCI               "FIN_XGeCI"
#define NBP_FIN_XGeCI                3

/* fin d'une appli (APPLI/SCRUT->PIG) */
#define MSG_FIN_APPLI             "FIN_APPLI"
#define NBP_FIN_APPLI              4

/* lancement d'une appli communiquante (PIG->SCRUT) */
#define MSG_LANCER_APPLI          "LANCER_APPLI"
#define NBP_LANCER_APPLI          -5
/* A placer dans une commande LANCER_APPLI */
/* Determine la position des identificateurs de pipes */
#define INS_ID_PIPES    "__ID_PIPES__"

/* lancement d'une appli non communiquante (PIG->SCRUT) */
#define MSG_LANCER_APPLI_SANS_COM "LANCER_APPLI_SANS_COM"
#define NBP_LANCER_APPLI_SANS_COM -5

/* Destruction d'une appli SCRUT->APPLI PIG->SCRUT */
#define MSG_QUITTER_APPLI         "QUITTER_APPLI"
#define NBP_QUITTER_APPLI         4

/* Destruction de tous les scruteurs (ou GeCI) SCRUT->SCRUT */
#define MSG_DESTRUCTION           "DESTRUCTION"
#define NBP_DESTRUCTION           3

/* Creation d'une liaison PIG->SCRUT */
#define MSG_CREER_LIAISON         "CREER_LIAISON"
#define NBP_CREER_LIAISON         5

/* Destruction d'une liaison PIG->SCRUT */
#define MSG_DETRUIRE_LIAISON      "DETRUIRE_LIAISON"
#define NBP_DETRUIRE_LIAISON      5

/* Prevu : distribution une liste d'elements */
#define MSG_DISTRIB_LISTE_ELMNT    "DISTRIB_LISTE_ELMNT"
#define NBP_DISTRIB_LISTE_ELMNT    5

/* A SORTIR DES UNIFICATION DES ATELIERS SUIVANT LE MODELE */
#define MSG_POSTER_LISTE_ELMNT    "POSTER_LISTE_ELMNT"
#define NBP_POSTER_LISTE_ELMNT    5

#define MSG_ENVOYER_LISTE_ELMNT   "ENVOYER_LISTE_ELMNT"
#define NBP_ENVOYER_LISTE_ELMNT    4

#define MSG_CHANGER_CHEMIN         "CHANGER_CHEMIN"
#define NBP_CHANGER_CHEMIN         4

/* erreur lorsqu'un element est poste */

#define MSG_ERREUR_LIAISON_SCRUTEUR "ERREUR_LIAISON_SCRUTEUR"
#define NBP_ERREUR_LIAISON_SCRUTEUR 4

#endif /* __FORMAT_MSG__ */











