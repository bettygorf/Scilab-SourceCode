/**************************************************************/
/* Module de gestion des messages pour les applis CalICo v1.3 */
/**************************************************************/

#include <stdio.h>
#include <string.h>
#include <signal.h>
#ifdef hpux
#include <unistd.h>
#endif
#include <fcntl.h>

#ifdef __STDC__
#include <stdlib.h>
#include <unistd.h>
#endif

#ifdef __MSC__
int fcntl(int a,int b,int c) { } ;
/** XXXXX : not defined in vc++ **/
#define SIGQUIT 0
#define F_GETFL 0
#define F_SETFL 0
#define O_NONBLOCK 0
#endif 

#include "utilitaires.h"
#include "libCom.h"
#include "formatage_messages.h"
#include "gestion_memoire.h"
#include "gestion_messages.h"

#define LONG 11
/* Apres un appel a init_messages, tb_messages contient la   */
/* table des messages spontanes reconnus par l'application.  */
/* De meme, pipe_out et pipe_in contiennent les descripteurs */
/* des deux pipes de communication vers le scruteur.         */
/* Un message est ensuite envoye par le scruteur afin de     */
/* transmettre a l'application son identificateur (stocke    */
/* a l'adresse Identificateur_application.                   */

static actions_messages *tb_messages=NULL;
static int pipe_out = -1;
static int pipe_in = -1;
static char *Identificateur_application=NULL;

static void interpreter_message_spontane();
static void erreur();
static int lire_buffer_sur_pipe();

#define MAUVAISE_TRAME fprintf(stderr,"<attendre_message> : mauvais format de trame !\n")

/* Initialisation du module de gestion des messages. */
void init_messages(table,p_in,p_out)
actions_messages *table;
int p_in;
int p_out;
{
    char *trame;
    Message message;
#if defined (sun) && defined (SYSV)
    sigset_t set,oset;
#endif  
    
    tb_messages=table;
    pipe_in=p_in;
    pipe_out=p_out;

#if defined (sun) && defined (SYSV)
    sigemptyset(&set);
    sigemptyset(&oset);
    sigaddset(&set,SIGTERM);
    sigprocmask(SIG_BLOCK,&set,&oset);
    sigemptyset(&set);
    sigemptyset(&oset);
    sigaddset(&set,SIGQUIT);
    sigprocmask(SIG_BLOCK,&set,&oset);
    sigemptyset(&set);
    sigemptyset(&oset);
    sigaddset(&set,SIGINT);
    sigprocmask(SIG_BLOCK,&set,&oset);
#else
    sigblock(SIGTERM);
    sigblock(SIGQUIT);
    sigblock(SIGINT);
#endif

    while((trame=lire_trame()) ==  NULL)
	;

    message=decouper_trame(trame);

    liberer(trame);

    if ((message.taille != NBP_IDENT_APPLI) || (strcmp(MSG_IDENT_APPLI,message.tableau[2]) != 0))
	erreur("message d'identification invalide.");

    Identificateur_application=dupliquer_chaine(message.tableau[1]);

    liberer_message(message);
}

/* Retourne un char * pointant sur l'identificateur de l'application  */
/* passe lors de l'initialisation des communications par le scruteur. */
/* ATTENTION : il est interdit d'effectuer des effets de bords sur la */
/* chaine retournee, ou de la liberer.                                */
char *identificateur_appli()
{
    if (Identificateur_application == NULL)
	erreur("communications non initialisees.");

    return Identificateur_application;
}

/* Cette procedure doit etre appelee periodiquement a travers */
/* un XtAppAddTimeOut par exemple afin de scanner le pipe     */
/* connecte au scruteur. Cette procedure n'est pas blocante   */
/* tant qu'il n'y a pas de messages. Si un messages est lu,   */
/* un appel a interpreter_message_spontane est effectue.      */
void scanner_messages()
{
    char *trame;
    Message message;

    if ((trame=lire_trame()) != NULL)
    {
	message=decouper_trame(trame);
	if (message.taille != -1)
	{
	    interpreter_message_spontane(message);
	    liberer_message(message);
	}
	else
	    MAUVAISE_TRAME;
    }
}

/* Attente d'un message non spontane.                  */
/* Les messages spontanes sont toujours traites.       */
/* Attention : l'utilisation de identificateur_appli() */
/* est preferable a l'utilisation directe de           */
/* Identificateur_application, car on n'a pas encore   */
/* verifie si init_messages() a bien ete appelee.      */
static Message mess_resultat;
Message attendre_message(source,type_message,nb_parametres_max)
char *source;
char *type_message;
int nb_parametres_max;
{
  char *trame;
  int ff = fcntl(pipe_in,F_GETFL,0);

  while(1)
    {
      fcntl(pipe_in, F_SETFL, ff&~O_NONBLOCK);
	
      trame=lire_trame();
      mess_resultat=decouper_trame(trame);

      if (mess_resultat.taille != -1)
	{
	  if (((nb_parametres_max >= 0) && (mess_resultat.taille == nb_parametres_max)) || ((nb_parametres_max < 0) && (mess_resultat.taille >= -nb_parametres_max)))
	    if ((source == NULL) || !strcmp(source,mess_resultat.tableau[0]))
	      if ((type_message != NULL) || !strcmp(type_message,mess_resultat.tableau[2]))
		if (!strcmp(mess_resultat.tableau[1],identificateur_appli()))
		  break;
		
	  interpreter_message_spontane(mess_resultat);
	  liberer_message(mess_resultat);
	}
      else
	MAUVAISE_TRAME;
    }
  fcntl(pipe_in, F_SETFL, ff);
  return mess_resultat;
}

/* Cette procedure effectue une recherche dans la table des */
/* messages tb_messages. Si le message est trouve, la       */
/* fonction action correspondante est appelee.              */
static void interpreter_message_spontane(message)
Message message;
{
    int i;

    if (tb_messages == NULL)
	erreur("communications non initialisees.");

    i=0;
    while(tb_messages[i].type_message != NULL)
    {
	if (message.taille >= 3)
	    if ((tb_messages[i].source == NULL) || !strcmp(tb_messages[i].source,message.tableau[0]))
		if ((tb_messages[i].type_message == NULL) || !strcmp(tb_messages[i].type_message,message.tableau[2]))
		{
		    if (!strcmp(message.tableau[1],Identificateur_application))
		    {
			if (tb_messages[i].nb_parametres >= 0)
			{
			    if (message.taille == tb_messages[i].nb_parametres)
				break;
			}
			else
			{
			    if (message.taille >= -tb_messages[i].nb_parametres)
				break;
			}
		    }
		}
	i++;
    }
    (*tb_messages[i].action)(message);
}

/* Envoie d'une trame au scruteur */
void ecrire_trame(trame)
char *trame;
{	
  
  long longueur;
  char chaine_num[LONG];

  if (pipe_out == -1)
    erreur("communications non initialisees.");
  
  longueur=strlen(trame)+1;
  sprintf(chaine_num,"%010d",(int) longueur);
  chaine_num[LONG]='\0';
  write(pipe_out,chaine_num,LONG);
  write(pipe_out,trame,longueur);
  
}

/* Lecture d'une trame en provenance du scruteur. */
/* Cet appel n'est pas bloquant : s'il n'y a rien */
/* a lire, cette fonction renvoie NULL.           */
char *lire_trame()
{	
    
  long longueur;
    char *trame;
    char chaine_num[LONG];
      
    if (pipe_in == -1)
	erreur("communications non initialisees.");

    if (!lire_buffer_sur_pipe(chaine_num,LONG)) return NULL;
    longueur=atol(chaine_num);
    trame=allouer_type(char,longueur+1);

    while(!lire_buffer_sur_pipe(trame,longueur))
	;

    return trame;
}


static int lire_buffer_sur_pipe(buffer,taille)
void *buffer;
long taille;
{
    long caracteres_lus = 0;
    long caracteres_a_lire;
    long longueur_paquet;
    do
    {
	caracteres_a_lire = taille - caracteres_lus;
	longueur_paquet = read(pipe_in,((char *)buffer)+caracteres_lus,
			       caracteres_a_lire);
	if (longueur_paquet == -1 && caracteres_lus == 0) {
	    return 0;
	  }
	else {
	    caracteres_lus += longueur_paquet;
	  }
    }
    while(caracteres_lus < taille);

    return 1;
}

/* Procedure de gestion des erreurs du module. */
static void erreur(msg_erreur)
char *msg_erreur;
{
  fprintf(stderr,"Module de communication : %s",msg_erreur);
  /*    fprintf(stderr,"Module de communication : %s",msg_erreur);
	exit(1);*/
}
