SHELL = /bin/sh
SCIDIR=../..

OBJSC = winDumpExts.obj 

OBJSF = 

include ../../Makefile.incl.mak
CFLAGS = $(CC_OPTIONS) 
FFLAGS = $(FC_OPTIONS)

GUIFLAGS=-SUBSYSTEM:console

#=================== dumpexts.exe ===========================

all:: ../../bin/dumpexts.exe

../../bin/dumpexts.exe 	:  winDumpExts.obj 
	$(LINKER) -SUBSYSTEM:console -OUT:"../../bin/dumpexts.exe" winDumpExts.obj \
	$(RESOURCES) $(GUILIBS)




