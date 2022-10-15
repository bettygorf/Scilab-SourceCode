SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) $(XFLAGS)

OBJS =  poppad.obj popfile.obj popfind.obj popfont.obj popprnt.obj 

all:: $(SCIDIR)/bin/xless.exe
world: all

RESOURCES= rpoppad.res 

$(SCIDIR)/bin/xless.exe: $(OBJS) $(RESOURCES)
	@echo Linking ../bin/xless.exe
	@$(LINKER) -nologo -SUBSYSTEM:windows -OUT:"../bin/xless.exe" $(OBJS) \
	$(RESOURCES)  $(GUILIBS)
	@echo Linking done

clean::
	$(RM) $(OBJS) 

distclean::
	$(RM) $(OBJS) $(SCIDIR)/bin/xless $(RESOURCES)

rpoppad.res : rpoppad.rc poppad.h poppad.ico
	$(RC) $(RCVARS) /forpoppad.res rpoppad.rc



