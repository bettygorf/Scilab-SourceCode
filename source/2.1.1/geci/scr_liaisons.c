/*********************************************************/
/* Module de gestion des liaisons pour le scruteur. V1.0 */
/*********************************************************/

#include <sys/types.h>
#include <sys/time.h>
#include <stdio.h>
#include <fcntl.h>

#include "gestion_memoire.h"

#include "libCom.h"
#include "listes_chainees.h"

#include "scruteur.h"
#include "scr_liaisons.h"
#include "scr_applications.h"
#include "scr_messages.h"

static void ajouter_liaison();
static void supprimer_liaison();

static void ajouter_liaison(application_source,identificateur_destination)
application *application_source;
char *identificateur_destination;
{
    if (ldc_rechercher_objet(application_source -> liste_liaisons,identificateur_destination) != NULL)
	    Erreur_scruteur(concatenation_plusieurs_chaines("<ajouter_liaison> : Liaison deja existante entre ",application_source -> identificateur_appli," et ",identificateur_destination,NULL));
    
    if (ldc_rechercher_objet(liste_applications, identificateur_destination) == NULL)
	    Erreur_scruteur(concatenation_plusieurs_chaines("<ajouter_liaison> : Destination inexistante : ",identificateur_destination,NULL));
    
    ldc_ajouter_objet(application_source -> liste_liaisons, dupliquer_chaine(identificateur_destination));
}

void desallouer_liaison(objet)
ldc_objet_liste objet;
{
    liberer(objet);
}

int rechercher_liaison(objet,correspondance)
ldc_objet_liste objet;
ldc_element_correspondance correspondance;
{
    char *identificateur = (char *) correspondance;
    liaison_dest identificateur_liaison = (liaison_dest) objet;
    
    if (correspondance == NULL)
	    return 1;
    
    return !strcmp(identificateur,identificateur_liaison);
}

static void supprimer_liaison(appli_a_deconnecter,identificateur_destination)
application *appli_a_deconnecter;
char *identificateur_destination;
{
    if (ldc_supprimer_objet(appli_a_deconnecter -> liste_liaisons, identificateur_destination) == NULL)
	    Erreur_scruteur(concatenation_plusieurs_chaines("<supprimer_liaison> : Liaison inexistante entre ",appli_a_deconnecter -> identificateur_appli," et ",identificateur_destination,NULL));
}

void supprimer_liaisons_appli(identificateur)
char *identificateur;
{
    application *application_scrutee = ldc_rechercher_objet(liste_applications,NULL);

    while(application_scrutee != NULL) {
	ldc_supprimer_objet(application_scrutee -> liste_liaisons,identificateur);
	application_scrutee = ldc_objet_suivant(liste_applications,application_scrutee -> identificateur_appli);
    }
}



/* Methodes affectees au messages spontanes */

void poster_liste_elemnt_actmsg(message)
Message message;
{
    application *application_source, *application_destinataire;
    liaison_dest liaison;
    int i,desc;
    char machine_hote[MAXHOSTLEN];
    
    if ((application_source = ldc_rechercher_objet(liste_applications, message.tableau[0])) == NULL)
	    Erreur_scruteur(concatenation_plusieurs_chaines("<poster_liste_elemnt> : Application inexistante : ",message.tableau[0],NULL));
    
    liaison = ldc_rechercher_objet(application_source -> liste_liaisons, NULL);
    
    if (liaison == NULL) {
	if(socket_com == -1) /* GeCI local */
		envoyer_message_var(ID_XGeCI,MSG_ERREUR_LIAISON_SCRUTEUR,
				    "Attentionnnnnnnnnn !!!!!!!!! : Cette application n'est pas connectee !",NULL);
	else	/* GeCI distant */    	 
		envoyer_message_brut_directement(message, socket_com);
    }
    while(liaison != NULL) {
	if ((application_destinataire = ldc_rechercher_objet(liste_applications, liaison)) == NULL)
		Erreur_scruteur(concatenation_plusieurs_chaines("<poster_liste_elemnt> : Application inexistante : ", liaison,NULL));
	
	gethostname(machine_hote,MAXHOSTLEN) ;
	if(strcmp(application_destinataire->nom_machine, machine_hote)) { /* Autre machine */
	    for (i=0; i<nb_machines; i++) {
		if(!strcmp(application_destinataire->nom_machine,
			   liste_machines[i].nom_machine)) {
		    desc=liste_machines[i].desc;
		    i=nb_machines;
		}
	    }
	    envoyer_message_brut_directement(message, desc);
	}
	else {
	    liberer(message.tableau[1]);
	    message.tableau[1]=dupliquer_chaine(liaison);
	    
	    liberer(message.tableau[2]);
	    message.tableau[2]=dupliquer_chaine(MSG_DISTRIB_LISTE_ELMNT);
	    
	    envoyer_message_brut(message);
	}
	liaison = ldc_objet_suivant(application_source -> liste_liaisons, liaison);
    }
}



void creer_liaison_actmsg(message)
Message message;
{
    application *application_courante;
    char machine_hote[MAXHOSTLEN];
    int i,desc;
    
    if ((application_courante = ldc_rechercher_objet(liste_applications,message.tableau[3])) == NULL) {
	/* On est forcement dans un scruteur distant */
	/* On rajoute cette application en lui donnant arbitrairement comme voie de communication 
	   la voie de communication avec le scruteur (ou geci) local */
	ajouter_application(message.tableau[3],"INCONNUE",socket_com,socket_com,-2);
	if ((application_courante = 
	     ldc_rechercher_objet(liste_applications,message.tableau[3])) == NULL)
		Erreur_scruteur("<creer_liaison_actmsg> Probleme dans l'enregistrement de l'application");
    }
    ajouter_liaison(application_courante,message.tableau[4]);
    
    if ((application_courante = ldc_rechercher_objet(liste_applications,message.tableau[4])) == NULL)
	    Erreur_scruteur(concatenation_plusieurs_chaines("<detruire_liaison> : Application inexistante : ",message.tableau[4],NULL));
    
    /* Autre machine */
    gethostname(machine_hote,MAXHOSTLEN) ;
    if(strcmp(application_courante->nom_machine, machine_hote)) {
	for (i=0; i<nb_machines; i++) {
	    if(!strcmp(application_courante->nom_machine, liste_machines[i].nom_machine)) {
		desc=liste_machines[i].desc;
		i=nb_machines;
	    }
	}
	liberer(message.tableau[0]);
	message.tableau[0]=dupliquer_chaine(ID_GeCI_local);
	
	envoyer_message_brut_directement(message,desc);
    }
}



void detruire_liaison_actmsg(message)
Message message;
{
    application *application_source, *application_destinataire;
    char machine_hote[MAXHOSTLEN];
    liaison_dest liaison;
    char i, desc;
    

    if ((application_source = ldc_rechercher_objet(liste_applications,message.tableau[3])) == NULL)
	    Erreur_scruteur(concatenation_plusieurs_chaines("<detruire_liaison> : Application inexistante : ",message.tableau[3],NULL));
    
    liaison = ldc_rechercher_objet(application_source -> liste_liaisons, NULL);
    
    if (liaison == NULL) 
	    envoyer_message_var(ID_XGeCI,MSG_ERREUR_LIAISON_SCRUTEUR,
				"Attentionnnnnnnnnn !!!!!!!!! : Cette application n'est pas connectee !",NULL);
    
    while(liaison != NULL) {
	if ((application_destinataire = ldc_rechercher_objet(liste_applications, liaison)) == NULL)
		Erreur_scruteur(concatenation_plusieurs_chaines("<poster_liste_elemnt> : Application inexistante : ", liaison,NULL));
	
	gethostname(machine_hote,MAXHOSTLEN) ;
	if(strcmp(application_destinataire->nom_machine, machine_hote)) { /* Autre machine */
	    for (i=0; i<nb_machines; i++) {
		if(!strcmp(application_destinataire->nom_machine, liste_machines[i].nom_machine)) {
		    desc=liste_machines[i].desc;
		    i=nb_machines;
		}
	    }
	    liberer(message.tableau[0]);
	    message.tableau[0]=dupliquer_chaine(ID_GeCI_local);
	    envoyer_message_brut_directement(message, desc);
	}
	supprimer_liaison(application_source,message.tableau[4]);
	liaison = ldc_objet_suivant(application_source -> liste_liaisons, liaison);
    }
}

