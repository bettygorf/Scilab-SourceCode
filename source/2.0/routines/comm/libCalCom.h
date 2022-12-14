#ifndef _LIBCALCOM_
#define _LIBCALCOM_

/*********************************************************************
 * Header file utilitaires.h
 */

typedef struct Tableau_avec_taille
{
    char **tableau;
    int taille;
} tableau_avec_taille;


extern void liberer_tableau_de_pointeurs();

/*
    concat_caractere et strcat_plus_caractere :
    il faut que la chaine passee en premier argument ait 
    la place d'accueillir ce qui leur sera concatene.
*/

extern void concat_caractere();
extern void strcat_plus_caractere();


extern char *concatener_deux_chaines();
extern tableau_avec_taille convertir_nombre_arbitraire_de_chaines_en_tableau();
extern char *concatenation_plusieurs_chaines();

/*
    dupliquer_chaine est l'equivalent de strdup mais utilise allouer_type
    du module de gesation memoire.
*/
extern char *dupliquer_chaine();


/*********************************************************************
 * Header file : formatage_messages
 */

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


/*********************************************************************
 * Header file : communications
 */

/*
   La fonction envoyer_message_parametres_var prend un nombre arbitraire de
   chaines de caracteres et les envoie au scruteur apres les avoir formate
   correctement.
*/
extern void envoyer_message_parametres_var();

/*
   La fonction envoyer_message_tableau fait la meme chose que
   la fonction envoyer_message_parametres_var, mais les chaines
   de caracteres lui sont passees dans une structure Message.
*/
extern void envoyer_message_tableau();

/*
   attendre_reponse renvoie un message de la source et du type demande.
*/
extern Message attendre_reponse();



/*********************************************************************
 * Header file : gestion_messages
 */

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










