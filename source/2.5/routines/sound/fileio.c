/*********************************************************************
 * This Software is ( Copyright ENPC 1998 )                          *
 * Jean-Philippe Chancelier Enpc/Cergrene                            *
 * See also the copyright below for do_printf                        *
 * interface and implementation of xxprintf and xxscanf functions    *
 * for scilab                                                        *
 
 *********************************************************************/

#include <math.h>
#include <stdio.h>
#ifdef __STDC__
#include <stdlib.h>
#else 
#include <malloc.h>
#endif

#if defined(SYSV) || defined(WIN32)
#include <string.h>
#else
#include <strings.h>
#endif

#include <ctype.h>  /* isdigit */
#include "../graphics/Math.h"
#include "../stack-c.h"
#include "../sun/Sun.h"

extern char * SciGetLine _PARAMS((char *));
extern FILE *GetFile _PARAMS((int *));
extern void C2F(zzledt1) _PARAMS((char *buffer, int *buf_size, int *len_line, int *eof, long int dummy1)); 
extern int C2F(xscion) _PARAMS((int *));
extern int sciprint2 _PARAMS((int i,char *fmt, ...));
static int do_printf _PARAMS((char *fname,FILE * fp, char *format,int n_args,
			      int arg_cnt,char **strv));
static int do_scanf _PARAMS((char *fname,FILE *fp, char *format,int *nargs, 
			     char *strv,int *retval));

#define RET_BUG -1 
#define FAIL 0
#define OK 1

static char * GetString _PARAMS((char *fname,int first,int arg) );
static int GetScalarInt _PARAMS((char *fname,int first,int arg,int *ival));
static int GetScalarDouble  _PARAMS((char *fname,int first,int arg,double *dval));
static void StringConvert _PARAMS((char *str));
static int ReadLine _PARAMS((FILE *fd));
int NumTokens _PARAMS((char *str));

/*********************************************************************
 * Scilab printf function OK 
 *********************************************************************/

int int_objprintf(fname)
     char *fname;
{
  static int l1, m1, n1;
  Nbvars = 0;
  CheckRhs(1,1000);
  CheckLhs(0,1);
  if ( Rhs < 1 ) 
    { 
      sciprint("Error:\tRhs must be > 0\r\n");
      Error(999);
      return 0;
    }
  GetRhsVar(1,"c",&m1,&n1,&l1);
  if ( do_printf("printf",stdout,cstk(l1),Rhs,1,(char **)0) < 0) 
    {
      sciprint("Error in printf\r\n");
      Error(999);
      return 0;
    }
  LhsVar(1)=0; /** No return value **/
  PutLhsVar();
  return 0;
}  

/*********************************************************************
 * Scilab fprintf function OK 
 *********************************************************************/

int int_objfprintf(fname)
     char *fname;
{
  FILE *f;
  static int l1, m1, n1,l2,m2,n2;
  Nbvars = 0;
  CheckRhs(1,1000);
  CheckLhs(0,1);
  if ( Rhs < 2 ) 
    { 
      sciprint("Error:\tRhs must be >= 2\r\n");
      Error(999);
      return 0;
    }
  GetRhsVar(1,"i",&m1,&n1,&l1); /* file id */
  GetRhsVar(2,"c",&m2,&n2,&l2); /* format */
  if ((f= GetFile(istk(l1))) == (FILE *)0)
    {
      sciprint("fprintf:\t wrong file descriptor %d\r\n",*istk(l1));
      Error(999);
      return 0;
    }
  if ( do_printf("fprintf",f,cstk(l2),Rhs-1,2,(char **)0) < 0) 
    {
      sciprint("Error in fprintf\r\n");
      Error(999);
      return 0;
    }
  LhsVar(1)=0; /** No return value **/
  PutLhsVar();
  return 0;
}  

/*********************************************************************
 * Scilab sprintf function OK 
 *********************************************************************/

int int_objsprintf(fname)
     char *fname;
{
  unsigned long lstr;
  static int l1, m1, n1,m2,n2;
  Nbvars = 0;
  CheckRhs(1,1000);
  CheckLhs(0,1);
  if ( Rhs < 1 ) 
    { 
      sciprint("Error:\tRhs must be > 0\r\n");
      Error(999);
      return 0;
    }
  GetRhsVar(1,"c",&m1,&n1,&l1);
  if ( do_printf("sprintf",(FILE *) 0,cstk(l1),Rhs,1,(char **) &lstr) < 0) 
    {
      sciprint("Error in sprintf\r\n");
      Error(999);
      return 0;
    }
  /** Create a Scilab String : str must not be freed **/
  m2=strlen((char *) lstr);
  n2=1;
  CreateVarFromPtr( 2, "c", &m2, &n2, &lstr);
  LhsVar(1)=2;
  PutLhsVar();    
  return 0;
}  

/*********************************************************************
 * Scilab scanf function
 *********************************************************************/
#define MAXSTR 512

int int_objscanf(fname)
     char *fname;
{
  static char String[MAXSTR];
  static int l1, m1, n1, len= MAXSTR-1,m2,n2,l2,zero=0;
  int args,i,retval,lline,status,iflag;
  Nbvars = 0;
  CheckRhs(1,1);
  GetRhsVar(1,"c",&m1,&n1,&l1); /** format **/
  StringConvert(cstk(l1));  /* conversion */
  /** Read a line with Scilab read function **/
  C2F(xscion)(&iflag);
  if ( iflag == 0) 
    C2F(zzledt)(String,&len,&lline,&status,strlen(String));
  else
    C2F(zzledt1)(String,&len,&lline,&status,strlen(String));
  if(status != 0) 
    {
      sciprint("Error: in scanf\r\n");
      Error(999);
      return 0;
    }
  if (lline == 0) {String[0] = ' ';lline=1;}
  /** use the scaned line as input **/
  args = Rhs; /* args set to Rhs on entry */
  if ( do_scanf("scanf",(FILE *) 0,cstk(l1),&args,String,&retval) < 0 ) 
    {
      sciprint("Error: in scanf\r\n");
      Error(999);
      return 0;
    }
  if (Lhs == 1) {
    i = Rhs+1;
    if (retval!=-1) 
      C2F(mklistfromvars)(&i,&retval);
    else {
      m2=n2=1;
      CreateVar(Rhs+1, "d", &m2, &n2, &l2);
      *stk(l2) = (double) retval;
    }
    LhsVar(1)=Rhs+1;
  }
  else {
    m2=n2=1;
    CreateVar(Rhs+args+1, "d", &m2, &n2, &l2);
    *stk(l2) = (double) retval;
    /** we must complete the returned arguments up to Lhs **/
    for ( i = args+2; i <= Lhs ; i++) 
      {
	CreateVar(Rhs+i,"d",&zero,&zero,&l2);
	LhsVar(i) = Rhs+i;
      }
    LhsVar(1)=Rhs+args+1;
  }
  PutLhsVar();
  return 0;
} 

/*********************************************************************
 * Scilab sscanf function
 *********************************************************************/

int int_objsscanf(fname)
     char *fname;
{
  static int l1, m1, n1,l2,m2,n2,un=1,i,zero=0;
  int args,retval;
  Nbvars = 0;
  CheckRhs(2,2);
  GetRhsVar(1,"c",&m1,&n1,&l1); /* String */
  GetRhsVar(2,"c",&m2,&n2,&l2); /* Format */
  StringConvert(cstk(l1));  /* conversion */
  StringConvert(cstk(l2));  /* conversion */
  args = Rhs; /* args set to Rhs on entry */
  if ( do_scanf("sscanf",(FILE *)0,cstk(l2),&args,cstk(l1),&retval) < 0 ) 
    {
      sciprint("Error: in sscanf\r\n");
      Error(999);
      return 0;
    }
  if (Lhs == 1) {
    i = Rhs+1;
    if (retval!=-1) 
      C2F(mklistfromvars)(&i,&retval);
    else {
      CreateVar(Rhs+1, "d", &un, &un, &l2);
      *stk(l2) = (double) retval;
    }
    LhsVar(1)=Rhs+1;
  }
  else {
    CreateVar(Rhs+args+1, "d", &un, &un, &l2);
    *stk(l2) = (double) retval;
    /** we must complete the returned arguments up to Lhs **/
    for ( i = args+2; i <= Lhs ; i++) 
      {
	CreateVar(Rhs+i,"d",&zero,&zero,&l2);
	LhsVar(i) = Rhs+i;
      }
    LhsVar(1)=Rhs+args+1;
  }
  PutLhsVar();
  return 0;
}  

/*********************************************************************
 * Scilab fscanf function
 *********************************************************************/

int int_objfscanf(fname)
     char *fname;
{
  static int l1, m1, n1,l2,m2,n2,i,zero=0;
  FILE  *f;
  int args,retval;
  Nbvars = 0;
  CheckRhs(2,2);
  if ( Rhs < 2 ) 
    { 
      sciprint("Error:\tRhs must be >= 2\r\n");
      Error(999);
      return 0;
    }
  GetRhsVar(1,"i",&m1,&n1,&l1);
  GetRhsVar(2,"c",&m2,&n2,&l2);/* format */
  StringConvert(cstk(l2));  /* conversion */
  if ((f= GetFile(istk(l1))) == (FILE *)0)
    {
      sciprint("fprintf:\t wrong file descriptor %d\r\n",*istk(l1));
      Error(999);
      return 0;
    }
  args = Rhs; /* args set to Rhs on entry */
  if ( do_scanf("fscanf",f,cstk(l2),&args,(char *)0,&retval) < 0 ) 
    {
      sciprint("Error: in fscanf\r\n");
      Error(999);
      return 0;
    }
  if (Lhs == 1) {
    i = Rhs+1;
    if (retval!=-1) 
      C2F(mklistfromvars)(&i,&retval);
    else {
      m2=n2=1;
      CreateVar(Rhs+1, "d", &m2, &n2, &l2);
      *stk(l2) = (double) retval;
    }
    LhsVar(1)=Rhs+1;
  }
  else {
    m2=n2=1;
    CreateVar(Rhs+args+1, "d", &m2, &n2, &l2);
    *stk(l2) = (double) retval;
    /** we must complete the returned arguments up to Lhs **/
    for ( i = args+2; i <= Lhs ; i++) 
      {
	CreateVar(Rhs+i,"d",&zero,&zero,&l2);
	LhsVar(i) = Rhs+i;
      }
    LhsVar(1)=Rhs+args+1;
  }
  PutLhsVar();
  return 0;
}  


/*********************************************************************
 * Scilab numtokens
 *********************************************************************/

int int_objnumTokens(fname)
     char *fname;
{
  static int l1,m1,n1,l2,un=1;
  Nbvars = 0;
  CheckRhs(1,1);
  GetRhsVar(1,"c",&m1,&n1,&l1);
  StringConvert(cstk(l1));  /* conversion */
  CreateVar(2, "d", &un, &un, &l2);
  *stk(l2) = (double) NumTokens(cstk(l1));
  LhsVar(1) = 2;
  PutLhsVar();
  return 0;
}  


/*********************************************************************
 * Scilab fprintfMat function
 *********************************************************************/

int int_objfprintfMat(fname)
     char *fname;
{
  int l1, m1, n1,l2,m2,n2,m3,n3,l3,i,j;
  FILE  *f;
  char *Format;
  Nbvars = 0;
  CheckRhs(1,3); 
  CheckLhs(1,1);
  GetRhsVar(1,"c",&m1,&n1,&l1);/* file name */
  GetRhsVar(2,"d",&m2,&n2,&l2);/* data */
  if ( Rhs == 3) 
    {
      GetRhsVar(3,"c",&m3,&n3,&l3);/* format */
      StringConvert(cstk(l3));  /* conversion */
      Format = cstk(l3);
    }
  else 
    {
      Format = "%f";
    }
  if (( f = fopen(cstk(l1),"w")) == (FILE *)0) 
    {
      sciprint("Error: in function %s, cannot open file %s\r\n",
	       fname,cstk(l1));
      Error(999);
      return 0;
    }
  for (i = 0 ; i < m2 ; i++ ) 
    {
      for ( j = 0 ; j < n2 ; j++) 
	{
	  fprintf(f,Format,*stk(l2+i + m2*j));
	  fprintf(f," ");
	}
      fprintf(f,"\n");
    }
  fclose(f);
  LhsVar(1)=0 ; /** no return value **/
  PutLhsVar();
  return 0;
}  

/*********************************************************************
 * Scilab fscanMat function
 *********************************************************************/
#define INFOSIZE 1024
static char Info[INFOSIZE];

int int_objfscanfMat(fname)
     char *fname;
{
  double x;
  static int l1, m1, n1,l2,m2,n2;
  int i,j,rows,cols,lres,n;
  int vl=-1;
  FILE  *f;
  char *Format;
  Nbvars = 0;
  CheckRhs(1,1); /** just 1 <<pour l''instant>> **/
  CheckLhs(1,1);
  GetRhsVar(1,"c",&m1,&n1,&l1);/* file name */
  if ( Rhs == 2) 
    {
      GetRhsVar(2,"c",&m2,&n2,&l2);/* format */
      StringConvert(cstk(l2));  /* conversion */
      Format = cstk(l2);
    }
  else 
    {
      Format = 0;
    }
  if (( f = fopen(cstk(l1),"r")) == (FILE *)0) 
    {
      sciprint("Error: in function %s, cannot open file %s\r\n",
	       fname,cstk(l1));
      Error(999);
      return 0;
    }
  /*** first pass to get colums and rows ***/
  strcpy(Info,"--------");
  n =0; 
  while ( sscanf(Info,"%lf",&x) <= 0 && n != EOF ) 
    { n=ReadLine(f); vl++;}
  if ( n == EOF )
    {
      sciprint("Error: in function %s, cannot read data in file %s\r\n",
	       fname,cstk(l1));
      Error(999);
      return 0;
    }
  cols = NumTokens(Info);
  rows = 1;
  while (1) 
    { 
      n=ReadLine(f);
      if ( n == EOF ||  n == 0 ) break;
      if ( sscanf(Info,"%lf",&x) <= 0) break;
      rows++;
    }
  if ( cols == 0 || rows == 0) rows=cols=0;
  CreateVar(Rhs+1, "d", &rows, &cols, &lres);
  /** second pass to read data **/
  rewind(f);
  /** skip non numeric lines **/
  for ( i = 0 ; i < vl ; i++) ReadLine(f);
  for (i=0; i < rows ;i++)
    for (j=0;j < cols;j++)
      { 
	double xloc;
	fscanf(f,"%lf",&xloc);
	*stk(lres+i+rows*j)=xloc;
      }
  LhsVar(1)=Rhs+1;
  PutLhsVar();
  return 0;
}  

static int ReadLine_Old(fd)
     FILE *fd;
{
  int n;
  n= fscanf(fd,"%[^\n]%*c",Info);
  if ( n==0) n=fscanf(fd,"%*c");
  return(n);
}

static int ReadLine(fd)
     FILE *fd;
{
  int n=0;
  while (1)
    {
      char c = getc(fd);
      if ( n > INFOSIZE) 
	{
	  sciprint("Error Info buffer is too small (too many columns in your file ?)\r\n");
	  return EOF ;/** A changer XXXX : pour retournet un autre message **/
	}
      Info[n]= c ; 
      if ( c == '\n') { Info[n] = '\0' ; return 1;}
      else if ( c == EOF ) return EOF;  
      n++;
    }
}



/***************************************
 * Test de TestNumTokens 
 ***************************************/
#ifdef TEST 
static void TestNumTokens()
{
  char buf[30], format[20];
  strcpy(format,"%d Tokens in <%s>\n");
  strcpy(buf,"un deux trois");fprintf(stderr,format,NumTokens(buf),buf);
  strcpy(buf,"un");  fprintf(stderr,format,NumTokens(buf),buf);
  strcpy(buf,"un deux trois  "); fprintf(stderr,format,NumTokens(buf),buf);
  strcpy(buf,"un\tdeux\ttrois\n"); fprintf(stderr,format,NumTokens(buf),buf);
  fprintf(stderr,format, NumTokens((char *) 0) , ((char *) 0));
  strcpy(buf,"un\t");  fprintf(stderr,format,NumTokens(buf),buf);
  strcpy(buf," \t\nun");  fprintf(stderr,format,NumTokens(buf),buf);
  strcpy(buf,"1.0  1.0");fprintf(stderr,format,NumTokens(buf),buf);
}
#endif 

int NumTokens(string)
     char string[];
{
  char buf[128];
#ifdef __ABSC__ /* ABSOFT */
  int n=1, EOS = 0;
#else
  int n=0, EOS = -1;
#endif
  int lnchar=0,ntok=-1;
  int length = strlen(string)+1;
  if (string != 0)
    { 
      /** Counting leading white spaces **/
      sscanf(string,"%*[ \t\n]%n",&lnchar);
      while ( n != EOS && lnchar <= length  )
	{ 
	  int nchar1=0,nchar2=0;
	  ntok++;
	  n= sscanf(&(string[lnchar]),
		    "%[^ \n\t]%n%*[ \t\n]%n",buf,&nchar1,&nchar2);
	  lnchar += (nchar2 <= nchar1) ? nchar1 : nchar2 ;
	}
      return(ntok);
    }
  return(FAIL);
}


/***************************************************************
 * Emulation of Ansi C XXscanf functions 
 * The number of scaned object is hardwired (MAXSCAN) 
 * and scaned strings (%s,%c %[) are limited to MAX_STR characters
 *
 * XXXX Could be changed to eliminate the MAXSCAN limitation 
 * 
 ****************************************************************/

#define MAX_STR 1024
/* warning if maxscan is increased don't forget to chage the (*printer)(......) 
   line below **/

#define MAXSCAN 20

#define VPTR void * 

typedef enum {SF_C,SF_S,SF_LUI,SF_SUI,SF_UI,SF_LI,SF_SI,SF_I,SF_LF,SF_F} sfdir;

typedef int (*PRINTER) _PARAMS((FILE *, char *,...));
typedef int (*FLUSH) _PARAMS((FILE *));

int voidflush(fp) 
     FILE *fp ;
{
  return 0;
};

static int do_scanf (fname,fp,format,nargs,strv,retval)
     char *fname;
     FILE *fp;
     char *format;
     int  *nargs;
     char *strv;
     int *retval;
{
  double dval;
  int i,m1,n1,m2,n2,l2;
  char sformat[MAX_STR];
  char char_buf[MAXSCAN][MAX_STR];
  long unsigned int buf_lui[MAXSCAN];
  short unsigned int buf_sui[MAXSCAN];
  unsigned int buf_ui[MAXSCAN];
  long int buf_li[MAXSCAN];
  short int buf_si[MAXSCAN];
  int buf_i[MAXSCAN];
  double buf_lf[MAXSCAN];
  float buf_f[MAXSCAN];
  void *ptrtab[MAXSCAN];
  sfdir  type[MAXSCAN];
  int nc[MAXSCAN];
  int n_directive_count=0;
  char save,directive;
  char *p,*p1;
  register char *q;
  char *target;
  int l_flag=0, h_flag=0,width_flag,width_val,ign_flag,str_width_flag=0;
  int num_conversion = -1;	/* for error messages and counting arguments*/
  PRINTER printer;		/* pts at fprintf() or sprintf() */
  q = format;
  *retval = 0;
  if (fp == (FILE *) 0)		
    {
      /* doing sscanf or scanf */
      target = strv;
      printer = (PRINTER) sscanf;
    }
  else
    {
      /* doing fscanf */
      target = (char *) fp;
      printer = (PRINTER) fscanf;
    }

  /* Traverse format string, doing scanf(). */
  while (1)
    {
      /* scanf */
      p=q;
      while (*q != '%' && *q != '\0' ) q++;
      if ( *q == '%' && *(q+1) == '%' ) 
	{
	  q=q+2;
	  while (*q != '%' && *q != '\0' ) q++;
	}
      if (*q == 0) 
	{
	  break ;
	}

      q++; /** q point to character following % **/

      
      /* 
       * We have found a conversion specifier, figure it out,
       * then scan the data asociated with it.
       */

      num_conversion++;
      if ( num_conversion > MAXSCAN ) 
	{
	  sciprint("Error:\tscanf too many (%d > %d) conversion required\r\n",
		   num_conversion,MAXSCAN);
	  return RET_BUG;
	}
      /* mark the '%' with p1 */
      
      p1 = q - 1; 

      /* check for width field */

      while ( isdigit(((int)*q)) ) q++;
      width_flag =0;

      if ( p1+1 != q ) 
	{	  
	  char w= *q;
	  *q='\0';
	  width_flag = 1;
	  sscanf(p1+1,"%d",&width_val);
	  *q=w;
	}

      /* check for ignore argument */

      ign_flag=0;

      if (*q == '*')
	{
	  /* Ignore the argument in the input args */
	  num_conversion = Max(num_conversion-1,0);
	  ign_flag = 1;
	  q++;
	}
      else

      /* check for %l or %h */

      l_flag = h_flag = 0;

      if (*q == 'l')
	{
	  q++;
	  l_flag = 1;
	}
      else if (*q == 'h')
	{
	  q++;
	  h_flag = 1;
	}

      /* directive points to the scan directive  */

      directive = *q++;

      if ( directive == '[' )
	{
	  char *q1=q--;
	  /** we must find the closing bracket **/
	  while ( *q1 != '\0' && *q1 != ']') q1++;
	  if ( *q1 == '\0') 
	    {
	      sciprint("Error:\tscanf, unclosed [ directive\r\n");
	      return RET_BUG;
	    }
	  if ( q1 == q +1 || strncmp(q,"[^]",3)==0 ) 
	    {
	      q1++;
	      while ( *q1 != '\0' && *q1 != ']') q1++;  
	      if ( *q1 == '\0') 
		{
		  sciprint("Error:\tscanf unclosed [ directive\r\n");
		  return RET_BUG;
		}
	    }
	  directive = *q1++;
	  q=q1;
	}

      /** accumulate characters in the format up to next % directive **/
      /*** unused 
      while ( *q != '\0' && *q != '%' ) q++;
      if ( *q == '%' && *(q+1) == '%' ) 
	{
	  q=q+2;
	  while (*q != '%' && *q != '\0' ) q++;
	}
	**/
      save = *q;
      *q = 0;
      
      /** if (debug) Sciprintf("Now directive [%s],%c\r\n",p,directive); **/
      
      if ( ign_flag != 1) 
	{
	  switch (directive )
	    {
	    case ']':
	      if (width_flag == 0 ) str_width_flag = 1;
	      if (width_flag == 1 && width_val > MAX_STR-1 )
		{
		  sciprint("Error:\tscanf, width field %d is too long (> %d) for %%[ directive\r\n",
			   width_val,MAX_STR-1);
		  return RET_BUG;
		}
	      ptrtab[num_conversion] =  char_buf[num_conversion];
	      type[num_conversion] = SF_S;
	      break;
	    case 's':
	      if (l_flag + h_flag)
		sciprint("Error:\tscanf: bad conversion\r\n");
	      if (width_flag == 0 ) str_width_flag = 1;
	      if (width_flag == 1 && width_val > MAX_STR-1 )
		{
		  sciprint("Error:\tscanf, width field %d is too long (< %d) for %%s directive\r\n",
			   width_val,MAX_STR-1);
		  return RET_BUG;
		}
	      ptrtab[num_conversion] =  char_buf[num_conversion];
	      type[num_conversion] = SF_S;
	      break;
	    case 'c':
	      if (l_flag + h_flag)
		sciprint("Error:\tscanf: bad conversion\r\n");
	      if ( width_flag == 1 ) 
		nc[num_conversion ] = width_val;
	      else
		nc[num_conversion ] = 1;
	      if (width_flag == 1 && width_val > MAX_STR-1 )
		{
		  sciprint("Error:\tscanf width field %d is too long (< %d) for %%c directive\r\n",
			   width_val,MAX_STR-1);
		  return RET_BUG;
		}
	      ptrtab[num_conversion] =  char_buf[num_conversion];
	      type[num_conversion] = SF_C;
	      break;
	    case 'o':
	    case 'u':
	    case 'x':
	    case 'X':
	      if ( l_flag ) 
		{
		  ptrtab[num_conversion] =  &buf_lui[num_conversion];
		  type[num_conversion] = SF_LUI;
		}
	      else if ( h_flag) 
		{
		  ptrtab[num_conversion] =  &buf_sui[num_conversion];
		  type[num_conversion] = SF_SUI;
		}
	      else 
		{
		  ptrtab[num_conversion] =  &buf_ui[num_conversion];
		  type[num_conversion] = SF_UI;
		}
	      break;
	    case 'D':
	      ptrtab[num_conversion] =  &buf_li[num_conversion];
	      type[num_conversion] = SF_LI;
	      break;
	    case 'n':
	      /** count the n directives since they are not counted by retval **/
	      n_directive_count++;
	    case 'i':
	    case 'd':
	      if ( l_flag ) 
		{
		  ptrtab[num_conversion] =  &buf_li[num_conversion];
		  type[num_conversion] = SF_LI;
		}
	      else if ( h_flag) 
		{
		  ptrtab[num_conversion] =  &buf_si[num_conversion];
		  type[num_conversion] = SF_SI;
		}
	      else 
		{
		  ptrtab[num_conversion] =  &buf_i[num_conversion];
		  type[num_conversion] = SF_I;
		}
	      break;
	    case 'e':
	    case 'f':
	    case 'g':
	    case 'E':
	    case 'G':
	      if (h_flag)
		{
		  sciprint("Error:\tscanf: bad conversion\r\n");
		  return RET_BUG;
		}
	      else if (l_flag) 
		{
		  ptrtab[num_conversion] =  &buf_lf[num_conversion];
		  type[num_conversion] = SF_LF;
		}
	      else
		{
		  ptrtab[num_conversion] =  &buf_f[num_conversion];
		  type[num_conversion] = SF_F;
		}
	      break;
	    default:
	      sciprint("Error:\tscanf: bad conversion\r\n");
	      return RET_BUG;
	    }
	  *q = save;
	}
    }
  /** we replace %s and %[ directive with a max length field **/
  
  if ( str_width_flag == 1) 
    {
      char *f1=format;
      char *f2=sformat;
      char *slast = sformat + MAX_STR-1 -4;
      while ( *f1 != '\0'  ) 
	{
	  int n;
	  *f2++ = *f1++;
	  if ( *(f1-1) == '%' && ( *(f1) == 's'  || *(f1) == '['))
	    {
	      n=sprintf(f2,"%d",MAX_STR-1);
	      f2 += n;
      	      *f2++ = *f1++;
	    }
	  if ( f2 == slast )
	    {
	      sciprint("Error:\tscanf, format is too long (> %d) \r\n",MAX_STR-1);
	      return RET_BUG;
	    }
	}
      format = sformat;
    }
    

  /** Calling scanf function : 
    Only  num_conversion +1 qrgument are used 
    the last arguments transmited points to nothing 
    but this is not a problem since they won't be used ***/


  *retval = (*printer) ((VPTR) target,format,ptrtab[0],ptrtab[1],ptrtab[2],
		       ptrtab[3],ptrtab[4],ptrtab[5],ptrtab[6],ptrtab[7],
		       ptrtab[8],ptrtab[9],ptrtab[10],ptrtab[11],ptrtab[12],
		       ptrtab[13],ptrtab[14],ptrtab[15],ptrtab[16],ptrtab[17],
		       ptrtab[18],ptrtab[19]);
  /** *nargs counts the number of corectly scaned arguments **/
  *nargs = Min(num_conversion+1,Max(*retval+n_directive_count,0));
  if ( *nargs + Rhs > intersiz ) 
    {
      sciprint("Error:\ttoo many directive in scanf\r\n");
      return RET_BUG;
    }

  m2=n2=1;
  for ( i=1 ; i <= *nargs ; i++) 
    {
      unsigned long lstr;
      switch ( type[i-1] )
	{
	  
	case SF_C:
	  char_buf[i-1][nc[i-1]]='\0';
	  m1=strlen(char_buf[i-1]);
	  n1=1;
	  lstr= (unsigned long) char_buf[i-1];
	  CreateVarFromPtr(Rhs+i, "c", &m1, &n1, &lstr);
	  LhsVar(i+1)=Rhs+i;
	  /** Sciprintf("read [%s]\n",char_buf[i-1]); **/
	  break;
	case SF_S:
	  m1=strlen(char_buf[i-1]);
	  n1=1;
	  lstr= (unsigned long) char_buf[i-1];
	  CreateVarFromPtr(Rhs+i, "c", &m1, &n1, &lstr);
	  LhsVar(i+1)=Rhs+i;
	  break;
	case SF_LUI:
	  dval = *((unsigned long int*) ptrtab[i-1]);
	  CreateVar(Rhs+i, "d", &m2, &n2, &l2);
	  *stk(l2) = dval;
	  LhsVar(i+1)=Rhs+i;
	  break;
	case SF_SUI:
	  dval = *((unsigned short int*) ptrtab[i-1]);
	  CreateVar(Rhs+i, "d", &m2, &n2, &l2);
	  *stk(l2) = dval;
	  LhsVar(i+1)=Rhs+i;
	  break;
	case SF_UI:
	  dval = *((unsigned int*) ptrtab[i-1]);
	  CreateVar(Rhs+i, "d", &m2, &n2, &l2);
	  *stk(l2) = dval;
	  LhsVar(i+1)=Rhs+i;
	  break;
	case SF_LI:
	  dval = *((long int*) ptrtab[i-1]);
	  CreateVar(Rhs+i, "d", &m2, &n2, &l2);
	  *stk(l2) = dval;
	  LhsVar(i+1)=Rhs+i;
	  break;
	case SF_SI:
	  dval = *((short int*) ptrtab[i-1]);
	  CreateVar(Rhs+i, "d", &m2, &n2, &l2);
	  *stk(l2) = dval;
	  LhsVar(i+1)=Rhs+i;
	  break;
	case SF_I:
	  dval = *((int*) ptrtab[i-1]);
	  CreateVar(Rhs+i, "d", &m2, &n2, &l2);
	  *stk(l2) = dval;
	  LhsVar(i+1)=Rhs+i;
	  break;
	case SF_LF:
	  dval = *((double*) ptrtab[i-1]);
	  CreateVar(Rhs+i, "d", &m2, &n2, &l2);
	  *stk(l2) = dval;
	  LhsVar(i+1)=Rhs+i;
	  break;
	case SF_F:
	  dval = *((float*) ptrtab[i-1]);
	  CreateVar(Rhs+i, "d", &m2, &n2, &l2);
	  *stk(l2) = dval;
	  LhsVar(i+1)=Rhs+i;
	  break;
	}
    }
  return 0;
}


/***************************************************************
								
  do_printf: code extraced from RLab and hacked for Scilab 
              by Jean-Philippe Chancelier 1998. 

    Copyright (C) 1995  Ian R. Searle
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *************************************************************** */


/*---------- types and defs for doing printf ------------*/
#define  PF_C		0
#define  PF_S		1
#define  PF_D		2	/* int conversion */
#define  PF_LD		3	/* long int */
#define  PF_F		4	/* float conversion */

/* for switch on number of '*' and type */

#define  AST(num,type)  (5*(num)+(type))

/* Buffer for printf **/

#define MAX_SPRINTF_SIZE  4096
static char sprintf_buff[MAX_SPRINTF_SIZE];
static char *sprintf_limit = sprintf_buff + MAX_SPRINTF_SIZE;

static int do_printf (fname,fp,format,nargs,arg_cnt,strv)
     char *fname;
     FILE *fp;
     char *format;
     int nargs,arg_cnt;
     char **strv;
{
  int first; /*** A Enlever **/
  int m1;
  char save;
  char *p;
  register char *q;
  char *target;
  int l_flag, h_flag;		/* seen %ld or %hd  */
  int ast_cnt;
  int ast[2];
  double dval = 0.0;
  char *sval= "bug";
  int num_conversion = 0;	/* for error messages */
  int pf_type = 0;		/* conversion type */
  PRINTER printer;		/* pts at fprintf() or sprintf() */
  FLUSH   flush;
  int argcnt;

  int retval;			/* Attempt to return C-printf() return-val */
  argcnt = nargs - 1;		/* To count backward */
  q = format;
  retval = 0;

  if (fp == (FILE *) 0)		
    {
      /* doing sprintf */
      target = sprintf_buff;
      flush = voidflush;
      printer = (PRINTER) sprintf;
    }
  else if ( fp == stdout ) 
    {
      /** doing printf **/
      target =  (char *) 0; /* unused */
      flush = fflush;
      printer = (PRINTER) sciprint2;
    }
  else 
    {
      /* doing fprintf */
      target = (char *) fp;	/* will never change */
      flush = fflush;
      printer = (PRINTER) fprintf;
    }

  /* Traverse format string, doing printf(). */
  while (1)
    {
      if (fp)			/* printf */
	/** XXXX on pourrait couper en deux pour separer fp==stdout et fp == file **/
	{
	  while (*q != '%')
	    {
	      switch (*q) 
		{
		case 0 : 
		  fflush (fp);
		  return (retval);
		  break;
		case '\\':
		  q++;
		  switch (*q) 
		    {
		    case 0 : 
		      fflush (fp);
		      return (retval);
		      break;
		    case 'r':
		      (*printer) ((VPTR) target, "\r");
		      q++;
		      retval++;
		      break;
		    case 'n':
		      if ( fp == stdout ) 
			(*printer) ((VPTR) target, "\r");
		      (*printer) ((VPTR) target, "\n");
		      q++;
		      retval++;
		      break;
		    case 't':
		      (*printer) ((VPTR) target, "\t");
		      q++;
		      retval++;
		      break;
		    case '\\':
		      (*printer) ((VPTR) target, "\\");
		      q++;
		      retval++;
		      break;
		    default:
		      /**  putc (*q, fp); **/
		      (*printer) ((VPTR) target, "%c",*q);
		      q++;
		      retval++;
		    }
		  break;
		default:
		  /**  putc (*q, fp); **/
		  (*printer) ((VPTR) target, "%c",*q);
		  q++;
		  retval++;
		  break;
		}
	    }
	}
      else
	{
	  /* sprintf() */
	  while (*q != '%')
	    {
	      if (*q == 0)
		{
		  if (target > sprintf_limit)	/* damaged */
		    {
		      sciprint("Error:\tsprintf problem, buffer too small\r\n");
		      return RET_BUG;
		    }
		  else
		    {
		      /* really done */
		      *target = '\0';
		      *strv = sprintf_buff;
		      return (retval);
		    }
		}
	      else
		{
		  *target++ = *q++;
		  retval++;
		}
	    }
	}

      num_conversion++;

      if (*++q == '%')		/* %% */
	{
	  if (fp)
	    {
	      /** putc (*q, fp); **/
	      (*printer) ((VPTR) target, "%c",*q);
	      retval++;
	    }
	  else
	    {
	      *target++ = *q;
	    }
	  q++;
	  continue;
	}

      /* 
       * We have found a conversion specifier, figure it out,
       * then print the data asociated with it.
       */

      if (argcnt <= 0)
	{
	  (*printer) ((VPTR) target, "\n");
	  (*flush) ((FILE *) target);
	  sciprint("Error:\tprintf: not enough arguments\r\n");
	  return RET_BUG;
	}
      else
	{
 	  /* Get The data object from the arg-list */
	  ++arg_cnt;
	  argcnt--;
	}

      /* mark the '%' with p */
      p = q - 1;

      /* eat the flags */
      while (*q == '-' || *q == '+' || *q == ' ' ||
	     *q == '#' || *q == '0')
	q++;

      ast_cnt = 0;		/* asterisk count */
      if (*q == '*')
	{
	  /* Use current arg as field width spec */
	  if (GetScalarInt(fname,first,arg_cnt,&m1) == FAIL) return -1;
	  ast[ast_cnt++] = m1;
	  q++;

	  if (argcnt <= 0)
	    {
	      (*printer) ((VPTR) target, "\n");
	      (*flush) ((FILE *) target);
	      sciprint("Error:\tprintf: not enough arguments\r\n");
	      return RET_BUG;
	    }
	  else
	    {
	      /* Get next arg */
	      ++arg_cnt;
	      argcnt--;
	    }
	}
      else
	while ( isdigit(((int)*q)))  q++;
      /* width is done */

      if (*q == '.')		/* have precision */
	{
	  q++;
	  if (*q == '*')
	    {
	      /* Use current arg as precision spec */
	      if (GetScalarInt(fname,first,arg_cnt,&m1) == FAIL) return RET_BUG;
	      ast[ast_cnt++] = m1;
	      q++;

	      if (argcnt <= 0)
		{
		  (*printer) ((VPTR) target, "\n");
		  (*flush) ((FILE *) target);
		  sciprint("Error:\tprintf: not enough arguments\r\n");
		  return RET_BUG;
		}
	      else
		{
		  /* Get next arg */
		  ++arg_cnt;
		  argcnt--;
		}
	    }
	  else
	    while ( isdigit(((int)*q)) ) q++;
	}

      if (argcnt < 0)
	{
	  (*printer) ((VPTR) target, "\n");
	  (*flush) ((FILE *) target);
	  sciprint("Error:\tprintf: not enough arguments\r\n");
	  return RET_BUG;
	}

      l_flag = h_flag = 0;

      if (*q == 'l')
	{
	  q++;
	  l_flag = 1;
	}
      else if (*q == 'h')
	{
	  q++;
	  h_flag = 1;
	}

      /* Set pf_type and load val */
      switch (*q++)
	{
	case 's':
	  if (l_flag + h_flag)
	    sciprint("Warning:\tprintf: bad conversion l or h flag mixed with s directive\r\n");
	  if ((sval = GetString(fname,first,arg_cnt)) == (char*)0) return RET_BUG;
	  pf_type = PF_S;
	  break;
	case 'c':
	  if (l_flag + h_flag)
	    sciprint("Warning:\tprintf: bad conversion l or h flag mixed with c directive\r\n");
	  if ((sval = GetString(fname,first,arg_cnt)) == (char*)0) return RET_BUG;
	  pf_type = PF_C;
	  break;
	case 'd':
	  if (GetScalarDouble(fname,first,arg_cnt,&dval) == FAIL) return RET_BUG;
	  pf_type = PF_D;
	  break;

	case 'o':
	  sciprint("Error:\tprintf: \"o\" format not allowed\r\n");
	  return RET_BUG;
	  break;

	case 'x':
	  if (GetScalarDouble(fname,first,arg_cnt,&dval) == FAIL) return RET_BUG;
	  pf_type = PF_D;
	  break;

	case 'X':
	  if (GetScalarDouble(fname,first,arg_cnt,&dval) == FAIL) return RET_BUG;
	  pf_type = PF_D;
	  break;

	case 'i':
	case 'u':
	  /* use strod() here */
	  if (GetScalarDouble(fname,first,arg_cnt,&dval) == FAIL) return RET_BUG;
	  pf_type = l_flag ? PF_LD : PF_D;
	  break;

	case 'e':
	case 'g':
	case 'f':
	case 'E':
	case 'G':
	  if (h_flag + l_flag)
	    {
	      sciprint("Error:\tprintf: bad conversion\r\n");
	      return RET_BUG;
	    }
	  /* use strod() here */
	  if (GetScalarDouble(fname,first,arg_cnt,&dval) == FAIL) return RET_BUG;
	  pf_type = PF_F;
	  break;

	default:
	  sciprint("Error:\tprintf: bad conversion\r\n");
	  return RET_BUG;
	}

      save = *q;
      *q = 0;

      /* ready to call printf() */
      /* 
       * target:   The output file (or variable for sprintf())
       * p:        the beginning of the format
       * ast:      array with asterisk values
       */
      switch (AST (ast_cnt, pf_type))
	{
	case AST (0, PF_C):
	  retval += (*printer) ((VPTR) target, p, sval[0]);
	  break;

	case AST (1, PF_C):
	  retval += (*printer) ((VPTR) target, p, ast[0], sval[0]);
	  break;

	case AST (2, PF_C):
	  retval += (*printer) ((VPTR) target, p, ast[0], ast[1],sval[0]);
	  break;

	case AST (0, PF_S):
	  retval += (*printer) ((VPTR) target, p, sval);
	  break;

	case AST (1, PF_S):
	  retval += (*printer) ((VPTR) target, p, ast[0], sval);
	  break;

	case AST (2, PF_S):
	  retval += (*printer) ((VPTR) target, p, ast[0], ast[1], sval);
	  break;

	case AST (0, PF_D):
	  retval += (*printer) ((VPTR) target, p, (int) dval);
	  break;

	case AST (1, PF_D):
	  retval += (*printer) ((VPTR) target, p, ast[0], (int) dval);
	  break;

	case AST (2, PF_D):
	  retval += (*printer) ((VPTR) target, p, ast[0], ast[1], (int) dval);
	  break;

	case AST (0, PF_LD):
	  retval += (*printer) ((VPTR) target, p, (long int) dval);
	  break;

	case AST (1, PF_LD):
	  retval += (*printer) ((VPTR) target, p, ast[0], (long int) dval);
	  break;

	case AST (2, PF_LD):
	  retval += (*printer) ((VPTR) target, p, ast[0], ast[1], (long int) dval);
	  break;

	case AST (0, PF_F):
	  retval += (*printer) ((VPTR) target, p, dval);
	  break;

	case AST (1, PF_F):
	  retval += (*printer) ((VPTR) target, p, ast[0], dval);
	  break;

	case AST (2, PF_F):
	  retval += (*printer) ((VPTR) target, p, ast[0], ast[1], dval);
	  break;
	}
      if (fp == (FILE *) 0)
	while (*target)
	  target++;
      *q = save;
    }
}





/****************************************************
 * Utility functions 
 ****************************************************/

static char * GetString(fname,first,arg) 
     char *fname;
     int first,arg;
{
  int mx,nx,lx;
  if (! C2F(getrhsvar)(&arg,"c",&mx,&nx,&lx,1L))
    return (char *) 0;
  else 
    return cstk(lx);
}

/** changes `\``n` --> `\n` idem for \t and \r  **/

void StringConvert(str)
     char *str;
{
  char *str1;
  str1 = str;
  while ( *str != 0) 
    {
      if ( *str == '\\' ) 
	{
	  switch ( *(str+1)) 
	    {
	    case 'n' : *str1 = '\n' ; str1++; str += 2;break;
	    case 't' : *str1 = '\n' ; str1++; str += 2;break;
	    case 'r' : *str1 = '\n' ; str1++; str += 2;break;
	    default : *str1 = *str; str1++; str++;break;
	    }
	}
      else 
	{
	  *str1 = *str; str1++; str++;
	}
    }
  *str1 = '\0';
}

static int GetScalarInt(fname,first,arg,ival) 
     char *fname;
     int first,arg,*ival;
{
  int mx,nx,lx;
  if (! C2F(getrhsvar)(&arg,"i",&mx,&nx,&lx,1L))
    return FAIL;
  else 
    {
      *ival =  *(istk(lx));
      return OK;
    }
}

static int GetScalarDouble(fname,first,arg,dval)
     char *fname;
     int first,arg;
     double *dval;
{
  int mx,nx,lx;
  if (! C2F(getrhsvar)(&arg,"d",&mx,&nx,&lx,1L))
    return FAIL;
  else 
    {
      *dval =  *(stk(lx));
      return OK;
    }
}


