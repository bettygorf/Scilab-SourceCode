#ifndef _COMMUNICATIONS_
#define _COMMUNICATIONS_

#include "../machine.h"
#include "formatage_messages.h"

/*
    La fonction envoyer_message_parametres_var prend un nombre arbitraire de
    chaines de caracteres et les envoie au scruteur apres les avoir formate
    correctement.
*/

extern void envoyer_message_parametres_var _PARAMS((char *fmt, ...));

/*
    La fonction envoyer_message_tableau fait la meme chose que
    la fonction envoyer_message_parametres_var, mais les chaines
    de caracteres lui sont passees dans une structure Message.
*/

extern void envoyer_message_tableau _PARAMS((Message message));

/*
    attendre_reponse renvoie un message de la source et du type demande.
*/
extern Message attendre_reponse _PARAMS((char *source, char *type_message, int nb_parametres_min));

#endif
