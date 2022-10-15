/***************************************************/
/* Module de gestion des liaisons pour le scruteur */
/***************************************************/

#ifndef _SCR_MESSAGES_
#define _SCR_MESSAGES_

#include "listes_chainees.h"
#include "formatage_messages.h"

typedef char *liaison_dest;

extern void poster_liste_elemnt_actmsg();
extern void creer_liaison_actmsg();
extern void detruire_liaison_actmsg();
extern int rechercher_liaison();
extern void desallouer_liaison();
void supprimer_liaisons_appli();

#endif
