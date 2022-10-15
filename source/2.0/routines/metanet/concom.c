#include "../machine.h"

#define NULL 0

void C2F(concom)(icomp,n,ncomp,ns,nsize)
int *icomp, *n, *ncomp, *nsize;
int **ns;
{
  int i;
  *nsize = 0;
  if ((*ns = (int *)malloc(*n * sizeof(int))) == NULL) {
    cerro("Running out of memory");
    return;
  }
  for (i = 0; i < *n; i++){
    if (ncomp[i] == *icomp) {
      (*ns)[*nsize] = i + 1;
      (*nsize)++;
    }
  }
}
