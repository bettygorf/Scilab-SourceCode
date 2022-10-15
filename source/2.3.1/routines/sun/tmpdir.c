
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

#ifdef __MSC__
#ifdef __MINGW32__
/** XXXXX missing in mingw32 **/
#define putenv(x) 
#else 
#define putenv(x) _putenv(x)
#endif 
#endif 

static char tmp_dir[20],buf[128];

/****************************
 * creates a tmp dir for a scilab session 
 * and fixes the TMPDIR env variable
 ****************************/

void C2F(settmpdir)()
{

#ifdef WIN32 
  sprintf(tmp_dir,"C:/tmp/SD_%d_",(int) getpid());
  sprintf(buf,"mkdir %s",tmp_dir);
  if (winsystem(buf,0))
    {
      sciprint("Error : %s failed\r\n",buf);
    }
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
  sprintf(tmp_dir,"C:/tmp/SD_%d_",(int) getpid());
  sprintf(buf,"deltree /Y %s",tmp_dir);
  if (winsystem(buf,0))
    {
      sciprint("Error : %s failed\r\n",buf);
    }
#else 
  sprintf(tmp_dir,"/tmp/S*_%d_*",(int) getpid());
  sprintf(buf,"rm -f -r %s >/dev/null  2>/dev/null",tmp_dir);
  system(buf);
  sprintf(buf,"rm -f -r /tmp/%d.metanet.* > /dev/null  2>/dev/null",(int) getpid());
  system(buf);
#endif 
}

