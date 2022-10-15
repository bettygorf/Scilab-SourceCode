/*
   communications.c

   module destine a faire la jonction entre les modules
   d'interface et le systeme de communications.
*/

#include <varargs.h>
#include <stdio.h>
#include <string.h>

#include "gestion_memoire.h"
#include "formatage_messages.h"
#include "libCom.h"
#include "gestion_messages.h"
#include "utilitaires.h"
#include "communications.h"

static char *creer_trame();

void envoyer_message_parametres_var(va_alist)
va_dcl
{
    va_list liste;

    tableau_avec_taille conversion;

    va_start(liste);

    conversion=convertir_nombre_arbitraire_de_chaines_en_tableau(&liste);

    envoyer_message_tableau(conversion);

    va_end(liste);

    liberer_tableau_de_pointeurs(conversion.tableau,conversion.taille);

    gbd_liberer_mixte(conversion.tableau);
}

void envoyer_message_tableau(message)
Message message;
{
    char *trame;
    Message nouveau_message;
    int compteur;

    nouveau_message.tableau=allouer_type(char *,message.taille+1);
    nouveau_message.tableau[0]=dupliquer_chaine("");

    for(compteur=0;compteur<message.taille;compteur++)
	nouveau_message.tableau[compteur+1]=message.tableau[compteur];
    nouveau_message.taille=message.taille+1;

    trame=creer_trame(nouveau_message);

    liberer(nouveau_message.tableau[0]);
    liberer(nouveau_message.tableau);

    ecrire_trame(trame);

    liberer(trame);
}



Message attendre_reponse(source,type_message,nb_parametres_min)
char *source;
char *type_message;
int nb_parametres_min;
{
    return attendre_message(source,type_message,nb_parametres_min);
}


/*
    creer_trame transforme un Message en une trame.
    (toutes les chaines sont concatenees dans une seule
     et le tout est encapsule entre DEBUT_DE_TRAME et FIN_DE_TRAME)
*/
static char *creer_trame(message)
Message message;
{
    char *trame;
    char *milieu_de_trame;
    int taille_trame;

    liberer(message.tableau[0]);
    message.tableau[0]=dupliquer_chaine(identificateur_appli());

    milieu_de_trame=coller_chaines(message);

    taille_trame=strlen(DEBUT_DE_TRAME)+1+strlen(milieu_de_trame)+1+strlen(FIN_DE_TRAME)+1;
    trame=allouer_type(char,taille_trame);
    *trame='\0';

    strcat_plus_caractere(trame,DEBUT_DE_TRAME,SEPARATEUR);
    strcat_plus_caractere(trame,milieu_de_trame,SEPARATEUR);
    strcat(trame,FIN_DE_TRAME);

    liberer(milieu_de_trame);
    return trame;
}
