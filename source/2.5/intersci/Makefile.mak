SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl.mak

# just add -DEPSFIG 
# il you prefer epsfig to special to insert postscript files in LaTeX 

CFLAGS = $(CC_OPTIONS)

all:: ..\bin\intersci.exe

world: all

..\bin\intersci.exe: intersci.obj
	@$(LINKER) -SUBSYSTEM:console -OUT:"$@" intersci.obj $(GUILIBS)

clean::
	@del intersci.obj

distclean:: clean 
	@del ..\bin\intersci.exe
