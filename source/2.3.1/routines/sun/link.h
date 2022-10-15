
extern void GetDynFunc _PARAMS(( int ii, void (**realop)()));
extern int SearchInDynLinks _PARAMS((char *op, void (**realop)()));
extern void SciLinkInit _PARAMS((void));
extern void  ShowDynLinks _PARAMS((void));
extern void RemoveInterf _PARAMS((int));
extern void SciLink _PARAMS((int iflag,int *rhs,int *ilib,char *files[],
			     char *en_names[],char *strf));

extern void C2F(iislink) _PARAMS((   char *buf,   integer *irep));
