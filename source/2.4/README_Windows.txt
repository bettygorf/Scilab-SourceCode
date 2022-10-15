		Scilab version 2.4 for Windows (NT/95)
                **************************************
			      12 July 1998

******************************************************************************

0 - COPYRIGHT NOTICE
********************

Scilab is free software. It can be used both in academia and in industry
free of charge.

To use Scilab, you should fill out and return the end of the file notice.tex 
or notice.ps (postscript file). You may email to Scilab@inria.fr.

******************************************************************************
I - TO RUN SCILAB (BINARY VERSION)
**********************************

   1 - You have already installed Scilab by executing "scilab24.exe".
       By default Scilab is in "C:\Program Files\Scilab-2.4" directory.

   2 - Run Scilab by executing "Scilab" from the startup menu.
       In fact, it is a link to "runscilab.exe" in Scilab subdirectory "bin", 
       so you can run Scilab by executing directly "runscilab.exe".

   3 - Scilab has been compiled with Visual C++ 5.0 (see III below).
       All examples of incremental link given with Scilab are prepared
       for Visual C++.

   4 - If you have any problem or suggestion to improve Scilab
       send an email to:
       
                          Scilab@inria.fr

       or better post a message to newsgroup:

		      comp.soft-sys.math.scilab

******************************************************************************
II - TO CUSTOMIZE SCILAB FONTS, WINDOW SIZE and SCILAB MENUS 
************************************************************

	When you enter Scilab for the first time the window may be too
	large and the fonts not properly choosen.  Just change this
	with mouse and menus (right mouse click in the scilab window)
	and use the "Update scilab.ini" menu to save your changes. The
	behavior is the same for graphics windows.
	
	For the popup help, just change the size and it will keep it for 
	the next calls.

	You can also edit the files "bin/wscilab.mnu" and
	"bin/wgscilab.mnu" to customize the Scilab menus. It's quite
	easy to change them.

******************************************************************************
III - TO COMPILE SCILAB FROM A SOURCE VERSION
*********************************************

   We have compiled this distribution with Visual C++ 5.0. It is
   possible to compile it with egcs or Cygwin compiler but the
   incremental link does not work yet.

   1 - To compile with Visual C++ 4.0 or 5.0, edit the beginning of the 
       file "Makefile.incl.mak". Then type "nmake /f Makefile.mak".

       If you want to compile with TCL/TK interface, you need to uncomment
       the corresponding lines in "Makefile.incl.mak". You also need to
       modify the Makefiles of TCL/TK distribution and recompile it:
       in files "tcl8.0\win\makefile.vc" and "tk8.0\win\makefile.vc" replace 
       the line
       "libcdll = msvcrt.lib oldnames.lib" by
       "libcdll = libcmt.lib oldnames.lib"and the line
       "cvarsdll   = $(cvarsmt) -D_DLL" by
       "cvarsdll   = $(cvarsmt)".

       If you want to compile with PVM interface, you need to uncomment
       the corresponding lines in "Makefile.incl.mak". You also need to modify
       the pathnames of the compiler in the file "conf/WIN32.def".
       Note that at the present time, PVM interface does not work on Windows.

   2 - To compile with egcs or Cygwin compiler, type "./configure" and then
       "make all".

******************************************************************************
			       THAT'S ALL FOLKS
******************************************************************************

