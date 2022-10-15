SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

LIBRARY = $(SCIDIR)/libs/system2.a

OBJSC =

OBJSF = fmttyp.o getfun.o\
	btof.o btofm.o ftob.o\
	bschur.o bjac.o bintg.o bj2.o bydot.o boptim.o bgety.o bgetx.o\
	badd.o bresid.o bfeval.o bresd.o bjacd.o\
	cvwm.o cvdm.o atome.o iseye.o\
	alloc.o back.o\
	matz.o matc.o matzs.o\
	expsum.o termf.o bsurf.o bsurfd.o tradsl.o \
	dldsp.o istrue.o isnum.o namstr.o basnms.o cmplxt.o \
	intstr.o extlarg.o bcol.o bsolv.o bjsolv.o\
	bydot2.o

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

alloc.o: ../stack.h
back.o: ../stack.h
badd.o: ../stack.h ../callinter.h
bcol.o: ../stack.h ../callinter.h
bfeval.o: ../callinter.h ../stack.h
bgetx.o: ../stack.h ../callinter.h
bgety.o: ../stack.h ../callinter.h
bintg.o: ../stack.h ../callinter.h
bj2.o: ../stack.h ../callinter.h
bjac.o: ../stack.h ../callinter.h
bjacd.o: ../stack.h ../callinter.h
bjsolv.o: ../stack.h
boptim.o: ../stack.h ../callinter.h
bresd.o: ../stack.h ../callinter.h
bresid.o: ../stack.h ../callinter.h
bschur.o: ../stack.h ../callinter.h
bsolv.o: ../stack.h
bsurf.o: ../stack.h ../callinter.h
bsurfd.o: ../stack.h ../callinter.h
btof.o: ../stack.h
btofm.o: ../stack.h
bydot.o: ../stack.h ../callinter.h
bydot2.o: ../stack.h ../callinter.h
extlarg.o: ../stack.h
ftob.o: ../stack.h
getfun.o: ../stack.h
istrue.o: ../stack.h
matc.o: ../stack.h
matz.o: ../stack.h
matzs.o: ../stack.h
namstr.o: ../stack.h
transl.o: ../stack.h
