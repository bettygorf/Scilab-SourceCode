SHELL = /bin/sh

SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/scicos.a

BLOCKSF= evtdly.o cstblk.o dband.o \
	gain.o lusat.o pload.o qzcel.o qzflr.o\
	qzrnd.o qztrn.o scope.o lsplit.o csslti.o\
	dsslti.o trash.o zcross.o \
	absblk.o expblk.o logblk.o sinblk.o tanblk.o cosblk.o powblk.o\
	sqrblk.o delay.o selblk.o forblk.o ifthel.o writef.o invblk.o hltblk.o\
	gensin.o rndblk.o lookup.o timblk.o cdummy.o gensqr.o mfclck.o\
	sawtth.o tcslti.o scopxy.o evscpe.o integr.o readf.o affich.o\
	intpol.o intplt.o minblk.o maxblk.o dlradp.o andlog.o iocopy.o \
	sum2.o sum3.o delayv.o mux.o demux.o samphold.o dollar.o mscope.o \
	eselect.o 

BLOCKSC=selector.o sum.o prod.o

OBJSF=sciblk.o  addevt.o scicos.o cosini.o cossim.o cosend.o \
	simblk.o grblk.o sctree.o skipvars.o scierr.o scifunc.o \
	list2vars.o dtosci.o itosci.o scitoi.o scitod.o vvtosci.o $(BLOCKSF)

OBJSC=callf.o import.o sciblk2.o $(BLOCKSC)

BLOCKS=$(BLOCKSF) $(BLOCKSC)

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

include ../Make.lib

#---------------Blocks 

blocks.h: Makefile
	@echo "generation of blocks.h"
	@$(RM) Fblocknames Cblockname
	@for i in $(BLOCKSF:.o=); do  (echo $$i );done > Fblocknames 
	@for i in $(BLOCKSC:.o=); do  (echo $$i );done > Cblocknames 
	@./GenBlocks

clean::
	$(RM) $(OBJS)
distclean::
	$(RM) $(OBJS) $(LIBRARY) Fblocknames Cblocknames blocks.h

#--------------dependencies 

callf.o: blocks.h ../machine.h
sciblk.o : ../stack.h ../callinter.h
scifunc.o : ../stack.h ../callinter.h
selector.o: ../machine.h
