# version for Visual C++
#------------------------

all::

MAKE=nmake /f Makefile.mak

#---------------------
# Scilab tksci library 
#---------------------
# To compile with TCL/TK interface, uncomment the following lines and give
# the good pathnames for TKLIBS and TCL_INCLUDES.
TKSCI=libs/tksci.lib 
TKLIBS=d:\tcl8.0\win\tcl80.lib d:\tk8.0\win\tk80.lib
TCL_INCLUDES=-Id:\tcl8.0\generic -Id:\tk8.0\generic -Id:\tk8.0\xlib
DTK=-DWITH_TK
#---------------------
# Scilab pvm library
#---------------------
# To compile with PVM interface, uncomment the following lines and give
# the good pathname for PVM_ROOT.
#
#PVM=libs/pvm.lib 
#PVM_ROOT=d:\scilab-2.4\pvm3
#PVM_ARCH=WIN32
#PVMLIB=$(PVM_ROOT)\lib\WIN32\libpvm3.lib $(PVM_ROOT)\lib\WIN32\libgpvm3.lib 
#PVM_INCLUDES=-I$(PVM_ROOT)/src
#DPVM=-DWITH_PVM
#
# YES if we compile the PVM given with Scilab else NO
#DLPVM=YES
#--------------------------
# to generate blas symbols compatible with 
# intel blas library 
#--------------------------
#DMKL=-DMKL
#---------------------
# C compiler
# typically, for compiling use: CFLAGS = $(CC_OPTIONS)
# and for linking: $(CC) -o $(PROGRAM) $(OBJS) $(CC_LDFLAGS)
#---------------------
CC=cl
LINKER=link
# debug option for the linker 
LINKER_FLAGS=/NOLOGO /DEBUG /Debugtype:cv /machine:ix86
# standard option for the linker 
LINKER_FLAGS=/NOLOGO /machine:ix86
INCLUDES=-I../f2c $(TCL_INCLUDES) $(PVM_INCLUDES)
# compiler flags 
CC_COMMON=-D__MSC__ -DWIN32 -c -DSTRICT -nologo $(INCLUDES) $(DTK) $(DPVM) $(DMKL) -MT
# debug 
CC_OPTIONS =  $(CC_COMMON) -Z7 -W3 -Od 
# standard option (optimization does not work)
CC_OPTIONS = $(CC_COMMON) -Od  -GB -Gd -W3
CC_LDFLAGS = 
#--------------------
# resource compiler 
#--------------------
RC=rc
RCVARS=-r -DWIN32
#--------------------
# Libraries 
#--------------------
GUIFLAGS=-SUBSYSTEM:console
GUILIBS=comctl32.lib wsock32.lib shell32.lib winspool.lib user32.lib gdi32.lib comdlg32.lib kernel32.lib advapi32.lib 

#XLIBS=$(TKLIBS) $(PVMLIB) $(GUILIBS) libc.lib 
XLIBS=-NODEFAULTLIB:libc.lib $(TKLIBS) $(PVMLIB) $(GUILIBS) libcmt.lib oldnames.lib

.c.obj	:
	@echo ------------- Compile file $< --------------
	$(CC) $(CFLAGS) $< 

#--------------------
# RM only exists if gcwin32 is installed 
#----------------------------------

RM = rm -f 

#--------------------
# clean 
#----------------------------------

clean::
	@del *.CKP 
	@del *.ln 
	@del *.BAK 
	@del *.bak 
	@del core 
	@del errs 
	@del *~ 
	@del *.a 
	@del .emacs_* 
	@del tags 
	@del TAGS 
	@del make.log 

distclean:: clean 
