SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/tksci.a

OBJSF = 

OBJSC  = tksci.o TK_ScilabCallback.o \
	tksci_SciInterf.o \
	LAB_TK_DoOneEvent.o \
	LAB_TK_EvalFile.o \
	LAB_TK_EvalStr.o \
	LAB_TK_GetVar.o \
	LAB_TK_SetVar.o \
	LAB_figure.o \
	LAB_findobj.o \
	LAB_get.o \
	LAB_opentk.o \
	LAB_set.o \
	LAB_uicontrol.o \
	LAB_close.o \
	LAB_uimenu.o \
	TK_uicontrol.o \
	LAB_gcf.o \
	LAB_essai.o \
	gvar.o \
	LAB_setgvar.o LAB_getgvar.o


include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS) $(XFLAGS) $(TK_INC_PATH) $(TCL_INC_PATH) -I. -I../fraclab

include ../Make.lib


tksci.o: ../machine.h

all:: Makefile.mak

Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile
