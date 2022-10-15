SHELL = /bin/sh
SCIDIR=../

all:: Lib.exe Name.exe
	Makesubdirs.bat all

distclean::
	Makesubdirs.bat distclean 

clean::
	Makesubdirs.bat clean 

include ../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) 
FFLAGS = $(FC_OPTIONS)

OBJS = Lib.obj Name.obj 

clean ::
	$(RM) $(OBJS)

distclean::
	$(RM) $(OBJS) 


Lib.exe	: Lib.c 
	$(CC) $(CFLAGS) $*.c 	
	$(LINKER) -SUBSYSTEM:console -OUT:"Lib.exe" Lib.obj 

Name.exe: Name.c 
	$(CC) $(CFLAGS) $*.c 	
	$(LINKER) -SUBSYSTEM:console -OUT:"Name.exe" Name.obj 






