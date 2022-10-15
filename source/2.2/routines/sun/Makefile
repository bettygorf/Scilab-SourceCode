# Generated automatically from Makefile.in by configure.
SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS) $(XFLAGS)

FFLAGS = $(FC_OPTIONS)

LIBRARY = $(SCIDIR)/libs/sun.a

SUN_FORTRAN = bashos.o basin.o basout.o \
	cluni0.o clunit.o ctrlc.o dbasin.o  \
	fgetarg.o getpro.o inffic.o inibrk.o sigbas.o \
	sync.o

SUN_C = getenvc.o link.o systemc.o zzledt.o  csignal.o getpidc.o timer.o \
	flags.o

OBJSC = $(SUN_C)

OBJSF = $(SUN_FORTRAN)

OBJS = $(OBJSC) $(OBJSF)

all:: $(LIBRARY)

world: all

$(LIBRARY): $(OBJS)
	@echo Creation of $(LIBRARY)
	@$(RM) $@
	@$(AR) $@ $(OBJS)
	@$(RANLIB) $@

clean::
	$(RM) $(OBJS)
distclean::
	$(RM) $(OBJS) $(LIBRARY)

bashos.o: ../stack.h
basin.o: ../stack.h
basout.o: ../stack.h
clunit.o: ../stack.h
dbasin.o: ../stack.h
sigbas.o: ../stack.h
sync.o: ../stack.h

getenvc.o: ../machine.h
link.o: ../machine.h linux_link.c SYSV_link.c std_link.c
systemc.o: ../machine.h
zzledt.o: ../machine.h
csignal.o: ../machine.h
getpidc.o: ../machine.h
timer.o: ../machine.h
