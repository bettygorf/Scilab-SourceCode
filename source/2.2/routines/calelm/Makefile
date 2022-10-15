SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

LIBRARY = $(SCIDIR)/libs/calelm.a

OBJSC =

OBJSF = coshin.o arcosh.o  dad.o dadd.o dasum.o daxpy.o dcopy.o ddif.o \
	ddot.o dmcopy.o dmmul.o dnrm2.o drot.o drotg.o dscal.o dset.o dsort.o \
	dsum.o dswap.o dtild.o dvmul.o entier.o franck.o gdcp2i.o hilber.o \
	icopy.o idamax.o iset.o isort.o iwamax.o kronc.o kronr.o magic.o \
	mtran.o pythag.o  round.o simple.o urand.o wasum.o watan.o \
	waxpy.o wcopy.o wdiv.o wdotci.o wdotcr.o wlog.o wmmul.o wmul.o \
	wnrm2.o wrscal.o wscal.o wsign.o wsqrt.o wswap.o wvmul.o dipow.o \
	ddpow.o dwpow.o wdpow.o wipow.o wwpow.o int2db.o rea2db.o\
	isoval.o isova0.o imcopy.o dlblks.o rat.o lnblnk.o dmmul1.o

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
