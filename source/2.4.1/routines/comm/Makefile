SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/comm.a

OBJSC = initcom.o messages.o

OBJSF =

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

include ../Make.lib

initcom.o: ../machine.h ../libcomm/libCalCom.h ../libcomm/libCom.h
messages.o: ../machine.h ../libcomm/libCalCom.h ../libcomm/libCom.h

all:: Makefile.mak

Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile
