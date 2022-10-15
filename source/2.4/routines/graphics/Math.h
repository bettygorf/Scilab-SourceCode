/* Copyright INRIA */
#include "../machine.h"

#ifdef WIN32 
#ifndef __CYGWIN32__
#include <float.h>
#define finite(x) _finite(x) 
#endif 
#ifdef __MINGW32__
/** XXXX _finite not known with mingw32 */
#undef finite 
#define finite(x) 1 
#endif 
#endif /* WIN32 */

#define Abs(x) ( ( (x) >= 0) ? (x) : -( x) )
#define Min(x,y)	(((x)<(y))?(x):(y))
#define Max(x,y)	(((x)>(y))?(x):(y))

#define PI0 (integer *) 0
#define PD0 (double *) 0
#define SMDOUBLE 1.e-200 /* Smalest number to avoid dividing by zero */

/** 
#define linint(x) ((integer) floor(x)) 
#define inint(x) ((int) floor(x))  
**/

/** 
  if we suppose that the x transmited is in the range of integers 
  we could also use :
  #define inint(x) (( x > 0 ) ? ((int) (x + 0.5)) : ((int) (x - 0.5));
 **/

#define linint(x) ((integer) floor(x + 0.5 )) 
#define inint(x) ((int) floor(x + 0.5 ))  


/* Les arguments des fonction XWindows doivent etre des int16 ou unsigned16 */

#define int16max   0x7FFF
#define uns16max   0xFFFF

#ifdef lint5
#include <sys/stdtypes.h>
#define MALLOC(x) malloc(((size_t) x))
#define FREE(x) if (x  != NULL) free((void *) x);
#define REALLOC(x,y) realloc((void *) x,(size_t) y)
#else
#define MALLOC(x) malloc(((unsigned) x))
#define FREE(x) if (x  != NULL) free((char *) x);
#define REALLOC(x,y) realloc((char *) x,(unsigned) y)
#endif

#if (defined(sun) && defined(SYSV)) 
#include <ieeefp.h>
#endif

#include "Graphics.h" 



