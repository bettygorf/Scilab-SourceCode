/* Copyright INRIA */
/*------------------------------------------
   POPFONT.C -- Popup Editor Font Functions
  ------------------------------------------*/

#include <windows.h>
#include <commdlg.h>

extern LPSTR GetInt(LPSTR str, LPINT pval);
static LOGFONT logfont ;
static HFONT   hFont ;

static int ReadFont = 0;


BOOL PopFontChooseFont (HWND hwnd)
     {
     CHOOSEFONT cf ;

     cf.lStructSize      = sizeof (CHOOSEFONT) ;
     cf.hwndOwner        = hwnd ;
     cf.hDC              = NULL ;
     cf.lpLogFont        = &logfont ;
     cf.iPointSize       = 0 ;
     cf.Flags            = CF_INITTOLOGFONTSTRUCT | CF_SCREENFONTS
                                                  | CF_EFFECTS ;
     cf.rgbColors        = 0L ;
     cf.lCustData        = 0L ;
     cf.lpfnHook         = NULL ;
     cf.lpTemplateName   = NULL ;
     cf.hInstance        = NULL ;
     cf.lpszStyle        = NULL ;
     cf.nFontType        = 0 ;               // Returned from ChooseFont
     cf.nSizeMin         = 0 ;
     cf.nSizeMax         = 0 ;

     return ChooseFont (&cf) ;
     }

static  LPSTR file = "scilab.ini";
static  LPSTR section = "HELP";

void WriteFIni()
{
  char profile[80];
  wsprintf(profile, "%d %d", logfont.lfHeight,logfont.lfWidth);
  WritePrivateProfileString(section, "HelpFWH", profile, file);
  wsprintf(profile, "%d %d", logfont.lfItalic,logfont.lfWeight);
  WritePrivateProfileString(section, "HelpFIW", profile, file);
  wsprintf(profile, "%s",logfont.lfFaceName);
  WritePrivateProfileString(section, "HelpFName", profile, file);
  return;
}

void ReadFIni()
{
  char profile[81];
  int x,y;
  LPSTR p;
  GetPrivateProfileString(section, "HelpFWH", "", profile, 80, file);
  if ( (p = GetInt(profile, &x)) != NULL && (p = GetInt(p, &y)) != NULL) 
    {
      logfont.lfHeight=x;logfont.lfWidth=y;
      ReadFont=1;
    }
  GetPrivateProfileString(section, "HelpFIW", "", profile, 80, file);
  if ( (p = GetInt(profile, &x)) != NULL && (p = GetInt(p, &y)) != NULL) 
    {
     logfont.lfItalic=x;
     logfont.lfWeight=y;
     ReadFont=1;
    }
  GetPrivateProfileString(section, "HelpFName", "", profile, 80, file);
  if ( profile[0] != 0 )
    strcpy(logfont.lfFaceName,profile);
}


void PopFontInitialize (HWND hwndEdit)
     {
       ReadFIni();
       if ( ReadFont == 0) 
	 {
	   GetObject (GetStockObject (SYSTEM_FONT), sizeof (LOGFONT),
		      (PSTR) &logfont) ;
	 }
     hFont = CreateFontIndirect (&logfont) ;
     SendMessage (hwndEdit, WM_SETFONT, (WPARAM) hFont, 0) ;
     }

void PopFontSetFont (HWND hwndEdit)
     {
     HFONT hFontNew ;
     RECT  rect ;
     hFontNew = CreateFontIndirect (&logfont) ;
     WriteFIni();
     SendMessage (hwndEdit, WM_SETFONT, (WPARAM) hFontNew, 0) ;
     DeleteObject (hFont) ;
     hFont = hFontNew ;
     GetClientRect (hwndEdit, &rect) ;
     InvalidateRect (hwndEdit, &rect, TRUE) ;
     }

void PopFontDeinitialize (void)
     {
     DeleteObject (hFont) ;
     }
