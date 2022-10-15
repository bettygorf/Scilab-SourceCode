SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/sound.lib 

OBJSC = sound.obj raw.obj wav.obj  sox.obj libst.obj misc.obj 
OBJSF = soundII.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) 

include ../Make.lib.mak

$(OBJSC):	st.h 




