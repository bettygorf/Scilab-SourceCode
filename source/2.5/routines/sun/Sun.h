/* Copyright INRIA */
#ifndef SUNSCI_PROTO
#define  SUNSCI_PROTO

#ifdef __STDC__
#ifndef  _PARAMS
#define  _PARAMS(paramlist)		paramlist
#endif
#else	
#ifndef  _PARAMS
#define  _PARAMS(paramlist)		()
#endif
#endif


typedef long int ftnlen ;

/*  "addinter-n.c.X1" */

extern void C2F(addinter)  _PARAMS((int *descla, int *ptrdescla, int *nvla, char *iname, int *desc, int *ptrdesc, int *nv));  
extern void RemoveInterf  _PARAMS((int Nshared));  
extern void C2F(userlk) _PARAMS((integer *k));  
/*  "bashos-n.c.X1" */

extern int C2F(bashos) _PARAMS((char *ligne, integer *n, integer *nout, integer *ierr, ftnlen ligne_len));  
/*  "basin-n.c.X1" */

extern int C2F(basin) _PARAMS((integer *ierr, integer *lunit, char *string, char *fmt, ftnlen string_len, ftnlen fmt_len));  

/*  "basout-n.c.X1" */
extern int C2F(basout) _PARAMS((integer *io, integer *lunit, char *string, ftnlen string_len));  
extern int C2F(basou1) _PARAMS((integer *lunit, char *string, ftnlen string_len));  
/*  "cgpath-n.c.X1" */
extern void C2F(cgpath) _PARAMS((char *nomfic, integer *ln));  
/*  "cluni0-n.c.X1" */
extern int C2F(cluni0) _PARAMS((char *name, char *nams, integer *ln, integer *ierr, ftnlen name_len, ftnlen nams_len));  
/*  "clunit-n.c.X1" */
extern int C2F(clunit) _PARAMS((integer *lunit, char *name, integer *mode, ftnlen name_len));  
/*  "csignal-n.c.X1" */
extern void controlC_handler  _PARAMS((int sig));  
extern int C2F(csignal) _PARAMS((void));  
/*  "ctrlc-n.c.X1" */
extern int C2F(ctrlc) _PARAMS((void));  
/*  "dbasin-n.c.X1" */
extern int C2F(dbasin) _PARAMS((integer *ierr, integer *lunit, char *fmt, double *v, integer *iv, integer *n, ftnlen fmt_len));  
extern int C2F(s2val) _PARAMS((char *str, double *v, integer *iv, integer *n, integer *maxv, integer *ierr, ftnlen str_len));  
extern int C2F(nextv) _PARAMS((char *str, double *v, integer *nv, integer *ir, integer *ierr, ftnlen str_len));  
extern int C2F(s2int) _PARAMS((char *str, integer *nlz, integer *v, integer *ir, integer *ierr, ftnlen str_len));  
/*  "fgetarg-hpux-n.c.X1" */
extern int C2F(fgetarg) _PARAMS((integer *n, char *str, ftnlen str_len));  
/*  "fgetarg-n.c.X1" */
extern int C2F(fgetarg) _PARAMS((integer *n, char *str, ftnlen str_len));  
/*  "flags-n.c.X1" */
extern void set_echo_mode  _PARAMS((int mode));  
extern int get_echo_mode  _PARAMS((void));  
extern void set_is_reading  _PARAMS((int mode));  
extern int get_is_reading  _PARAMS((void));  
/*  "getenvc-n.c.X1" */
extern void C2F(getenvc) _PARAMS((int *ierr, char *var, char *cont, int *iflag));  
/*  "getpidc-n.c.X1" */
extern int C2F(getpidc) _PARAMS((int *id1));  
/*  "getpro-n.c.X1" */
extern void C2F(getpro) _PARAMS((char *ret_val, ftnlen ret_val_len));  

/*  "inffic-n.c.X1" */
extern void C2F(inffic) _PARAMS((integer *iopt, char *name, integer *nc));  
extern void C2F(infficl) _PARAMS((integer *iopt, integer *nc));  
/*  "inibrk-n.c.X1" */
extern int C2F(inibrk) _PARAMS((void));  
extern int C2F(sunieee) _PARAMS((void));  
extern integer C2F(my_handler_) _PARAMS((integer *sig, integer *code, integer *sigcontext, integer *addr));  
extern integer C2F(my_ignore_) _PARAMS((integer *sig, integer *code, integer *sigcontext, integer *addr));  

/*  "plevel-n.c.X1" */
extern int C2F(plevel) _PARAMS((integer *n));  
/*  "sigbas-n.c.X1" */
extern int C2F(sigbas) _PARAMS((integer *n));  
/*  "systemc-n.c.X1" */
extern int C2F(systemc) _PARAMS((char *command, integer *stat));  
/*  "timer-n.c.X1" */
extern int C2F(timer) _PARAMS((double *etime));  
extern int C2F(stimer) _PARAMS((void));  
/*  "tmpdir-n.c.X1" */
extern void C2F(settmpdir) _PARAMS((void));  
extern void C2F(tmpdirc) _PARAMS((void));  
/*  "zzledt-n.c.X1" */
extern void C2F(zzledt) _PARAMS((char *buffer, int *buf_size, int *len_line, int *eof, long int dummy1));  

#endif  SUNSCI_PROTO
