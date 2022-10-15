/*------------------------------------------------------------------------
    Graphic library for 2D and 3D plotting 
    Copyright (C) 1998 Chancelier Jean-Philippe
    jpc@cergrene.enpc.fr 
 --------------------------------------------------------------------------*/

#ifndef __MATH_H__
#define __MATH_H__
#include "../machine.h"

#ifdef WIN32 
#if !(defined __CYGWIN32__) && !(defined __ABSC__)
#include <float.h>
#define finite(x) _finite(x) 
#endif 
#if (defined __MINGW32__) || (defined __ABSC__)
/** XXXX _finite not known with mingw32 */
#undef finite 
/*#define finite(x) 1 */ /* Following solution is better (See code in "finite.c")*/
#ifdef __STDC__
int finite(double);
#else
int finite();
#endif
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


#if defined(THINK_C)|| defined(WIN32)
#define M_PI	3.14159265358979323846
#else
#if defined(HAVE_VALUES_H)
#include <values.h>
#else
#ifndef M_PI
#define M_PI    3.14159265358979323846 
#endif
#endif
#endif


#include "Graphics.h" 
#endif
