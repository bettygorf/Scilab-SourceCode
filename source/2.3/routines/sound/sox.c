/*
 * Modified code from sox for Scilab to read/write 
 * wav files 
 *
 * July 5, 1991
 * Copyright 1991 Lance Norskog And Sundry Contributors
 * This source code is freely redistributable and may be used for
 * any purpose.  This copyright notice must be maintained. 
 * Lance Norskog And Sundry Contributors are not responsible for 
 * the consequences of using this software.
 * 
 */

#include "st.h"
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctype.h>
#include <errno.h>

#include "../machine.h"

#define Abs(x) ( ( (x) >= 0) ? (x) : -( x) )

struct soundstream informat;
ft_t ft;


C2F(loadwave)(filename,res,size_res,ierr)
     char *filename;
     double *res;
     integer *ierr,*size_res;
{
  double maxi,sum;
  long buf[BUFSIZ], i,size_max;
  int e, f, havedata,olen;
  double *res1;
  *ierr=0;
  init();
  /* Get input format options */
  ft = &informat;
  ft->ierr=*ierr;
  /* Get input file */
  if ((ft->fp = fopen(filename, READBINARY)) == NULL)
    {
      sciprint("Can't open input file '%s': %s\r\n", 
	   filename, strerror(errno));
      *ierr=1;
      return;
    }
  ft->filename = filename;
#if defined(DOS) || defined(__OS2__) || defined(WIN32) || defined (__MWERKS__)
  informat.seekable  = 1;
#else
  informat.seekable  = (filetype(fileno(informat.fp)) == S_IFREG);
#endif
  informat.comment = informat.filename;

  /* Read and write starters can change their formats. */
  wavstartread(&informat);
  if ( ft->ierr > 0 ) 
    {
      return;
    }
  checkformat(&informat);
  if ( ft->ierr > 0 ) 
    {
      return;
    }
  sciprint("Input file: using sample rate %lu\r\n\tsize %s, style %s, %d %s\r\n",
	 informat.info.rate, sizes[informat.info.size], 
	 styles[informat.info.style], informat.info.channels, 
	 (informat.info.channels > 1) ? "channels" : "channel");
  
  /* read chunk */
  size_max = *size_res ; 
  *size_res  = 0;
  olen = 1;
  res1=res;
  while ( olen > 0 )
    {
      olen = wavread(&informat,buf, (long) BUFSIZ);
      if ( ft->ierr > 0 ) 
	{
	  return;
	}
      *size_res += olen ;
      if ( *size_res > size_max ) 
	{
	  sciprint(" Sorry wav file too big \r\n");
	  return;
	}
      for ( i = 0 ; i < olen ; i++ ) 
	{
	  *res1++ = buf[i];
	}
    }
  
  fclose(informat.fp);
  /** centering data **/

  sum = 0.0;
  for ( i = 0 ; i < *size_res ; i++ ) 
    {
      sum += res[i];
    }
  sum /= (*size_res);
  for ( i = 0 ; i < *size_res ; i++ ) 
    {
      res[i] -= sum ;
    }
  maxi= res[0];
  for ( i = 0 ; i < *size_res ; i++ ) 
    {

      if ( Abs(res[i]) > maxi ) maxi = Abs(res[i]);
    }
  for ( i = 0 ; i < *size_res ; i++ ) 
    {
      res[i] /=  maxi;
    }
  *ierr= ft->ierr;
}

C2F(savewave)(filename,res,rate,size_res,ierr)
     char *filename;
     double *res;
     integer *ierr,*size_res,*rate ;
{
  long buf[BUFSIZ];
  long i,size_max;
  int e, f, havedata,olen,count;
  double maxi,sum,m,*loc;
  *ierr=0;
  init();
  /* Get input format options */
  ft = &informat;
  ft->ierr=*ierr;
  /* Get input file */
  if ((ft->fp = fopen(filename, WRITEBINARY)) == NULL)
    {
      sciprint("Can't open output file '%s': %s\r\n", 
	   filename, strerror(errno));
      *ierr=1;
      return;
    }

  ft->filename = filename;
#if defined(DOS) || defined(__OS2__) || defined(WIN32) || defined (__MWERKS__)
  informat.seekable  = 1;
#else
  informat.seekable  = (filetype(fileno(informat.fp)) == S_IFREG);
#endif
  informat.comment = informat.filename;

  
  /* changing the formats. */
  informat.info.size = WORD;
  informat.info.rate = *rate ;
  informat.info.style = SIGN2;
  informat.info.channels =1;

  m=res[0];
  for ( i = 0 ; i < *size_res ; i++) 
    {
      if ( Abs(res[i]) > m ) m = Abs(res[i]);
    }
  
  wavstartwrite(&informat);
  if ( ft->ierr > 0 ) 
    {
      *ierr= ft->ierr;
      cleanup();
      return;
    }
  /* read chunk */
  size_max = *size_res ; 
  *size_res  = 0;
  count = 0 ;
  loc= res;
  while ( count < size_max ) 
    {
      double x;
      long int len, num;
      len = count + BUFSIZ;
      len = ( len > size_max ) ? size_max : len;
      for ( i = count ; i < len   ; i++ ) 
	{
	  /* x= v/m*2**(31-1); */
	  x= (*loc++)/m*2147483647;
	  buf[i-count ] = (long) x;
	}
      num = len - count ;
      wavwrite(&informat,buf, num );
      if ( ft->ierr > 0 ) 
	{
	  *ierr= ft->ierr;
	  cleanup();
	  return;
	}
      count = len;
    }
  wavstopwrite(&informat);
  fclose(informat.fp);
  res[0] = ((double)(size_max))/((double) (*rate));
  *ierr= ft->ierr;

}

init() {
  /* init files */
  informat.info.rate      = 0;
  informat.info.size      = -1;
  informat.info.style     = -1;
  informat.info.channels  = -1;
  informat.comment   = NULL;
  informat.swap      = 0;
  informat.filetype  = "wav";
  informat.fp        = stdin;
  informat.filename  = "input";
}

/* 
 * Process input file -> effect table -> output file
 *	one buffer at a time
 */

#if	defined(unix) || defined(AMIGA) || defined(ARM) || defined(aix)
filetype(fd)
int fd;
{
  struct stat st;
  fstat(fd, &st);
  return st.st_mode & S_IFMT;
}
#endif

/* called from util.c:fail */

cleanup() 
{
  if (informat.fp)
    fclose(informat.fp);
}

/* check that all settings have been given */

checkformat(ft) 
     ft_t ft;
{
  if (ft->info.rate == 0)
    {
      sciprint("Sampling rate for %s file was not given\r\n", ft->filename);
      ft->ierr=1;
      return;
    }
  if ((ft->info.rate < 100) || (ft->info.rate > 50000))
    {
      sciprint("Sampling rate %lu for %s file is bogus\r\n", 
	   ft->info.rate, ft->filename);
      ft->ierr=1;
      return;
    }

  if (ft->info.size == -1)
    {
      sciprint("Data size was not given for %s file\r\n", ft->filename);
      ft->ierr=1;
      return;
    }
  if (ft->info.style == -1 && ft->info.size != FLOAT)
    {
      sciprint("Data style was not given for %s file\r\n", ft->filename);
      ft->ierr=1;
      return;
    }
  /* it's so common, might as well default */
  if (ft->info.channels == -1)
    ft->info.channels = 1;
}



