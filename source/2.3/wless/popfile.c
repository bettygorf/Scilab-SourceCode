/*------------------------------------------
   POPFILE.C -- Popup Editor File Functions
  ------------------------------------------*/

#include <windows.h>
#include <commdlg.h>
#include <stdlib.h>
#include <stdio.h>

#include "poppad.h"

static OPENFILENAME ofn ;

void PopFileInitialize (HWND hwnd)
     {
     static char szFilter[] = "Text Files (*.TXT)\0*.txt\0"  \
                              "ASCII Files (*.ASC)\0*.asc\0" \
                              "All Files (*.*)\0*.*\0\0" ;

     ofn.lStructSize       = sizeof (OPENFILENAME) ;
     ofn.hwndOwner         = hwnd ;
     ofn.hInstance         = NULL ;
     ofn.lpstrFilter       = szFilter ;
     ofn.lpstrCustomFilter = NULL ;
     ofn.nMaxCustFilter    = 0 ;
     ofn.nFilterIndex      = 0 ;
     ofn.lpstrFile         = NULL ;          // Set in Open and Close functions
     ofn.nMaxFile          = _MAX_PATH ;
     ofn.lpstrFileTitle    = NULL ;          // Set in Open and Close functions
     ofn.nMaxFileTitle     = _MAX_FNAME + _MAX_EXT ;
     ofn.lpstrInitialDir   = NULL ;
     ofn.lpstrTitle        = NULL ;
     ofn.Flags             = 0 ;             // Set in Open and Close functions
     ofn.nFileOffset       = 0 ;
     ofn.nFileExtension    = 0 ;
     ofn.lpstrDefExt       = "txt" ;
     ofn.lCustData         = 0L ;
     ofn.lpfnHook          = NULL ;
     ofn.lpTemplateName    = NULL ;
     }

BOOL PopFileOpenDlg (HWND hwnd, PSTR pstrFileName, PSTR pstrTitleName)
{
  ofn.hwndOwner         = hwnd ;
  ofn.lpstrFile         = pstrFileName ;
  ofn.lpstrFileTitle    = pstrTitleName ;
  ofn.Flags             = OFN_HIDEREADONLY | OFN_CREATEPROMPT ;

  return GetOpenFileName (&ofn) ;
}

BOOL PopFileSaveDlg (HWND hwnd, PSTR pstrFileName, PSTR pstrTitleName)
{
  ofn.hwndOwner         = hwnd ;
  ofn.lpstrFile         = pstrFileName ;
  ofn.lpstrFileTitle    = pstrTitleName ;
  ofn.Flags             = OFN_OVERWRITEPROMPT ;
  
  return GetSaveFileName (&ofn) ;
}

static long PopFileLength (FILE *file)
     {
     int iCurrentPos, iFileLength ;

     iCurrentPos = ftell (file) ;

     fseek (file, 0, SEEK_END) ;

     iFileLength = ftell (file) ;

     fseek (file, iCurrentPos, SEEK_SET) ;

     return iFileLength ;
     }

BOOL PopFileRead (HWND hwndEdit, PSTR pstrFileName)
     {
       char *p,*q;
     FILE  *file ;
     int    iLength ,count ,i;
     PSTR   pstrBuffer ;
     PSTR   pstrBuffer1 ;
     if (NULL == (file = fopen (pstrFileName, "rb"))) 
          return FALSE ;
     iLength = PopFileLength (file) ;

     if (NULL == (pstrBuffer = (PSTR) malloc (iLength)))
          {
          fclose (file) ;
          return FALSE ;
          }

     fread (pstrBuffer, 1, iLength, file) ;
     fclose (file) ;
     pstrBuffer[iLength] = '\0' ;
     count = 0;
     for ( i= 0 ; i < iLength ; i++) 
       {
	 if (pstrBuffer[i] == '\n' ) count++;
       }
     if ( count != 0 ) 
       {
	 iLength += count;
	 if (NULL == (pstrBuffer1 = (PSTR) malloc (iLength)))
	   return FALSE ;
	 p = pstrBuffer1;
	 q = pstrBuffer;
	 while ( *q != '\0') 
	   {
	     if ( *q == '\n' )
	       {
		 if ( q== pstrBuffer || ( q!= pstrBuffer && *(q-1) != '\r'))
		   {
		     *p = '\r'; p++;
		   }
	       }
	     *p++ = *q++;
	   }
       }
     *p = '\0';
     SetWindowText (hwndEdit, pstrBuffer1) ;
     free (pstrBuffer) ;
     free (pstrBuffer1) ;

     return TRUE ;
     }

BOOL PopFileWrite (HWND hwndEdit, PSTR pstrFileName)
     {
     FILE  *file ;
     int    iLength ;
     PSTR   pstrBuffer ;

     if (NULL == (file = fopen (pstrFileName, "wb")))
          return FALSE ;

     iLength = GetWindowTextLength (hwndEdit) ;

     if (NULL == (pstrBuffer = (PSTR) malloc (iLength + 1)))
          {
          fclose (file) ;
          return FALSE ;
          }

     GetWindowText (hwndEdit, pstrBuffer, iLength + 1) ;

     if (iLength != (int) fwrite (pstrBuffer, 1, iLength, file))
          {
          fclose (file) ;
          free (pstrBuffer) ;
          return FALSE ;
          }

     fclose (file) ;
     free (pstrBuffer) ;

     return TRUE ;
     }
