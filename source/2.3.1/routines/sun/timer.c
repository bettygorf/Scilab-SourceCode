#include <stdio.h>

#if ~defined(THINK_C) && ~defined(__MWERKS__) 
#ifndef __MSC__
#ifndef  __MINGW32__
#include <sys/time.h>
#endif 
#endif
#endif 

#include <time.h>
#include "../machine.h"

#if defined(THINK_C) || defined(__MWERKS__)
#include <Threads.h> 
#endif

#ifndef CLOCKS_PER_SEC
#if defined(sun)
#define CLOCKS_PER_SEC 1000000
#endif
#endif

static clock_t t1;
static int init_clock = 1;

int C2F(timer)(etime)
     double *etime;
{
  clock_t t2;
  t2 = clock();
  if (init_clock == 1) {init_clock = 0; t1 = t2;}
  *etime=(double)((double)(t2 - t1)/(double)CLOCKS_PER_SEC);
  t1 = t2;
  return(0);
}

/* define X_GETTIMEOFDAY macro, a portable gettimeofday() */
#if  defined(VMS)
#define X_GETTIMEOFDAY(t) gettimeofday(t)
#else
#if defined(THINK_C) || defined(__MWERKS__)
#define X_GETTIMEOFDAY(t) 0 
#else
#if defined(WIN32)
#ifndef __MSC__
#ifndef  __MINGW32__
#define X_GETTIMEOFDAY(t) gettimeofday(t, &tmz )
static struct timezone tmz;
#else
#define X_GETTIMEOFDAY(t) 0
#endif /** __MINGW32__ **/
#else
#define X_GETTIMEOFDAY(t) 0
#endif /* MSC__ */
#else
#define X_GETTIMEOFDAY(t) gettimeofday(t, (struct timezone*)0)
#endif
#endif
#endif 

int C2F(stimer)()
{
#if defined(THINK_C)||defined(__MWERKS__) 
        YieldToAnyThread();
        return(0);
#else
#ifndef __MSC__
#ifndef __MINGW32__
  struct timeval ctime;
  X_GETTIMEOFDAY(&ctime);
  return(ctime.tv_usec);
#endif
#endif
#endif
}
