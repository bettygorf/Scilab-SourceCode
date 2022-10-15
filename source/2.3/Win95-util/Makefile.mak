SHELL = /bin/sh
SCIDIR=../
include ../Makefile.incl.mak
CFLAGS = $(CC_OPTIONS)
TESTLIBS= -lcomctl32  -lwsock32 -lshell32 -lwinspool -luser32 -lgdi32 -lcomdlg32 
RESOURCES= Rscilab.res

all:: ../bin/runscilab.exe

../bin/runscilab.exe: runscilab.c  $(RESOURCES) 
	rm -f runscilab.obj 
	$(CC) $(CFLAGS) -DTEST runscilab.c 	
	$(LINKER) $(GUIFLAGS) -OUT:"../bin/runscilab.exe" runscilab.obj \
	$(RESOURCES) $(GUILIBS) 


# resources 



all	:: $(RESOURCES) 

Rscilab.res: Rscilab.rc 
	$(RC) $(RCVARS) /foRscilab.res Rscilab.rc



