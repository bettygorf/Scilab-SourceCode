/************************************
 * reading functions for scilab 
 * Scilab 1997
 *   Jean-Philippe Chancelier 
 ************************************/

#include <stdio.h>
#include <string.h>
#ifndef STRICT
#define STRICT
#endif
#include <windows.h>
#include "wgnuplib.h"
#include "wresource.h"
#include "wcommon.h"
#include "plot.h"

extern char input_line[MAX_LINE_LEN + 1] ;

/***********************************************************************
 * line editor win32 version 
 * Input function for Scilab 
 * zzledt1 for scilab 
 * zzledt  for scilab -nw 
 **********************************************************************/

char prompt[10];

extern void C2F(zzledt1)(buffer, buf_size, len_line, eof, dummy1)
     char *buffer;
     int *buf_size;
     int *len_line;
     int *eof;
     long int dummy1;    /* added by FORTRAN to give buffer length */
{
  set_is_reading(TRUE);
  read_line(prompt);
  strncpy(buffer,input_line,*buf_size);
  *len_line = strlen(buffer);
  /** fprintf(stderr,"[%s,%d]\n",buffer,*len_line); **/
  *eof = FALSE;
  set_is_reading(FALSE);
  return;
}

/**** Warning here : eof can be true  ***/

extern void C2F(zzledt)(buffer, buf_size, len_line, eof, dummy1)
     char *buffer;
     int *buf_size;
     int *len_line;
     int *eof;
     long int dummy1;    /* added by FORTRAN to give buffer length */
{
  int i;
  set_is_reading(TRUE);
  i=read_line(prompt);
  strncpy(buffer,input_line,*buf_size);
  *len_line = strlen(buffer);
  /** fprintf(stderr,"[%s,%d]\n",buffer,*len_line); **/
  *eof = (i==1) ? TRUE : FALSE;
  set_is_reading(FALSE);
  return;
}

void C2F(setprlev)(pause)
     int *pause;
{
  if ( *pause == 0 ) 
    sprintf(prompt,"-->");
  else 
    sprintf(prompt,"-%d->",*pause);
}

     

