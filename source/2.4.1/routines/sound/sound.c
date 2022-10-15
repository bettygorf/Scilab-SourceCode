/* Copyright INRIA */
#include <stdio.h>
#ifdef __STDC__
#include <stdlib.h>
#endif
#include <string.h>
#include <math.h>
#ifdef __STDC__
#include <float.h>
#endif
#include <limits.h>
#include <ctype.h>

#include "../graphics/Math.h"

#include "st.h"


#if (defined(sun) && !defined(SYSV)) 
char *strerror _PARAMS((int errcode));
#endif


static int swap = 0;

#define MAXF 20
static int CurFile =-1;
static struct soundstream ftf;
static ft_t ft ;

static FILE *ftformat[MAXF]={(FILE*) 0}; /*** must be zero initialized ***/
static int ftswap[MAXF]={0}; /** swap status for each file **/

static int GetFirst() 
{
  int i ;
  for ( i = 0 ; i < MAXF ; i++) 
    if ( ftformat[i] == (FILE *) 0 ) return(i) ;
  return(MAXF);
}

FILE *GetFile(fd)
     integer *fd;
{
  int fd1;
  fd1 = (*fd != -1) ?  Min(Max(*fd,0),MAXF-1) : CurFile ;
  if ( fd1 != -1 ) 
    return(ftformat[fd1]);
  else
    return((FILE *) 0);
}

int GetSwap(fd)
     integer *fd;
{
  int fd1;
  fd1 = (*fd != -1) ?  Min(Max(*fd,0),MAXF-1) : CurFile ;
  if ( fd1 != -1 ) 
    return(ftswap[fd1]);
  else
    return(0);
}


int islittle_endian()
{
  int	littlendian = 1;
  char	*endptr;
  endptr = (char *) &littlendian;
  return (int) *endptr;
}

void C2F(mopen)(fd,file,status,f_swap,res,error)
     int *error,*f_swap;
     char *file,*status;
     double *res;
     int *fd;
{   
  int	littlendian = 1;
  char	*endptr;
  /* next line added by ss 16/10/98 */
  swap =0;
  *error=0;
  endptr = (char *) &littlendian;
  if ( (!*endptr) )
    {
      if( *f_swap == 1 ) 
	swap = 1;
      else 
	swap =0;
    }
  /*  sciprint("    Byte Swap status %d \r\n",swap);*/
  *fd = GetFirst();
  if ( *fd == MAXF )
    {
      *error=1;
      /* sciprint("Too many opened files!\r\n"); */
      return;
    }
  ftformat[*fd]=fopen(file,status);
  ftswap[*fd]= swap;
  if (! ftformat[*fd] )
    {     
      *error=2;
      /* sciprint("Could not open the file!\n");*/
      return;
    }
  CurFile = *fd;
  *res = (double)ferror(ftformat[*fd]);
}

/**************************************
 * close the file with id *fd if *id != -1 and *id != -2
 * the current file if *id = -1 
 * all opened file if *id = -2 
 **************************************/

void C2F(mclose) (fd,res)
     double *res;
     integer *fd;
{     
  int fd1;
  if ( *fd == -2) 
    /* closing all opened files */
    {
      for ( fd1=0; fd1< MAXF; fd1++) {
	if ( ftformat[fd1] )
	  {
	    fclose( ftformat[fd1] );
	    *res = (double)ferror( ftformat[fd1]);
	    ftformat[fd1]  = (FILE*) 0;
	  }

      }
    }
  else
    {
      if ( *fd != -1) 
	{
	/* closing given  file */
	  fd1 = Min(Max(*fd,0),MAXF-1);
	}
      else 
	{
	/* closing current  file */
	  fd1 = CurFile;
	}
      if ( fd1 != -1 ) 
	{
	  if ( ftformat[fd1] )
	    {
	      fclose( ftformat[fd1] );
	      *res = (double)ferror( ftformat[fd1]);
	      ftformat[fd1]  = (FILE*) 0;
	    }
	  else
	    {
	      *res = 0.0;
	      sciprint("File %d not active \r\n",fd1);
	    }
	}
      else 
	{
	  *res = -1.0;
	  sciprint("No file to close \r\n",fd1);
	}
    }
}


void C2F(meof) (fd,res)
     double *res;
     integer *fd;
{       
  FILE *fa= GetFile(fd);
  *res = fa ? feof(fa) : 1;
}


void C2F(mclearerr) (fd)
     integer *fd;
{       
  FILE *fa= GetFile(fd);
  clearerr(fa);
}




#if (defined(sun) && !defined(SYSV)) || defined(sgi)
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2
#endif 

FILE * GetFile();

void C2F(mseek) (fd,offset,flag,err)
     integer *fd,*offset,*err;
     char *flag;
{     
  int iflag;
#if (defined(sun) && !defined(SYSV)) || defined(sgi)
  int irep;
#endif
  FILE *fa= GetFile(fd);
  if ( fa == (FILE *) 0 ) 
    {
      sciprint("mseek: wrong file descriptor \r\n");
      *err=1;
      return;
    }
  if ( strncmp(flag,"set",3)==0 ) 
    iflag = SEEK_SET;
  else if ( strncmp(flag,"cur",3)==0 ) 
    iflag = SEEK_CUR;
  else if ( strncmp(flag,"end",3)==0 ) 
    iflag = SEEK_END;
  else 
    {
      sciprint("mseek : flag = %s not recognized \r\n");
      *err=1;
      return;
    }
#if (defined(sun) && !defined(SYSV)) || defined(sgi)
  irep = fseek(fa,(long) *offset,iflag) ;
  if ( irep != 0 ) 
    {
      sciprint(strerror(irep));
      *err=1;
    }
  else
    *err=0;
#else
  if (fseek(fa,(long) *offset,iflag) == -1 ) 
    {
      sciprint("mseek: error\r\n");
      *err=1;
    }
  else 
    *err=0;
#endif
}

void C2F(mtell) (fd,offset,err)
     integer *fd,*offset,*err;
{     
  FILE *fa= GetFile(fd);
  if ( fa == (FILE *) 0 ) 
    {
      sciprint("mseek: wrong file descriptor \r\b");
      *err=1;
      return;
    }
  *err=0;
  *offset = ftell(fa) ;
}


/* 
   Read and write words and longs in "machine format".  
   Swap if indicated. 
   */


#define MPUT(Type,Fswap) for ( i=0; i< *n; i++)  \
           { \
	      Type val; \
	      val =(Type) *res++; \
	      if ( swap) val = Fswap(val); \
	      fwrite(&val,sizeof(Type),1,fa); \
	    }


#define MPUT_GEN(Type,Fswap) if ( strlen(type) == 1) \
	    {MPUT(Type,Fswap); }  else \
	    { \
	      switch (type[1])  \
		{ \
		case 'b': \
		  if (islittle_endian()==1) swap=1; \
		  else swap=0; \
		  MPUT(Type,Fswap); \
		  break; \
		case 'l': \
		  if (islittle_endian()==1) swap=0; \
		  else swap=1; \
		  MPUT(Type,Fswap); \
		  break; \
		default: \
		  sciprint("mput : %s format not recognized \r\n",type); \
		  *ierr=1;return; \
			     }}


void C2F(mput) (fd,res,n,type,ierr)
     double *res;
     integer *n,*ierr;
     char type[];
     integer *fd;
{  
  char c1,c2;
  int i,nc;
  FILE *fa;
  ft_t ft;
  fa = GetFile(fd);
  swap = GetSwap(fd);
  ft = &ftf; 
  ft->fp = fa;
  nc=strlen(type);
  if ( nc == 0) 
    {
      sciprint("mput : format is of 0 length  \r\n",type);
      *ierr=1;
      return;
    }
  if (fa)
    { 
      switch ( type[0] )
	{
	case 'l' : 
	  MPUT_GEN(long,swapl);
	  break;
	case 's' : 
	  MPUT_GEN(short,swapw);
	  break;
	case 'c' : 
	  for ( i=0; i< *n; i++) 
	    {
	      char val;
	      val =(char) *res++;
	      fwrite(&val,sizeof(char),1,fa);
	    }
	  break;
	case 'd' :  
	  MPUT_GEN(double,swapd); 
	  break;
	case 'f' : 
	  MPUT_GEN(float,swapf);
	  break;
	case 'u' :
	  if ( strlen(type) > 1) c1=type[1] ;
	  else c1=' ';
				  
	  switch ( c1 )
	    {
	    case 'b' :
	      if ( strlen(type) > 2) c2=type[2];
	      else c2=' ';
	      switch (c2 )
		{
		case 'l' :
		  /* Write long, big-endian: big end first. 
		     68000/SPARC style. */
		  for ( i=0; i< *n; i++) 
		    {
		      unsigned long val;
		      val =(unsigned long) *res++;
		      wblong(ft, val);
		    }
		  break;
		case 's' :
		  /* Write short, big-endian: big end first. 
		     68000/SPARC style. */
		  for ( i=0; i< *n; i++) 
		    {
		      unsigned short val;
		      val =(unsigned short) *res++;
		      wbshort(ft,val);
		    }
		  break;
		  
		}
	      break;
	    case 'l' : 
	      if ( strlen(type) > 2) c2=type[2];
	      else c2=' ';
	      switch ( c2 )
		{
		case 'l' :
		  /* Write long, little-endian: little end first. 
		     VAX/386 style.*/
		  for ( i=0; i< *n; i++) 
		      {
			unsigned long val;
			val =(unsigned long) *res++;
			wllong(ft, val);
		      }
		  break;
		case 's' :
		  /* Write short, little-endian: little end first. 
		     VAX/386 style.*/
		  for ( i=0; i< *n; i++) 
		    {
		      unsigned short val;
		      val =(unsigned short) *res++;
		      wlshort(ft,val);
		    }
		  break;
		default: MPUT(unsigned long,swapl);
		  break;
		}
	      break;
	    case 's' : MPUT(unsigned short,swapw);
	      break;
	    case 'c' :
	      for ( i=0; i< *n; i++) 
		{
		  unsigned char val;
		  val =(unsigned char) *res++;
		  fwrite(&val,sizeof(unsigned char),1,fa);
		}
	      break;
	    default :
	      sciprint("mput : %s format not recognized \r\n",type);
	      *ierr=1;
	      return;
	    }
	  break;
	default :
	  sciprint("mput : %s format not recognized \r\n",type);
	  *ierr=1;
	  return;
	}
      *ierr = ferror(fa);
      return;
    }
  sciprint("No input file \r\n");
  *ierr=1;
}



#define MGET(Type,Fswap) for ( i=0; i< *n; i++)  \
           { \
	      Type val; \
	      if ( fread(&val,sizeof(Type),1,fa) != 1) {items= i;break;};\
	      if ( swap) val = Fswap(val);\
	      *res++ = val;\
	    }


#define MGET_GEN(NumType,Fswap) if ( strlen(type) == 1) \
	    {MGET(NumType,Fswap); }  else \
	    { \
	      switch (type[1])  \
		{ \
		case 'b': \
		  if (islittle_endian()==1) swap=1; \
		  else swap=0; \
		  MGET(NumType,Fswap); \
		  break; \
		case 'l': \
		  if (islittle_endian()==1) swap=0; \
		  else swap=1; \
		  MGET(NumType,Fswap); \
		  break; \
		default: \
		  sciprint("mget : %s format not recognized \r\n",type); \
		  *ierr=1; return;\
			     }}


/*****************************************************************
 * read n items of type type 
 * if read fails *ierr contains the number of properly read items 
 ****************************************************************/



void C2F(mget) (fd,res,n,type,ierr)
     double *res;
     integer *n,*ierr,*fd;
     char type[];
{  
  char c1,c2;
  int i,items=-1,nc;
  ft_t ft;
  FILE *fa;
  fa = GetFile(fd);
  swap = GetSwap(fd);
  ft = &ftf; 
  ft->fp = fa;
  nc=strlen(type);
  if ( nc == 0) 
    {
      sciprint("mget : format is of 0 length  \r\n",type);
      *ierr=1;
      return;
    }
  if (fa)
    { 
      switch ( type[0] )
	{
	case 'l' : MGET_GEN(long,swapl);
	  break;
	case 's' : MGET_GEN(short,swapw);
	  break;
	case 'c' :
	  for ( i=0; i< *n; i++) 
	    {
	      char val;
	      if ( fread(&val,sizeof(char),1,fa) != 1) 
		 {items= i;break;}
	      *res++ = val;
	    }
	  break;
	case 'd' :  MGET_GEN(double,swapd);
	  break;
	case 'f' :  MGET_GEN(float,swapf);
	  break;
	case 'u' :
	  if ( strlen(type) > 1) c1=type[1] ;
	  else c1=' ';

	  switch ( c1 )
	    {
	    case 'b' :
	      if ( strlen(type) > 2) c2=type[2];
	      else c2=' ';
	      switch ( c2)
		{
		case 'l' :
		  /* Read long, big-endian: big end first. 
		     68000/SPARC style. */
		  for ( i=0; i< *n; i++) 
		    {
		      unsigned long val;
		      val = rblong(ft);
		      if ( feof(fa) != 0)  {items= i;break;}
		      *res ++ = val ;
		    }
		  break;
		case 's' :
		  /* Read short, big-endian: big end first. 
		     68000/SPARC style. */
		  for ( i=0; i< *n; i++) 
		    {
		      unsigned short val;
		      val = rbshort(ft);
		      if ( feof(fa) != 0)  {items= i;break;}
		      *res++ = val;
		    }
		  break;
		}
	      break;
	    case 'l' : 
	      if ( strlen(type) > 2) c2=type[2];
	      else c2=' ';
	      switch ( c2 )
		{
		case 'l' :
		  /* Read long, little-endian: little end first. 
		     VAX/386 style.*/
		  for ( i=0; i< *n; i++) 
		      {
			unsigned long val;
			val = rllong(ft);
			if ( feof(fa) != 0)  {items= i;break;}
			*res++ = val;
		      }
		  break;
		case 's' :
		  /* Read short, little-endian: little end first. 
		     VAX/386 style.*/
		  for ( i=0; i< *n; i++) 
		    {
		      unsigned short val;
		      val = rlshort(ft);
		      if ( feof(fa) != 0)  {items= i;break;}
		      *res++ = val;
		    }
		  break;
		default: MGET(unsigned long,swapl);
		  break;
		}
	      break;
	    case 's' : MGET(unsigned short,swapw);
	      break;
	    case 'c' :
	      for ( i=0; i< *n; i++) 
		{
		  unsigned char  val;
		  if ( fread(&val,sizeof(unsigned char),1,fa)!= 1) 
		    {items= i;break;};
		  *res++ = val;
		}
	      break;
	    default :
	      sciprint("mget : %s format not recognized \r\n",type);
	      *ierr=1;
	      return;
	    }
	  break;
	default :
	  sciprint("mget : %s format not recognized \r\n",type);
	  *ierr=1;
	  return;
	}
      if ( items != -1 ) 
	{
	  *ierr = -(items) -1 ;
	  /** sciprint("Read %d out of \r\n",items,*n); **/
	}
      return;
    }
  sciprint("No input file \r\n");
  *ierr=1;
}

void C2F(mgetstr) (fd,start,n,ierr)
     char **start;
     integer *ierr,*n,*fd;
{ 
  int count;
  FILE *fa;
  fa = GetFile(fd);
  if (fa)
    { 
      *start= (char *) malloc((*n+1)*sizeof(char));
      if ( *start == (char *) 0)
 	{       
	  sciprint("No more memory \r\n");
	  *ierr=1;
	  return;
	}
      count=fread(*start,sizeof(char),*n,fa);
      (*start)[*n]='\0';
      if ( count != *n ) 
	{
	  *ierr = - count -1;
	}
      return;
    }
  sciprint("No input file \r\n");
  *ierr=1;
}


void C2F(mputstr) (fd,str,res,ierr)
     char *str;
     double *res;
     int *ierr,*fd;
{   
  FILE *fa;
  fa = GetFile(fd);
  if (!fa) 
    {
      sciprint("No input file \r\n");
      *ierr=1;
    }
  else 
    {
      fprintf(fa,"%s",str);
      (*res) = (*ierr) =ferror(fa);
    }
}

