SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

PROGRAM=./gcall

all:: $(PROGRAM)

$(PROGRAM): gcall.f
	$(RM) $@
	$(FC) -o $@ gcall.f $(FC_LDFLAGS) $(SCIDIR)/libs/calelm.a
clean::
	$(RM) gcall.o
distclean::
	$(RM) gcall.o $(PROGRAM)

LIBRARY = $(SCIDIR)/libs/scicos.a


BLOCKS= bound.o evtdly.o cstblk.o dband.o \
	gain.o gnsin.o lusat.o pload.o prod.o qzcel.o qzflr.o\
	qzrnd.o qztrn.o rslti.o scope.o scoxy.o lsplit.o csslti.o\
	dsslti.o stepf.o sum.o trash.o zcross.o \
	absblk.o expblk.o logblk.o sinblk.o tanblk.o cosblk.o powblk.o\
	sqrblk.o delay.o selblk.o forblk.o ifthel.o writef.o invblk.o hltblk.o\
	gensin.o rndblk.o lookup.o timblk.o cdummy.o gensqr.o mfclck.o\
	sawtth.o tcslti.o scopxy.o evscpe.o integr.o readf.o affich.o

OBJSF=sciblk.o inout.o addevt.o scicos.o cosini.o cossim.o cosend.o \
	simblk.o grblk.o sctree.o $(BLOCKS)

OBJSC=callf.o


OBJS = $(OBJSC) $(OBJSF)

all:: $(LIBRARY)

world: all


$(LIBRARY): $(OBJS)
	@echo Creation of $(LIBRARY)
	@$(RM) $@
	@$(AR) $@ $(OBJS)
	@$(RANLIB) $@

blocks.h: gcall.f blocknames 
	./gcall

blocknames: 
	@$(RM) blocknames;touch  blocknames;
	@for i in $(BLOCKS:.o=); do  (echo $$i >>  blocknames );done


clean::
	$(RM) $(OBJS)
distclean::
	$(RM) $(OBJS) $(LIBRARY) blocknames blocks.h

callf.o: blocks.h ../machine.h
sciblk.o : ../stack.h ../callinter.h
