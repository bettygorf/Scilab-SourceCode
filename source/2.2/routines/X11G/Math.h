

#ifndef THINK_C
#include "../machine.h"
#else
#include "machine.h"
#endif

#define Abs(x) ( ( (x) >= 0) ? (x) : -( x) )
#define Min(x,y)	(((x)<(y))?(x):(y))
#define Max(x,y)	(((x)>(y))?(x):(y))

extern double Mini();
extern double Maxi();

#define PI0 (integer *) 0
#define PD0 (double *) 0
#define SMDOUBLE 1.e-200 /* Smalest number to avoid dividing by zero */
#define inint(x) ((int) floor(x)) 
#define linint(x) ((integer) floor(x)) 

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



