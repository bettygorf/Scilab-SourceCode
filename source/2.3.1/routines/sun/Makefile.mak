# Generated automatically from Makefile.in by configure.
SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/sun.lib

OBJSF = bashos.obj basin.obj basout.obj \
	cluni0.obj clunit.obj ctrlc.obj dbasin.obj  \
	fgetarg.obj getpro.obj inffic.obj inibrk.obj sigbas.obj 

OBJSC  = getenvc.obj link.obj systemc.obj zzledt.obj  csignal.obj getpidc.obj timer.obj \
	flags.obj men_Sutils.obj addinter.obj h_help_data.obj tmpdir.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) $(XFLAGS)

include ../Make.lib.mak

bashos.obj: ../stack.h
basin.obj: ../stack.h
basout.obj: ../stack.h
clunit.obj: ../stack.h
dbasin.obj: ../stack.h
sigbas.obj: ../stack.h
sync.obj: ../stack.h

getenvc.obj: ../machine.h
link.obj: ../machine.h link_linux.c link_SYSV.c link_std.c link_W95.c
systemc.obj: ../machine.h
zzledt.obj: ../machine.h
csignal.obj: ../machine.h
getpidc.obj: ../machine.h
timer.obj: ../machine.h
