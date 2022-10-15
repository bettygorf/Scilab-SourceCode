/*
  Simple program to start Scilab with its console window hidden.
  This program is provided purely for convenience, since most users will
  use Scilab in windowing (GUI) mode, and will not want to have an extra
  console window lying around.  

  This file was adapted from runemacs.c ( emacs distribution )

*/

#ifndef WIN32 
#define WIN32
#endif 

#include <windows.h>
#include <string.h>
#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif 

#ifdef __MSC__
#define putenv(x) _putenv(x)
#endif 

int WINAPI
WinMain (HINSTANCE hSelf, HINSTANCE hPrev, LPSTR cmdline, int nShow)
{
  STARTUPINFO start;
  SECURITY_ATTRIBUTES sec_attrs;
  PROCESS_INFORMATION child;
  int wait_for_child = FALSE;
  DWORD ret_code = 0;
  char *new_cmdline;
  char *p;
  char modname[MAX_PATH+1];

  if (!GetModuleFileName (NULL, modname+1, MAX_PATH))
    goto error;
  if ((p = strrchr (modname+1, '\\')) == NULL)
    goto error;
  *p = 0;

  new_cmdline = alloca (MAX_PATH + strlen (cmdline) + 1);
  strcpy (new_cmdline, modname+1);
  strcat (new_cmdline, "\\scilex.exe ");

  /* Append original arguments if any; first look for -wait as first
     argument, and apply that ourselves.  */
  if (strncmp (cmdline, "-wait", 5) == 0)
    {
      wait_for_child = TRUE;
      cmdline += 5;
    }
  strcat (new_cmdline, cmdline);
  memset (&start, 0, sizeof (start));
  start.cb = sizeof (start);
  start.dwFlags = STARTF_USESHOWWINDOW;
  start.wShowWindow = SW_HIDE;
  /** start.wShowWindow = SW_SHOWMINIMIZED; **/

  sec_attrs.nLength = sizeof (sec_attrs);
  sec_attrs.lpSecurityDescriptor = NULL;
  sec_attrs.bInheritHandle = FALSE;

  if (CreateProcess (NULL, new_cmdline, &sec_attrs, NULL, TRUE, 0,
		     NULL, NULL, &start, &child))
    {
      if (wait_for_child)
	{
	  WaitForSingleObject (child.hProcess, INFINITE);
	  GetExitCodeProcess (child.hProcess, &ret_code);
	}
      CloseHandle (child.hThread);
      CloseHandle (child.hProcess);
    }
  else
    goto error;
  return (int) ret_code;

error:
  MessageBox (NULL, "Could not start Scilab.", "Error", MB_ICONSTOP);
  return 1;
}


