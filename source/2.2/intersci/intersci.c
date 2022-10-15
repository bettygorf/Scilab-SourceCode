#include "intersci.h"

void AddForName();
void ChangeForName();
void Copyright();
char *Forname2Int();
void GenFundef();
int GetBasType();
int GetForType();
IVAR GetExistOutVar();
IVAR GetExistVar();
IVAR GetOutVar();
IVAR GetVar();
void OptVar();
int ParseLine();
int ParseScilabLine();
int ReadListElement();
void ReadListFile();
void ReadFile();
int ReadFunction();
int TypeToBas();
void WriteArgCheck();
void WriteCall();
void WriteCallRest();
void WriteCallConvertion();
void WriteCrossCheck();
void WriteEqualCheck();
void WriteExternalVariableOutput();
void WriteFortranCall();
void WriteFunctionCode();
void WriteHeader();
void WriteListAnalysis();
void WriteOutput();
void WriteVariable();
void WriteVariableOutput();

int main(argc,argv)
unsigned int argc;
char **argv;
{
  switch (argc) {
  case 3:
    break;
  default:
    printf("usage:  intersci <interface file> <interface number>\n");
    exit(1);
    break;
  }
  basfun = BasfunAlloc();
  if (basfun == 0) {
    printf("Running out of memory\n");
    exit(1);
  }
  forsub = ForsubAlloc();
   if (forsub == 0) {
    printf("Running out of memory\n");
    exit(1);
  }
  ReadFile(argv[1]);
  GenFundef(argv[1],atoi(argv[2]));
  exit(0);
}

void ReadFile(file)
char *file;
{
  FILE *fin, *fout;
  char filout[MAXNAM];
  char filin[MAXNAM];
  int i;
  sprintf(filin,"%s.desc",file);
  fin = fopen(filin,"r");
  if (fin == 0) {
    printf("interface file \"%s\" does not exist\n",filin);
    exit(1);
  }
  Copyright();
  strcpy(filout,file);
  strcat(filout,".f");
  fout = fopen(filout,"w");

  nFun = 0;
  while(ReadFunction(fin)) {
    nFun++;
    if (nFun > MAXFUN) {
      printf("Too many SCILAB functions. The maximum is %d\n",MAXFUN);
      exit(1);
    }
    WriteFunctionCode(fout);
  }
  WriteMain(fout,file);
  printf("FORTRAN file \"%s\" has been created\n",filout);
  fclose(fout);
  fclose(fin);
}

WriteMain(fout,file)
     FILE *fout;
     char* file;
{
  int i;
  fprintf(fout,"\nc  interface function ");
  fprintf(fout,"\nc   ********************\n ");
  WriteHeader(fout," ",file);
  fprintf(fout,"      goto (");
  for (i = 1; i < nFun ; i++) {
    fprintf(fout,"%d,",i);
    if ( i% 10 == 0 ) fprintf(fout,"\n     $  ");
  }
  fprintf(fout,"%d) fin \n       return\n",nFun);
  for (i = 0; i < nFun; i++) {
    fprintf(fout,"%d      call ints%s\n      return\n",i+1,funNames[i]);
  }
  fprintf(fout,"       end\n");
}

void Copyright()
{
  printf("\nINTERSCI Version %s (%s)\n",VERSION,DATE);
  printf("    Copyright (C) INRIA All rights reserved\n\n");
}

int ReadFunction(f)
FILE *f;
{
  int i, j, l, type, ftype;
  char s[MAXLINE];
  char str[MAXNAM];
  char *words[MAXLINE];
  char *optwords[MAXLINE];
  IVAR ivar;
  int nwords, line1, inbas, fline1, infor, nopt, out1;

  nVariable = 0;
  maxOpt = 0;
  line1 = 1;
  inbas = 0;
  fline1 = 0;
  infor = 0;
  out1 = 0;
  while (fgets(s,MAXLINE,f)) {
    /* analysis of one line */
    if (line1 != 1) nwords = ParseLine(s,words);
    else nwords = ParseScilabLine(s,words);
    /* end of description */
    if (words[0][0] == '*') return(1);
    if (line1 == 1) {
      /* SCILAB function description */
      if ((int)strlen(words[0]) > 24) {
	printf("SCILAB function name too long: \"%s\"\n",words[0]);
	exit(1);
      }
      basfun->name = (char *)malloc((unsigned)(strlen(words[0])+1));
      strcpy(basfun->name,words[0]);
      printf("**************************\n");
      printf("processing SCILAB function \"%s\"\n",words[0]);
      funNames[nFun] = basfun->name;
      i = nwords - 1;
      if (i > MAXARG) {
	printf("too may input arguments for SCILAB function\"%s\"\n",
	       words[0]);
	printf("  augment constant \"MAXARG\" and recompile intersci\n");
	exit(1);
      }
      basfun->nin = i;
      for (i = 0; i < nwords - 1; i++) {
	if (words[i+1][0] == '{') {
	  maxOpt++;
	  if (maxOpt > 2) {
	    printf("Only 2 optional variables allowed\n");
	    exit(1);
	  }
	  nopt = ParseLine(words[i+1]+1,optwords);
	  if (nopt != 2) {
	    printf("Bad syntax for optional argument. Two variables needed\n");
	    exit(1);
	  }
	  ivar = GetVar(optwords[0],1);
	  basfun->in[i] = ivar;
	  variables[ivar-1]->opt_type = NAME;
	  variables[ivar-1]->opt_name =
	    (char *)malloc((unsigned)(strlen(optwords[1])+1));
	  strcpy(variables[ivar-1]->opt_name,optwords[1]);
	}
	else if (words[i+1][0] == '[') {
	  maxOpt++;
	  if (maxOpt > 2) {
	    printf("Only 2 optional variables allowed\n");
	    exit(1);
	  }
	  nopt = ParseLine(words[i+1]+1,optwords);
	  if (nopt != 2) {
	    printf("Bad syntax for optional argument. Two variables needed\n");
	    exit(1);
	  }
	  ivar = GetVar(optwords[0],1);
	  basfun->in[i] = ivar;
	  variables[ivar-1]->opt_type = VALUE;
	  variables[ivar-1]->opt_name =
	    (char *)malloc((unsigned)(strlen(optwords[1])+1));
	  strcpy(variables[ivar-1]->opt_name,optwords[1]);
	}
	else basfun->in[i] = GetVar(words[i+1],1);
      }
      line1 = 0;
      inbas = 1;
    } else if (inbas == 1) {
      if (nwords == 0) {
	/* end of SCILAB variable description */
	inbas = 0;
	fline1 = 1;
      } else {
	/* SCILAB variable description */
	ivar = GetVar(words[0],1);
	i = ivar - 1;
	if (nwords == 1) {
	  printf("type missing for variable \"%s\"\n",words[0]);
	  exit(1);
	}
	type = GetBasType(words[1]);
	variables[i]->type = type;
	switch (type) {
	case SCALAR:
	case ANY:
	  break;
	case COLUMN:
	case ROW:
	case STRING:
	case WORK:
        case VECTOR:
	  if (nwords != 3) {
	    printf("bad type specification for variable \"%s\"\n",
		   words[0]);
	    exit(1);
	  }
	  variables[i]->el[0] = GetVar(words[2],1);
	  break;
	case LIST:
	case TLIST:
	  if (nwords != 3) {
	    printf("bad type specification for variable \"%s\"\n",
		   words[0]);
	    exit(1);
	  }
	  ReadListFile(words[2],words[0],i);
	  break;
	case POLYNOM:
	case MATRIX:
	case STRINGMAT:
	  if (nwords != 4) {
	    printf("bad type specification for variable \"%s\"\n",
		   words[0]);
	    exit(1);
	  }	  
	  variables[i]->el[0] = GetVar(words[2],1);
	  variables[i]->el[1] = GetVar(words[3],1);
	  break;
	case SEQUENCE:
	  printf("variable \"%s\" cannot have type \"SEQUENCE\"\n",
		 words[0]);
	  exit(1);
	  break;
	case EMPTY:
	  printf("variable \"%s\" cannot have type \"EMPTY\"\n",
		 words[0]);
	  exit(1);
	  break;
	}
      }
    } else if (fline1 == 1) {
      /* FORTRAN subroutine description */
      forsub->name = (char *)malloc((unsigned)(strlen(words[0])+1));
      strcpy(forsub->name,words[0]);
      i = nwords - 1;
      if (i > MAXARG) {
	printf("too many argument for FORTRAN subroutine \"%s\"\n",
	       words[0]);
	printf("  augment constant \"MAXARG\" and recompile intersci\n");
	exit(1);
      }
      forsub->narg = i;
      for (i = 0; i < nwords - 1; i++) {
	forsub->arg[i] = GetExistVar(words[i+1]);
      }
      fline1 = 0;
      infor = 1;
    } else if (infor == 1) {
      if (nwords == 0) {
	/* end of FORTRAN subroutine description */
	infor = 0;
	out1 = 1;
      }
      else {
	/* FORTRAN variable description */
	if (nwords == 1) {
	  printf("type missing for FORTRAN argument \"%s\"\n",
		 words[0]);
	  exit(1);
	}
	ivar = GetExistVar(words[0]);
	ftype = GetForType(words[1]);
	variables[ivar-1]->for_type = ftype;
	if (ftype == EXTERNAL) {
	  strcpy((char *)(variables[ivar-1]->fexternal),words[1]);
	  switch (variables[ivar-1]->type) {
	  case COLUMN:
	  case POLYNOM:
	  case ROW:
	  case STRING:
          case VECTOR:
	    sprintf(str,"ne%d",ivar);
	    AddForName(variables[ivar-1]->el[0],str);
	    break;
	  case MATRIX:
	  case STRINGMAT:
	    sprintf(str,"me%d",ivar);
	    AddForName(variables[ivar-1]->el[0],str);
	    sprintf(str,"ne%d",ivar);
	    AddForName(variables[ivar-1]->el[1],str);
	    break;
	  default:
	    printf("FORTRAN argument \"%s\" with external type \"%s\"\n",
		   variables[ivar-1]->name,words[1]);
	    printf("  cannot have a variable type of \"LIST\" \"TLIST\"\n");
	    printf("  or \"WORK\"\n");
	    exit(1);
	    break;
	  }
	}
      }
    } else if (out1 == 1) {
      /* output variable description */
      i = ivar - 1;
      if (nwords == 1) {
	printf("type missing for output variable \"out\"\n");
	exit(1);
      }
      ivar = GetOutVar(words[0]);
      basfun->out = ivar;
      i = ivar - 1;
      type = GetBasType(words[1]);
      variables[i]->type = type;
      switch (type) {
      case LIST:
      case TLIST:
      case SEQUENCE:
	l = nwords - 2;
	if (l > MAXEL) {
	  printf("list or sequence too long for output variable \"out\"\n");
	  printf("  augment constant \"MAXEL\" and recompile intersci\n");
	  exit(1);
	}
	for (j = 0; j < l; j++) 
	  variables[i]->el[j] = GetExistVar(words[j+2]);
	variables[i]->length = l;
	break;
      case EMPTY:
	break;
      default:
	printf("output variable \"out\" of SCILAB function\n");
	printf("  must have type \"LIST\", \"TLIST\", \"SEQUENCE\" or\n");
	printf("  \"EMPTY\"\n");
	exit(1);
	break;
      }
      out1 = 0;
    }
    else {
      /* possibly equal variables */
      ivar = GetExistVar(words[0]);
      i = ivar -1 ;
      variables[i]->equal = GetExistVar(words[1]);
    }
  }
  /* end of description file */
  return(0);
}

/* put the words of SCILAB function description line "s" in "words" and 
   return the number of words with checking syntax of optional variables:
   "{g  the_g }" => 1 word "{g  the_g \n"
   "[f v]" => 1 word "[f v\n" 
*/
int ParseScilabLine(s,words)
char *s, *words[];
{
  char w[MAXNAM];
  int nwords = 0;
  int inword = 1;
  int inopt1 = 0; /* {  } */
  int inopt2 = 0; /* [  ] */
  int i = 0;
  if (*s == ' ' || *s == '\t') inword = 0;
  if (*s == '{') inopt1 = 1;
  if (*s == '[') inopt2 = 1;
  while (*s) {
    if (inopt1) {
      w[i++] = *s++;
      if (*s == '{' || *s == '[' || *s == ']' || *s == '\n') {
	printf("Bad syntax for optional argument. No matching \"}\"\n");
	exit(1);
      }
      else if (*s == '}') {
	w[i++] = '\n';
	w[i] = '\0';
	words[nwords] = (char *)malloc((unsigned)(i+1));
	strcpy(words[nwords],w);
	nwords++;
	inopt1 = 0;
	inword = 0;
      }
    }
    else if (inopt2) {
      w[i++] = *s++;
      if (*s == '[' || *s == '{' || *s == '}' || *s == '\n') {
	printf("Bad syntax for optional argument. No matching \"]\"\n");
	exit(1);
      }
      else if (*s == ']') {
	w[i++] = '\n';
	w[i] = '\0';
	words[nwords] = (char *)malloc((unsigned)(i+1));
	strcpy(words[nwords],w);
	nwords++;
	inopt2 = 0;
	inword = 0;
      }
    }
    else if (inword) {
      w[i++] = *s++;
      if (*s == ' ' || *s == '\t' || *s == '\n') {
	w[i] = '\0';
	words[nwords] = (char *)malloc((unsigned)(i+1));
	strcpy(words[nwords],w);
	nwords++;
	inword = 0;
      }
    }
    else {
      *s++;
      if (*s != ' ' && *s != '\t') {
	/* beginning of a word */
	i = 0;
	inword = 1;
	if (*s == '{') inopt1 = 1;
	if (*s == '[') inopt2 = 1;
      }
    }
  }
  return(nwords);
}

/* put the words of line "s" in "words" and return the number of words */
int ParseLine(s,words)
char *s, *words[];
{
  char w[MAXNAM];
  int nwords = 0;
  int inword = 1;
  int i = 0;
  if(*s == ' ' || *s == '\t') inword = 0;
  while (*s) {
    if (inword) {
      w[i++] = *s++;
      if (*s == ' ' || *s == '\t' || *s == '\n') {
	w[i] = '\0';
	words[nwords] = (char *)malloc((unsigned)(i+1));
	strcpy(words[nwords],w);
	nwords++;
	inword = 0;
      }
    }
    else {
      *s++;
      if (*s != ' ' && *s != '\t') {
	i = 0;
	inword = 1;
      }
    }
  }
  return(nwords);
}

/* return the variable number of variable name. if it does not already exist,
  it is created and "nVariable" is incremented
  p corresponds to the present slot of var structure:
  - if the variable does not exist it is created with p value
  - if the variable exists it is created with (p or 0) value */
IVAR GetVar(name,p)
char *name;
int p;
{
  int i;
  VARPTR var;
  if (strcmp(name,"out") == 0) {
    printf("the name of a variable which is not the output variable\n");
    printf("  of SCILAB function cannot be \"out\"\n");
    exit(1);
  }
  for (i = 0; i < nVariable; i++) {
    var = variables[i];
    if (strcmp(var->name,name) == 0) {
      var->present = var->present || p;
      return(i+1);
    }
  }
  if (nVariable == MAXVAR) {
    printf("too many variables\n");
    printf("  augment constant \"MAXVAR\" and recompile intersci\n");
    exit(1);
  }
  var = VarAlloc();
  if (var == 0) {
    printf("Running out of memory\n");
    exit(1);
  }
  var->name = (char *)malloc((unsigned)(strlen(name) + 1));
  strcpy(var->name,name);
  var->type = 0;
  var->length = 0;
  var->for_type = 0;
  var->equal = 0;
  var->nfor_name = 0;
  var->list_el = 0;
  var->opt_type = 0;
  var->present = p;
  variables[nVariable++] = var;
  return(nVariable);
}

/* return the variable number of variable name which must already
  exist */
IVAR GetExistVar(name)
char *name;
{
  int i;
  VARPTR var;
  if (strcmp(name,"out") == 0) {
    printf("the name of a variable which is not the output variable\n");
    printf("  of SCILAB function cannot be \"out\"\n");
    exit(1);
  }
  for (i = 0; i < nVariable; i++) {
    var = variables[i];
    if (strcmp(var->name,name) == 0) {
      /* always present */
      var->present = 1;
      return(i+1);
    }
  }
  printf("variable \"%s\" must exist\n",name);
  exit(1);
}

/* return the variable number of variable "out"
  which is created and "nVariable" is incremented */

IVAR GetOutVar(name)
char *name;
{
  VARPTR var;
  if (strcmp(name,"out") != 0) {
    printf("the name of output variable of SCILAB function\n");
    printf("  must be \"out\"\n");
    exit(1);
  }
  if (nVariable == MAXVAR) {
    printf("too many variables\n");
    printf("  augmente constant \"MAXVAR\" and recompile intersci\n");
    exit(1);
  }
  var = VarAlloc();
  if (var == 0) {
    printf("Running out of memory\n");
    exit(1);
  }
  var->name = (char *)malloc((unsigned)(strlen(name) + 1));
  strcpy(var->name,name);
  var->type = 0;
  var->length = 0;
  var->for_type = 0;
  var->equal = 0;
  var->nfor_name = 0;
  var->list_el = 0;
  var->opt_type = 0;
  var->present = 0;
  variables[nVariable++] = var;
  return(nVariable);
}

/* return the variable number of variable "out"
   which must exist */

IVAR GetExistOutVar()
{
  int i;
  char str[4];
  strcpy(str,"out");
  for (i = 0; i < nVariable; i++) {
    if (strcmp(variables[i]->name,str) == 0)
      return(i+1);
  }
  printf("variable \"out\" must exist\n");
  exit(1);
}

/* convert string to integer variable type */
int GetBasType(type)
char *type;
{
  if (strcmp(type,"column") == 0) 
    return(COLUMN);
  else if (strcmp(type,"list") == 0) 
    return(LIST);
  else if (strcmp(type,"tlist") == 0) 
    return(TLIST);
  else if (strcmp(type,"matrix") == 0)
    return(MATRIX);
  else if (strcmp(type,"polynom") == 0)
    return(POLYNOM);
  else if (strcmp(type,"row") == 0)
    return(ROW);
  else if (strcmp(type,"scalar") == 0)
    return(SCALAR);
  else if (strcmp(type,"sequence") == 0)
    return(SEQUENCE);
  else if (strcmp(type,"string") == 0)
    return(STRING);
  else if (strcmp(type,"work") == 0)
    return(WORK);
  else if (strcmp(type,"empty") == 0)
    return(EMPTY);
  else if (strcmp(type,"any") == 0)
    return(ANY);
  else if (strcmp(type,"vector") == 0)
    return(VECTOR);
  else if (strcmp(type,"stringmat") == 0)
    return(STRINGMAT);
  else {
    printf("the type of variable \"%s\" is unknown\n",type);
    exit(1);
  }
}

/* convert string to integer FORTRAN type */
int GetForType(type)
char *type;
{
  if (strcmp(type,"char") == 0)
    return(CHAR);
  else if (strcmp(type,"int") == 0) 
    return(INT);
  else if (strcmp(type,"integer") == 0) 
    return(INT);
  else if (strcmp(type,"double") == 0)
    return(DOUBLE);
  else if (strcmp(type,"real") == 0)
    return(REAL);
  else if (strcmp(type,"Cstringv") == 0)
    return(CSTRINGV);
  else return(EXTERNAL);
}

void WriteHeader(f,fname0,fname)
FILE *f;
char* fname,*fname0;
{
  fprintf(f,"      subroutine %s%s\n",fname0,fname);
  fprintf(f,"c\n");
  fprintf(f,"      include '../stack.h'\n");
  fprintf(f,"c\n");
  fprintf(f,"      integer iadr, sadr\n");
  fprintf(f,"      iadr(l)=l+l-1\n");
  fprintf(f,"      sadr(l)=(l/2)+1\n");
  fprintf(f,"      rhs = max(0,rhs)\n");
  fprintf(f,"c\n");
}

void WriteFunctionCode(f)
FILE* f;
{
  int i;
  IVAR ivar;

  printf("  generating  code for SCILAB function\"%s\"\n",
	 basfun->name);
  printf("    and FORTRAN subroutine\"%s\"\n",forsub->name);
  fprintf(f,"c fin = %d \n",nFun);
  fprintf(f,"c SCILAB function : %s\n",basfun->name);
  WriteHeader(f,"ints",basfun->name);

  /* possibly init for string flag */
  for (i = 0; i < forsub->narg; i++) {
    if (variables[forsub->arg[i]-1]->for_type == CHAR) {
      fprintf(f,"        lbuf = 1\n");
      break;
    }
  }

  /* init for work space */
  fprintf(f,"        lw = lstk(top+1)\n");
  fprintf(f,"        l0 = lstk(top+1-rhs)\n");

  /* rhs argument number checking */
  if (maxOpt == 0)
    fprintf(f,"        if (rhs .ne. %d) then\n",basfun->nin);
  else
    fprintf(f,"        if (rhs .gt. %d .or. rhs .lt. %d) then\n",
	    basfun->nin,basfun->nin - maxOpt);
  fprintf(f,"          call error(39)\n");
  fprintf(f,"          return\n");
  fprintf(f,"        endif\n");

  /* lhs argument number checking */
  ivar = basfun->out;
  if ((variables[ivar-1]->length == 0) || (variables[ivar-1]->type == LIST)
      || (variables[ivar-1]->type == TLIST))
    fprintf(f,"        if (lhs .ne. 1) then\n");
  else fprintf(f,"        if (lhs .gt. %d) then\n",variables[ivar-1]->length);
  fprintf(f,"          call error(41)\n");
  fprintf(f,"          return\n");
  fprintf(f,"        endif\n");

  /* SCILAB argument checking */
  for (i = 0; i < basfun->nin; i++)
    {
      WriteArgCheck(f,i);

      if ((variables[i]->type == LIST) || (variables[i]->type == TLIST))
      /* SCILAB list analizis*/
	WriteListAnalysis(f,i);
    }
  /* SCILAB cross checking */
  WriteCrossCheck(f);

  /* SCILAB equal output variable checking */
  WriteEqualCheck(f);

  /* FORTRAN call */
  WriteFortranCall(f);

  /* FORTRAN output to SCILAB */
  WriteOutput(f);
}

void WriteArgCheck(f,i)
FILE *f;
int i;
{
  int i1, type;
  char str[MAXNAM];
  char str1[MAXNAM];
  VARPTR var = variables[basfun->in[i]-1];
  i1 = i + 1;

  fprintf(f,"c       checking variable %s (number %d)\n",var->name,i1);
  fprintf(f,"c       \n");

  if (var->opt_type != 0)
    OptVar(f,var,i1); /* optional argument */

  /* type checking */
  fprintf(f,"        il%d = iadr(lstk(top-rhs+%d))\n",i1,i1);
  if (var->type != ANY) {
    type = TypeToBas(var->type);
    fprintf(f,"        if (istk(il%d) .ne. %d) then\n",i1,type);
    fprintf(f,"          err = %d\n",i1);
    switch(type) {
    case 1:
      fprintf(f,"          call error(53)\n");
      break;
    case 2:
      fprintf(f,"          call error(54)\n");
      break;
    case 10:
      fprintf(f,"          call error(55)\n");
      break;
    case 15:
      fprintf(f,"          call error(56)\n");
      break;
    }
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
  }

  /* size checking */
  switch(var->type) {
  case COLUMN:
    fprintf(f,"        if (istk(il%d+2) .ne. 1) then\n",i1);
    fprintf(f,"          err = %d\n",i1);
    fprintf(f,"          call error(89)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        n%d = istk(il%d+1)\n",i1,i1);
    sprintf(str,"n%d",i1);
    strcpy(str1,variables[var->el[0]-1]->name);
    if (isdigit(str1[0]) != 0) {
      /* the dimension of the variable is a constant integer */
      fprintf(f,"        if (%s .ne. %s) then\n",str,str1);
      fprintf(f,"          err = %d\n",i1);
      fprintf(f,"          call error(89)\n");
      fprintf(f,"          return\n");
      fprintf(f,"        endif\n");
    }
    AddForName(var->el[0],str);
    fprintf(f,"        l%d = sadr(il%d+4)\n",i1,i1);
    break;
  case MATRIX:
  case STRINGMAT:
    /* square matrix */
    if (var->el[0] == var->el[1]) {
      fprintf(f,"        if (istk(il%d+1) .ne. istk(il%d+2)) then\n",
	      i1,i1);
      fprintf(f,"          err = %d\n",i1);
      fprintf(f,"          call error(20)\n");
      fprintf(f,"          return\n");
      fprintf(f,"        endif\n");
    }
    fprintf(f,"        n%d = istk(il%d+1)\n",i1,i1);
    fprintf(f,"        m%d = istk(il%d+2)\n",i1,i1);
    sprintf(str,"n%d",i1);
    strcpy(str1,variables[var->el[0]-1]->name);
    if (isdigit(str1[0]) != 0) {
      /* the dimension of the variable is a constant integer */
      fprintf(f,"        if (%s .ne. %s) then\n",str,str1);
      fprintf(f,"          err = %d\n",i1);
      fprintf(f,"          call error(89)\n");
      fprintf(f,"          return\n");
      fprintf(f,"        endif\n");
    }
    AddForName(var->el[0],str);
    sprintf(str,"m%d",i1);
    strcpy(str1,variables[var->el[1]-1]->name);
    if (isdigit(str1[0]) != 0) {
      /* the dimension of the variable is a constant integer */
      fprintf(f,"        if (%s .ne. %s) then\n",str,str1);
      fprintf(f,"          err = %d\n",i1);
      fprintf(f,"          call error(89)\n");
      fprintf(f,"          return\n");
      fprintf(f,"        endif\n");
    }
    AddForName(var->el[1],str);
    fprintf(f,"        l%d = sadr(il%d+4)\n",i1,i1);
    break;
  case ROW:
    fprintf(f,"        if (istk(il%d+1) .ne. 1) then\n",i1);
    fprintf(f,"          err = %d\n",i1);
    fprintf(f,"          call error(89)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        m%d = istk(il%d+2)\n",i1,i1);
    sprintf(str,"m%d",i1);
    strcpy(str1,variables[var->el[0]-1]->name);
    if (isdigit(str1[0]) != 0) {
      /* the dimension of the variable is a constant integer */
      fprintf(f,"        if (%s .ne. %s) then\n",str,str1);
      fprintf(f,"          err = %d\n",i1);
      fprintf(f,"          call error(89)\n");
      fprintf(f,"          return\n");
      fprintf(f,"        endif\n");
    }
    AddForName(var->el[0],str);
    fprintf(f,"        l%d = sadr(il%d+4)\n",i1,i1);
    break;
  case VECTOR:
    fprintf(f,"        m%d = istk(il%d+1)*istk(il%d+2)\n",i1,i1,i1);
    sprintf(str,"m%d",i1);
    strcpy(str1,variables[var->el[0]-1]->name);
    if (isdigit(str1[0]) != 0) {
      /* the dimension of the variable is a constant integer */
      fprintf(f,"        if (%s .ne. %s) then\n",str,str1);
      fprintf(f,"          err = %d\n",i1);
      fprintf(f,"          call error(89)\n");
      fprintf(f,"          return\n");
      fprintf(f,"        endif\n");
    }
    AddForName(var->el[0],str);
    fprintf(f,"        l%d = sadr(il%d+4)\n",i1,i1);
    break;

  case POLYNOM:
    fprintf(f,"        if (istk(il%d+1)*istk(il%d+2) .ne. 1) then\n",
	    i1,i1);
    fprintf(f,"          err = %d\n",i1);
    fprintf(f,"          call error(89)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        n%d = istk(il%d+9)-2\n",i1,i1);
    sprintf(str,"n%d",i1);
    strcpy(str1,variables[var->el[0]-1]->name);
    if (isdigit(str1[0]) != 0) {
      /* the dimension of the variable is a constant integer */
      fprintf(f,"        if (%s .ne. %s) then\n",str,str1);
      fprintf(f,"          err = %d\n",i1);
      fprintf(f,"          call error(89)\n");
      fprintf(f,"          return\n");
      fprintf(f,"        endif\n");
    }
    AddForName(var->el[0],str);
    fprintf(f,"        l%d = sadr(il%d+10)\n",i1,i1);
    break;
  case SCALAR:
    fprintf(f,"        if (istk(il%d+1)*istk(il%d+2) .ne. 1) then\n",
	    i1,i1);
    fprintf(f,"          err = %d\n",i1);
    fprintf(f,"          call error(89)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        l%d = sadr(il%d+4)\n",i1,i1);
    break;
  case STRING:
    fprintf(f,"        if (istk(il%d+1)*istk(il%d+2) .ne. 1) then\n",
	    i1,i1);
    fprintf(f,"          err = %d\n",i1);
    fprintf(f,"          call error(89)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        n%d = istk(il%d+5)-1\n",i1,i1);
    sprintf(str,"n%d",i1);
    strcpy(str1,variables[var->el[0]-1]->name);
    if (isdigit(str1[0]) != 0) {
      /* the dimension of the variable is a constant integer */
      fprintf(f,"        if (%s .ne. %s) then\n",str,str1);
      fprintf(f,"          err = %d\n",i1);
      fprintf(f,"          call error(89)\n");
      fprintf(f,"          return\n");
      fprintf(f,"        endif\n");
    }
    AddForName(var->el[0],str);
    fprintf(f,"        l%d = il%d+6\n",i1,i1);
    break;
  case ANY:
    break;
  }
}

int TypeToBas(type)
int type;
{
  switch (type) {
  case COLUMN:
  case MATRIX:
  case ROW:
  case SCALAR:
  case VECTOR:
    return(1);
  case LIST:
    return(15);
  case TLIST:
    return(16);
  case POLYNOM:
    return(2);
  case STRING:
  case STRINGMAT:
    return(10);
  default:
    printf("unknown variable type\n");
    exit(1);
  }
}

void AddForName(ivar,name)
IVAR ivar;
char* name;
{
  VARPTR var;
  int l;
  var = variables[ivar-1];
  l = var->nfor_name;
  if (l == MAXARG) {
    printf("too many \"for_name\" for variable \"%s\"\n",var->name);
    printf("  augment constant \"MAXARG\" and recompile intersci\n");
    exit(1);
  }
  var->for_name[l] = (char *)malloc((unsigned)(strlen(name) + 1));
  strcpy(var->for_name[l],name);
  var->nfor_name = l + 1;
}

void ChangeForName(ivar,name)
IVAR ivar;
char* name;
{
  VARPTR var;
  int l;
  var = variables[ivar-1];
  l = var->nfor_name;
  var->for_name[0] = (char *)malloc((unsigned)(strlen(name) + 1));
  strcpy(var->for_name[0],name);
  /* useful ??? */
  if (l == 0) var->nfor_name = 1;
}

void WriteCrossCheck(f)
FILE *f;
{
  int i, j;
  char *n1, *n2;
  VARPTR var;

  fprintf(f,"c     \n");        
  fprintf(f,"c       cross variable size checking\n"); 
  fprintf(f,"c     \n");               
  for (i = 0; i < nVariable; i++) {
    var = variables[i];
    /* does not check list elements */
    if (var->nfor_name != 0 && var->list_el == 0) {
      if (strncmp(var->for_name[0],"ne",2) != 0 &&
	  strncmp(var->for_name[0],"me",2) != 0) {
	n1 = Forname2Int(var->for_name[0]);
	for (j = 1; j < var->nfor_name; j++) {
	  n2 = Forname2Int(var->for_name[j]);
	  fprintf(f,"        if (%s .ne. %s) then\n",n1,n2);
	  fprintf(f,"          call error(42)\n");
	  fprintf(f,"          return\n");
	  fprintf(f,"        endif\n");
	}
      }
    }
  }
  fprintf(f,"c     \n");        
  fprintf(f,"c       cross formal parameter checking\n");
  fprintf(f,"c       not implemented yet\n");
}

void WriteEqualCheck(f)
FILE *f;
{
  fprintf(f,"c     \n");        
  fprintf(f,"c       cross equal output variable checking\n");
  fprintf(f,"c       not implemented yet\n");
}

void WriteFortranCall(f)
FILE *f;
{
  int i, j, ind;
  IVAR ivar, iivar;
  char call[MAXCALL];
  char str1[8],str2[8];
  sprintf(call,"call %s(",forsub->name);
  /* loop on FORTRAN arguments */
  for (i = 0; i < forsub->narg; i++) {
    ivar = forsub->arg[i];
    ind = 0;
    if (variables[ivar-1]->list_el != 0) {
      /* FORTRAN argument is a list element */
      iivar = GetExistVar(variables[ivar-1]->list_name);
      for (j = 0; j < basfun->nin; j++) {
	if (iivar == basfun->in[j]) {
	  /* it must be a SCILAB argument */
	  sprintf(str1,"%de%d",iivar,variables[ivar-1]->list_el);
	  sprintf(str2,"%de%d",iivar,variables[ivar-1]->list_el);
	  WriteCallConvertion(f,ivar,str2,str1,call);
	  ind = 1;
	  break;
	}
      }
      if (ind == 0) {
	printf("list or tlist \"%s\" must be an argument of SCILAB function\n",
	       variables[ivar-1]->list_name);
	exit(1);
      }
    }
    else {
      for (j = 0; j < basfun->nin; j++) {
	if (ivar == basfun->in[j]) {
	  /* FORTRAN argument is a SCILAB argument */
	  sprintf(str1,"%d",j+1);
	  sprintf(str2,"%d",i+1);
	  WriteCallConvertion(f,ivar,str2,str1,call);
	  ind = 1;
	  break;
	}
      }
    }
    if (ind == 0) {
	/* FORTRAN argument is not a SCILAB argument */
      WriteCallRest(f,ivar,i+1,call);
    }
  }
  if  (forsub->narg == 0) strcat(call,")");
  else call[strlen(call)-1] = ')';
  fprintf(f,"        err=lw-lstk(bot)\n");
  fprintf(f,"        if (err .gt. 0) then\n");
  fprintf(f,"          call error(17)\n");
  fprintf(f,"          return\n");
  fprintf(f,"        endif\n");
  fprintf(f,"c\n");
  WriteCall(f,call);
  fprintf(f,"        if (err .gt. 0) return\n");  
  fprintf(f,"c\n");
}

void WriteCallConvertion(f,ivar,farg,barg,call)
FILE *f;
IVAR ivar; 
char *farg;
char *barg;
char *call;
{
  VARPTR var = variables[ivar-1];
  char str[MAXNAM];
  switch (var->type) {
  case COLUMN:
    if (var->for_type == CHAR || var->for_type == CSTRINGV) {
      printf("incompatibility between the variable type and the FORTRAN type for variable \"%s\"\n",var->name);
      exit(1);
    }
    switch (var->for_type) {
    case INT:
      fprintf(f,"        call entier(n%s,stk(l%s),istk(iadr(l%s)))\n",
	      barg,barg,barg);
      sprintf(str,"istk(iadr(l%s))",barg);
      ChangeForName(ivar,str);
      strcat(call,str);
      strcat(call,",");
      break;
    case REAL:
      fprintf(f,"        call simple(n%s,stk(l%s),stk(l%s))\n",barg,barg,barg);
      sprintf(str,"stk(l%s),",barg);
      strcat(call,str);
      break;
    case DOUBLE:
      sprintf(str,"stk(l%s),",barg);
      strcat(call,str);
      break;
    }
    break;
  case MATRIX:
    if (var->for_type == CHAR || var->for_type == CSTRINGV) {
      printf("incompatibility between the variable type and the FORTRAN type for variable \"%s\"\n",var->name);
      exit(1);
    }
    switch (var->for_type) {
    case INT:
      fprintf(f,"        call entier(n%s*m%s,stk(l%s),istk(iadr(l%s)))\n",
	      barg,barg,barg,barg);
      sprintf(str,"istk(iadr(l%s))",barg);
      ChangeForName(ivar,str);
      strcat(call,str);
      strcat(call,",");
      break;
    case REAL:
      fprintf(f,"        call simple(n%s*m%s,stk(l%s),stk(l%s))\n",
	      barg,barg,barg,barg);
      sprintf(str,"stk(l%s),",barg);
      strcat(call,str);
      break;
    case DOUBLE:
      sprintf(str,"stk(l%s),",barg);
      strcat(call,str);
      break;
    }    
    break;
  case POLYNOM:
    if (var->for_type == CHAR || var->for_type == CSTRINGV) {
      printf("incompatibility between the variable type and the FORTRAN type for variable \"%s\"\n",var->name);
      exit(1);
    }
    switch (var->for_type) {
    case INT:
      fprintf(f,"        call entier(n%s,stk(l%s),istk(iadr(l%s)))\n",barg,barg,barg);
      sprintf(str,"istk(iadr(l%s))",barg);
      strcat(call,str);
      strcat(call,",");
      ChangeForName(ivar,str);
      break;
    case REAL:
      fprintf(f,"        call simple(n%s,stk(l%s),stk(l%s))\n",barg,barg,barg);
      sprintf(str,"stk(l%s),",barg);
      strcat(call,str);
      break;
    case DOUBLE:
      sprintf(str,"stk(l%s),",barg);
      strcat(call,str);
      break;
    }    
    break;
  case ROW:
  case VECTOR:
    if (var->for_type == CHAR || var->for_type == CSTRINGV) {
      printf("incompatibility between the variable type and the FORTRAN type for variable \"%s\"\n",var->name);
      exit(1);
    }
    switch (var->for_type) {
    case INT:
      fprintf(f,"        call entier(m%s,stk(l%s),istk(iadr(l%s)))\n",barg,barg,barg);
      sprintf(str,"istk(iadr(l%s))",barg);
      strcat(call,str);
      strcat(call,",");
      ChangeForName(ivar,str);
      break;
    case REAL:
      fprintf(f,"        call simple(m%s,stk(l%s),stk(l%s))\n",barg,barg,barg);
      sprintf(str,"stk(l%s),",barg);
      strcat(call,str);
      break;
    case DOUBLE:
      sprintf(str,"stk(l%s),",barg);
      strcat(call,str);
      break;
    }    
    break;
  case SCALAR:
    if (var->for_type == CHAR || var->for_type == CSTRINGV) {
      printf("incompatibility between the variable type and the FORTRAN type for variable \"%s\"\n",var->name);
      exit(1);
    }
    switch (var->for_type) {
    case INT:
      fprintf(f,"        call entier(1,stk(l%s),istk(iadr(l%s)))\n",barg,barg);
      sprintf(str,"istk(iadr(l%s))",barg);
      strcat(call,str);
      strcat(call,",");
      ChangeForName(ivar,str);
      break;
    case REAL:
      fprintf(f,"        call simple(1,stk(l%s),stk(l%s))\n",barg,barg);
      sprintf(str,"stk(l%s),",barg);
      strcat(call,str);
      break;
    case DOUBLE:
      sprintf(str,"stk(l%s),",barg);
      strcat(call,str);
      break;      
    }    
    break;
  case STRINGMAT:
    if (var->for_type != CSTRINGV) {
      printf("incompatibility between the variable type and the FORTRAN type for variable \"%s\"\n",var->name);
      exit(1);
    }
    fprintf(f,"        lw%s=lw\n",farg);
    fprintf(f,"        lw=lw+1\n");
    fprintf(f,"        call stringc(istk(il%s),stk(lw%s),ierr)\n",
	    barg,farg);
    sprintf(str,"stk(lw%s),",farg);
    strcat(call,str);
    fprintf(f,"        if (ierr.ne.0) then\n");
    fprintf(f,"          buf='not enough memory'\n");
    fprintf(f,"          call error(1000)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    break;
  case LIST:
  case TLIST:
  case SEQUENCE:
    printf("a FORTRAN argument cannot have a variable type of \"LIST\"\n");
    printf("  \"TLIST\" or \"SEQUENCE\"\n");
    exit(1);
    break;
  case STRING:
    if (var->for_type != CHAR) {
      printf("incompatibility between the variable type and the FORTRAN type for variable \"%s\"\n",var->name);
      exit(1);
    }
    fprintf(f,"        lbuf%s = lbuf\n",farg);
    fprintf(f,"        call cvstr(n%s,istk(l%s),buf(lbuf%s:lbuf%s+n%s-1),1)\n",
	    barg,barg,farg,farg,barg);
    sprintf(str,"buf(lbuf%s:lbuf%s+n%s-1),",farg,farg,barg);
    strcat(call,str);
    fprintf(f,"        lbuf = lbuf+n%s+1\n",barg);
    break;
  case ANY:
    sprintf(str,"istk(il%s),",barg);
    strcat(call,str);
    break;
  }
}

void WriteCallRest(f,ivar,farg,call)
FILE *f;
IVAR ivar;
int farg;
char *call;
{
  VARPTR var = variables[ivar-1];
  char str[MAXNAM];
  char str1[MAXNAM];
  char sdim[MAXNAM];
  int ind,j;
  switch (var->type) {
  case 0:
    /* FORTRAN argument is the dimension of an output variable with
       EXTERNAL type */
    if (var->nfor_name == 0) {
      printf("dimension variable \"%s\" is not defined\n",var->name);
      exit(1);
    }
    switch (var->for_type) {
    case 0:
    case INT:
      sprintf(str,"%s,",var->for_name[0]);
      strcat(call,str);
      break;
    case DOUBLE:
      fprintf(f,"         lw%d=lw\n",farg);
      fprintf(f,"         stk(lw%d)=real(%s)\n",farg,var->for_name[0]);
      fprintf(f,"         lw=lw+1\n");
      sprintf(str,"stk(lw%d),",farg);
      strcat(call,str);
      break;
    case REAL:
      fprintf(f,"         lw%d=lw\n",farg);
      fprintf(f,"         stk(lw%d)=real(%s)\n",farg,var->for_name[0]);
      fprintf(f,"         call simple(1,stk(lw%d),stk(lw%d))\n",farg,farg);
      fprintf(f,"         lw=lw+1\n");
      sprintf(str,"stk(lw%d),",farg);      
      strcat(call,str);
      break;
    case CHAR:
    case CSTRINGV:
      printf("a dimension variable cannot have FORTRAN type \"%s\"\n",
	     var->for_type);
      exit(1);
      break;
    }
    break;
    /* working or output argument (always double reservation!) */
  case COLUMN:
  case POLYNOM:
  case ROW:
  case WORK:
  case VECTOR:
    if (variables[var->el[0]-1]->nfor_name == 0) {
      strcpy(str,variables[var->el[0]-1]->name);
      if (isdigit(str[0]) == 0) {
	ind = 0;
	for (j = 0; j < basfun->nin; j++) {
	  if (strcmp(variables[var->el[0]-1]->name,
		     variables[basfun->in[j]-1]->name) == 0) {
	    /* dimension of FORTRAN argument is a SCILAB argument */
	    sprintf(sdim,"nn%d",farg);
	    fprintf(f,"        %s=stk(l%d)\n",sdim,j+1);
	    AddForName(var->el[0],sdim);
	    ind = 1;
	    break;
	  }
	}
	if (ind == 0) {
	  printf("dimension variable \"%s\" is not defined\n",
		 variables[var->el[0]-1]->name);
	  exit(1);
	}
      } else {
	sprintf(sdim,"nn%d",farg);
	fprintf(f,"        %s=%s\n",sdim,str);
	AddForName(var->el[0],sdim);
      }
    }
    if (var->for_type == EXTERNAL) strcpy(str1,"1");
    else strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    fprintf(f,"        lw%d=lw\n",farg);
    fprintf(f,"        lw=lw+%s\n",str1);
    sprintf(str,"stk(lw%d),",farg);
    strcat(call,str);
    break;
  case MATRIX:
     if (variables[var->el[0]-1]->nfor_name == 0) {
      strcpy(str,variables[var->el[0]-1]->name);
      if (isdigit(str[0]) == 0) {
	ind = 0;
	for (j = 0; j < basfun->nin; j++) {
	  if (strcmp(variables[var->el[0]-1]->name,
		     variables[basfun->in[j]-1]->name) == 0) {
	    /* dimension of FORTRAN argument is a SCILAB argument */
	    sprintf(sdim,"nn%d",farg);
	    fprintf(f,"        %s=stk(l%d)\n",sdim,j+1);
	    AddForName(var->el[0],sdim);
	    ind = 1;
	    break;
	  }
	}
	if (ind == 0) {
	  printf("dimension variable \"%s\" is not defined\n",
		 variables[var->el[0]-1]->name);
	  exit(1);
	}
      } else {
	sprintf(sdim,"nn%d",farg);
	fprintf(f,"        %s=%s\n",sdim,str);
	AddForName(var->el[0],sdim);
      }
    }  
   if (variables[var->el[1]-1]->nfor_name == 0) {
      strcpy(str,variables[var->el[1]-1]->name);
      if (isdigit(str[0]) == 0) {
	ind = 0;
	for (j = 0; j < basfun->nin; j++) {
	  if (strcmp(variables[var->el[1]-1]->name,
		     variables[basfun->in[j]-1]->name) == 0) {
	    /* dimension of FORTRAN argument is a SCILAB argument */
	    sprintf(sdim,"mm%d",farg);
	    fprintf(f,"        %s=stk(l%d)\n",sdim,j+1);
	    AddForName(var->el[1],sdim);
	    ind = 1;
	    break;
	  }
	}
	if (ind == 0) {
	  printf("dimension variable \"%s\" is not defined\n",
		 variables[var->el[1]-1]->name);
	  exit(1);
	}
      } else {
	sprintf(sdim,"mm%d",farg);
	fprintf(f,"        %s=%s\n",sdim,str);
	AddForName(var->el[1],sdim);
      }
    }
    if (var->for_type == EXTERNAL) {
      strcpy(str1,"1");
    } else sprintf(str1,"%s*%s",
		   Forname2Int(variables[var->el[0]-1]->for_name[0]),
		   Forname2Int(variables[var->el[1]-1]->for_name[0]));   
    fprintf(f,"        lw%d=lw\n",farg);
    fprintf(f,"        lw=lw+%s\n",str1);
    sprintf(str,"stk(lw%d),",farg);
    strcat(call,str);
    break;
  case STRINGMAT:
     if (variables[var->el[0]-1]->nfor_name == 0) {
      strcpy(str,variables[var->el[0]-1]->name);
      if (isdigit(str[0]) == 0) {
	ind = 0;
	for (j = 0; j < basfun->nin; j++) {
	  if (strcmp(variables[var->el[0]-1]->name,
		     variables[basfun->in[j]-1]->name) == 0) {
	    /* dimension of FORTRAN argument is a SCILAB argument */
	    sprintf(sdim,"nn%d",farg);
	    fprintf(f,"        %s=stk(l%d)\n",sdim,j+1);
	    AddForName(var->el[0],sdim);
	    ind = 1;
	    break;
	  }
	}
	if (ind == 0) {
	  printf("dimension variable \"%s\" is not defined\n",
		 variables[var->el[0]-1]->name);
	  exit(1);
	}
      } else {
	sprintf(sdim,"nn%d",farg);
	fprintf(f,"        %s=%s\n",sdim,str);
	AddForName(var->el[0],sdim);
      }
    }  
   if (variables[var->el[1]-1]->nfor_name == 0) {
      strcpy(str,variables[var->el[1]-1]->name);
      if (isdigit(str[0]) == 0) {
	ind = 0;
	for (j = 0; j < basfun->nin; j++) {
	  if (strcmp(variables[var->el[1]-1]->name,
		     variables[basfun->in[j]-1]->name) == 0) {
	    /* dimension of FORTRAN argument is a SCILAB argument */
	    sprintf(sdim,"mm%d",farg);
	    fprintf(f,"        %s=stk(l%d)\n",sdim,j+1);
	    AddForName(var->el[1],sdim);
	    ind = 1;
	    break;
	  }
	}
	if (ind == 0) {
	  printf("dimension variable \"%s\" is not defined\n",
		 variables[var->el[1]-1]->name);
	  exit(1);
	}
      } else {
	sprintf(sdim,"mm%d",farg);
	fprintf(f,"        %s=%s\n",sdim,str);
	AddForName(var->el[1],sdim);
      }
    }
    fprintf(f,"        lw%d=lw\n",farg);
    fprintf(f,"        lw=lw+1\n");
    sprintf(str,"stk(lw%d),",farg);
    strcat(call,str);
    break;
  case SCALAR:
    fprintf(f,"        lw%d=lw\n",farg);
    fprintf(f,"        lw=lw+1\n");
    sprintf(str,"stk(lw%d),",farg);
    strcat(call,str);   
    break;
  case STRING:
    if (variables[var->el[0]-1]->nfor_name == 0) {
      strcpy(str,variables[var->el[0]-1]->name);
      if (isdigit(str[0]) == 0) {
	ind = 0;
	for (j = 0; j < basfun->nin; j++) {
	  if (strcmp(variables[var->el[0]-1]->name,
		     variables[basfun->in[j]-1]->name) == 0) {
	    /* dimension of FORTRAN argument is a SCILAB argument */
	    sprintf(sdim,"nn%d",farg);
	    fprintf(f,"        %s=stk(l%d)\n",sdim,j+1);
	    AddForName(var->el[0],sdim);
	    ind = 1;
	    break;
	  }
	}
	if (ind == 0) {
	  printf("dimension variable \"%s\" is not defined\n",
		 variables[var->el[0]-1]->name);
	  exit(1);
	}
      } else {
	sprintf(sdim,"nn%d",farg);
	fprintf(f,"        %s=%s\n",sdim,str);
	AddForName(var->el[0],sdim);
      }
    }
    if (var->for_type == EXTERNAL) {
      fprintf(f,"        lw%d=lw\n",farg);
      fprintf(f,"        lw=lw+1\n");
      sprintf(str,"stk(lw%d),",farg);
      strcat(call,str);
    }
    else {
      strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
      fprintf(f,"        lbuf%d=lbuf\n",farg);
      fprintf(f,"        lbuf=lbuf+%s\n",str1);
      sprintf(str,"buf(lbuf%d),",farg);
      strcat(call,str);
    }
    break;
  case LIST:
  case TLIST:
  case SEQUENCE:
  case ANY:
    printf("work or output FORTRAN argument cannot have\n");
    printf("  type \"ANY\", \"LIST\", \"TLIST\" or \"SEQUENCE\"\n");
    exit(1);
    break;
  }
}

void WriteCall(f,call)
FILE *f;
char *call;
{
  int i, line1;
  char str[65]; /* 72 - 6 - 2 + 1 */
  i = 0;
  line1 = 1;
  while (*call) {
    str[i++] = *call++;
    if (i == 64) {
      str[i] = '\0';
      i = 0;
      if (line1 == 1) {
	fprintf(f,"        %s\n",str);
	line1 = 0;
      }
      else fprintf(f,"     & %s\n",str);
    }
  }
  if (i != 0) {
    str[i] = '\0';
    if (line1 == 1) fprintf(f,"        %s\n",str);
    else fprintf(f,"     & %s\n",str);
  }
}

void WriteOutput(f)
FILE *f;
{
  IVAR iout,ivar;
  VARPTR var,vout;
  int i;

  fprintf(f,"        top=top-rhs\n");

  iout = GetExistOutVar();
  vout = variables[iout -1];

  fprintf(f,"        lw0=lw\n");
  fprintf(f,"        mv=lw0-l0\n");
  switch (vout->type) {
  case LIST:
    fprintf(f,"c       Creation of output list\n");
    fprintf(f,"        top=top+1\n");
    fprintf(f,"        il=iadr(lw)\n");
    fprintf(f,"        istk(il)=15\n");
    fprintf(f,"        istk(il+1)=%d\n",vout->length);
    fprintf(f,"        istk(il+2)=1\n");
    fprintf(f,"        lw=sadr(il+%d)\n",(vout->length)+3);
    fprintf(f,"        lwtop=lw\n");

    /* loop on output variables */
    for (i = 0; i < vout->length; i++) {
      ivar = vout->el[i];
      var = variables[ivar-1];
      fprintf(f,"c     \n");        
      fprintf(f,"c       Element : %s\n",var->name);
      WriteVariable(f,var,ivar);
      fprintf(f,"c     \n");        
      fprintf(f,"        istk(il+%d)=lw-lwtop+1\n",i+3);
    }
    fprintf(f,"c     \n");        
    fprintf(f,"        lstk(top+1)=lw-mv\n");
    fprintf(f,"c     \n");        
    fprintf(f,"c     Putting in order the stack\n");
    fprintf(f,"        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)\n");
    fprintf(f,"        return\n");
    break;
  case TLIST:/* CHECK TLIST */
    fprintf(f,"c       Creation of output tlist\n");
    fprintf(f,"        top=top+1\n");
    fprintf(f,"        il=iadr(lw)\n");
    fprintf(f,"        istk(il)=16\n");
    fprintf(f,"        istk(il+1)=%d\n",vout->length);
    fprintf(f,"        istk(il+2)=1\n");
    fprintf(f,"        lw=sadr(il+%d)\n",(vout->length)+3);
    fprintf(f,"        lwtop=lw\n");

    /* loop on output variables */
    for (i = 0; i < vout->length; i++) {
      ivar = vout->el[i];
      var = variables[ivar-1];
      fprintf(f,"c     \n");        
      fprintf(f,"c       Element : %s\n",var->name);
      WriteVariable(f,var,ivar);
      fprintf(f,"c     \n");        
      fprintf(f,"        istk(il+%d)=lw-lwtop+1\n",i+3);
    }
    fprintf(f,"c     \n");        
    fprintf(f,"        lstk(top+1)=lw-mv\n");
    fprintf(f,"c     \n");        
    fprintf(f,"c     Putting in order the stack\n");
    fprintf(f,"        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)\n");
    fprintf(f,"        return\n");
    break;
  case SEQUENCE:
    /* loop on output variables */
    for (i = 0; i < vout->length; i++) {
      ivar = vout->el[i];
      var = variables[ivar-1];
      fprintf(f,"c     \n");        
      fprintf(f,"        if(lhs .ge. %d) then\n",i+1);
      fprintf(f,"c     \n");        
      fprintf(f,"c       output variable: %s\n",var->name);
      fprintf(f,"c     \n");        
      fprintf(f,"        top=top+1\n");
      WriteVariable(f,var,ivar);
      fprintf(f,"        lstk(top+1)=lw-mv\n");
      fprintf(f,"        endif\n");
    }
    fprintf(f,"c     \n");        
    fprintf(f,"c       putting in order the stack\n");
    fprintf(f,"c     \n");        
    fprintf(f,"        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)\n");
    fprintf(f,"        return\n");
    break;
  case EMPTY:
    fprintf(f,"c       no output variable\n");
    fprintf(f,"        top=top+1\n");
    fprintf(f,"        il=iadr(l0)\n");
    fprintf(f,"        istk(il)=0\n");
    fprintf(f,"        lstk(top+1)=l0+1\n");
    fprintf(f,"        return\n");
    break;
  }
  fprintf(f,"      end\n");
  fprintf(f,"c\n"); 

}

void WriteVariableOutput(f,var,barg,farg,convert)
FILE *f;
VARPTR var;
int barg;
int farg;
int convert;
{
  char str[MAXNAM];
  char str1[MAXNAM];
  char str2[MAXNAM];
  fprintf(f,"        ilw=iadr(lw)\n");
  if (convert == 1) {
    /* tricky, isn'it ? */
    barg = 0;
  }
  if (barg == 0) sprintf(str,"lw%d",farg);
  else sprintf(str,"l%d",barg);
  switch (var->type) {
  case COLUMN:
    strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    fprintf(f,"        err=lw+4+%s-lstk(bot)\n",str1);
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    if (barg == 0) {
      fprintf(f,"        istk(ilw)=1\n");
      fprintf(f,"        istk(ilw+1)=%s\n",str1);		    
      fprintf(f,"        if (%s.eq.0) then\n",str1);
      fprintf(f,"          istk(ilw+2)=0\n");
      fprintf(f,"        else\n");
      fprintf(f,"          istk(ilw+2)=1\n");
      fprintf(f,"        endif\n");
      fprintf(f,"        istk(ilw+3)=0\n");
    } else {
      fprintf(f,"        call icopy(4,istk(il%d),1,istk(ilw),1)\n",barg);
      sprintf(str1,"n%d",barg);
    }
    fprintf(f,"        lw=sadr(ilw+4)\n");
     switch (var->for_type) {
    case INT:
      fprintf(f,"        call int2db(%s,stk(%s),1,stk(lw),1)\n",
	      str1,str);
      fprintf(f,"        lw=lw+%s\n",str1);
      break;
    case DOUBLE:
      fprintf(f,"        call dcopy(%s,stk(%s),1,stk(lw),1)\n",
	      str1,str);
      fprintf(f,"        lw=lw+%s\n",str1);
      break;
    case REAL:
      fprintf(f,"        call rea2db(%s,stk(%s),1,stk(lw),1)\n",
	      str1,str);
      fprintf(f,"        lw=lw+%s\n",str1);
      break;
    }
    break;
  case MATRIX:
    strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    strcpy(str2,Forname2Int(variables[var->el[1]-1]->for_name[0]));
    fprintf(f,"        err=lw+4+%s*%s-lstk(bot)\n",str1,str2);
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    if (barg == 0) {
      fprintf(f,"        istk(ilw)=1\n");
      fprintf(f,"        if (%s*%s.eq.0) then\n",str1,str2);
      fprintf(f,"          istk(ilw+1)=0\n");
      fprintf(f,"          istk(ilw+2)=0\n");
      fprintf(f,"        else\n");
      fprintf(f,"          istk(ilw+1)=%s\n",str1);
      fprintf(f,"          istk(ilw+2)=%s\n",str2);
      fprintf(f,"        endif\n");
      fprintf(f,"        istk(ilw+3)=0\n");
    } else {
      fprintf(f,"        call icopy(4,istk(il%d),1,istk(ilw),1)\n",barg);
      sprintf(str1,"n%d",barg);
      sprintf(str2,"m%d",barg);
    }
    fprintf(f,"        lw=sadr(ilw+4)\n");
    switch (var->for_type) {
    case INT:
      fprintf(f,"        call int2db(%s*%s,stk(%s),1,stk(lw),1)\n",
	      str1,str2,str);
      fprintf(f,"        lw=lw+%s*%s\n",str1,str2);
      break;
    case DOUBLE:
      fprintf(f,"        call dcopy(%s*%s,stk(%s),1,stk(lw),1)\n",
	      str1,str2,str);
      fprintf(f,"        lw=lw+%s*%s\n",str1,str2);	    
      break;
    case REAL:
      fprintf(f,"        call rea2db(%s*%s,stk(%s),1,stk(lw),1)\n",
	      str1,str2,str);
      fprintf(f,"        lw=lw+%s*%s\n",str1,str2);	  
      break;
    }  
    break;
  case ROW:
  case VECTOR:
    strcpy(str2,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    fprintf(f,"        err=lw+4+%s-lstk(bot)\n",str2);
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");	  
    if (barg == 0) {
      fprintf(f,"        istk(ilw)=1\n");
      fprintf(f,"        if (%s.eq.0) then\n",str2);
      fprintf(f,"          istk(ilw+1)=0\n");
      fprintf(f,"        else\n");
      fprintf(f,"          istk(ilw+1)=1\n");
      fprintf(f,"        endif\n");
      fprintf(f,"        istk(ilw+2)=%s\n",str2);
      fprintf(f,"        istk(ilw+3)=0\n");
    } else {
      fprintf(f,"        call icopy(4,istk(il%d),1,istk(ilw),1)\n",barg);
      sprintf(str2,"m%d",barg);
    }
    fprintf(f,"        lw=sadr(ilw+4)\n");
    switch (var->for_type) {
    case INT:
      fprintf(f,"        call int2db(%s,stk(%s),1,stk(lw),1)\n",
	      str2,str);
      fprintf(f,"        lw=lw+%s\n",str2);
      break;
    case DOUBLE:
      fprintf(f,"        call dcopy(%s,stk(%s),1,stk(lw),1)\n",
	      str2,str);
      fprintf(f,"        lw=lw+%s\n",str2);
      break;
    case REAL:
      fprintf(f,"        call rea2db(%s,stk(%s),1,stk(lw),1)\n",
	      str2,str);
      fprintf(f,"        lw=lw+%s\n",str2);
      break;
    }  
    break;
  case SCALAR:
    fprintf(f,"        err=lw+5-lstk(bot)\n");
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");  
    if (barg == 0) {
      fprintf(f,"        istk(ilw)=1\n");
      fprintf(f,"        istk(ilw+1)=1\n");
      fprintf(f,"        istk(ilw+2)=1\n");
      fprintf(f,"        istk(ilw+3)=0\n");
    } else {
      fprintf(f,"        call icopy(4,istk(il%d),1,istk(ilw),1)\n",barg);
    }
    fprintf(f,"        lw=sadr(ilw+4)\n");
    switch (var->for_type) {
    case INT:
      fprintf(f,"        call int2db(1,stk(%s),1,stk(lw),1)\n",str);
      fprintf(f,"        lw=lw+1\n");
      break;
    case DOUBLE:
      fprintf(f,"        call dcopy(1,stk(%s),1,stk(lw),1)\n",str);
      fprintf(f,"        lw=lw+1\n");
      break;
    case REAL:
      fprintf(f,"        call rea2db(1,stk(%s),1,stk(lw),1)\n",str);
      fprintf(f,"        lw=lw+1\n");
      break;
    }
    break;
  case POLYNOM:
    strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    strcpy(str2,variables[var->el[1]-1]->name);
    fprintf(f,"        err=sadr(ilw+10)+%s-lstk(bot)\n",str1);
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");	  
    if (barg == 0) {
      fprintf(f,"        istk(ilw)=2\n");
      fprintf(f,"        istk(ilw+1)=1\n");		    
      fprintf(f,"        istk(ilw+2)=1\n");
      fprintf(f,"        istk(ilw+3)=0\n");
      fprintf(f,"        call cvstr(4,'%s    ',istk(ilw+4),0)\n",str2);
      /* str2 comes from SCILAB input ??? */
      fprintf(f,"        istk(ilw+8)=1\n");
      fprintf(f,"        istk(ilw+9)=1+%s\n",str1);
    } else {
      fprintf(f,"        call icopy(10,istk(il%d),1,istk(ilw),1)\n",barg);
      sprintf(str1,"n%d",barg); 
    }
    fprintf(f,"        lw=sadr(ilw+10)\n");
    switch (var->for_type) {
    case INT:
      fprintf(f,"        call int2db(%s,stk(%s),1,stk(lw),1)\n",
	      str1,str);
      fprintf(f,"        lw=lw+%s\n",str1);
      break;
    case DOUBLE:
      fprintf(f,"        call dcopy(%s,stk(%s),1,stk(lw),1)\n",
	      str1,str);
      fprintf(f,"        lw=lw+%s\n",str1);
      break;
    case REAL:
      fprintf(f,"        call rea2db(%s,stk(%s),1,stk(lw),1)\n",
	      str1,str);
      fprintf(f,"        lw=lw+%s\n",str1);
      break;
    }
    break;
  case STRING:
    strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    fprintf(f,"        err=sadr(ilw+5+%s)-lstk(bot)\n",str1);
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");	  
    if (barg == 0) {
      fprintf(f,"        istk(ilw)=1\n");
      fprintf(f,"        istk(ilw+1)=1\n");		    
      fprintf(f,"        istk(ilw+2)=1\n");
      fprintf(f,"        istk(ilw+3)=0\n");
      fprintf(f,"        istk(ilw+4)=1\n");
      fprintf(f,"        istk(ilw+5)=1+%s\n",str1);
    } else {
      fprintf(f,"        call icopy(6,istk(il%d),1,istk(ilw),1)\n",barg);
      sprintf(str1,"n%d",barg);
    }
    fprintf(f,"        lw=ilw+6\n");
    fprintf(f,"        call cvstr(%s,istk(lw),buf(lbuf%d:lbuf%d+%s),0)\n",
	    str1,farg,farg,str1);
    fprintf(f,"        lw=lw+sadr(ilw+%s)\n",str1);
    break;
  case STRINGMAT:
    strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    strcpy(str2,Forname2Int(variables[var->el[1]-1]->for_name[0]));
    sprintf(str,"lw%d",farg);
    fprintf(f,"        call cstringf(stk(%s),istk(ilw),%s,%s,\n",
	    str,str1,str2);
    fprintf(f,"     &    lstk(bot)-sadr(ilw),ierr)\n");
    fprintf(f,"        if (ierr .gt. 0) then\n");
    fprintf(f,"          buf='not enough memory'\n");
    fprintf(f,"          call error(1000)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    sprintf(str,"istk(ilw+4+%s*%s)-1",str1,str2);
    fprintf(f,"        lw=sadr(ilw+5+%s*%s+%s)\n",str1,str2,str);
    break;
  case WORK:
  case LIST:
  case TLIST:
  case SEQUENCE:
  case ANY:
    printf("output variable \"%s\" cannot have type\n",
	   var->name);
    printf("  \"WORK\", \"LIST\", \"TLIST\", \"SEQUENCE\" or \"ANY\"\n");
    exit(1);
    break;
  }
}

void WriteExternalVariableOutput(f,var,farg)
FILE *f;
VARPTR var;
int farg;
{
  char str[MAXNAM];
  char str1[MAXNAM];
  char str2[MAXNAM];
  fprintf(f,"        ilw=iadr(lw)\n");
  switch (var->type) {
  case COLUMN:
    strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    fprintf(f,"        err=lw+4+%s-lstk(bot)\n",str1);
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        istk(ilw)=1\n");
    fprintf(f,"        istk(ilw+1)=%s\n",str1);		    
    fprintf(f,"        if (%s.eq.0) then\n",str1);
    fprintf(f,"          istk(ilw+2)=0\n");
    fprintf(f,"        else\n");
    fprintf(f,"          istk(ilw+2)=1\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        istk(ilw+3)=0\n");
    sprintf(str,"lw%d",farg);
    fprintf(f,"        lw=sadr(ilw+4)\n");
    fprintf(f,"        call %s(%s,stk(%s),stk(lw))\n",
	    var->fexternal,str1,str);
    fprintf(f,"        lw=lw+%s\n",str1);
    break;
  case MATRIX:
    strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    strcpy(str2,Forname2Int(variables[var->el[1]-1]->for_name[0]));
    fprintf(f,"        err=lw+4+%s*%s-lstk(bot)\n", str1,str2);
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        istk(ilw)=1\n");
    fprintf(f,"        if (%s*%s.eq.0) then\n",str1,str2);
    fprintf(f,"          istk(ilw+1)=0\n");
    fprintf(f,"          istk(ilw+2)=0\n");
    fprintf(f,"        else\n");
    fprintf(f,"          istk(ilw+1)=%s\n",str1);
    fprintf(f,"          istk(ilw+2)=%s\n",str2);
    fprintf(f,"        endif\n");
    fprintf(f,"        istk(ilw+3)=0\n");
    sprintf(str,"lw%d",farg);
    fprintf(f,"        lw=sadr(ilw+4)\n");
    fprintf(f,"        call %s(%s*%s,stk(%s),stk(lw))\n",
	    var->fexternal,str1,str2,str);
    fprintf(f,"        lw=lw+%s*%s\n",str1,str2);
    break;
  case ROW:
  case VECTOR:
    strcpy(str2,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    fprintf(f,"        err=lw+4+%s-lstk(bot)\n",str2);
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        istk(ilw)=1\n");
    fprintf(f,"        if (%s.eq.0) then\n",str2);
    fprintf(f,"          istk(ilw+1)=0\n");
    fprintf(f,"        else\n");
    fprintf(f,"          istk(ilw+1)=1\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        istk(ilw+2)=%s\n",str2);
    fprintf(f,"        istk(ilw+3)=0\n");
    sprintf(str,"lw%d",farg);
    fprintf(f,"        lw=sadr(ilw+4)\n");
    fprintf(f,"        call %s(%s,stk(%s),stk(lw))\n",
	    var->fexternal,str2,str);
    fprintf(f,"        lw=lw+%s\n",str2);
    break;
  case SCALAR:
    fprintf(f,"        err=lw+5-lstk(bot)\n");
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        istk(ilw)=1\n");
    fprintf(f,"        istk(ilw+1)=1\n");
    fprintf(f,"        istk(ilw+2)=1\n");
    fprintf(f,"        istk(ilw+3)=0\n");
    sprintf(str,"lw%d",farg);	    
    fprintf(f,"        lw=sadr(ilw+4)\n");
    fprintf(f,"        call %s(1,stk(%s),stk(lw))\n",
	    var->fexternal,str);
    fprintf(f,"        lw=lw+1\n");
    break;
  case POLYNOM:
    strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    strcpy(str2,variables[var->el[1]-1]->name);
    fprintf(f,"        err=sadr(ilw+10)+%s-lstk(bot)\n",str1);
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        istk(ilw)=1\n");
    fprintf(f,"        istk(ilw+1)=1\n");		    
    fprintf(f,"        istk(ilw+2)=1\n");
    fprintf(f,"        istk(ilw+3)=0\n");
    fprintf(f,"        call cvstr(4,'%s    ',istk(ilw+4),0)\n",str2);
    /* str2 comes from SCILAB input ??? */
    fprintf(f,"        istk(ilw+8)=1\n");
    fprintf(f,"        istk(ilw+9)=1+%s\n",str1);
    sprintf(str,"lw%d",farg);
    fprintf(f,"        lw=sadr(ilw+10)\n");
    fprintf(f,"        call %s(%s,stk(%s),stk(lw))\n",
	    var->fexternal,str1,str);
    fprintf(f,"        lw=lw+%s\n",str1);
    break;
  case STRING:
    strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    fprintf(f,"        err=sadr(ilw+6+%s)-lstk(bot)\n",str1);
    fprintf(f,"        if (err .gt. 0) then\n");
    fprintf(f,"          call error(17)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    fprintf(f,"        istk(ilw)=10\n");
    fprintf(f,"        istk(ilw+1)=1\n");		    
    fprintf(f,"        istk(ilw+2)=1\n");
    fprintf(f,"        istk(ilw+3)=0\n");
    fprintf(f,"        istk(ilw+4)=1\n");
    fprintf(f,"        istk(ilw+5)=%s+1\n",str1);
    sprintf(str,"lw%d",farg);	
    fprintf(f,"        call %s(%s,stk(%s),istk(ilw+6))\n",
	    var->fexternal,str1,str);
    fprintf(f,"        lw=sadr(ilw+6+%s)\n",str1);
    break;
  case STRINGMAT:
    strcpy(str1,Forname2Int(variables[var->el[0]-1]->for_name[0]));
    strcpy(str2,Forname2Int(variables[var->el[1]-1]->for_name[0]));
    sprintf(str,"lw%d",farg);
    fprintf(f,"        call %s(stk(%s),istk(ilw),%s,%s,\n",
	    var->fexternal,str,str1,str2);
    fprintf(f,"     &    lstk(bot)-sadr(ilw),ierr)\n");
    fprintf(f,"        if (ierr .gt. 0) then\n");
    fprintf(f,"          buf='not enough memory'\n");
    fprintf(f,"          call error(1000)\n");
    fprintf(f,"          return\n");
    fprintf(f,"        endif\n");
    sprintf(str,"istk(ilw+4+%s*%s)-1",str1,str2);
    fprintf(f,"        lw=sadr(ilw+5+%s*%s+%s)\n",str1,str2,str);
    break;
  }
}

void ReadListFile(listname,varlistname,ivar)
char *listname;
char *varlistname;
IVAR ivar;
{
  FILE *fin;
  char filin[MAXNAM];
  int nel;
  
  sprintf(filin,"%s.list",listname);
  fin = fopen(filin,"r");
  if (fin == 0) {
    printf("description file for list or tlist \"%s\" does not exist\n",
	   filin);
    exit(1);
  }
  printf("reading description file for list or tlist \"%s\"\n",
	 listname);

  nel = 0;
  while(ReadListElement(fin,varlistname,ivar,nel)) {
    nel++;
  }

  fclose(fin);
}

int ReadListElement(f,varlistname,iivar,nel)
FILE *f;
char *varlistname;
int nel;
IVAR iivar;
{
  char s[MAXLINE];
  char *words[MAXLINE];
  int i, nline, nwords, type;
  IVAR ivar;
  char str[MAXNAM];
  
  nline = 0;
  while (fgets(s,MAXLINE,f) != NULL) {
    /* analyse of one line */
    nline++;
    switch (nline) {
    case 1:
      break;
    case 2:
      /* SCILAB variable description */
      nwords = ParseLine(s,words);
      sprintf(str,"%s(%s)",words[0],varlistname);
      ivar = GetVar(str,0);
      i = ivar - 1;
      if (nwords == 1) {
	printf("type missing for variable \"%s\"\n",words[0]);
	exit(1);
      }
      type = GetBasType(words[1]);
      variables[i]->type = type;
      variables[i]->list_name = (char *)malloc((unsigned)(strlen(varlistname)+1));
      strcpy(variables[i]->list_name,varlistname);
      variables[i]->list_el = nel+1;
      sprintf(str,"stk(l%de%d)",iivar+1,nel+1);
      AddForName(ivar,str);     
      switch (type) {
      case SCALAR:
      case ANY:
	break;
      case COLUMN:
      case ROW:
      case STRING:
      case VECTOR:
	if (nwords != 3) {
	  printf("bad type for variable \"%s\"\n",
		 words[0]);
	  exit(1);
	}
	if (isdigit(words[2][0]))
	  variables[i]->el[0] = GetVar(words[2],0);
	else {
	  sprintf(str,"%s(%s)",words[2],varlistname);
	  variables[i]->el[0] = GetVar(str,0);
	}
	break;
      case POLYNOM:
      case MATRIX:
      case STRINGMAT:
	if (nwords != 4) {
	  printf("bad type for variable \"%s\"\n",
		 words[0]);
	  exit(1);
	}	  
	if (isdigit(words[2][0]))
	  variables[i]->el[0] = GetVar(words[2],0);
	else {
	  sprintf(str,"%s(%s)",words[2],varlistname);	
	  variables[i]->el[0] = GetVar(str,0);
	}
	if (isdigit(words[3][0]))
	  variables[i]->el[1] = GetVar(words[3],0);
	else {
	  sprintf(str,"%s(%s)",words[3],varlistname);	
	  variables[i]->el[1] = GetVar(str,0);
	}
	break;
      case WORK:
	printf("variable \"%s\" cannot have type \"WORK\"\n",
	       words[0]);
	exit(1);
      case SEQUENCE:
	printf("variable \"%s\" cannot have type \"SEQUENCE\"\n",
	       words[0]);
	exit(1);
      case EMPTY:
	printf("variable \"%s\" cannot have type \"EMPTY\"\n",
		 words[0]);
	exit(1);
      case LIST:
	printf("variable \"%s\" cannot have type \"LIST\"\n",
	       words[0]);
	exit(1);
      case TLIST:
	printf("variable \"%s\" cannot have type \"TLIST\"\n",
	       words[0]);
	exit(1);
      }
      break;
    default:
      /* end of description */
      if (s[0] == '*') return(1);
      else {
	printf("bad description file for list or tlist \"%s\"\n",
	       varlistname);
	exit(1);
      }
      break;
    }
  }
  return(0);
}

void WriteListAnalysis(f,i)
/* is nearly a copy of WriteArgCheck */
FILE *f;
int i;
{
  int k,i1,iel,type;
  char str1[MAXNAM],str[MAXNAM];
  VARPTR var;

  i1=i+1;

  fprintf(f,"        n%d=istk(il%d+1)\n",i1,i1);
  fprintf(f,"        l%d=sadr(il%d+n%d+3)\n",i1,i1,i1);

  for (k = 0; k < nVariable ; k++) 
    {
      var = variables[k];
      if ((var->list_el != 0) &&
	  (strcmp(var->list_name,variables[i]->name) == 0) &&
	  var->present)
	{
	  iel=var->list_el;
	  fprintf(f,"c      \n");
	  fprintf(f,"c       --   subvariable %s --\n",var->name);
	  sprintf(str1,"%de%d",i1,iel);
	  fprintf(f,"        il%s=iadr(l%d+istk(il%d+%d)-1)\n",
		  str1,i1,i1,iel+1);
	
	  if (TESTLISTELEMENTS && (var->type != ANY)) {
	    type = TypeToBas(var->type);
	    fprintf(f,"        if (istk(il%s) .ne. %d) then\n",str1,type);
	    fprintf(f,"          err = %d\n",i1);
	    switch(type) {
	    case 1:
	      fprintf(f,"          call error(53)\n");
	      break;
	    case 2:
	      fprintf(f,"          call error(54)\n");
	      break;
	    case 10:
	      fprintf(f,"          call error(55)\n");
	      break;
	    case 15:
	      fprintf(f,"          call error(56)\n");
	      break;
	    }
	    fprintf(f,"          return\n");
	    fprintf(f,"        endif\n");
	  }
	  switch (var->type) {
	  case COLUMN :
	    if(TESTLISTELEMENTS) {
	      fprintf(f,"        if (istk(il%s+2) .ne. 1) then\n",str1);
	      fprintf(f,"          err = %d\n",i1);
	      fprintf(f,"          call error(89)\n");
	      fprintf(f,"          return\n");
	      fprintf(f,"        endif\n");
	    }
	    fprintf(f,"        n%s = istk(il%s+1)\n",str1,str1);
	    fprintf(f,"        l%s = sadr(il%s+4)\n",str1,str1);
	    sprintf(str,"n%s",str1);
	    AddForName(var->el[0],str);
	    break;
	  case MATRIX:
	    if(TESTLISTELEMENTS) {
	      /* square matrix */
	      if (var->el[0] == var->el[1]) {
		fprintf(f,"        if (istk(il%s+1) .ne. istk(il%s+2)) then\n",
			str1,str1);
		fprintf(f,"          err = %d\n",i1);
		fprintf(f,"          call error(20)\n");
		fprintf(f,"          return\n");
		fprintf(f,"        endif\n");
	      }
	    }
	    fprintf(f,"        n%s = istk(il%s+1)\n",str1,str1);
	    fprintf(f,"        m%s = istk(il%s+2)\n",str1,str1);
	    sprintf(str,"n%s",str1);
	    AddForName(var->el[0],str);
	    sprintf(str,"m%s",str1);
	    AddForName(var->el[1],str);
	    fprintf(f,"        l%s = sadr(il%s+4)\n",str1,str1);
	    break;
	  case STRINGMAT:
	    if(TESTLISTELEMENTS) {
	      /* square matrix */
	      if (var->el[0] == var->el[1]) {
		fprintf(f,"        if (istk(il%s+1) .ne. istk(il%s+2)) then\n",
			str1,str1);
		fprintf(f,"          err = %d\n",i1);
		fprintf(f,"          call error(20)\n");
		fprintf(f,"          return\n");
		fprintf(f,"        endif\n");
	      }
	    }
	    fprintf(f,"        n%s = istk(il%s+1)\n",str1,str1);
	    fprintf(f,"        m%s = istk(il%s+2)\n",str1,str1);
	    sprintf(str,"n%s",str1);
	    AddForName(var->el[0],str);
	    sprintf(str,"m%s",str1);
	    AddForName(var->el[1],str);
	    fprintf(f,"        l%s = il%s\n",str1,str1);
	    break;
	  case ROW:
	    if(TESTLISTELEMENTS) {
	      fprintf(f,"        if (istk(il%s+1) .ne. 1) then\n",str1);
	      fprintf(f,"          err = %d\n",i1);
	      fprintf(f,"          call error(89)\n");
	      fprintf(f,"          return\n");
	      fprintf(f,"        endif\n");
	    }
	    fprintf(f,"        m%s = istk(il%s+2)\n",str1,str1);
	    sprintf(str,"m%s",str1);
	    AddForName(var->el[0],str);
	    fprintf(f,"        l%s = sadr(il%s+4)\n",str1,str1);
	    break;
	  case VECTOR:
	    fprintf(f,"        m%s =istk(il%s+1)*istk(il%s+2)\n",str1,str1,str1);
	    sprintf(str,"m%s",str1);
	    AddForName(var->el[0],str);
	    fprintf(f,"        l%s = sadr(il%s+4)\n",str1,str1);
	    break;
	    
	  case POLYNOM:
	    if(TESTLISTELEMENTS) {
	      fprintf(f,"        if (istk(il%s+1)*istk(il%s+2) .ne. 1) then\n",
		      str1,str1);
	      fprintf(f,"          err = %d\n",i1);
	      fprintf(f,"          call error(89)\n");
	      fprintf(f,"          return\n");
	      fprintf(f,"        endif\n");
	    }
	    fprintf(f,"        n%s = istk(il%s+9)-2\n",str1,str1);
	    sprintf(str,"n%s",str1);
	    strcpy(str1,variables[var->el[0]-1]->name);
	    AddForName(var->el[0],str);
	    fprintf(f,"        l%s = sadr(il%s+10)\n",str1,str1);
	    break;
	  case SCALAR:
	    if(TESTLISTELEMENTS) {
	      fprintf(f,"        if (istk(il%s+1)*istk(il%s+2) .ne. 1) then\n",
		      str1,str1);
	      fprintf(f,"          err = %d\n",i1);
	      fprintf(f,"          call error(89)\n");
	      fprintf(f,"          return\n");
	      fprintf(f,"        endif\n");
	    }
	    fprintf(f,"        l%s = sadr(il%s+4)\n",str1,str1);
	    break;
	  case STRING:
	    if(TESTLISTELEMENTS) {
	      fprintf(f,"        if (istk(il%s+1)*istk(il%s+2) .ne. 1) then\n",
		      str1,str1);
	      fprintf(f,"          err = %d\n",i1);
	      fprintf(f,"          call error(89)\n");
	      fprintf(f,"          return\n");
	      fprintf(f,"        endif\n");
	    }
	    fprintf(f,"        n%s = istk(il%s+5)-1\n",str1,str1);
	    sprintf(str,"n%s",str1);
	    AddForName(var->el[0],str);
	    fprintf(f,"        l%s = il%s+6\n",str1,str1);
	    break;
	  case ANY:
	    break;
	  }
	}
    }
}

void WriteVariable(f,var,ivar)
FILE *f;
VARPTR var;
IVAR ivar;
{
  IVAR ivar2, barg, farg;
  VARPTR var2;
  int j;

  /* get number of variable in SCILAB calling list */
  barg = 0;
  for (j = 0; j < basfun->nin; j++) {
    if (ivar == basfun->in[j]) {
      barg = j + 1;
      break;
    }
  }
  /* get number of variable in FORTRAN calling list */
  farg = 0;
  for (j = 0; j < forsub->narg; j++) {
    if (ivar == forsub->arg[j]) {
      farg = j + 1;
      break;
    }
  }
  if (var->for_type == EXTERNAL) {
    /* external type */
    if (barg != 0) {
      printf("output variable with external type \"%s\" \n",
	     var->name);
      printf("  cannot be an input argument of SCILAB function\n");
      exit(1);
    }
    if (var->equal != 0) {
      printf("output variable with external type \"%s\"\n",
	     var->name);
      printf("  cannot have a convertion\n");
      exit(1);
    }
    if (farg == 0) {
      printf("output variable with external type \"%s\" must be\n",
	     var->name);
      printf("  an argument of FORTRAN subroutine");
      exit(1);
    }
    WriteExternalVariableOutput(f,var,farg);
  }
  else {
    if (var->equal != 0) {
      /* SCILAB type convertion */
      if (barg !=0 || farg!= 0) {
	printf("output variable with convertion \"%s\" must not be\n",var->name);
	printf("  an input variable of SCILAB function or an argument\n");
	printf("  of FORTRAN subroutine\n");
	exit(1);
      }
      ivar2 = var->equal;
      var2 = variables[ivar-1];
      /* get number of equal variable in SCILAB calling list */
      barg = 0;
      for (j = 0; j < basfun->nin; j++) {
	if (ivar2 == basfun->in[j]) {
	  barg = j + 1;
	  break;
	}
      }
      if (barg == 0) {
	printf("output variable with convertion \"%s\" must be\n",
	       var->name);
	printf("  an input variable of SCILAB function\n");
	exit(1);
      }
      /* get number of equal variable in FORTRAN calling list */
      farg = 0;
      for (j = 0; j < forsub->narg; j++) {
	if (ivar2 == forsub->arg[j]) {
	  farg = j + 1;
	  break;
	}
      }
      if (farg == 0) {
	printf("output variable with convertion \"%s\" must be\n",
	       var->name);
	printf("  an argument FORTRAN subroutine");
	exit(1);
      }
      var->for_type = var2->for_type;
      WriteVariableOutput(f,var,barg,farg,1);
    }
    else {
      /* no SCILAB type convertion */
      if (farg == 0) {
	printf("variable without convertion \"%s\" must be an argument\n",
	       var->name);
	printf("  of FORTRAN subroutine\n");
	exit(1);
      }
      WriteVariableOutput(f,var,barg,farg,0);
    }
  }
}

char *Forname2Int(str)
char *str;
{
  int l;
  char *p;
  if (strncmp(str,"stk",3) == 0) {
    l = strlen(str);
    p = (char *)malloc((unsigned)(l + 6));
    sprintf(p,"int(%s)",str);
    return p;
  }
  else return str;
}

void OptVar(f,var,i)
FILE *f;
VARPTR var;
int i;
{
  switch (maxOpt) {
  case 1:
    if (i != basfun->nin) {
      printf("Optional arguments must be at the end of the calling sequence\n");
      exit(1);
    }
    fprintf(f,"        if (rhs .eq. %d) then\n",basfun->nin - 1);
    switch (var->opt_type) {
    case NAME:
      fprintf(f,"          call cvname(id,'%s       ',0)\n",var->opt_name);
      fprintf(f,"          call stackg(id)\n");
      fprintf(f,"          if (err .gt. 0) return\n");
      fprintf(f,"          rhs = rhs + 1\n");
      fprintf(f,"          lw = lstk(top + 1)\n");
      break;
    case VALUE:
      fprintf(f,"          il%d = iadr(lstk(top + 1))\n",i);
      fprintf(f,"          top = top + 1\n");
      fprintf(f,"          rhs = rhs + 1\n");
      switch (var->type) {
      case SCALAR:
	fprintf(f,"          err = lstk(top) + 5 - lstk(bot)\n");
	fprintf(f,"          if (err .gt. 0) then\n");
	fprintf(f,"            call error(17)\n");
	fprintf(f,"            return\n");
	fprintf(f,"          endif\n");
	fprintf(f,"          istk(il%d) = 1\n",i);
	fprintf(f,"          istk(il%d + 1) = 1\n",i);
	fprintf(f,"          istk(il%d + 2) = 1\n",i);
	fprintf(f,"          istk(il%d + 3) = 0\n",i);
	fprintf(f,"          stk(sadr(il%d + 4)) = %s\n",i,var->opt_name);
	fprintf(f,"          lstk(top + 1) = sadr(il%d + 4) + 1\n",i);
	fprintf(f,"          lw = lstk(top + 1)\n");
	break;
      case STRING:
	fprintf(f,"          err = sadr(il%d + %d) - lstk(bot)\n",
		i,strlen(var->opt_name)+6);
	fprintf(f,"          if (err .gt. 0) then\n");
	fprintf(f,"            call error(17)\n");
	fprintf(f,"            return\n");
	fprintf(f,"          endif\n");
	fprintf(f,"          istk(il%d) = 10\n",i);
	fprintf(f,"          istk(il%d + 1) = 1\n",i);
	fprintf(f,"          istk(il%d + 2) = 1\n",i);
	fprintf(f,"          istk(il%d + 3) = 0\n",i);
	fprintf(f,"          istk(il%d + 4) = 1\n",i);
	fprintf(f,"          istk(il%d + 5) = %d\n",i,strlen(var->opt_name)+1);
	fprintf(f,"          call cvstr(%d,'%s',istk(il%d+6),0)\n",
		strlen(var->opt_name),var->opt_name,i);
	fprintf(f,"          lstk(top + 1) = sadr(il%d + %d) + 1\n",i,
		strlen(var->opt_name)+6);
	fprintf(f,"          lw = lstk(top + 1)\n");
	break;
      default:
	printf("Optional variable with value must be \"SCALAR\" or \"STRING\"\n");
	exit(1);
	break;
      }
      break;
    }
    fprintf(f,"        endif\n");
    break;
  case 2:
    printf("2 optional variables not yet implemented\n");
    exit(1);
    break;
  }
}

void GenFundef(file,interf)
char *file;
int interf;
{
  FILE *fout;
  char filout[MAXNAM];
  int i,j;

  strcpy(filout,file);
  strcat(filout,".fundef");
  fout = fopen(filout,"w");
  for (i = 0; i < nFun; i++) {
    fprintf(fout,"%s",funNames[i]);
    for (j = 0; j < 25 - (int)strlen(funNames[i]); j++) fprintf(fout," ");
    fprintf(fout,"%.2d%.2d   3\n",interf,i+1);
  }
  printf("\nfile \"%s\" has been created\n",filout);
  fclose(fout);
}
