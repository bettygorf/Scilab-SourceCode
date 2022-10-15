/*******************************************************************/
/* Module de gestion des applications lancees par le scruteur      */
/*******************************************************************/

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
#include "connexion.h"

static int rechercher_application();
static int rechercher_machine();
static void desallouer_application();
static void desallouer_machine();

ldc_liste_chainee liste_applications=NULL;
application *application_suivante;
int nb_machines=0;
liaison_machine liste_machines[NB_MACHINES];
Message memorisation_message;

int executer_application(identificateur,nom_machine,argc,argv,flag_communication)
char *identificateur;
char *nom_machine;
int argc;
char *argv[];
int flag_communication;
{
    int compteur,compteur_bis;
    int pipe_vers_appli[2];
    int pipe_vers_scruteur[2];
    int id;
    int position_id_pipes;
    long flags;
    char **nouveau_argv;

    if (flag_communication)    {
	if (pipe(pipe_vers_appli) || pipe(pipe_vers_scruteur))
		Erreur_scruteur("<executer_application> : Creation d'un pipe impossible.");
	
/*	flags=fcntl(pipe_vers_appli[0],F_GETFL,0);
	fcntl(pipe_vers_appli[0],F_SETFL,O_NDELAY | flags);*/
	fcntl(pipe_vers_appli[0],F_SETFL,
	      O_NONBLOCK|fcntl(pipe_vers_appli[0],F_GETFL,0));
    }
    
    if ((id=fork()) == 0) { /* Atelier */

	if (flag_communication) {
	    close(pipe_vers_appli[1]);
	    close(pipe_vers_scruteur[0]);
	    
	    position_id_pipes = -1;
	    for(compteur=1;compteur<argc;compteur++)
		    if (!strcmp(argv[compteur],INS_ID_PIPES))	{
			position_id_pipes=compteur-1;
			break;
		    }
	    
	    nouveau_argv=allouer_type(char *,argc+4);
	    
	    for(compteur=0,compteur_bis=0; compteur<argc;compteur++,compteur_bis++) {
		
		nouveau_argv[compteur_bis]=dupliquer_chaine(argv[compteur]);
		
		if (compteur == position_id_pipes || 
		    (position_id_pipes == -1 && compteur == 0)) {
		    nouveau_argv[compteur_bis+1]=allouer_type(char,7);
		    nouveau_argv[compteur_bis+2]=allouer_type(char,5);
		    nouveau_argv[compteur_bis+3]=allouer_type(char,5);
		    sprintf(nouveau_argv[compteur_bis+1],"-pipes");
		    sprintf(nouveau_argv[compteur_bis+2],"%.4d",pipe_vers_appli[0]);
		    sprintf(nouveau_argv[compteur_bis+3],"%.4d",pipe_vers_scruteur[1]);
		    compteur_bis+=3;
		    if (position_id_pipes != -1)
			    compteur++;
		}
	    }
	    nouveau_argv[compteur_bis]=NULL;
	    execvp(nouveau_argv[0],nouveau_argv);
	}
	else
		execvp(argv[0],argv);
	
	perror(NULL);
	Erreur_scruteur(concatener_deux_chaines("<executer_application> : Impossible d'executer ",argv[0]));
    }
    
    if (id != -1)  { /* GeCI */
	
	if (flag_communication) {
	    close(pipe_vers_appli[0]);
	    close(pipe_vers_scruteur[1]);
	    ajouter_application(identificateur,nom_machine,
				pipe_vers_scruteur[0],pipe_vers_appli[1],id);
	    envoyer_message_var(identificateur,MSG_IDENT_APPLI,NULL);
	}
	return 0;
    }
    return -1;
}



int executer_application_a_distance(message)
Message message;
{
    int i, desc, existe;
    long flags;
    
    existe=0;
    for (i=0; i<nb_machines; i++) {
	if(!strcmp(message.tableau[4], liste_machines[i].nom_machine)) {
	    desc=liste_machines[i].desc;
	    existe=1;
	    i=nb_machines;
	}
    }
    if (!existe){
	
	/* Lancement du scruteur sur la machine distante et connexion */
	desc=connexion(message.tableau[4]); 
	
	if (desc == -1)  {/* pas de demon sur la machine cible */ 
	    envoyer_message_var(ID_XGeCI,MSG_ERREUR_LIAISON_SCRUTEUR,
				"Attentionnnnnnnnnn !!!!!!!! : Probleme de connexion \nLe demon (calicod) est il lance sur cette machine ? ",NULL);
	    envoyer_message_var(ID_XGeCI,MSG_FIN_APPLI,message.tableau[3],NULL);
	    /*Erreur_scruteur("<executer_application_a_distance> : Pas de demon sur la machine indiquee.");*/
	    return ;
	}
	
/*	flags=fcntl(desc,F_GETFL,0);
	fcntl(desc,F_SETFL,flags|O_NDELAY);*/
	fcntl(desc,F_SETFL,O_NONBLOCK|fcntl(desc,F_GETFL,0));
	
	liste_machines[nb_machines].nom_machine=dupliquer_chaine(message.tableau[4]);
	liste_machines[nb_machines].desc=desc;
	nb_machines++;
    }
    ajouter_application(message.tableau[3],message.tableau[4],desc,desc,-2);
    
    if(memorisation_message.taille!=0) {
	envoyer_message_brut_directement(memorisation_message,desc);
	liberer_message(memorisation_message);
    }
    liberer(message.tableau[0]);
    message.tableau[0]=dupliquer_chaine(ID_GeCI_local);
    
    envoyer_message_brut_directement(message,desc);
    return 0;

}

void ajouter_application(identificateur,nom_machine,pipe_vers_scruteur,pipe_vers_appli,pid)
char *identificateur;
char *nom_machine;
int pipe_vers_scruteur;
int pipe_vers_appli;
int pid;
{
    application *nouvelle_application;
    
    if (pipe_vers_scruteur != -2 ) 
	    FD_SET (pipe_vers_scruteur,&readfds);
    
    
    if (liste_applications == NULL)
	    liste_applications = ldc_creer(rechercher_application,desallouer_application,liberer,allouer);
    nouvelle_application = allouer_type(application,1);
    nouvelle_application -> identificateur_appli = dupliquer_chaine(identificateur);
    nouvelle_application -> pipe_vers_appli = pipe_vers_appli;
    nouvelle_application -> pipe_vers_scruteur = pipe_vers_scruteur;
    nouvelle_application -> nom_machine = dupliquer_chaine(nom_machine);
    nouvelle_application -> liste_liaisons = ldc_creer(rechercher_liaison,desallouer_liaison,liberer,allouer);
    nouvelle_application -> pid = pid;
    
    ldc_ajouter_objet(liste_applications,nouvelle_application);
}

void supprimer_application(identificateur)
char *identificateur;
{
    ldc_supprimer_objet(liste_applications,identificateur);
    supprimer_liaisons_appli(identificateur);
}

static void desallouer_application(objet)
ldc_objet_liste objet;
{
    application *application_a_detruire = (application *)objet;
    char machine_hote[MAXHOSTLEN];    
    
    gethostname(machine_hote,MAXHOSTLEN) ;
    
    /* Meme machine */
    if(!strcmp(application_a_detruire -> nom_machine, machine_hote))  {
	
	FD_CLR (application_a_detruire->pipe_vers_scruteur,&readfds);
	close(application_a_detruire -> pipe_vers_appli);
	close(application_a_detruire -> pipe_vers_scruteur);
    }
    if (application_a_detruire -> liste_liaisons != NULL)
	    ldc_detruire(application_a_detruire -> liste_liaisons);
    
    liberer(application_a_detruire -> identificateur_appli);
    liberer(application_a_detruire -> nom_machine);
    liberer(application_a_detruire);
}

static int rechercher_application(objet,correspondance)
ldc_objet_liste objet;
ldc_element_correspondance correspondance;
{
    application *application_a_chercher = (application *)objet;
    char *identificateur = (char *)correspondance;
    
    if (correspondance == NULL)
	    return 1;
    
    return (!strcmp(application_a_chercher -> identificateur_appli,identificateur));
}



void detruire_applications_scruteur()
{
    application *application_restante;
    char machine_hote[MAXHOSTLEN];
    Message message;
    int i, desc;
    
    gethostname(machine_hote,MAXHOSTLEN) ;
    
    while((application_restante = ldc_rechercher_objet(liste_applications,NULL)) != NULL) {
	/* Meme machine */
	if(!strcmp(application_restante -> nom_machine, machine_hote)) 
	    envoyer_message_var(application_restante -> identificateur_appli,
				MSG_QUITTER_APPLI,
				application_restante -> identificateur_appli,
				NULL);
	else {
	    for (i=0; i<nb_machines; i++) {
		if(!strcmp(application_restante -> nom_machine, 
			   liste_machines[i].nom_machine)) {
		    desc=liste_machines[i].desc;
		    i=nb_machines;
		}
	    }
	    message.taille=4;
	    message.tableau=allouer_type(char *,message.taille+1);
	    message.tableau[0]=dupliquer_chaine(ID_SCRUTEUR);
	    message.tableau[1]=dupliquer_chaine(ID_SCRUTEUR);
	    message.tableau[2]=dupliquer_chaine(MSG_QUITTER_APPLI);
	    message.tableau[3]=dupliquer_chaine(application_restante->identificateur_appli);
	    envoyer_message_brut_directement(message, desc);
	    liberer_message(message);
	} 
	supprimer_application(application_restante -> identificateur_appli);
    }
}

/* Methodes affectees au messages spontanes */

void lancer_appli_actmsg(message)
Message message;
{
    int compteur=0;
    char machine_hote[MAXHOSTLEN];
    
    gethostname(machine_hote,MAXHOSTLEN) ;
   
    /* Meme machine */
    if(!strcmp(message.tableau[4], machine_hote)) {
	executer_application(message.tableau[3],message.tableau[4],
			     message.taille-5,message.tableau+5,1);
    }
    else { 
	/* Demande de lancement de l'atelier sur une machine distante */
	executer_application_a_distance(message);
    }
}

void lancer_appli_sans_comm_actmsg(message)
Message message;
{
    executer_application(message.tableau[3],message.tableau[4],message.taille-5,message.tableau+5,0);
}

void fin_xgeci_actmsg(message)
Message message;
{
    supprimer_application(ID_XGeCI);
    detruire_applications_scruteur();
    exit(1);
}

void fin_appli_actmsg(message)
Message message;
{
    if(!strcmp(message.tableau[3], application_suivante->identificateur_appli)) 
	    application_suivante = ldc_objet_suivant(liste_applications,application_suivante -> identificateur_appli);
    
    supprimer_application(message.tableau[3]);
    if(socket_com == -1) /* GeCI local */
	    envoyer_message_var(ID_XGeCI,MSG_FIN_APPLI,message.tableau[3],NULL);
    else /* GeCI distant */
	    envoyer_message_var(ID_GeCI_local,MSG_FIN_APPLI,message.tableau[3],NULL);
}

void quitter_appli_actmsg(message)
Message message;
{
    application *recherche_appli_a_detruire;
    char machine_hote[MAXHOSTLEN];
    Message nouveau_message;
    int i, desc;
    
    gethostname(machine_hote,MAXHOSTLEN);

    recherche_appli_a_detruire = ldc_rechercher_objet(liste_applications,message.tableau[3]);
    
    if (recherche_appli_a_detruire == NULL)
	    Erreur_scruteur(concatener_deux_chaines("<quitter_appli_actmsg> : mauvais parametres : ",message.tableau[3]));
    
    /* Meme machine */
    if(!strcmp(recherche_appli_a_detruire -> nom_machine, machine_hote))  {
	envoyer_message_var(message.tableau[3],MSG_QUITTER_APPLI,message.tableau[3],NULL);
	supprimer_application(message.tableau[3]);
	wait(NULL);
    }
    else {
	for (i=0; i<nb_machines; i++) {
	    if(!strcmp(recherche_appli_a_detruire -> nom_machine, liste_machines[i].nom_machine)) {
		desc=liste_machines[i].desc;
		i=nb_machines;
	    }
	}
	nouveau_message.taille=4;
	nouveau_message.tableau=allouer_type(char *,nouveau_message.taille+1);
	nouveau_message.tableau[0]=dupliquer_chaine(ID_SCRUTEUR);
	nouveau_message.tableau[1]=dupliquer_chaine(ID_SCRUTEUR);
	nouveau_message.tableau[2]=dupliquer_chaine(MSG_QUITTER_APPLI);
	nouveau_message.tableau[3]=dupliquer_chaine(recherche_appli_a_detruire->identificateur_appli);
	envoyer_message_brut_directement(nouveau_message, desc);
	liberer_message(nouveau_message);
	
	supprimer_application(message.tableau[3]);
    }
}

void auto_destruction(message)
Message message;
{
    exit(1);
}


void changer_repertoire_actmsg(message)
Message message;
{
    int i;
    
    if(socket_com == -1) {
	liberer(message.tableau[0]);
	message.tableau[0]=dupliquer_chaine(ID_GeCI_local);
	memorisation_message.tableau=allouer_type(char *,message.taille);
	for(i=0;i<message.taille;i++)
		memorisation_message.tableau[i]=dupliquer_chaine(message.tableau[i]);
	memorisation_message.taille=message.taille;
    }
    chdir(message.tableau[3]); 
}
