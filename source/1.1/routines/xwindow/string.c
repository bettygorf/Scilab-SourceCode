#include "../machine.h"
#include "scilab_d.h"

/*
 *  Converts a Scilab String coded as integer array [ a crazy old feature]
 *  into a C string [ the C string is allocated with maloc ]
 *  this routine calls a Fortran Function.
 *  WARNING : we MUST add a last argument giving the size of p 
 *  when calling the cvstr Fortran routine [ see Fortran compiler 
 *   documentation ]
 */

ScilabStr2C(n,Scistring,strh,ierr)
     int *n,*ierr;
     int *Scistring;
     char **strh;
     
{
  int job=1;
  *strh =(char *) malloc((unsigned) (*n)+1);
  if ((*strh) == NULL)    {*ierr=1;     return;};
  F2C(cvstr)(n,Scistring,*strh,&job,*n);
  (*strh)[*n]='\0';
};

/*
 * Converts a Scilab array of 
 * String coded as integer array [ a crazy old feature]
 * into a C array of strings [ NULL terminated ]
 * as 
 *   char*  items[] = {
 *      "first list entry",
 *      "second list entry",
 *      NULL
 *      };
 *   
 */

ScilabMStr2CM(Scistring,nstring,ptrstrings,strh,ierr)
     int *Scistring,*nstring,*ptrstrings,*ierr;
     char ***strh;
{
  char **strings,*p;
  int li,ni,*SciS,i;
  strings=(char **) malloc((unsigned) ((*nstring)+1)*sizeof(char *));
  if (strings==NULL) {*ierr=1; return;}
  li=1;
  SciS= Scistring;
  for ( i=1 ; i<*nstring+1 ; i++) 
    {
      ni=ptrstrings[i]-li;
      li=ptrstrings[i];
      ScilabStr2C(&ni,SciS,&p,ierr);
      strings[i-1]=p;
      if ( *ierr == 1) return;
      SciS += ni;
    }
  strings[*nstring]=NULL;
  *strh=strings;
};

/*
 * Converts a Scilab array of 
 * String coded as integer array [ a crazy old feature]
 * into a C  string where all the Scilab strings are
 * separated by '\n'
 */


ScilabMStr2C(desc,nd,ptrdesc,strh,ierr)
     int *desc,*nd,*ptrdesc,*ierr;
     char **strh;
{
  int ln,li=1,ni,di=0,*SciS,job=1,i;
  char *description,*p;
  ln=ptrdesc[*nd]+*nd+1;
  description=(char *) malloc((unsigned) ln*sizeof(char));
  if (description==NULL) {*ierr=1; return;}
  SciS= desc;
  for (i=1 ; i<*nd+1 ; i++) 
    {
      p= &(description[di]);
      ni=ptrdesc[i]-li;
      di += ni+1;
      F2C(cvstr)(&ni,SciS,p,&job,ni);
      SciS += ni;
      p[ni]= '\n';
      li=ptrdesc[i];
    };
  description[ln-2]='\0';
  *strh=description;
}


/*
 * Converts a C string containing \n 
 * into a Scilab matrix of String 
 */


ScilabC2MStr2(res,nr,ptrres,str,ierr,maxchars,maxlines)
     int *res,*ptrres,*nr,*ierr,maxchars,maxlines;
     char *str;
{
  int job=0,li=0,ni= -1,n,i;
  *nr=0;
  ptrres[0]=1;
  n=strlen(str);
  if (n <= maxchars) 
    {
      str[n]='\n';
      for (i=0;i < n+1;i++)
	{
	  if(str[i]=='\n') 
	    {
	      ni=i-li;
	      ptrres[*nr+1]=ptrres[*nr]+ni;
	      F2C(cvstr)(&ni,res,&str[li],&job,ni);
	      res+=ni;
	      li += ni+1;
	      ni= -1;
	      *nr += 1;
	      if (*nr>maxlines) { *ierr=3; return;};
	    };
	}
    }
  else  *ierr=2;
}
