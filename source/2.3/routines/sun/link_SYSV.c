/*********************************
 * Link version for SYSV machine 
 *********************************/


#include <stdio.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/file.h>


#ifndef hppa
#include <dlfcn.h>
#else
#include <dl.h>
#endif

#if (defined(sun) && defined(SYSV)) 
#include <unistd.h>
#include <sys/wait.h>
#endif

#ifdef sun
#include <sys/vnode.h>
#include <archives.h>
#endif

#ifdef linux 
#include <unistd.h>
#include <sys/wait.h>
#endif 

#ifndef linux
#ifndef hppa
#include <sys/mode.h>
#endif
#endif 

#ifdef __alpha
#include <c_asm.h>
#endif

#ifdef sgi
#define vfork fork
#endif

#if defined  __alpha || defined sgi
#include <a.out.h>
#endif

#include <string.h>

caddr_t endv[22],wh;

#define round(x,s) (((x) + ((s)-1)) & ~((s)-1))
#define Min(x,y)	(((x)<(y))?(x):(y))
#define Max(x,y)	(((x)>(y))?(x):(y))

extern char *strchr();

static void Sci_Delsym _PARAMS((int ));
static int Sci_dlopen _PARAMS((char *loaded_files[]));
static int Sci_dlsym _PARAMS((char *ename,int  ishared,char * strf));
static int SetArgv  _PARAMS((char *argv[], char *files[],int first,int max,int *err));
static int SetArgv1  _PARAMS((char *argv[], char *files,int first,int max,int *err));


/*************************************
 * New version : link entry names 
 *   from new shared lib created with 
 *   files.
 *   return in ilib the number of the shared archive 
 *   or -1 or -2 
 *   -1 : the shared archive was not loaded 
 *   -2 : pb with one of the entry point 
 *************************************/

void SciLink(iflag,rhs,ilib,files,en_names,strf)
     int iflag,*ilib,*rhs;
     char *files[],*en_names[],*strf;
{
  int i;
  if ( iflag == 0 )
    {
      *ilib  = Sci_dlopen(files);
    }
  if (*ilib  == -1 ) return;
  sciprint("shared archive loaded\r\n");
  if ( *rhs >= 2) 
    {
      i=0 ;
      while ( en_names[i] != (char *) 0)
	{
	  if ( Sci_dlsym(en_names[i],*ilib,strf) == FAIL) 
	    *ilib=-2;
	  i++;
	}
    }
}

/**************************************
 * return 1 if link accepts multiple file iin one call
 * or 0 elsewhere 
 *************************************/

static int LinkStatus()
{
  return(1);
}

/**************************************
 * Unlink a shared lib 
 *************************************/

void C2F(isciulink)(i) 
     integer *i;
{
  /* delete entry points in shared lib *i */
  Sci_Delsym(*i);
  /* delete entry points used in addinter in shared lib *i */
  RemoveInterf(*i);
}


/*************************************
 * This routine 
 *   changes the file list <<loaded_files>>
 *   to a shared archive and call dlopen 
 *   the shared lib handler is stored in a Table 
 *   The return value is == -1 if the dlopen failed 
 *************************************/

#define MAXARGV 128

int Sci_dlopen(loaded_files)
     char *loaded_files[];
{
  int i=0;
  int argc=3,err=0;
#ifndef hppa
  void *hd1 = (void *) 0;
#else
  shl_t hd1;
#endif
  char tmp_file[TMPL],*libs,*getenv();
  /** XXXXX **/
  if ( strncmp(loaded_files[0],"scilab",6) !=0)
    {
      libs=getenv("SYSLIBS");
      /** XXXXX **/
      sciprint("linking files ");
      while ( loaded_files[i] != NULL) 
	{
	  sciprint("%s ",loaded_files[i]);
	  i++;
	}
      sciprint(" to create a shared executable\r\n");
      sprintf(tmp_file, "/tmp/SL_%d_XXXXXX",(int) getpid());
      mktemp(tmp_file);
      {
	int pid, status, wpid;
	static char *argv[MAXARGV] = {
	  /*   0        1         2    3  4   */
#ifdef sun
	  "/usr/ucb/ld", "-r", "-o", 0, 0
#else
#ifdef linux
	  "/usr/bin/ld", "-shared", "-o", 0, 0  
#else
#ifdef hppa
          "/bin/ld", "-b", "-o", 0, 0
#else
	  "/bin/ld", "-shared", "-o", 0, 0  
#endif
#endif
#endif
	};
	argv[argc] = tmp_file; argc++;
	argc = SetArgv(argv,loaded_files,argc,MAXARGV,&err);
	if ( err == 1 ) return(-1);
	if (libs) 
	  {
	    argc = SetArgv1(argv,libs,argc,MAXARGV,&err);
	    if ( err == 1 ) return(-1);
	  }
	argv[argc] = (char *) 0;
	
#ifdef DEBUG
	for ( i=0 ; i < argc ; i++) 
	  sciprint("arg[%d]=%s\n",i,argv[i]);
#endif	
	
	if ((pid = vfork()) == 0) {
	  execv(argv[0], argv);
	  _exit(1);
	}
	if (pid < 0) {
	  sciprint("can't create new process: \r\n");
	  return(-1);
	}
	while ((wpid = wait(&status)) != pid)
	  if (wpid < 0) {
	    sciprint("no child !\r\n");
	    return(-1);
	  }
	if (status != 0) {
	  sciprint("ld returned bad status: %x\r\n", status);
	  return(-1);
	}
      }
      /* this will load the shared library */
#ifndef hppa
      hd1 = dlopen(tmp_file, RTLD_NOW);
#else
      hd1 = shl_load(tmp_file, BIND_IMMEDIATE);
#endif
    }
  else
    {
      /* use symbols from scilab */
      /* XXXXXX Attention sur Sun Seulement */
#ifdef sun 
      hd1 = dlopen((char *)0, RTLD_NOW);
#else
#ifdef hppa
      hd1 = PROG_HANDLE;
#else
      sciprint("Link : scilab is not a valid first argument on your machine\r\n");
      return(-1);
#endif
#endif
    }
  /* this will load the shared library */
#ifndef hppa
  if ( hd1 == (void *) NULL || hd1 < (void *) 0 ) {
    sciprint("%s\r\n",dlerror());
#else
  if (  hd1 == NULL) {
    sciprint("link error\r\n");
#endif
    return(-1);
  }
  for ( i = 0 ; i < Nshared ; i++ ) 
    {
      if ( hd[i].ok == FAIL) 
	{
	  hd[i].shl =  (unsigned long)hd1;
	  strcpy(hd[i].tmp_file,tmp_file);
	  hd[i].ok = OK;
	  return(i);
	}
    }
  
  if ( Nshared == ENTRYMAX ) 
    {
      sciprint("You can't open shared files maxentry %d reached\r\n",ENTRYMAX);
      return(FAIL);
    }

  strcpy(hd[Nshared].tmp_file,tmp_file);
  hd[Nshared].shl = (unsigned long)hd1;
  hd[Nshared].ok = OK;
  Nshared ++;
  return(Nshared-1);
}


/*************************************
 * This routine load the entryname ename 
 *     from shared lib ishared 
 * return FAIL or OK 
 *************************************/

int Sci_dlsym(ename,ishared,strf)
     int ishared;
     char *ename;
     char *strf;
{
#ifdef hppa
  shl_t hd1;
  int irep = 0;
#endif
  int ish = Min(Max(0,ishared),ENTRYMAX-1);
  char enamebuf[MAXNAME];
  if ( strf[0] == 'f' )
    Underscores(1,ename,enamebuf);
  else 
    Underscores(0,ename,enamebuf);

  /* lookup the address of the function to be called */
  if ( NEpoints == ENTRYMAX ) 
    {
      sciprint("You can't link more functions maxentry %d reached\r\n",ENTRYMAX);
      return(FAIL);
    }
  if ( hd[ish].ok == FAIL ) 
    {
      sciprint("Shared lib %d does not exists\r\n",ish);
      return(FAIL);
    }
  /** entry was previously loaded **/
  if ( SearchFandS(ename,ish) >= 0 ) 
    {
      sciprint("Entry name %s is already loaded from lib %d\r\n",ename,ish);
      return(OK);
    }
#ifndef hppa
  EP[NEpoints].epoint = (function) dlsym((void *) hd[ish].shl, enamebuf);
  if ( (unsigned long) EP[NEpoints].epoint == (unsigned long) 0 )

#else
  hd1 = (shl_t)  hd[ish].shl;
  irep= shl_findsym(&hd1, enamebuf,TYPE_PROCEDURE,&(EP[NEpoints].epoint));
  if ( irep == -1 )
#endif
    {
      char *loc;
      sciprint("%s is not an entry point \r\n",enamebuf);
#ifndef hppa
      loc = dlerror();
      if ( loc != NULL) sciprint("%s \r\n",loc);
#else
      sciprint("link error\r\n");
#endif
      return(FAIL);
    }
  else 
    {
      /* we don't add the _ in the table */
      sciprint("Linking %s (in fact %s)\r\n",ename,enamebuf);
      strncpy(EP[NEpoints].name,ename,MAXNAME);
      EP[NEpoints].Nshared = ish;
      NEpoints++;
    }
  return(OK);  
}


/***************************************************
 * Delete entry points associated with shared lib ishared
 * then delete the shared lib 
 ****************************************************/


void Sci_Delsym( ishared) 
     int ishared;
{
  int ish = Min(Max(0,ishared),ENTRYMAX-1);
  int i=0;
  for ( i = NEpoints-1 ; i >=0 ; i--) 
    {
      if ( EP[i].Nshared == ish )
	{
	  int j;
	  for ( j = NEpoints - 2 ; j >= i ; j-- )
	    {
	      EP[j].epoint = EP[j+1].epoint;
	      EP[j].Nshared = EP[j+1].Nshared;
	      strcpy(EP[j].name,EP[j+1].name);
	    }
	  NEpoints--;
	}
    }
#ifndef hppa
  dlclose((void *) hd[ish].shl);
#else
  shl_unload((shl_t)  hd[ish].shl);
#endif
  unlink(hd[ish].tmp_file);
  hd[ish].ok = FAIL;
}

  
/******************************************************
 * Utility function 
 * files is a null terminated array of char pointers 
 * files[i] is broken into pieces ( separated by ' ') 
 * and positions are stored in argv starting at position 
 * first 
 *******************************************************/

int SetArgv(argv,files,first,max,err)
     char *argv[];
     char *files[];
     int first,max,*err;
{
  int i=0,j=first;
  *err=0;
  while ( files[i] != (char *) NULL) 
    {
      j= SetArgv1(argv,files[i],j,max,err);
      if (*err == 1) return(j);
      i++;
    }
  return(j);
}

int SetArgv1(argv,files,first,max,err)
     char *argv[];
     char *files;
     int first,max,*err;
{
  int j=first;
  char *loc = files;
  while ( *loc == ' ' && *loc != '\0'  ) loc++;
  while ( *loc != '\0' )
    {
      argv[j] = loc; j++;
      if ( j == max ) 
	{
	  sciprint("Link too many files \r\n");
	  *err=1;
	  break;
	}
      if ( ( loc  = strchr(loc, ' ')) != (char *) 0) 
	{ 
	  *loc = 0;	loc++;
	  while ( *loc == ' ' && *loc != '\0'  ) loc++;
	}
      else
	{
	  break;
	}
    }
  return(j);
}
  
