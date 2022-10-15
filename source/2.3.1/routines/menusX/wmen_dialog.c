/***********************************************
 * wmdialog.c / Scilab
 *   Jean-Philippe Chancelier 
 *   Bugs and mail : Scilab@inria.fr 
 ***********************************************/

#include "wmen_scilab.h"

extern SciDialog ScilabDialog;

/****************************************************
 * Event handler function for the line style window 
 * uses GetWindowLong(hwnd, 4) and SetWindowLong
 ****************************************************/

EXPORT int CALLBACK 
SciDialogDlgProc(HWND hdlg, UINT wmsg, WPARAM wparam, LPARAM lparam)
{
  
  switch (wmsg) {
  case WM_INITDIALOG:
    SetDlgItemText(hdlg, DI_TIT, ScilabDialog.description);
    SetDlgItemText(hdlg, DI_TEXT,ScilabDialog.init);
    SetDlgItemText(hdlg, IDOK,ScilabDialog.pButName[0]);
    SetDlgItemText(hdlg, IDCANCEL,ScilabDialog.pButName[1]);
    return TRUE;
  case WM_COMMAND:
    switch (LOWORD(wparam)) {
    case IDOK:
      GetDlgItemText(hdlg, DI_TEXT, dialog_str, MAXSTR-1);
      if (dialog_str[strlen(dialog_str)-1] == '\n') 
	dialog_str[strlen(dialog_str)-1] = '\0' ;
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
 * Activate the Line Style Dialog box window 
 * GetWindowLong(hwnd, 4) must be available for use 
 ****************************************************/

int  DialogWindow()
{
  DLGPROC lpfnSciDialogDlgProc ;
  lpfnSciDialogDlgProc = (DLGPROC) MyGetProcAddress("SciDialogDlgProc",
						    SciDialogDlgProc);
  if (DialogBox(hdllInstance, "SciDialogDlgBox",textwin.hWndParent,
		lpfnSciDialogDlgProc)  == IDOK) 
    return(TRUE);
  else 
    return(FALSE);
}


