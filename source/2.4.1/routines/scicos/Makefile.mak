#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/scicos.lib

BLOCKSF=intcos.obj coselm.obj \
	evtdly.obj cstblk.obj dband.obj \
	gain.obj lusat.obj pload.obj qzcel.obj qzflr.obj\
	qzrnd.obj qztrn.obj scope.obj lsplit.obj csslti.obj\
	dsslti.obj trash.obj zcross.obj \
	absblk.obj expblk.obj logblk.obj sinblk.obj tanblk.obj cosblk.obj powblk.obj\
	sqrblk.obj delay.obj selblk.obj forblk.obj ifthel.obj writef.obj invblk.obj hltblk.obj\
	gensin.obj rndblk.obj lookup.obj timblk.obj cdummy.obj gensqr.obj mfclck.obj\
	sawtth.obj tcslti.obj tcsltj.obj scopxy.obj evscpe.obj integr.obj readf.obj affich.obj\
	intpol.obj intplt.obj minblk.obj maxblk.obj dlradp.obj andlog.obj iocopy.obj \
	sum2.obj sum3.obj delayv.obj mux.obj demux.obj samphold.obj dollar.obj mscope.obj \
	eselect.obj intrp2.obj   intrpl.obj fsv.obj memo.obj

BLOCKSC=selector.obj sum.obj prod.obj switchn.obj relay.obj

OBJSF=sciblk.obj  addevt.obj doit.obj odoit.obj zdoit.obj scicos.obj cosini.obj cossim.obj cosend.obj \
	 sctree.obj ftree2.obj ftree3.obj ftree4.obj skipvars.obj scierr.obj scifunc.obj \
	list2vars.obj dtosci.obj itosci.obj scitoi.obj scitod.obj vvtosci.obj \
	scitovv.obj $(BLOCKSF)

OBJSC=callf.obj import.obj sciblk2.obj simblk.obj grblk.obj $(BLOCKSC)

BLOCKS=$(BLOCKSF) $(BLOCKSC)

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak



Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile


#---------------Blocks 

include Make.Blocks.mak

clean::
	$(RM) $(OBJS)
distclean::
	$(RM) $(OBJS) $(LIBRARY) Fblocknames Cblocknames blocks.h

#--------------dependencies 

callf.obj: blocks.h ../machine.h ../sun/link.h scicos.h
scifunc.obj : ../stack.h ../callinter.h
selector.obj: ../machine.h
import.obj: ../machine.h import.h
prod.obj: ../machine.h
sciblk2.obj: ../machine.h
sum.obj: ../machine.h
switchn.0: ../machine.h

sciblk.obj : ../stack.h ../callinter.h
dtosci.obj: ../stack.h
itosci.obj: ../stack.h
list2vars.obj: ../stack.h
readf.obj: ../stack.h
readf.obj: ../stack.h
sciblk.obj: ../stack.h
scierr.obj: ../stack.h
scifunc.obj: ../stack.h ../callinter.h
scitod.obj: ../stack.h
scitoi.obj: ../stack.h
scitovv.obj: ../stack.h
skipvars.obj: ../stack.h
vvtosci.obj: ../stack.h
writef.obj: ../stack.h
grblk.obj: ../machine.h import.h
simblk.obj: ../machine.h import.h
coselm.obj : ../stack.h
intcos.obj : ../stack.h
