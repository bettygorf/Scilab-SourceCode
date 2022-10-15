SHELL = /bin/sh

SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/scicos.lib

BLOCKSF= evtdly.obj cstblk.obj dband.obj \
	gain.obj lusat.obj pload.obj prod.obj qzcel.obj qzflr.obj\
	qzrnd.obj qztrn.obj scope.obj lsplit.obj csslti.obj\
	dsslti.obj sum.obj trash.obj zcross.obj \
	absblk.obj expblk.obj logblk.obj sinblk.obj tanblk.obj cosblk.obj powblk.obj\
	sqrblk.obj delay.obj selblk.obj forblk.obj ifthel.obj writef.obj invblk.obj hltblk.obj\
	gensin.obj rndblk.obj lookup.obj timblk.obj cdummy.obj gensqr.obj mfclck.obj\
	sawtth.obj tcslti.obj scopxy.obj evscpe.obj integr.obj readf.obj affich.obj\
	intpol.obj intplt.obj minblk.obj maxblk.obj dlradp.obj andlog.obj iocopy.obj \
	sum2.obj sum3.obj delayv.obj mux.obj demux.obj samphold.obj dollar.obj mscope.obj \
	eselect.obj  

BLOCKSC=selector.obj

OBJSF=sciblk.obj  addevt.obj scicos.obj cosini.obj cossim.obj cosend.obj \
	simblk.obj grblk.obj sctree.obj skipvars.obj scierr.obj scifunc.obj \
	list2vars.obj dtosci.obj itosci.obj scitoi.obj scitod.obj $(BLOCKSF)\
	vvtosci.obj

OBJSC=callf.obj import.obj sciblk2.obj $(BLOCKSC)

BLOCKS=$(BLOCKSF) $(BLOCKSC)

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak

#---------------Blocks 
# need a bat file for this with nmake 
#blocks.h: Makefile
#	@echo "generation of blocks.h"
#	@$(RM) Fblocknames Cblockname
#	@for i in $(BLOCKSF:.obj=); do  (echo $$i );done > Fblocknames 
#	@for i in $(BLOCKSC:.obj=); do  (echo $$i );done > Cblocknames 
#	@./GenBlocks

clean::
	$(RM) $(OBJS)
distclean::
	$(RM) $(OBJS) $(LIBRARY) Fblocknames Cblocknames blocks.h

#--------------dependencies 

callf.obj: blocks.h ../machine.h
sciblk.obj : ../stack.h ../callinter.h
selector.obj: ../machine.h
