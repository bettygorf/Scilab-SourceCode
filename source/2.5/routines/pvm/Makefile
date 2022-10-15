SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/pvm.a

OBJSC = lpack.o pvm_grp.o pvm_proc_ctrl.o pvm_send.o  pvm_info.o \
	pvm_recv.o sci_tools.o
OBJSF = intpvm.o mycmatptr.o varpack.o

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS) 

FFLAGS = $(FC_OPTIONS)

include ../Make.lib

all:: Makefile.mak Makefile.amk

Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile

Makefile.amk	: Makefile
	$(SCIDIR)/util/Mak2ABSMak Makefile

intpvm.o: ../stack.h
lpack.o:../stack-c.h ../machine.h
pvm_grp.o: sci_tools.h ../machine.h
pvm_info.o: ../machine.h
pvm_proc_ctrl.o: ../machine.h
pvm_recv.o:../stack.h sci_tools.h ../machine.h
pvm_send.o:../stack.h sci_tools.h ../machine.h
sci_tools.o: sci_tools.h ../machine.h



