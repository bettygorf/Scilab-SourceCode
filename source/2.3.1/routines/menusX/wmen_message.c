/* wmessage.c
 * Scilab 
 *   Jean-Philipe Chancelier 
 *   Bugs and mail : Scilab@inria.fr 
 */

#include "wmen_scilab.h"

extern SciMess ScilabMessage;

/****************************************************
 * Event handler function for the line style window 
 * uses GetWindowLong(hwnd, 4) and SetWindowLong
 ****************************************************/

EXPORT BOOL CALLBACK 
SciMessageDlgProc(HWND hdlg, UINT wmsg, WPARAM wparam, LPARAM lparam)
{
  
  switch (wmsg) {
  case WM_INITDIALOG:
    SetDlgItemText(hdlg, DI_TEXT,ScilabMessage.string);
    SetDlgItemText(hdlg, IDOK,ScilabMessage.pButName[0]);
    if ( ScilabMessage.nb >= 2) 
      SetDlgItemText(hdlg, IDCANCEL,ScilabMessage.pButName[1]);
    return TRUE;
  case WM_COMMAND:
    switch (LOWORD(wparam)) {
    case IDOK:
      /** GetDlgItemText(hdlg, DI_TEXT, str, MAXSTR-1);
      if (str[strlen(str)-1] == '\n') str[strlen(str)-1] = '\0' ;
      **/
      EndDialog(hdlg, IDOK);
      return TRUE;
    case IDCANCEL:
      EndDialog(hdlg, IDCANCEL);
      return TRUE;
    }
    break;
  }
  return FALSE;
}


/****************************************************
 * Activate the Message Dialog box window 
 ****************************************************/

int  ExposeMessageWindow()
{
  char *buf;
  DLGPROC lpfnSciMessageDlgProc ;
  lpfnSciMessageDlgProc = (DLGPROC) MyGetProcAddress("SciMessageDlgProc",
						    SciMessageDlgProc);
  if ( ScilabMessage.nb == 2) 
    buf = "SciMessageDlgBox2";
  else 
    buf = "SciMessageDlgBox1";
  if (DialogBox(hdllInstance, buf,textwin.hWndParent,
		lpfnSciMessageDlgProc)  == IDOK) 
    return(TRUE);
  else 
    return(FALSE);
}


