
/** men_Sutils.c **/


#ifndef MEN_SUTIL_PROTO
#define MEN_SUTIL_PROTO

#ifdef __STDC__
#ifndef  _PARAMS
#define  _PARAMS(paramlist)		paramlist
#endif
#else	
#ifndef  _PARAMS
#define  _PARAMS(paramlist)		()
#endif
#endif

  extern void strwidth _PARAMS((char *, int *, int *));  
  extern void ScilabStr2C _PARAMS((int *n, int *, char **, int *));  
  extern void ScilabMStr2CM _PARAMS((int *, int *, int *, char ***, int *));  
  extern void ScilabMStr2C _PARAMS((int *, int *, int *, char **, int *));  
  extern void ScilabC2MStr2 _PARAMS((int*,int *,int *,char *,int *, int,int)); 
  extern void ScilabCM2MStr _PARAMS((char **,int,int *,int *,int ,int *));  

#endif /*  MEN_SUTIL_PROTO */
