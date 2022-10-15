SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl

.SUFFIXES: .dia .tst $(SUFFIXES)

.tst.dia:
	@$(SCIDIR)/util/scidem $(SCIDIR) $*.tst $*.dia

OBJS =  matops.dia scilab.dia macro.dia calpol.dia clause.dia \
	logops.dia sparse.dia lsparse.dia lstops.dia polops.dia \
	fmlelm.dia elemlib.dia \
	break.dia breakpoints.dia pause.dia \
	sprintf.dia sscanf.dia display.dia dmrdsp.dia \
	intg.dia matnew.dia matode.dia matopt.dia matqz.dia \
	matric.dia metanet.dia matimp.dia dassldasrt.dia \
	bezout.dia corr.dia evans.dia flts.dia fort.dia \
	colnew.dia feval.dia auto.dia pow.dia residu.dia rtitr.dia

all:: info

world: info

info:
	@echo "Type \"make tests\" in tests directory"
	@echo "  to test the  distribution"
	@echo " SEE THE README FILE (IMPORTANT) "

tests: $(OBJS)

clean ::
	$(RM) $(OBJS) examples.tst get_examples.log *.graph so_locations \
	foo*
distclean::
	$(RM) $(OBJS) examples.tst get_examples.log *.graph so_locations \
	foo*
