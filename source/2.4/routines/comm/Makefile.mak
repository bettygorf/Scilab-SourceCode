#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/comm.lib

OBJSC = initcom.obj messages.obj

OBJSF =

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak

initcom.obj: ../machine.h ../libcomm/libCalCom.h ../libcomm/libCom.h
messages.obj: ../machine.h ../libcomm/libCalCom.h ../libcomm/libCom.h



Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile
