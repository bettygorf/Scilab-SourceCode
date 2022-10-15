SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl

CFLAGS = $(CC_OPTIONS) $(XFLAGS)

OBJS = help.o init.o popup.o util.o callbacks.o window.o main.o \
	actions.o functions.o

all:: $(SCIDIR)/bin/xless

world: all

$(SCIDIR)/bin/xless: $(OBJS) $(XAW_LOCAL_LIB)
	$(RM) $@
	$(CC) -o $@ $(OBJS) $(CC_LDFLAGS) $(XLIBS)

clean::
	$(RM) $(OBJS)
distclean::
	$(RM) $(OBJS) $(SCIDIR)/bin/xless

all:: $(SCIDIR)/X11_defaults/xless.help

$(SCIDIR)/X11_defaults/xless.help: xless.help
	$(RM) $@
	cp xless.help $(SCIDIR)/X11_defaults/xless.help

all:: $(SCIDIR)/X11_defaults/XLess

$(SCIDIR)/X11_defaults/XLess : XLess.ad
	$(RM) $@
	cp XLess.ad $(SCIDIR)/X11_defaults/XLess

all:: $(SCIDIR)/X11_defaults/XLess-color

$(SCIDIR)/X11_defaults/XLess-color: XLess-co.ad
	$(RM) $@
	cp XLess-co.ad $(SCIDIR)/X11_defaults/XLess-color

distclean::
	$(RM) $(SCIDIR)/X11_defaults/xless.help
	$(RM) $(SCIDIR)/X11_defaults/XLess
	$(RM) $(SCIDIR)/X11_defaults/XLess-color

help.o: xless.h XLessHelp.icon
init.o: xless.h
popup.o: xless.h
util.o: xless.h
callbacks.o: xless.h
window.o: xless.h XLessWin.icon
main.o: xless.h XLessTop.icon
actions.o: xless.h
functions.o: xless.h
