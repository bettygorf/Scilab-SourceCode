#ifndef _FORMATAGE_MESSAGES_
#define _FORMATAGE_MESSAGES_

#include "utilitaires.h"

#define SEPARATEUR ' '
#define CARACTERE_ECHAPPEMENT '\\'

typedef tableau_avec_taille Message;

/*
   chaine au format message : chaine classique
   chaine au format trame : chaine dans laquelle les SEPARATEUR
   sont precedes d'un CARACTERE_ECHAPPEMENT pour qu'elle 
   ne soit pas decoupee lorsqu'elle est dans une trame.
*/



/*
   decouper_trame prend en entree une trame qui est une chaine de
   caracteres contenant des mots au format trame separes par des
   separateurs, un caractere SEPARATEUR precede d'un
   CARACTERE_ECHAPPEMENT n'etant pas considere comme un separateur.
   Chaque mot est place dans une entree d'un tableau, lui meme champ
   d'une structure Message, qui est retournee.
*/

extern Message decouper_trame();



/*
   coller_chaines concatene les mots du tableau de la structure
   Message dans une chaine qui sera retournee, en les separant par
   des SEPARATEUR et les formatant au format trame
*/

extern char *coller_chaines();



/*
   liberer_message libere les entrees du champ tableau de la
   structure Message, ainsi que le tableau lui-meme.
   Le tableau peut etre un tableau dynamique ou non, puisque c'est
   la fonction liberer_mixte qui est appelee.
*/

extern void liberer_message();

#endif
