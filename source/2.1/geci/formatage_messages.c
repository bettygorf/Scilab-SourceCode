/*
   decoupage_messages.c
   module destine a la mise au bon
   format des messages recus ou a emettre
*/


#include <string.h>
#include "gestion_memoire.h"
#include "buffer_dynamiques.h"
#include "utilitaires.h"
#include "formatage_messages.h"
#include "libCom.h"

#define NBRE_INITIAL 10

static char *filtre();
static char *codifie_chaine();

#define ERREUR_DECOUPER \
{ \
      gbd_liberer_mixte(sauve_parametre); \
      mess_resultat.tableau=NULL; \
      mess_resultat.taille = -1; \
      return mess_resultat; \
}
  
static Message mess_resultat;	  
   
Message decouper_trame(trame_origine)
char *trame_origine;
{
    
    char *sauve_parametre;
    char *pointeur_debut;
    char *pointeur_fin;
    int compteur;

    sauve_parametre=dupliquer_chaine(trame_origine);
    pointeur_debut=sauve_parametre;
    pointeur_fin=sauve_parametre;

    if (strncmp(trame_origine,DEBUT_DE_TRAME,sizeof(DEBUT_DE_TRAME)-1))
	ERREUR_DECOUPER;

    pointeur_fin+=sizeof(DEBUT_DE_TRAME)-1;
    if (*pointeur_fin != SEPARATEUR)
	ERREUR_DECOUPER;

    pointeur_debut=++pointeur_fin;
    
    mess_resultat.tableau=gbd_creer_buffer_dynamique_type(char *,NBRE_INITIAL,allouer,reallouer,liberer,NULL);
    compteur=0;

    for(;;)
    {
	switch(*pointeur_fin)
	{
	  case '\0':
	    ERREUR_DECOUPER;
	    
	  case SEPARATEUR:
	    *pointeur_fin='\0';
	    mess_resultat.tableau=gbd_augmenter_buffer_dynamique(mess_resultat.tableau,1);
	    mess_resultat.tableau[compteur++]=filtre(pointeur_debut);
	    pointeur_fin++;
	    pointeur_debut=pointeur_fin;
	    break;
	    
	  case CARACTERE_ECHAPPEMENT:
	    if (!*(pointeur_fin+1))
		pointeur_fin++;
	    else
		pointeur_fin+=2;
	    break;
	    
	  case CARACTERE_COMMANDE:
	    if (strcmp(pointeur_debut,FIN_DE_TRAME))
		ERREUR_DECOUPER;
	    mess_resultat.tableau=gbd_augmenter_buffer_dynamique(mess_resultat.tableau,1);
	    mess_resultat.tableau[compteur]=NULL;
	    mess_resultat.taille=compteur;
	    liberer(sauve_parametre);
	    return mess_resultat;

	  default:
	    pointeur_fin++;
	    break;
	}
    }
}



char *coller_chaines(message)
Message message;
{
    int taille, compteur;
    char *resultat;
    char *buffer;

    taille=0;

    if (message.taille == 0)
	return dupliquer_chaine("");

    for(compteur=0 ; compteur < message.taille ; compteur++)
	taille+=strlen(message.tableau[compteur])+1;

    resultat=allouer_type(char,taille*2);
    *resultat='\0';

    for(compteur=0 ; compteur < message.taille-1 ; compteur++)
    {
	buffer=codifie_chaine(message.tableau[compteur]);
	strcat_plus_caractere(resultat,buffer,SEPARATEUR);
        liberer(buffer);
    }
    buffer=codifie_chaine(message.tableau[compteur]);
    strcat(resultat,buffer);
    liberer(buffer);

    return resultat;
}



void liberer_message(message)
Message message;
{
    liberer_tableau_de_pointeurs(message.tableau,message.taille);
    gbd_liberer_mixte(message.tableau);
}



/*
   La fonction filtre remplace un CARACTERE_ECHAPPEMENT suivi
   d'un caractere par le caractere, c'est a dire passe la chaine
   du format trame au format classique.
*/

static char *filtre(chaine)
char *chaine;
{
    char *chaine_destination, *pointeur, *pointeur_destination;

    chaine_destination=allouer_type(char,strlen(chaine)+1);
    pointeur=chaine;
    pointeur_destination=chaine_destination;

    do
    {
	if ( (*pointeur) ==  CARACTERE_ECHAPPEMENT )
	    pointeur++;
	*(pointeur_destination++)=*pointeur;
    }
    while(*(pointeur++));
    
    chaine_destination=reallouer_type(char,chaine_destination,strlen(chaine_destination)+1);
    return chaine_destination ;
}



/*
    La fonction codifie_chaine passe une chaine au format classique
    au format trame.
*/

static char *codifie_chaine(chaine)
char *chaine;
{
    char *pointeur_source;
    char *chaine_destination;
    char *resultat;
    int compteur;

    pointeur_source=chaine;
    chaine_destination=gbd_creer_buffer_dynamique_type(char,strlen(chaine)+1,allouer,reallouer,liberer,NULL);
    chaine_destination=gbd_augmenter_buffer_dynamique(chaine_destination,strlen(chaine)+1);
    compteur=0;

    while(*pointeur_source)
    {
	if ( (*pointeur_source == SEPARATEUR) || (*pointeur_source == CARACTERE_ECHAPPEMENT) || (*pointeur_source == CARACTERE_COMMANDE) )
	{
	    chaine_destination[compteur]=CARACTERE_ECHAPPEMENT;
	    chaine_destination=gbd_augmenter_buffer_dynamique(chaine_destination,1);
	    compteur++;
	}
	chaine_destination[compteur]=*pointeur_source;
	pointeur_source++;
	compteur++;
    }
    chaine_destination[compteur]='\0';
    resultat=dupliquer_chaine(chaine_destination);
    gbd_liberer_mixte(chaine_destination);
    return resultat;
}

