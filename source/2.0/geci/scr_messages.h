/**************************************************/
/* Module de gestion de messages pour le scruteur */
/**************************************************/

#ifndef _SCR_GEST_MESSAGES_
#define _SCR_GEST_MESSAGES_

#include "formatage_messages.h"

extern char *Identificateur_application;

extern void envoyer_message();
extern void envoyer_message_var();
extern void interpreter_message();
extern int recevoir_message();
extern void envoyer_message_brut();
extern void envoyer_message_brut_directement();

extern void erreur_message_actmsg();

#endif
