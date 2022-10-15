/********************************************************/
/* Module de gestion de messages pour le scruteur. v1.0 */
/********************************************************/

#include <varargs.h>
#include <stdio.h>
#include <strings.h>

#include "libCom.h"
#include "formatage_messages.h"
#include "gestion_memoire.h"

#include "scr_liaisons.h"
#include "scr_applications.h"
#include "scr_messages.h"

typedef struct Actions_messages{
    char *source;
    char *type_message;
    int nb_parametres;
    void (*action)();
} actions_messages;

char *Identificateur_application=ID_SCRUTEUR;

static int lire_buffer_sur_pipe();

/* Table des messages reconnus par le scruteur */

actions_messages tb_messages[]={
{NULL, MSG_LANCER_APPLI, NBP_LANCER_APPLI, lancer_appli_actmsg},
{NULL, MSG_LANCER_APPLI_SANS_COM, NBP_LANCER_APPLI_SANS_COM, lancer_appli_sans_comm_actmsg},
{ID_XGeCI, MSG_FIN_XGeCI, NBP_FIN_XGeCI, fin_xgeci_actmsg},
{NULL, MSG_FIN_APPLI, NBP_FIN_APPLI, fin_appli_actmsg},
{NULL, MSG_QUITTER_APPLI, NBP_QUITTER_APPLI, quitter_appli_actmsg},
{ID_GeCI_local, MSG_DESTRUCTION, NBP_DESTRUCTION, auto_destruction},
{NULL, MSG_CREER_LIAISON, NBP_CREER_LIAISON, creer_liaison_actmsg},
{NULL, MSG_DETRUIRE_LIAISON, NBP_DETRUIRE_LIAISON, detruire_liaison_actmsg},
{NULL, MSG_POSTER_LISTE_ELMNT, NBP_POSTER_LISTE_ELMNT, poster_liste_elemnt_actmsg},
{NULL, MSG_ENVOYER_LISTE_ELMNT, NBP_ENVOYER_LISTE_ELMNT, poster_liste_elemnt_actmsg},
{NULL, MSG_CHANGER_CHEMIN, NBP_CHANGER_CHEMIN, changer_repertoire_actmsg},
{NULL, NULL, 0, erreur_message_actmsg}};

/* Cette procedure effectue une recherche dans la table des */
/* messages tb_messages. Si le message est trouve, la       */
/* fonction action correspondante est appelee.              */

void interpreter_message(message)
Message message;
{
    int i;
    
    i=0;
    while(tb_messages[i].nb_parametres != 0) {
	
	if (message.taille >= 3)
		
		if (tb_messages[i].source == NULL || 
                    !strcmp(tb_messages[i].source,message.tableau[0]))
			
			if (tb_messages[i].type_message == NULL || 
			    !strcmp(tb_messages[i].type_message,message.tableau[2])) {
			    
			    if (!strcmp(message.tableau[1],Identificateur_application)) {
				
				if (tb_messages[i].nb_parametres >= 0) {
				    
				    if (message.taille == tb_messages[i].nb_parametres)
					   
					    break;
				}
				else {
				    if (message.taille >= -tb_messages[i].nb_parametres)
					    break;
				}
			    }
			}
	i++;
    }

    (*tb_messages[i].action)(message);
}

void envoyer_message_var(va_alist)
    va_dcl
{
    Message message;
    va_list parametres;
    
    va_start(parametres);
    
    message=convertir_nombre_arbitraire_de_chaines_en_tableau(&parametres);
    
    va_end(parametres);
    
    envoyer_message(message);
    
    liberer_message(message);
}

void envoyer_message(message)
Message message;
{
    Message nouveau_message;
    int compteur;
    
    nouveau_message.tableau=allouer_type(char *,message.taille+1);
    
    nouveau_message.tableau[0]=dupliquer_chaine(Identificateur_application);
    
    for(compteur=0;compteur<message.taille;compteur++)
	    nouveau_message.tableau[compteur+1]=message.tableau[compteur];
    nouveau_message.taille=message.taille+1;
    
    envoyer_message_brut(nouveau_message);
    
    liberer(nouveau_message.tableau[0]);
    liberer(nouveau_message.tableau);
/*    liberer_message(nouveau_message);*/
}

void envoyer_message_brut(message)
Message message;
{
    long longueur_trame;
    char *trame,*noyau_trame;
    application *recherche_appli_destination;
    
    noyau_trame=coller_chaines(message);
    
    trame=concatenation_plusieurs_chaines(DEBUT_DE_TRAME," ",noyau_trame," ",FIN_DE_TRAME,NULL);
    
    liberer(noyau_trame);
    
    recherche_appli_destination = ldc_rechercher_objet(liste_applications,message.tableau[1]);
    
    if (recherche_appli_destination == NULL)
	    Erreur_scruteur(concatener_deux_chaines("<rechercher_application> : mauvais parametres : ",message.tableau[1]));
    
    longueur_trame=strlen(trame)+1;
    
    write(recherche_appli_destination->pipe_vers_appli,&longueur_trame,sizeof(longueur_trame));
    write(recherche_appli_destination->pipe_vers_appli,trame,longueur_trame);
    
    liberer(trame);
}

void envoyer_message_brut_directement(message,destinataire)
Message message;
int destinataire;
{
    long longueur_trame;
    char *trame,*noyau_trame;
    
    noyau_trame=coller_chaines(message);
    
    trame=concatenation_plusieurs_chaines(DEBUT_DE_TRAME," ",noyau_trame," ",FIN_DE_TRAME,NULL);
    
    liberer(noyau_trame);
    
    longueur_trame=strlen(trame)+1;
    
    write(destinataire,&longueur_trame,sizeof(longueur_trame));

    write(destinataire,trame,longueur_trame);
   
    liberer(trame);
}

int recevoir_message(descripteur,message)
int descripteur;
Message *message;
{
    char *trame;
    long longueur;

    if (lire_buffer_sur_pipe(descripteur,&longueur,sizeof(longueur)) == 0) return 0;
    trame=allouer_type(char,longueur+1);
    if (lire_buffer_sur_pipe(descripteur,trame,longueur) == 0) return 0;
    trame[longueur]='\0';
    *message=decouper_trame(trame);
    liberer(trame);
    return 1;
}

static int lire_buffer_sur_pipe(descripteur,buffer,taille)
int descripteur;
void *buffer;
long taille;
{
    long caracteres_lus = 0;
    long caracteres_a_lire;
    long longueur_paquet;
    
    do  {
	caracteres_a_lire = taille - caracteres_lus;
	while((longueur_paquet = read(descripteur,((char *)buffer)+caracteres_lus,caracteres_a_lire)) == -1)
		;
	if (longueur_paquet == 0) return 0;
	caracteres_lus += longueur_paquet;
    }
    while(caracteres_lus < taille);
    return 1;
}

/* Methodes affectees au messages spontanes */
void erreur_message_actmsg(message)
Message message;
{
    Erreur_scruteur(concatener_deux_chaines("<erreur message> : Mauvais format de message : ",message.tableau[2]));
}
