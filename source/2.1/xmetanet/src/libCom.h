/*********************************************************************
 * Header file : format_messages
 *
 * Format des messages v0.25 
 *
 */
#define CARACTERE_COMMANDE '#'
#define DEBUT_DE_TRAME "#DDT"
#define FIN_DE_TRAME   "#FDT"
#define MSG_SEPARATEUR ' '

#define ID_SCRUTEUR "SCRUT"
#define ID_GeCI     "SCRUT"
#define ID_PIG      "PIG"

/* fin d'une appli (APPLI/SCRUT->PIG) */
#define MSG_FIN_APPLI             "FIN_APPLI"
#define NBP_FIN_APPLI              4

/* message d'identification initial (SCRUT->APPLI/PIG/NOYAU) */
#define MSG_IDENT_APPLI           "APPLI_ID"
#define NBP_IDENT_APPLI            3

/* Destruction d'une appli SCRUT->APPLI PIG->SCRUT */
#define MSG_QUITTER_APPLI         "QUITTER_APPLI"
#define NBP_QUITTER_APPLI         4

/* Prevu : distribution une liste d'elements */
#define MSG_DISTRIB_LISTE_ELMNT    "DISTRIB_LISTE_ELMNT"
#define NBP_DISTRIB_LISTE_ELMNT    5

/* Prevu : poste une liste d'elements */
#define MSG_POSTER_LISTE_ELMNT    "POSTER_LISTE_ELMNT"
#define NBP_POSTER_LISTE_ELMNT    5

/* Type des messages */

#define ISIZE 8
#define DSIZE 16

#define CHARSEP '\n'
#define STRINGSEP "\n"

#define ACK       "ACK"
#define CREATE    "CREATE"
#define LOAD      "LOAD"
#define LOAD1     "LOAD1"
#define SHOWNS    "SHOWNS"
#define SHOWNS1   "SHOWNS1"
#define SHOWP     "SHOWP"
#define SHOWP1    "SHOWP1"
