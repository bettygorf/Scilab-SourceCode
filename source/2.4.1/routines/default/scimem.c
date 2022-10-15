/* Copyright INRIA */
#include <string.h>

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif


#include "../machine.h"

char *the_p=NULL;
char *the_ps=NULL;
/* static  char *the_p,*the_ps;*/

extern struct {
  double stk_1[2];
} C2F(stack);

integer C2F(scimem)(n,ptr)
     integer *n, *ptr;
{
  char *p1;
  if (*n > 0){
    /* add 1 for alignment problems */
    p1 = (char *) malloc((unsigned)sizeof(double) * (*n + 1));
    if (p1 != NULL) {
      the_ps = the_p;
      the_p = p1;
      /* add 1 for alignment problems */
      *ptr = ((int) (the_p - (char *)C2F(stack).stk_1))/sizeof(double) + 1;
    }
    else 
      {
	if (the_p == NULL) {
	  sciprint("No space to allocate Scilab stack\r\n");
	  exit(1); 
	}
	*ptr=0;
      }
  }
  return(0);
}

void C2F(freemem)()
{
  if (the_ps != NULL) free(the_ps);
}

