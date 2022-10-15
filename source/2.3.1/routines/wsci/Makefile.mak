SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/wsci.lib

OBJSC1 =wtext.obj wgnuplib.obj wmenu.obj wprinter.obj wpause.obj wgraph.obj winmain.obj \
	wmhelp.obj wgmenu.obj wstatbar.obj gvwprn.obj wmprint.obj wmtex.obj

OBJSC2 =readwin.obj wtloop.obj misc.obj \
	command.obj readcons.obj x_zzledt.obj jpc_Xloop.obj sh.obj

OBJSC = $(OBJSC1) $(OBJSC2)

OBJSF = 

include ../../Makefile.incl.mak
CFLAGS = $(CC_OPTIONS) 
FFLAGS = $(FC_OPTIONS)

include ../Make.lib.mak

#================== dependencies 

wgraph.obj : ../graphics/periWin-bcg.h
wmhelp.obj : ../sun/h_help.h ../graphics/periWin-bcg.h ../machine.h
$(OBJSC) : wgnuplib.h

#================= resources 

RESOURCES= Rscilab.res

all	:: $(RESOURCES) 

Rscilab.res: Rscilab.rc wresource.h
	$(RC) $(RCVARS) /foRscilab.res Rscilab.rc

GUIFLAGS=-SUBSYSTEM:console

#===================test ========================

test	: $(RESOURCES) wtest.obj ../../libs/wsci.a
	$(LINKER) $(GUIFLAGS) -OUT:"../../bin/test-vc.exe" wtest.obj \
	$(RESOURCES) ../../libs/wsci.lib ../../libs/graphics.lib \
	../../libs/wsci.lib ../../libs/menusX.lib \
	../../libs/sun.lib ../../libs/system.lib ../../libs/xdr.lib  $(GUILIBS)

wtest.obj : wtloop.c 

#=================== lpr ===========================

all:: ../../bin/lpr.exe

../../bin/lpr.exe 	: lpr.obj
	$(LINKER) -SUBSYSTEM:console -OUT:"../../bin/lpr.exe" lpr.obj \
	$(RESOURCES) $(GUILIBS)

lpr.obj : gvwprn.c 

#=================== runscilab========================

RUNRESOURCES= Rscilab.res

all:: ../../bin/runscilab.exe

../../bin/runscilab.exe: runscilab.c  $(RUNRESOURCES) 
	rm -f runscilab.obj 
	$(CC) $(CFLAGS) -DTEST runscilab.c 	
	$(LINKER) -SUBSYSTEM:windows -OUT:"../../bin/runscilab.exe" \
	runscilab.obj $(RESOURCES) $(GUILIBS) 

# resources 

all	:: $(RUNRESOURCES) 

Rrunscilab.res: Rrunscilab.rc 
	$(RC) $(RCVARS) /foRrunscilab.res Rrunscilab.rc

readcons.obj	: readline.c wtextc.h 
readgcwin.obj	: readline.c 
readwin.obj 	: readline.c




