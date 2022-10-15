
#if defined(__STDC__)
#define ARGS_FuncEx double *,double*, double *
#else
#define ARGS_FuncEx 
#endif 

typedef int (*funcex)(ARGS_FuncEx);
extern int C2F(fp1)(ARGS_FuncEx);
extern int C2F(fp2)(ARGS_FuncEx);
