SHELL = /bin/sh

SCIDIR=/usr/local/lib/scilab-2.3
include $(SCIDIR)/Version.incl
include $(SCIDIR)/Makefile.incl


all:: callsci

LIBRSCI = $(SCIDIR)/libs/system.a $(SCIDIR)/libs/interf.a $(SCIDIR)/libs/system2.a $(SCIDIR)/libs/optim.a  $(SCIDIR)/libs/integ.a $(SCIDIR)/libs/control.a $(SCIDIR)/libs/scicos.a $(SCIDIR)/libs/signal.a  $(SCIDIR)/libs/poly.a $(SCIDIR)/libs/calelm.a $(SCIDIR)/libs/lapack.a $(SCIDIR)/libs/graphics.a  $(SCIDIR)/libs/sparse.a $(SCIDIR)/libs/metanet.a $(SCIDIR)/libs/sun.a $(SCIDIR)/libs/system.a $(SCIDIR)/libs/sun.a  $(SCIDIR)/libs/intersci.a  $(SCIDIR)/libs/xsci.a $(SCIDIR)/libs/sun.a $(SCIDIR)/libs/graphics.a $(SCIDIR)/libs/menusX.a  $(SCIDIR)/libs/libcomm.a $(SCIDIR)/libs/comm.a $(SCIDIR)/libs/sound.a  $(SCIDIR)/libs/system.a

LIBR = $(XAW_LOCAL_LIB) $(LIBRSCI) $(DLDLIB)

DEFAULTS = $(SCIDIR)/routines/default/FTables.o  $(SCIDIR)/routines/default/Ex-colnew.o  $(SCIDIR)/routines/default/Ex-corr.o  $(SCIDIR)/routines/default/Ex-feval.o  $(SCIDIR)/routines/default/Ex-fsolve.o  $(SCIDIR)/routines/default/Ex-impl.o  $(SCIDIR)/routines/default/Ex-intg.o  $(SCIDIR)/routines/default/Ex-ode-more.o  $(SCIDIR)/routines/default/Ex-ode.o  $(SCIDIR)/routines/default/Ex-odedc.o  $(SCIDIR)/routines/default/Ex-optim.o  $(SCIDIR)/routines/default/Ex-schur.o  $(SCIDIR)/routines/default/Ex-fort.o  $(SCIDIR)/routines/default/Ex-dasrt.o  $(SCIDIR)/routines/default/Ex-dassl.o  $(SCIDIR)/routines/default/Ex-fbutn.o    $(SCIDIR)/routines/default/matusr.o  $(SCIDIR)/routines/default/matus2.o  $(SCIDIR)/routines/default/Funtab.o  $(SCIDIR)/routines/default/msgstxt.o  $(SCIDIR)/routines/default/scimem.o

FFLAGS = $(FC_OPTIONS)

callsci: callsci.o
	@x=1;if test -f $@; then  \
		x=`find $(DEFAULTS) $(LIBR)  \( -name '*.a' -o -name '*.o' \) \
		-newer $@ -print | wc -l `; \
	fi;\
	if test $$x -ne 0; then \
		$(RM) $@; \
		echo "linking"; \
		$(FC) $(FFLAGS) -o $@ callsci.o $(DEFAULTS) $(LIBR) \
	$(FC_LDFLAGS) $(XLIBS) $(TERMCAPLIB); \
	else \
		echo bin/scilex is up to date ; \
	fi

distclean::
	$(RM) callsci callsci.o 

