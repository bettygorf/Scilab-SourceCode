SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

LIBRARY = $(SCIDIR)/libs/control.a

ARL2= arl2.o arl2a.o phi.o \
	outl2.o jacl2.o feq.o optml2.o deg1l2.o degl2.o storl2.o calsca.o \
	hessl2.o tild.o mzdivq.o domout.o front.o  dzdivq.o \
	scapol.o onface.o watfac.o modul.o lq.o rootgp.o 

OBJSC =

OBJSF =  bezous.o cerr.o coef.o dclmat.o dexpm1.o \
	dfrmg.o dhetr.o expan.o find.o folhp.o fout.o \
	invtpl.o irow1.o irow2.o lrow2.o lybad.o \
	lybsc.o lydsr.o pade.o polmc.o \
	proj2.o qzk.o ricd.o rilac.o ssxmc.o sszer.o  \
	sybad.o sydsr.o syhsc.o wcerr.o wclmat.o \
	wdegre.o wesidu.o wexpm1.o wpade.o rtitr.o $(ARL2) \
	dgbfa.o dgbsl.o dgeco.o dgedi.o dgefa.o dgesl.o dlslv.o \
	dpofa.o dqrdc.o dqrsl.o dqrsm.o drref.o dsvdc.o giv.o hhdml.o \
	shrslv.o wgeco.o wgedi.o wgefa.o wgesl.o wlslv.o wpofa.o wqrdc.o \
	wqrsl.o wrref.o wsvdc.o ereduc.o \
	balanc.o balbak.o bdiag.o calcsc.o cbal.o comqr3.o \
	corth.o cortr.o dsubsp.o exch.o exchqz.o fxshfr.o hqror2.o htribk.o \
	htridi.o imtql3.o inva.o newest.o nextk.o orthes.o ortran.o \
	qhesz.o qitz.o quad.o quadit.o quadsd.o qvalz.o qvecz.o \
	realit.o scaleg.o reduc2.o \
	rpoly.o split.o tql2.o tred2.o wbalin.o wbdiag.o wexchn.o \
	wshrsl.o fstair.o

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
