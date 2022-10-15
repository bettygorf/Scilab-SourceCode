SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/sound.a

OBJSC = sound.o raw.o wav.o  sox.o libst.o misc.o 
OBJSF = soundII.o

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS) 

include ../Make.lib

$(OBJSC):	st.h 




