/* Copyright INRIA */

#include "../machine.h"
#include "../sun/addinter.h" /* for DynInterfStart */

extern int  C2F(matdsc) _PARAMS((void));
extern int  C2F(matdsr) _PARAMS((void));
extern int  C2F(userlk) _PARAMS((int *));
extern int  C2F(error) _PARAMS((int *));
extern void sciprint _PARAMS((char* ,...));
/***********************************************************
 * interface function 
 ***********************************************************/

static int Iflag=0; /* special flag for matdsr matdsc */

void C2F(MatdsRC)()
{
  if (Iflag == 1) 
    C2F(matdsc)();
  else
    C2F(matdsr)();
}

static int c_local = 9999;

void C2F(NoTksci)()
{
  sciprint("tksci interface not loaded \n");
  C2F(error)(&c_local);
  return;
}

void C2F(NoPvm)()
{
  sciprint("pvm interface not loaded \n");
  C2F(error)(&c_local);
  return;
}



/** table of interfaces **/

typedef  struct  {
  void  (*fonc)();} OpTab ;


#include "callinterf.h"

/***********************************************************
 * call the apropriate interface according to the value of k 
 * iflagint is only used inside MatdsRC to switch between 
 * matdsc or matdsr 
 ***********************************************************/

int C2F(callinterf)(k,iflagint)
      int *k,*iflagint;
{
  Iflag=*iflagint;
  if (*k > DynInterfStart) 
    C2F(userlk)(k);
  else
    (*(Interfaces[*k-1].fonc))();
  return 0;
}

/***********************************************************
 * Unused function just here to force linker to load some 
 * functions 
 ***********************************************************/

extern int   Blas_contents _PARAMS((int));
extern int   Lapack_contents _PARAMS((int));
extern int   Calelm_contents _PARAMS((int));
extern int   Sun_contents _PARAMS((int));
extern int   System2_contents _PARAMS((int));
extern int   System_contents _PARAMS((int));
extern int  Intersci_contents _PARAMS((int));

int ForceLink()
{
  Blas_contents(0);
  Lapack_contents(0);
  Calelm_contents(0);
  Sun_contents(0);
  System2_contents(0);
  System_contents(0);
  Intersci_contents(0);
  return 0;
}
