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

extern void init_messages();
extern char *identificateur_appli();
extern void scanner_messages();
extern Message attendre_message();
extern void ecrire_trame();
extern char *lire_trame();

#endif
