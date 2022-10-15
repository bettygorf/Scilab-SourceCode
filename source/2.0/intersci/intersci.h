/* VERSION et DATE */
#define VERSION "2.2"
#define DATE "MAY 1994" 

/* max dimension for the array: can be modified */
#define MAXARG 50
#define MAXCALL 2000
#define MAXEL 50
#define MAXLINE 500
#define MAXNAM 80
#define MAXVAR 200
/* flag for generation of type and element dimension checking for lists: 
   can be modified */
#define TESTLISTELEMENTS 0

/******************************************/
/* DO NOT CHANGE ANYTHING BELOW THIS LINE */
/******************************************/
#define MAXFUN 99 /* maximum number of SCILAB functions */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

/* FORTRAN variable types */ 
#define CHAR 1
#define INT 2
#define DOUBLE 3
#define REAL 4
#define EXTERNAL 5

/* SCILAB variable types */

#define COLUMN 1
#define LIST 2
#define MATRIX 3
#define POLYNOM 4
#define ROW 5
#define SCALAR 6
#define SEQUENCE 7
#define STRING 8
#define WORK 9
#define EMPTY 10
#define ANY 11
#define VECTOR 12

/* SCILAB optional variable types */

#define NAME 1 /* {var default-name} */
#define VALUE 2 /* {var default-value} */

char *malloc();

typedef int IVAR; /* variable number */

/* VAR struct: informations for FORTRAN and/or SCILAB variable */
typedef struct var {
  char *name; /* variable name */
  int type; /* SCILAB type */
  int length; /* number of el */
  IVAR el[MAXEL]; /* list of el IVAR (variable associated with,
		     typically dimensions) */
  int for_type; /* FORTRAN type */
  char *fexternal[MAXNAM]; /* name of external function when type is
			      external */
  IVAR equal; /* ? */
  int nfor_name; /* number of for_name */
  char *for_name[MAXARG]; /* list of for_name names (FORTRAN name
			   in generated FORTRAN code) */
  char *list_name; /* name of the list of which the variable is an element */
  int list_el; /* element number in the previous list */
  int opt_type; /* type of optional variable */
  char *opt_name; /* name or value default for optional variable */
  int present; /* 1 if the variable is really present in the description file
		  0 otherwise
		  used for list elements which might be not really present */
} VAR, *VARPTR;

/* BASFUN struct: informations for SCILAB function */
typedef struct basfun {
  char *name; /* function name */
  int nin; /* number of arguments */
  IVAR in[MAXARG]; /* list of argument IVAR */
  IVAR out; /* output IVAR */
} BASFUN, *BASFUNPTR;

/* FORSUB struct: informations for FORTRAN subroutine */
typedef struct forsub {
  char *name; /* subroutine name */
  int narg; /* number of arguments */
  IVAR arg[MAXARG]; /* list of argument IVAR */
} FORSUB, *FORSUBPTR;

/* memory allocators */

VARPTR VarAlloc()
{
  return((VARPTR) malloc(sizeof(VAR)));
}

BASFUNPTR BasfunAlloc()
{
  return((BASFUNPTR) malloc(sizeof(BASFUN)));
}

FORSUBPTR ForsubAlloc()
{
  return((FORSUBPTR) malloc(sizeof(FORSUB)));
}

/* global variables */

VARPTR variables[MAXVAR]; /* array of VAR structures */
int nVariable; /* number of variables */
BASFUNPTR basfun; /* SCILAB function structure */
FORSUBPTR forsub; /* FORTRAN subroutine structure */
int nFun; /* total number of functions in "desc" file */
int maxOpt; /* maximal number of optional variables */
char *funNames[MAXFUN]; /* array of function names */
