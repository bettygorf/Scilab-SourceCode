

typedef struct Isparse {
  int m,n,nel,it;
  int *mnel,*icol;
  double *xr;
  double *xi;
} Sparse ;

extern Sparse *NewSparse _PARAMS((int *,int *,int *,int *));


