#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/pvm.lib

OBJSC = lpack.obj pvm_grp.obj pvm_proc_ctrl.obj pvm_send.obj  pvm_info.obj \
	pvm_recv.obj sci_tools.obj
OBJSF = intpvm.obj mycmatptr.obj varpack.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) 

include ../Make.lib.mak



Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile


intpvm.obj: ../stack.h
lpack.obj:../stack-c.h ../machine.h
pvm_grp.obj: sci_tools.h ../machine.h
pvm_info.obj: ../machine.h
pvm_proc_ctrl.obj: ../machine.h
pvm_recv.obj:../stack.h sci_tools.h ../machine.h
pvm_send.obj:../stack.h sci_tools.h ../machine.h
sci_tools.obj: sci_tools.h ../machine.h



