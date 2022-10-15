#ifndef SCI_SOX 
#define SCI_SOX 

int C2F(loadwave) _PARAMS((char *filename, double *res, integer *size_res, integer flag, integer *ierr));

int C2F(savewave) _PARAMS((char *filename, double *res, integer *rate, integer *size_res, integer *ierr));

void C2F(mopen) _PARAMS((int *fd, char *file, char *status, int *f_swap, double *res, int *error));
void C2F(mclose) _PARAMS((integer *fd, double *res));
void C2F(meof) _PARAMS((integer *fd, double *res));
void C2F(mclearerr) _PARAMS((integer *fd));
void C2F(mseek) _PARAMS((integer *fd, integer *offset, char *flag, integer *err));
void C2F(mtell) _PARAMS((integer *fd, double *offset, integer *err));
void C2F(mput) _PARAMS((integer *fd, double *res, integer *n, char *type, integer *ierr));
void C2F(mget) _PARAMS((integer *fd, double *res, integer *n, char *type, integer *ierr));
void C2F(mgetstr) _PARAMS((integer *fd, char **start, integer *n, integer *ierr));
void C2F(mgetstr1) _PARAMS((integer *fd, char *start, integer *n, integer *ierr));
void C2F(mputstr) _PARAMS((int *fd, char *str, double *res, int *ierr));


#endif
