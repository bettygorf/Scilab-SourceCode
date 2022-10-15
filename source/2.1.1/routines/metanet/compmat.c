#include "../machine.h"

#define NULL 0

/* compl2_ computes la2, lp2 and ls2 from la1, lp1 and ls1 */

void C2F(compl2)(la1,lp1,ls1,m,n1,la2,lp2,ls2,dir,mm)
int *la1,*lp1,*ls1,*m,*n1,**la2,*lp2,**ls2,*dir,*mm;
{
  int i,ia,in,ip2,j,k,na;
  int sizint = sizeof(int);
  int n = *n1 - 1;

  if (*dir == 1) {
    *mm = 2 * *m;
    if ((*la2 = (int *)malloc(*mm * sizint)) == NULL) {
      cerro("Running out of memory");
      return;
    }
    if ((*ls2 = (int *)malloc(*mm * sizint)) == NULL) {
      cerro("Running out of memory");
      return;
    }
    ip2 = 1; lp2[ip2-1] = 1; na = 0;
    for (i = 1; i <= n; i++){ /* loop on nodes */
      for (j = lp1[i-1]; j <= lp1[i]-1; j++) {
	/* loop on arcs starting from node i: ia=(i,in) */
	na++;
	ia = la1[j-1];
	in = ls1[j-1];
	(*ls2)[na-1] = in;
	(*la2)[na-1] = ia;
      }
      /* looking for arcs ending at node i */
      for (j = 1; j <= n; j++)
	for (k = lp1[j-1]; k <= lp1[j]-1; k++) {
	  in = ls1[k-1];
	  if (in == i) {
	    na++;
	    ia = la1[k-1];
	    (*ls2)[na-1] = j;
	    (*la2)[na-1] = ia;
	  }
	}
      lp2[ip2++] = na + 1;
    }
  }
  else {
    *mm = *m;
    if ((*la2 = (int *)malloc(*mm * sizint)) == NULL) {
      cerro("Running out of memory");
      return;
    }
    if ((*ls2 = (int *)malloc(*mm * sizint)) == NULL) {
      cerro("Running out of memory");
      return;
    }
    for (i = 0; i < *n1; i++) lp2[i] = lp1[i];
    for (i = 0; i < *mm; i++) {
      (*ls2)[i] = ls1[i];
      (*la2)[i] = (la1[i] + 1)/ 2;
    }
  }
}

/* compht_ computes he and ta from la1, lp1 and ls1 */

void C2F(compht)(la1,lp1,ls1,m,n1,he,ta,dir,ma)
int *la1,*lp1,*ls1,*m,*n1,**he,**ta,*dir,*ma;
{
  int i,ia,in,j;
  int sizint = sizeof(int);
  int n = *n1 - 1;

  if (*dir == 1) {
    *ma = *m;
    if ((*he = (int *)malloc(*ma * sizint)) == NULL) {
      cerro("Running out of memory");
      return;
    }
    if ((*ta = (int *)malloc(*ma * sizint)) == NULL) {
      cerro("Running out of memory");
      return;
    }
    for (i = 1; i <= n; i++){ /* loop on nodes */
      for (j = lp1[i-1]; j <= lp1[i]-1; j++) {
	/* loop on arcs starting from node i: (i,in) */
	in = ls1[j-1]; ia = la1[j-1];
	(*he)[ia-1] = in;
	(*ta)[ia-1] = i;
      }
    }
  }
  else {
    *ma = *m / 2;
    if ((*he = (int *)malloc(*ma * sizint)) == NULL) {
      cerro("Running out of memory");
      return;
    }
    if ((*ta = (int *)malloc(*ma * sizint)) == NULL) {
      cerro("Running out of memory");
      return;
    }
    for (i = 1; i <= n; i++){ /* loop on nodes */
      for (j = lp1[i-1]; j <= lp1[i]-1; j++) {
	/* loop on arcs starting from node i: (i,in) */
	in = ls1[j-1]; ia = la1[j-1];
	if (ia % 2 != 0) {
	  (*he)[(ia+1)/2 - 1] = in;
	  (*ta)[(ia+1)/2 - 1] = i;
	}
      }
    }
  }
}

/* compunl1_ computes lla1, llp1 and lls1 of the undirected graph
   corresponding to la1, lp1 and ls1 of a directed graph */

void C2F(compunl1)(la1,lp1,ls1,m,n1,lla1,llp1,lls1,mm)
int *la1,*lp1,*ls1,*m,*n1,**lla1,*llp1,**lls1,*mm;
{
  int i,ia,in,ip,j,k,na;
  int sizint = sizeof(int);
  int n = *n1 - 1;

  *mm = 2 * *m;
  if ((*lla1 = (int *)malloc(*mm * sizint)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  if ((*lls1 = (int *)malloc(*mm * sizint)) == NULL) {
    cerro("Running out of memory");
    return;
  }
  ip = 1; llp1[ip-1] = 1; na = 0;
  for (i = 1; i <= n; i++){ /* loop on nodes */
    for (j = lp1[i-1]; j <= lp1[i]-1; j++) {
      /* loop on arcs starting from node i: ia=(i,in) */
      na++;
      ia = la1[j-1];
      in = ls1[j-1];
      (*lls1)[na-1] = in;
      (*lla1)[na-1] = 2*ia-1;
    }
    /* looking for arcs ending at node i */
    for (j = 1; j <= n; j++)
      for (k = lp1[j-1]; k <= lp1[j]-1; k++) {
	in = ls1[k-1];
	if (in == i) {
	  na++;
	  ia = la1[k-1];
	  (*lls1)[na-1] = j;
	  (*lla1)[na-1] = 2*ia;
	}
      }
    llp1[ip++] = na + 1;
  }
}

/* compla_ computes la1 from lp1 and ls1 */

void C2F(compla)(la1,lp1,ls1,m,n1,dir)
int *la1,*lp1,*ls1,*m,*n1,*dir;
{
  int i,j,in,inn,k,n,na;

  n = *n1 - 1; na = 0;
  if (*dir == 1)
    for (i = 1; i <= *m; i++) la1[i-1] = i;
  else {
    for (i = 1; i <= *m; i++) la1[i-1] = 0;
    for (i = 1; i <= n; i++){ /* loop on nodes */
      for (j = lp1[i-1]; j <= lp1[i]-1; j++) {
	/* loop on arcs starting from node i: na=(i,in) */
	in = ls1[j-1];
	if (la1[j-1] == 0) {
	  la1[j-1] = ++na;
	  /* looking for arc (in,i) */
	  for (k = lp1[in-1]; k <= lp1[in]-1; k++) {
	    inn = ls1[k-1];
	    if (inn == i) {
	      la1[k-1] = ++na;
	    }
	  }
	}
      }
    }
  }
}
