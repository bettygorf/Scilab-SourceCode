/*
 * Utility functions to build data for 
 * Scilab help browser 
 * J.P Chancelier 
 *    used by wsci/wmhelp.c ( Windows )
 *    and     xsci/h_help.c ( X Window ) 
 */

#include <stdio.h>
#include <string.h>

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
extern  char  *getenv();
#endif

#include "../graphics/Math.h"
#include "h_help.h"

extern void C2F(inffic) _PARAMS((integer * iopt,char *name,integer *nc));


/*
 * Help pathname 
 */

#define MAX_PATH_STR 1024
static char Help[MAX_PATH_STR];
static char Buf[MAX_PATH_STR];

/*
 * Functions defined here 
 */
static int NewString();
static void CleanHelpTopics();
static void CleanAproposTopics();

/**************************************
 * Info List for one chapter 
 **************************************/

char   **helpTopicInfo = 0;      /** info for the current chapter **/
int      nTopicInfo = 0;         /** number of items in the current chapter**/
static char    *helpPath = 0;
int      CurrentTopicInfo = -1;   /** chapter number of current help**/

/**************************************
 * help chapters 
 **************************************/

char* helpInfo[MAX_HELP_CHAPTERS];
char* helpPaths[MAX_HELP_CHAPTERS];
int   nInfo = 0;

/**************************************
 * Structure to deal with Apropos 
 * AP.nTopic : number of topics in the Apropos
 *             HelpTopic[i] 
 *             is in chapter HelpPaths[AP.Where[i]]
 **************************************/

Apropos AP ;


/******************************************************************
 * Callback procedure 
 * activate the help ( xless application on the selected topic 
 *****************************************************************/

void HelpActivate(ntopic) 
     int ntopic;
{
  char           *TopicInfo,*buf;
  char            Topic[30];
  int             ln, k;
  if (AP.nTopic == 0) 
    {
      /* get keyword as first word of  helpTopicInfo[ntopic] */
      TopicInfo = helpTopicInfo[ntopic];
    } 
  else 
    {
      TopicInfo = AP.HelpTopic[ntopic];
      helpPath  = helpPaths[ AP.Where[ntopic]];
    }
  /*** Set Topic to TopicInfo up to the first blank char**/
  k = 0;
  ln = strlen(TopicInfo);
  while (k < ln && TopicInfo[k] != ' ') 
    {
      Topic[k] = TopicInfo[k];
      k++;
    }
  Topic[k] = '\0';
  buf = (char *) MALLOC((strlen(helpPath) + k + 40) * (sizeof(char)));
  if (buf == NULL) 
    {
      printf("Not enough memory to allocate help tables\n");
      return;
    }
  SciCallHelp(buf,helpPath,Topic);
  FREE(buf);
}

void SciCallHelp(buf,helpPath,Topic)
     char *Topic;
     char *helpPath;
     char *buf;
{
  /** XXXXX cygwin bash scripts can't execute gcwin32 executable in batch
    up to now : we use the standard windows system function 
    that's why we need the getenv 
    ***/
#ifdef WIN32
  char *local = (char *) 0;
  local = getenv("SCI");
  if ( local != (char *) 0)
    sprintf(buf, "%s/bin/xless  %s/%s.cat ",local, helpPath, Topic);
  else
    /** maybe xless is in the path ? **/
    sprintf(buf, "xless  %s/%s.cat ", helpPath, Topic);
  /** sciprint("TestMessage : je lance un winsystem sur %s\r\n",buf); **/
  if (winsystem(buf,1))
    sciprint("help error: winsystem failed\r\n");
#else
  int i;
  C2F(xscion)(&i);
  if ( i != 0 )
    sprintf(buf, "$SCI/bin/xless %s/%s.cat 2> /dev/null &",helpPath, Topic);
  else 
    sprintf(buf, "cat %s/%s.cat | more ",helpPath, Topic);
  system(buf);
#endif
}

/**********************************************
 * seaches the help database for a specific help 
 * return 1 if memory failure occurs 
 * this is for the keyboard  scilab command help xxxx
 **********************************************/

int Sci_Help(name) 
     char *name;
{
  int i,k;
  if ( Help_Init() == 1) 
    {
      sciprint("can't use man\r\n");
      return(1);
    }
  for ( i= 0 ; i < nInfo ; i++ ) 
    {
      if (setHelpTopicInfo(i+1) == 1) return(1);
      for (k = 0; k < nTopicInfo; k++)
	{
	  if ( strncmp(name,helpTopicInfo[k],strlen(name))== 0 && 
	       helpTopicInfo[k][strlen(name)]== ' ' )
	    {
	      HelpActivate(k);
	      return(0);
	    }
	}
    }
  sciprint("No man for %s\r\n",name);
  return(0);
}



/**********************************************
 * seaches the help database for a specific topic
 * return 1 if memory failure occurs 
 * this is for the keyboard  scilab command help xxxx
 **********************************************/

#ifdef WIN32 
#include "../menusX/wmen_scilab.h" 
#else
#include "../menusX/men_scilab.h"
#endif

int Sci_Apropos(name) 
     char *name;
{
  static char *butn[]= { "Ok","Cancel",NULL};
  int Rep;
  ChooseMenu Ch;
  int i;
  /** init Help database **/
  if ( Help_Init() == 1) 
    {
      sciprint("can't use man\r\n");
      return(1);
    }
  /** fills apropos database **/
  if ( SetAproposTopics(name) == 1) return(1);
  if ( AP.nTopic == 0 ) 
    {
      sciprint("Nothing found for topic %s\r\n",name);
      return(0);
    }
  C2F(xscion)(&i);
  if ( i != 0 ) 
    {
      Ch.nstrings =   AP.nTopic ;
      Ch.nb = 2; 
      Ch.choice = 0;
      Ch.description = name;
      Ch.buttonname = butn;
      Ch.strings = AP.HelpTopic ;
      Rep = ExposeChooseWindow(&Ch);
      if ( Rep == TRUE )
	HelpActivate(Ch.choice);
    }
  else 
    {
      for ( i = 0 ; i < AP.nTopic ; i++) 
	sciprint("%s\r\n", AP.HelpTopic[i]);
    }
  return(0);
}

/************************************
 * Init function : 
 ************************************/

int Help_Init()
{
  static int first = 0;
  static int Erstatus = 0 ;
  if ( first == 0 ) 
    {
      if (( Erstatus=initHelpDatas()) == 1)  return(1);
      if (( Erstatus=setHelpTopicInfo(1)) == 1) return(1);
      AP.name[0] ='\0' ; /** Apropos topic initial name **/
      first++;
    }
  else
    {
      if ( Erstatus == 1 ) return(1);
      if ((Erstatus = setHelpTopicInfo(1)) == 1) return(1);
    }
  return(0);
}


/************************************
 * Init help Chapters List 
 ************************************/

int initHelpDatas()
{
  static int first=0;
  FILE           *fg;
  char            line[120];
  int             linecount;
  integer         iopt=1, nc;
  /** Init to zero **/
  if ( first == 0) 
    {
      int i ;
      for ( i = 0 ; i < MAX_HELP_CHAPTERS ; i++) 
	{
	  helpInfo[i] = (char *) 0;
	  helpPaths[i]= (char *) 0;
	}
      first = 1;
    }
  /* Get  Help Chapters file path */
  C2F(inffic) (&iopt, line, &nc);
  if ( HelpGetPath(line,Help,Buf) != 0 ) return(1);
  fg = fopen(Help, "r");
  if (fg == 0) 
    {
      sciprint("Unable to open file \"%s\"\r\n", Help);
      nInfo = 0;
      return (1);
    }
  /* Read path and title of each help Chapter */
  linecount = nInfo =  0;
  while (fgets(line, 120, fg) != 0) 
    {
      int rep;
      rep = HelpGetPath(line,Help,Buf) ;
      linecount++;
      if ( rep == -1 ) continue;
      if ( rep == 1  ) 
	{
	  sciprint("Ignoring line %d \r\n",linecount);
	  continue;
	}
      if ( NewString(&helpPaths[nInfo],Help) == 1 
	  ||  NewString(&helpInfo[nInfo],Buf) == 1 )
	{
	  int k;
	  /** Lacking memory for help **/
	  fclose(fg);
	  for (k = 0; k < nInfo ; k++) 
	    {
	      FREE(helpInfo[k]);
	      FREE(helpPaths[k]);
	    }
	  nInfo = 0 ;
	  return(1);
	}
      nInfo++;
      if (nInfo == MAX_HELP_CHAPTERS)
	{
	  sciprint("Max help chapters (%d) reached \r\n",
		   MAX_HELP_CHAPTERS );
	  break;
	}
    }
  fclose(fg);
  helpInfo[nInfo] = NULL;
  helpPaths[nInfo] = NULL;
  /** Init Apropos **/
  AP.nTopic =0;
  /** Init Topics **/
  nTopicInfo = 0;
  return (0);
}
    
/************************************
 * Parses a line as 
 * $SCI/man/graphics	Graphic Library
 * expand and stores the pathname in Path 
 * and the Title in Tit 
 * ( leading ' ' are ignored )
 ************************************/

int HelpGetPath(line,Path,Tit)
     char *line,*Tit,*Path;
{
  char *local = (char *) 0, lk;
  int ln,k;
  ln = strlen(line);
  if (line[ln - 1] == '\n') line[ln - 1] = '\0';
  while ( *line == ' ' ) line++;
  if ( *line == '\0' ) return(-1);
  if ( *line == '$') 
    { 
      int k1=0;
      /* path begins with an environnement variable */
      while (line[k1] != '/' && line[k1] != '\0' && line[k1] != ' ') k1++;
      lk = line[k1];
      line[k1] = '\0';
      if ((local = getenv(line+1)) == NULL) 
	{
	  sciprint("You must define the environment variable %s\r\n",
		   line+1);
	  return(1);
	} 
      else 
	{
	  line = line + k1;
	  *line = lk;
	}
    } 
  /* get rest of path */
  k=0;
  while ( line[k] != ' ' && line[k] != '\t' && line[k] != '\0') k++;
  /* store path */
  lk = line[k]; line[k] = '\0';
  if ( local != (char *) 0) {
      strcpy(Path,local);
      strcat(Path,line);
  }
  else {
      strcpy(Path,line);
  }
  /* Store Title */
  line[k]=lk;
  if ( line[k] != '\0' ) 
    {
      while ( line[k] == ' ' || line[k] == '\t' ) k++;
      strcpy(Tit,&line[k]);
    }
  else
    {
      Tit[0] ='\0';
    }
  return(0);
}

/************************************
 * Get The List of helps info 
 * for chapter n 
 ************************************/

int setHelpTopicInfo(n)
     int n;
{
  FILE           *fg;
  char            line[120];
  int             linecount, k, ln;
  CleanAproposTopics();
  if ( n == CurrentTopicInfo ) 
    {
      return(0);
    }
  else
    {
      CurrentTopicInfo = n ;
    }
  CleanHelpTopics();
  helpPath = helpPaths[n - 1];
  strcpy(Help, helpPath);
  strcat(Help, "/whatis");
  fg = fopen(Help, "r");
  if (fg == 0)
    {
      sciprint("Unable to open file \"%s\"\r\n", Help);
      return(1);
    }
  /* read whatis file just to count lines */
  linecount = 0;
  while (fgets(line, 120, fg) != 0)
    linecount++;
  rewind(fg);

  /* allocate a new helpTopicInfo */
  helpTopicInfo = (char **) MALLOC((linecount + 1) * sizeof(char *));
  if (helpTopicInfo == NULL) {
    sciprint("Not enough memory to allocate help tables\r\n");
    return(1);
  }
  nTopicInfo = 0;
  while (fgets(line, 120, fg) != 0) 
    {
      ln = strlen(line);
      if (line[ln - 1] == '\n') line[ln - 1] = '\0';
      if ( NewString(&( helpTopicInfo[nTopicInfo]),line) == 1)
	{
	  fclose(fg);
	  for (k = 0; k < nTopicInfo; k++)
	    FREE(helpTopicInfo[k]);
	  FREE(helpTopicInfo);
	  nTopicInfo = 0;
	  return(1);
	}
      nTopicInfo++;
    }
  helpTopicInfo[nTopicInfo]= (char *) 0;
  fclose(fg);
  return(0);
}


/******************************************
 * Clean The HelpInfo Datas  
 ******************************************/

static void CleanHelpTopics()
{
  int k;
  for (k = 0; k < nTopicInfo; k++)
    FREE(helpTopicInfo[k]);
  FREE(helpTopicInfo);
  nTopicInfo = 0;
  CurrentTopicInfo = -1;
}

/******************************************
 * Set the Apropos structure AP
 * with whatis line refering to str 
 * In case of memory failure the routine return 1
 ******************************************/

int SetAproposTopics(str)
     char *str;
{
  FILE           *fg;
  char            line[120];
  int             k, ln, n;
  if ( strcmp(str,AP.name)== 0) 
    {
      /** current apropos database is correct **/
      return(0);
    }
  else 
    {
      strncpy(AP.name,str,MAXTOPIC);
    }
  CleanAproposTopics();
  AP.nTopic = 0;
  for (n = 0; n < nInfo; n++) 
    {	
      strcpy(Help, helpPaths[n]);
      strcat(Help, "/whatis");
      fg = fopen(Help, "r");
      if (fg == 0) 
	{
	  sciprint("Unable to open file \"%s\"\r\n", Help);
	  continue;
	}
      /* search for str in  whatis file */
      while (fgets(line, 120, fg) != 0) 
	{
	  if (strstr(line, str) != 0) 
	    {
	      ln = strlen(line);
	      if (line[ln - 1] == '\n')
		line[ln - 1] = '\0';
	      if ( NewString(&(AP.HelpTopic[AP.nTopic]),line)==1)
		{
		  fclose(fg);
		  for (k = 0; k < AP.nTopic ; k++)
		    FREE(AP.HelpTopic[k]);
		  AP.nTopic =0;
		  return(1);
		}
	      AP.Where[AP.nTopic] = n;
	      AP.nTopic++;
	      if ( AP.nTopic >= APROPOSMAX-1)
		{
		  sciprint("Too many answers for topic %s \r\n",str);
  		  sciprint("I will ignore the last ones \r\n");
		break;
	    }
	}
	}
      fclose(fg);
    }
  AP.HelpTopic[AP.nTopic] = NULL;
  return(0);
}

/******************************************
 * Clean The Apropos Datas  
 ******************************************/

static void CleanAproposTopics()
{
  int n;
  for (n = 0; n < AP.nTopic ; n++) 
    {
      FREE(AP.HelpTopic[n]);
    }
  AP.nTopic = 0;
  AP.name[0] = '\0';
}

/************************************
 * Utility function 
 ************************************/

static int NewString(hstr,line)
     char **hstr, *line;
{
  *hstr = (char *) MALLOC((strlen(line) + 1) * (sizeof(char)));
  if ( (*hstr) == NULL)
    {
      sciprint("Not enough memory to allocate help tables\r\n");
      return(1);
    }
  strcpy(*hstr, line);
  return(0);
}

