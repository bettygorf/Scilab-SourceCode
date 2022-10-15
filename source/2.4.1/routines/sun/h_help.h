
#ifndef __SCIHELP
#define __SCIHELP

#ifdef __STDC__
#ifndef  _PARAMS
#define  _PARAMS(paramlist)		paramlist
#endif
#else	
#ifndef  _PARAMS
#define  _PARAMS(paramlist)		()
#endif
#endif

/**************************************
 * extern data 
 **************************************/

extern char   **helpTopicInfo ;
extern int      nTopicInfo ;

#define MAX_HELP_CHAPTERS 100

extern char* helpInfo[MAX_HELP_CHAPTERS];
extern char* helpPaths[MAX_HELP_CHAPTERS];
extern int   nInfo;

#define APROPOSMAX 100
#define MAXTOPIC 56

typedef struct {
  char name[MAXTOPIC];
  char *HelpTopic[APROPOSMAX];
  int  Where[APROPOSMAX];
  int  nTopic;
} Apropos;

extern  Apropos AP ;

#ifndef WIN32

extern void initHelpActions();
extern void initHelpPanel();
extern void setHelpShellState();

#else

extern void SciCallHelp  _PARAMS((char *buf,char *helpPath,char *Topic));
extern int HelpGetPath  _PARAMS((char* line,char *Path,char *Tit));

#endif /* WIN32 */

extern int Sci_Help _PARAMS((char *name));
extern int Sci_Apropos _PARAMS((char *name));
extern int Help_Init   _PARAMS((void));
extern int setHelpTopicInfo  _PARAMS((int n));
extern void HelpActivate _PARAMS((int ntopic));
extern int initHelpDatas  _PARAMS((void));
extern void SciCallHelp  _PARAMS((char *buf,char *helpPath,char *Topic));
extern int HelpGetPath  _PARAMS((char* line,char *Path,char *Tit));
extern int SetAproposTopics  _PARAMS((char *));

#endif /*  __SCIHELP */

