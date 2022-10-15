

#include "../machine.h"

#define Abs(x) ( ( (x) >= 0) ? (x) : -( x) )
#define Min(x,y)	(((x)<(y))?(x):(y))
#define Max(x,y)	(((x)>(y))?(x):(y))

extern double Mini();
extern double Maxi();

#define IP0 (int *) 0
#define SMDOUBLE 1.e-200 /* Smalest number to avoid dividing by zero */
