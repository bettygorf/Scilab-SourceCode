SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

LIBRARY = $(SCIDIR)/libs/intersci.a

OBJSC = cchar.o ccharf.o cdouble.o cdoublef.o cerro.o cint.o cintf.o cout.o \
	cstringf.o stringc.o

OBJSF = erro.o out.o

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

erro.o:       ../stack.h
out.o:       ../stack.h

cchar.o: ../machine.h
ccharf.o: ../machine.h
cdouble.o: ../machine.h
cdoublef.o: ../machine.h
cerro.o: ../machine.h
cint.o: ../machine.h
cintf.o: ../machine.h
cout.o: ../machine.h
cstringf.o: ../machine.h
stringc.o: ../machine.h
