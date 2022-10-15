SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl

.SUFFIXES: .dia .tst $(SUFFIXES)

.tst.dia:
	@$(SCIDIR)/util/scidem $(SCIDIR) $*.tst $*.dia

OBJS =  maxi.dia norm.dia matops.dia scilab.dia macro.dia calpol.dia clause.dia \
	sparse.dia lsparse.dia lstops.dia polops.dia \
	break.dia breakpoints.dia pause.dia \
	sprintf.dia sscanf.dia display.dia \
	matode.dia matopt.dia matelm.dia polelm.dia\
	metanet.dia matimp.dia dassldasrt.dia \
	call.dia \
	bvode.dia feval.dia auto.dia \
	odedc.dia sound.dia listinsertion.dia listextraction.dia \
	links.dia strelm.dia gsort.dia fmlelm.dia odedi.dia dcd.dia \
	grand.dia grandb.dia resume.dia errcatch.dia arma.dia \
	msscanf.dia msprintf.dia binary.dia mfprintf.dia mfscanf.dia \
	fscanfMat.dia global.dia matsys.dia saveload.dia

all:: info

world: info

info:
	@echo "Type \"make tests\" in tests directory"
	@echo "  to test the  distribution"
	@echo " SEE THE README FILE (IMPORTANT) "

tests: $(OBJS)

clean ::
	$(RM) $(OBJS) get_examples.log *.graph so_locations 
	$(RM) foo* test.wav one_man.tst test_macro_exec asave results *.bin

distclean:: clean 

FFLAGS = $(FC_OPTIONS) $(FC_PICFLAGS)

OBJSF = externals.o

linktest : $(OBJSF)

externals.o: externals.f
	$(FC) $(FFLAGS) -c externals.f  -o externals.o

clean::
	$(RM) externals.o
distclean::
	$(RM) externals.o


