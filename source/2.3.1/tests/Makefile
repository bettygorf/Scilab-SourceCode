SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl

.SUFFIXES: .dia .tst $(SUFFIXES)

.tst.dia:
	@$(SCIDIR)/util/scidem $(SCIDIR) $*.tst $*.dia

OBJS =  matops.dia scilab.dia macro.dia calpol.dia clause.dia \
	sparse.dia lsparse.dia lstops.dia polops.dia \
	break.dia breakpoints.dia pause.dia \
	sprintf.dia sscanf.dia display.dia \
	matode.dia matopt.dia \
	metanet.dia matimp.dia dassldasrt.dia \
	fort.dia \
	colnew.dia feval.dia auto.dia \
	odedc.dia sound.dia listinsertion.dia listextraction.dia \
	links.dia strelm.dia

all:: info

world: info

info:
	@echo "Type \"make tests\" in tests directory"
	@echo "  to test the  distribution"
	@echo " SEE THE README FILE (IMPORTANT) "

tests: $(OBJS)

clean ::
	$(RM) $(OBJS) examples.tst get_examples.log *.graph so_locations 
	$(RM) foo* test.wav one_man.tst test_macro_exec asave results *.bin

distclean:: clean 

FFLAGS = $(FC_OPTIONS)

OBJSF = externals.o

linktest : $(OBJSF)

externals.o: externals.f
	$(FC) $(FFLAGS) -c externals.f  -o externals.o

clean::
	$(RM) externals.o
distclean::
	$(RM) externals.o


