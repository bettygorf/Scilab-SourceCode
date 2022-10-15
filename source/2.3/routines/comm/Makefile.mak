SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/comm.lib

OBJSC = initcom.obj messages.obj

OBJSF =

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak

initcom.obj: ../machine.h ../libcomm/libCalCom.h ../libcomm/libCom.h
messages.obj: ../machine.h ../libcomm/libCalCom.h ../libcomm/libCom.h

