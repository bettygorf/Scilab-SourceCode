
#if defined(__STDC__)
#define ARGS_FuncEx double,double, double *
#else
#define ARGS_FuncEx 
#endif 

typedef int (*funcex)(ARGS_FuncEx);
extern int fp1(ARGS_FuncEx);
extern int fp2(ARGS_FuncEx);
