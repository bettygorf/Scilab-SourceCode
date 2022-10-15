/* Library to add C-Functions to Scilab And/Or Matlab */
/* Bertrand Guiheneuf 1996 */






#ifndef INCLUDE_CSCIINTERF
#define INCLUDE_CSCIINTERF

#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#ifndef MAX
#define MAX(a,b) (a > b ? a : b)
#endif

#ifndef MIN
#define MIN(a,b) (a < b ? a : b)
#endif




#include "../machine.h"
#include "../stack-def.h"

#ifndef integer
#define integer int
#endif

/* types definition */ 
typedef double Matrix; 








struct {
  int NbParamIn;
  int NbParamOut;
  int ReturnCounter;
  int FuncIndex;
  int ReturnIndex;
  char Retour[1000];
  int Err1;
  Matrix **Param;
  Matrix **Return;
} Interf;


/****************************************** P R O T O T Y P E S *************************************/


void InterfError();
extern int MatrixMemSize();
extern Matrix *MatrixCreate();
extern int MatrixIsNumeric();
extern int MatrixIsReal();
extern int MatrixIsComplex();
extern int MatrixIsScalar();
extern int MatrixIsList();
extern Matrix *MatrixCreateString();
extern char *MatrixReadString();
extern Matrix *ListCreate();
extern Matrix *AppendList();
extern int ListGetSize();
extern Matrix *ListGetCell();
extern void MatrixFree();
extern double *MatrixGetPr();
extern double *MatrixGetPi();
extern int MatrixGetWidth();
extern int MatrixGetHeight();
extern double MatrixGetScalar();
extern void MatrixTranspose();
extern void MatrixCopy();
extern void ReturnParam();
extern void InterfInit();
extern void InterfDone();



#endif /*INCLUDE_CSCIINTERF*/ 
