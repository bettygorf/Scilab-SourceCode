/* SCILAB - win/wgetfile.c 
 *   Jean-Philippe Chancelier 
 * A terminer 
 * Le pathname doit etre donne a la mode Windows95 
 * Il faut pouvoir le convertir a l'envers 
 */

#include "wmen_scilab.h"

/** #define MAXSTR 256 **/

/*************************************************     
 * Really Ugly I'm ashamed 
 * The main function to activate the file menu 
 **********************************************************/

int GetFileWindow(filemask,szFile,dirname,flag,ierr)
     char *filemask,*dirname,**szFile;
     int flag,*ierr;
{
  int rep,i;
  OPENFILENAME ofn;
  char *szTitle;
  char *szFileTitle;
  char *szFilter;
  if ( (szTitle = LocalAllocPtr(LPTR, MAXSTR+1)) == (char *)NULL 
       || (szFileTitle = LocalAllocPtr(LPTR, MAXSTR+1)) == (char *)NULL
       || (szFilter = LocalAllocPtr(LPTR, MAXSTR+1)) == (char *)NULL )
    {
      Scistring("Malloc : No more place");
      *ierr = 1;
      return(1);
    }
  *szFile = (char *) MALLOC((MAXSTR+1)*sizeof(char));
  if ( *szFile == (char*)0 ) 
    {
      Scistring("Malloc : No more place");
      *ierr = 1;
      return(1);
    }
  strncpy(szTitle,"Choose File name",MAXSTR);
  strcpy(szFilter,"Default (");
  strcat(szFilter,filemask);
  strcat(szFilter,")");
  i=strlen(szFilter);
  i++;	/* move past NULL */
  strcpy(szFilter+i,filemask);
  i+=strlen(szFilter+i);
  i++;	/* move past NULL */
  strcpy(szFilter+i,"All Files (*.*)");
  i+=strlen(szFilter+i);
  i++;	/* move past NULL */
  strcpy(szFilter+i,"*.*");
  i+=strlen(szFilter+i);
  i++;	/* move past NULL */
  szFilter[i++]='\0';	/* add a second NULL */
  rep = TRUE;
  (*szFile)[0] = '\0';
  /* clear the structrure */
  memset(&ofn, 0, sizeof(OPENFILENAME));
  ofn.lStructSize = sizeof(OPENFILENAME);
  ofn.hwndOwner = textwin.hWndParent;
  ofn.lpstrFilter = szFilter;
  ofn.nFilterIndex = 1;
  ofn.lpstrFile = *szFile;
  ofn.nMaxFile = MAXSTR;
  ofn.lpstrFileTitle = szFileTitle;
  ofn.nMaxFileTitle = MAXSTR;
  ofn.lpstrTitle = szTitle;
  if ( flag==1) 
    ofn.lpstrInitialDir = dirname;
  else
    ofn.lpstrInitialDir = (LPSTR)NULL;
  ofn.Flags = OFN_SHOWHELP | OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST;
  rep = GetSaveFileName(&ofn);
  FREE(szTitle);
  FREE(szFilter);
  FREE(szFileTitle);
  return(rep);
}

