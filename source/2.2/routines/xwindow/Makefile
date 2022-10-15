SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS) $(XFLAGS)

FFLAGS = $(FC_OPTIONS)

OBJSC = message.o choose.o dialog.o mdialog.o string.o testfrac.o \
	matdialog.o idialog.o choice.o Utils.o printdlg.o getfile.o

OBJSF =

OBJS = $(OBJSC) $(OBJSF)

LIBRARY = $(SCIDIR)/libs/xwindow.a

all:: $(LIBRARY)

world: all

$(LIBRARY): $(OBJS)
	@echo Creation of $(LIBRARY)
	@$(RM) $@
	@$(AR) $@ $(OBJS)
	@$(RANLIB) $@

clean::
	$(RM) $(OBJS)
distclean::
	$(RM) $(OBJS) $(LIBRARY)


#==============dependencies 

$(OBJSC) :  ../machine.h scilab_d.h
choice.o : choice.h
printdlg.o : choice.h 

