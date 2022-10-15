/************************************************************/
/*  Module de gestion des messages pour les applis CalICo   */
/************************************************************/

#ifndef _GESTION_MESSAGES_
#define _GESTION_MESSAGES_

#include "formatage_messages.h"

/* Non du premier message envoye par le scruteur pour */
/* leur communiquer leur identificateur.              */

#define MSG_IDENTIFICATION "APPLI_ID"

/* Cette structure permet de connaitre la procedure a appeler (action)    */
/* en cas de reception du message spontane "type_message".                */
/* Elle contient aussi le nombre de parametres requis pour l'appel de     */
/* cette procedure. En cas de parametres non definis, le champ            */
/* nb_parametres contiendra -N, ou N est le nombre de parametres minimun. */

typedef struct Actions_messages{
    char *source;
    char *type_message;
    int nb_parametres;
    void (*action)();
} actions_messages;

extern void init_messages _PARAMS((actions_messages *table, int p_in, int p_out));
extern char *identificateur_appli _PARAMS((void));
extern void scanner_messages _PARAMS((void));
extern Message attendre_message _PARAMS((char *source, char *type_message, int nb_parametres_max));
extern void ecrire_trame _PARAMS((char *trame));
extern char *lire_trame _PARAMS((void));

#endif
