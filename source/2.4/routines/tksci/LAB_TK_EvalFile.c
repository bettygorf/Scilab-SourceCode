/* Copyright INRIA */
#include "C-LAB_Interf.h"


#include <math.h>
#include <stdio.h>
#include "tksci.h"

void LAB_TK_EvalFile()


{


  Matrix *MInputStr;
  char *InputStr;

  

  MInputStr = (Matrix *)Interf.Param[0];
  InputStr = (char *)MatrixReadString(MInputStr);
  
  Tcl_EvalFile(TKinterp,InputStr);
  free(InputStr);

}

