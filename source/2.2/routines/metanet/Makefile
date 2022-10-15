SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

LIBRARY = $(SCIDIR)/libs/metanet.a

OBJSC = metanet.o loadg.o saveg.o show.o connex.o dmtree.o paths.o \
	transc.o files.o myhsearch.o

OBJSF = arbor.o busack.o cfc.o chcm.o compc.o compfc.o dijkst.o \
	dfs.o dfs1.o eclat.o flomax.o floqua.o ford.o \
	frang.o frmtrs.o ftrans.o kilter.o kiltq.o johns.o match.o minty.o \
	mintyq.o pcchna.o prim.o prim1.o tconex.o \
	relax.o compmat.o

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

metanet.o: ../machine.h ../comm/libCalCom.h ../comm/libCom.h
loadg.o: ../machine.h ../comm/libCom.h ../comm/libCalCom.h mysearch.h
saveg.o: ../machine.h
show.o: ../machine.h ../comm/libCalCom.h ../comm/libCom.h
connex.o: ../machine.h
dmtree.o: ../machine.h
paths.o: ../machine.h
transc.o: ../machine.h
myhsearch.o: mysearch.h
