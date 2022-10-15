#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/sound.lib

OBJSC = sound.obj raw.obj wav.obj  sox.obj libst.obj misc.obj 
OBJSF = soundII.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) 

include ../Make.lib.mak



Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile


$(OBJSC):	st.h 

soundII.obj: ../stack.h



