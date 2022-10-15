/* Copyright INRIA */
/*
  Interface with system C function
  */
#include<stdio.h>
#include "../machine.h"

#ifdef __STDC__
#include <stdlib.h>
#else
int  system();
#endif

int C2F(systemc)(command,stat)
     char * command;
     integer * stat;
{
  int status;
  status=system(command);
  *stat=(integer)status;
  return(0);
}
