SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/comm.a

OBJSC = initcom.o messages.o

OBJSF =

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

include ../Make.lib

initcom.o: ../machine.h ../libcomm/libCalCom.h ../libcomm/libCom.h
messages.o: ../machine.h ../libcomm/libCalCom.h ../libcomm/libCom.h
