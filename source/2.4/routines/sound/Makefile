SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/sound.a

OBJSC = sound.o raw.o wav.o  sox.o libst.o misc.o 
OBJSF = soundII.o

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS) 

include ../Make.lib

all:: Makefile.mak

Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile


$(OBJSC):	st.h 

soundII.o: ../stack.h
