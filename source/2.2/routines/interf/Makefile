SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

LIBRARY = $(SCIDIR)/libs/interf.a

OBJSC = ctest.o

OBJSF = datatf.o lstelm.o lstops.o matdes.o matdsc.o matdsr.o matelm.o\
	matimp.o matio.o matlu.o matnew.o matode.o matops.o matopt.o\
	matqr.o matqz.o matric.o matsvd.o matsys.o metane.o \
	polaut.o polelm.o polops.o sigelm.o strelm.o strops.o fmlelm.o \
	logic.o logelm.o xawelm.o misops.o stack.o stack-more.o colnew-int.o where.o \
	spelm.o lspops.o spops.o intcos.o matodc.o dasrti.o

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

colnew-int.o: ../stack.h
datatf.o: ../stack.h
fmlelm.o: ../stack.h
logelm.o: ../stack.h
logic.o: ../stack.h
lspops.o: ../stack.h
lstelm.o: ../stack.h
lstops.o: ../stack.h
matdes.o: ../stack.h
matdsc.o: ../stack.h
matdsr.o: ../stack.h
matelm.o: ../stack.h
matimp.o: ../stack.h
matio.o: ../stack.h
matlu.o: ../stack.h
matnew.o: ../stack.h
matode.o: ../stack.h
matops.o: ../stack.h
matopt.o: ../stack.h
matqr.o: ../stack.h
matqz.o: ../stack.h
matric.o: ../stack.h
matsvd.o: ../stack.h
matsys.o: ../stack.h
metane.o: ../stack.h
misops.o: ../stack.h
polaut.o: ../stack.h
polelm.o: ../stack.h
polops.o: ../stack.h
sigelm.o: ../stack.h
spelm.o: ../stack.h
spops.o: ../stack.h
stack.o: ../stack.h
stack-more.o: ../stack.h
strelm.o: ../stack.h
strops.o: ../stack.h
where.o: ../stack.h
xawelm.o: ../stack.h

ctest.o: ../machine.h
