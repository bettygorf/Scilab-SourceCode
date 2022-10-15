#ifndef SCI_GRAND
#define SCI_GRAND

extern double C2F(genbet) _PARAMS((double *aa, double *bb));
extern double C2F(genchi) _PARAMS((double *df));
extern double C2F(genexp) _PARAMS((double *av));
extern double C2F(genf) _PARAMS((double *dfn, double *dfd));
extern double C2F(gengam) _PARAMS((double *a, double *r__));
extern double C2F(gennch) _PARAMS((double *df, double *xnonc));
extern double C2F(gennf) _PARAMS((double *dfn, double *dfd, double *xnonc));
extern double C2F(gennor) _PARAMS((double *av, double *sd));
extern double C2F(genunf) _PARAMS((double *low, double *high));
extern double C2F(ranf) _PARAMS((void));
extern double C2F(sdot) _PARAMS((int *n, double *sx, int *incx, double *sy, int *incy));
extern double C2F(sexpo) _PARAMS((void));
extern double C2F(sgamma) _PARAMS((double *a));
extern double C2F(snorm) _PARAMS((void));
extern int C2F(advnst) _PARAMS((int *k));
extern int C2F(genmn) _PARAMS((double *parm, double *x, double *work));
extern int C2F(genmul) _PARAMS((int *n, double *p, int *ncat, int *ix));
extern int C2F(genprm) _PARAMS((int *iarray, int *larray));
extern int C2F(getcgn) _PARAMS((int *g));
extern int C2F(getsd) _PARAMS((int *iseed1, int *iseed2));
extern int C2F(ignbin) _PARAMS((int *n, double *pp));
extern int C2F(ignlgi) _PARAMS((void));
extern int C2F(ignnbn) _PARAMS((int *n, double *p));
extern int C2F(ignpoi) _PARAMS((double *mu));
extern int C2F(ignuin) _PARAMS((int *low, int *high, int *ierr));
extern int C2F(initgn) _PARAMS((int *isdtyp));
extern int C2F(inrgcm) _PARAMS((void));
extern int C2F(lennob) _PARAMS((char *string, int string_len));
extern int C2F(mltmod) _PARAMS((int *a, int *s, int *m, int *ierr));
extern int C2F(phrtsd) _PARAMS((char *phrase, int *phrasel, int *seed1, int *seed2, int phrase_len));
extern int C2F(qrgnin) _PARAMS((void));
extern int C2F(qrgnsn) _PARAMS((int *qvalue));
extern int C2F(rgnqsd) _PARAMS((int *qssd));
extern int C2F(setall) _PARAMS((int *iseed1, int *iseed2));
extern int C2F(setant) _PARAMS((int *qvalue));
extern int C2F(setcgn) _PARAMS((int *g));
extern int C2F(setgmn) _PARAMS((double *meanv, double *covm, int *ldcovm, int *p, double *parm, int *ierr));
extern int C2F(setsd) _PARAMS((int *iseed1, int *iseed2));
extern int C2F(spofa) _PARAMS((double *a, int *lda, int *n, int *info));

#endif /** SCI_GRAND   **/

