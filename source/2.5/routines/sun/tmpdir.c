/* Copyright INRIA/ENPC */

#include "../machine.h"
#include <stdio.h>

#ifdef __STDC__
#include <stdlib.h>
#ifndef WIN32
#include <sys/types.h>
#include <unistd.h>
#endif
#else 
extern  char  *getenv();
#endif

#if (defined __MSC__) || (defined __ABSC__)
#include <stdlib.h> 
#ifdef __MINGW32__
/** XXXXX missing in mingw32 **/
#define putenv(x) 
#else 
#ifdef __ABSC__
#define putenv(x) abs_putenv(x)
#define getpid() getpid_()
#else
#define putenv(x) _putenv(x)
#endif
#endif 
#endif

#define MAXINTERF 50
#define INTERFSIZE 25 
typedef struct 
{
  char name[INTERFSIZE]; /** name of interface **/
  void (*func)();        /** entrypoint for the interface **/
  int Nshared; /** id of the shared library **/
  int ok;    /** flag set to 1 if entrypoint can be used **/
} Iel;
extern Iel DynInterf[MAXINTERF];
extern int Call_shl_load;

#ifdef __STDC__
extern void C2F(setprlev)(int*);
#else
extern void C2F(setprlev)();
#endif


static char tmp_dir[20],buf[128];

/****************************
 * creates a tmp dir for a scilab session 
 * and fixes the TMPDIR env variable
 ****************************/

void C2F(settmpdir)()
{
#ifdef WIN32 
  if (!getenv("TEMP")) {
    sprintf(tmp_dir,"C:/tmp/SD_%d_",(int) getpid());
  } else {
    sprintf(tmp_dir,"%s\\SD_%d_",getenv("TEMP"),(int) getpid());
  }
  SciCreateDirectory(tmp_dir);
#else 
  sprintf(tmp_dir,"/tmp/SD_%d_",(int) getpid());
  sprintf(buf,"umask 000;if test ! -d %s; then mkdir %s; fi ",tmp_dir,tmp_dir);
  system(buf);
#endif 
  sprintf(buf,"TMPDIR=%s",tmp_dir);
  putenv(buf);
}

/*************************************************
 * remove TMPDIR and dynamic link temporary files 
 *************************************************/

void C2F(tmpdirc)()
{
#ifdef WIN32 
  if (!getenv("TEMP")) {
    sprintf(tmp_dir,"C:/tmp/SD_%d_",(int) getpid());
  } else {
    sprintf(tmp_dir,"%s\\SD_%d_",getenv("TEMP"),(int) getpid());
  }
  SciRemoveDirectory(tmp_dir);
#else 
#if (defined(hppa))
  if ((LinkStatus() == 1) && (Call_shl_load))
      C2F(isciulink)(&DynInterf[0].Nshared);
#endif
  sprintf(tmp_dir,"/tmp/S*_%d_*",(int) getpid());
  sprintf(buf,"rm -f -r %s >/dev/null  2>/dev/null",tmp_dir);
  system(buf);
  sprintf(buf,"rm -f -r /tmp/%d.metanet.* > /dev/null  2>/dev/null",(int) getpid());
  system(buf);
#endif 
}
