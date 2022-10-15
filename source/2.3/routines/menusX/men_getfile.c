#ifdef WIN32 
#include "wmen_scilab.h"
#else
#include "men_scilab.h"
#endif

/*************************************************     
 * test function 
 **********************************************************/

#define MAXSTRGETF 256

int TestGetFile() 
{
  int ierr=0;
  static char *init ="*.sci";
  char * res;
  res = (char *) MALLOC((MAXSTRGETF+1)*sizeof(char));
  if ( res  == (char*)0 ) 
    {
      Scistring("Malloc : No more place");
      ierr = 1;
    }
  return(GetFileWindow(init,&res,".",0,&ierr));
  
}

/****************************************************
 * Scilab getfile Menu
 * interface with scilab 
 **********************************************************/
     
void C2F(xgetfile)(filemask,dirname,res,ires,ierr,rhs)
     char *filemask,**res,*dirname;
     integer *ierr,*ires,*rhs;
{
  int flag=0,rep;
  *ierr = 0;
  if ( *rhs == 2) flag =1 ;
  rep = GetFileWindow(filemask,res,dirname,flag,ierr);
  if ( *ierr >= 1 || rep == FALSE )
    {
      *ires = 0 ;
      return;
    }
  else 

    {
      *ires=strlen(*res);
    }
}



