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


static int swap = 0;

#define MAXF 10
static int CurFile =-1;
static struct soundstream ftf;
static ft_t ft ;

static FILE *ftformat[MAXF]={(FILE*) 0}; /*** must be zero initialized ***/

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
  if ( *fd != -1) 
      fd1 = Min(Max(*fd,0),MAXF-1);
  else 
      fd1 = CurFile;
  if ( fd1 != -1 ) 
    return(ftformat[fd1]);
  else
    return((FILE *) 0);
}


void C2F(mopen)(fd,file,status,f_swap,res,error)
     int *error,*f_swap;
     char *file,*status;
     double *res;
     int *fd;
{   
  int	littlendian = 1;
  char	*endptr;
  endptr = (char *) &littlendian;
  if ( (!*endptr) && *f_swap == 1 ) swap = 1;
  sciprint("    Byte Swap status %d \r\n",swap);
  *fd = GetFirst();
  if ( *fd == MAXF )
    {
      *error=1;
      sciprint("Too many opened files!\r\n");
      return;
    }
  ftformat[*fd]=fopen(file,status);
  if (! ftformat[*fd] )
    {     
      *error=1;
      sciprint("Could not open the file!\n");
      return;
    }
  CurFile = *fd;
  *res = (double)ferror(ftformat[*fd]);
}

/**************************************
 * close the file with id *fd if *id != -1 
 * or the current file if *id = -1 
 **************************************/

void C2F(mclose) (fd,res)
     double *res;
     integer *fd;
{     
  int fd1;
  if ( *fd != -1) 
    {
      fd1 = Min(Max(*fd,0),MAXF-1);
    }
  else 
    {
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
    sciprint("No file to close \r\n",fd1);

}


void C2F(meof) (fd,res)
     double *res;
     integer *fd;
{       
  FILE *fa= GetFile(fd);
  *res = fa ? feof(fa) : 1;
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

void C2F(mput) (fd,res,n,type,ierr)
     double *res;
     integer *n,*ierr;
     char type[];
     integer *fd;
{  
  unsigned short val;
  char c;
  int i;
  FILE *fa;
  ft_t ft;
  fa = GetFile(fd);
  ft = &ftf; 
  ft->fp = fa;
  if (fa)
    { 
      switch ( type[0] )
	{
	case 'l' : MPUT(long,swapl);
	  break;
	case 's' : MPUT(short,swapw);
	  break;
	case 'c' : 
	  for ( i=0; i< *n; i++) 
	    {
	      char val;
	      val =(char) *res++;
	      fwrite(&val,sizeof(char),1,fa);
	    }
	  break;
	case 'd' : MPUT(double,swapd);
	  break;
	case 'f' : MPUT(float,swapf);
	  break;
	case 'u' :
	  switch ( type[1] )
	    {
	    case 'b' :
	      switch ( type[2] )
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
	      c = ( strlen(type) > 3 ) ? type[2] : ' ';
	      switch ( type[2] )
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
	      fread(&val,sizeof(Type),1,fa);\
	      if ( swap) val = Fswap(val);\
	      *res++ = val;\
	    }

void C2F(mget) (fd,res,n,type,ierr)
     double *res;
     integer *n,*ierr,*fd;
     char type[];
{  
  char c;
  unsigned short val;
  int i;
  ft_t ft;
  FILE *fa;
  fa = GetFile(fd);
  ft = &ftf; 
  ft->fp = fa;
  if (fa)
    { 
      switch ( type[0] )
	{
	case 'l' : MGET(long,swapl);
	  break;
	case 's' : MGET(short,swapw);
	  break;
	case 'c' :
	  for ( i=0; i< *n; i++) 
	    {
	      char val;
	      fread(&val,sizeof(char),1,fa);
	      *res++ = val;
	    }
	  break;
	case 'd' :  MGET(double,swapd);
	  break;
	case 'f' :  MGET(float,swapf);
	  break;
	case 'u' :
	  switch ( type[1] )
	    {
	    case 'b' :
	      switch ( type[2] )
		{
		case 'l' :
		  /* Read long, big-endian: big end first. 
		     68000/SPARC style. */
		  for ( i=0; i< *n; i++) 
		    {
		      unsigned long val;
		      val = rblong(ft);
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
		      *res++ = val;
		    }
		  break;
		}
	      break;
	    case 'l' : 
	      c = ( strlen(type) > 3 ) ? type[2] : ' ';
	      switch ( type[2] )
		{
		case 'l' :
		  /* Read long, little-endian: little end first. 
		     VAX/386 style.*/
		  for ( i=0; i< *n; i++) 
		      {
			unsigned long val;
			val = rllong(ft);
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
		  fread(&val,sizeof(unsigned char),1,fa);
		  *res++ = val;
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

void C2F(mgetstr) (fd,start,n,ierr)
     char **start;
     integer *ierr,*n,*fd;
{ 
  int i,count;
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

