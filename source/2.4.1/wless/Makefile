SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl

CFLAGS = $(CC_OPTIONS) $(XFLAGS)
LINKEROPT=-Wl,-subsystem,windows,-S

OBJS =  poppad.o popfile.o popfind.o popfont.o popprnt.o rpoppad.o

all:: $(SCIDIR)/bin/xless

world: all

$(SCIDIR)/bin/xless: $(OBJS) 
	gcc -o $@ $(OBJS) $(LINKEROPT) $(WIN32LIBS)	

clean::
	$(RM) $(OBJS) 

distclean::
	$(RM) $(OBJS) $(SCIDIR)/bin/xless 


rpoppad.res : rpoppad.rc poppad.h poppad.ico
	$(RC) $(RCVARS) -fo rpoppad.res rpoppad.rc

rpoppad.o  : rpoppad.res 
	$(CVTRES)  rpoppad.res rpoppad.o 


