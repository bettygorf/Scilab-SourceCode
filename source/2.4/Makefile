# Generated automatically from Makefile.in by configure.
SHELL = /bin/sh

binary:
	@if test -f .binary; then \
		echo "Humm... this is a binary version"; \
		config/findpath; \
		(cd scripts; make); \
                (cd maple; make); \
		echo "Installation done"; \
	else \
		echo "Humm... this is a source version,"; \
		echo "  you'd better read the README file first."; \
	fi

SCIDIR=.
include Makefile.incl

all:: bin/scilex  

world:: scilex-lib-world bin/scilex

LIBRSCI = libs/system.a libs/interf.a libs/system2.a libs/optim.a \
	libs/integ.a libs/control.a libs/scicos.a libs/signal.a \
	libs/poly.a libs/calelm.a libs/lapack.a libs/graphics.a \
	libs/sparse.a libs/metanet.a libs/sun.a  \
	libs/intersci.a  libs/xsci.a libs/graphics.a libs/menusX.a \
	libs/libcomm.a libs/comm.a libs/sound.a libs/dcd.a libs/rand.a \
	libs/blas.a libs/fraclab.a libs/pvm.a  libs/tksci.a

LIBR = $(XAW_LOCAL_LIB) $(LIBRSCI) $(DLDLIB) $(PVMGLIB) $(PVMLIB)

DEFAULTS = \
	routines/default/FTables.o \
	routines/default/Ex-colnew.o \
	routines/default/Ex-corr.o \
	routines/default/Ex-feval.o \
	routines/default/Ex-fsolve.o \
	routines/default/Ex-impl.o \
	routines/default/Ex-intg.o \
	routines/default/Ex-int2d.o \
	routines/default/Ex-int3d.o \
	routines/default/Ex-ode-more.o \
	routines/default/Ex-ode.o \
	routines/default/Ex-odedc.o \
	routines/default/Ex-optim.o \
	routines/default/Ex-schur.o \
	routines/default/Ex-fort.o \
	routines/default/Ex-dasrt.o \
	routines/default/Ex-dassl.o \
	routines/default/Ex-fbutn.o \
	routines/default/mainsci.o \
	routines/default/matusr.o  routines/default/matus2.o \
	routines/default/Funtab.o  routines/default/msgstxt.o \
	routines/default/scimem.o \
	routines/default/callinterf.o

include config/Makefile.alpha

distclean::
	$(RM) bin/scilex

SUBDIRS = scripts maple macros imp intersci xless xmetanet \
	tests demos geci examples

SUBDIRS-DOC = man doc

scilex-lib::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	cd routines; echo "making all in routines..."; \
		$(MAKE) $(MFLAGS) all;

scilex-lib::
	@cd pvm3; echo "making all in pvm3..."; $(MAKE) $(MFLAGS) "CC=$(CC)";

scilex-lib-world::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	@cd routines; echo "making world in routines..."; \
		$(MAKE) $(MFLAGS) world;

scilex-lib-world::
	@cd pvm3; echo "making all in pvm3..."; $(MAKE) $(MFLAGS);

all::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making all in $$i..."; \
			$(MAKE) $(MFLAGS) all); \
	done

world::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) $(SUBDIRS-DOC);\
	do \
		(cd $$i ; echo "making world in $$i..."; \
			$(MAKE) $(MFLAGS) world); \
	done


distclean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in routines $(SUBDIRS) $(SUBDIRS-DOC);\
	do \
		(cd $$i ; echo "making distclean in $$i..."; \
			$(MAKE) $(MFLAGS)  distclean); \
	done

distclean::
	@cd pvm3; echo "making distclean in pvm3..."; \
	$(MAKE) $(MFLAGS) clean;
	$(RM) -r pvm3/lib/ALPHA pvm3/bin/ALPHA

clean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in routines $(SUBDIRS) $(SUBDIRS-DOC);\
	do \
		(cd $$i ; echo "making clean in $$i..."; \
			$(MAKE) $(MFLAGS)  clean); \
	done

clean::
	@cd pvm3; echo "making clean in pvm3..."; \
	$(MAKE) $(MFLAGS)  clean;

tests:
	@echo "Type \"make tests\" in $(SCIDIR)/tests directory "
	@echo "  to test the  distribution"

distclean::
	$(RM) config.cache config.log config.status .binary foo.f foo.o \
	conftest conftest.c so_locations


SCIBASE = scilab-2.4

BINDISTFILES = \
	$(SCIBASE)/CHANGES $(SCIBASE)/README $(SCIBASE)/ACKNOWLEDGEMENTS \
	$(SCIBASE)/notice.ps $(SCIBASE)/notice.tex \
	$(SCIBASE)/scilab.quit $(SCIBASE)/scilab.star \
	$(SCIBASE)/configure $(SCIBASE)/config $(SCIBASE)/Makefile* \
	$(SCIBASE)/Version.incl $(SCIBASE)/patchlevel.h \
	$(SCIBASE)/X11_defaults \
	$(SCIBASE)/README_Windows.txt $(SCIBASE)/Win95-util \
	$(SCIBASE)/bin $(SCIBASE)/demos $(SCIBASE)/examples \
	$(SCIBASE)/imp/NperiPos.ps $(SCIBASE)/macros \
	$(SCIBASE)/man \
	$(SCIBASE)/maple $(SCIBASE)/scripts $(SCIBASE)/util \
	$(SCIBASE)/routines/*.h \
	$(SCIBASE)/routines/graphics/Math.h \
	$(SCIBASE)/routines/graphics/Graphics.h \
	$(SCIBASE)/routines/sun/link.h $(SCIBASE)/routines/intersci/sparse.h \
	$(SCIBASE)/pvm3/lib/pvm $(SCIBASE)/pvm3/lib/pvmd \
	$(SCIBASE)/pvm3/lib/pvmtmparch \
	$(SCIBASE)/pvm3/lib/ALPHA/pvmd3 \
	$(SCIBASE)/pvm3/lib/ALPHA/pvmgs \
	$(SCIBASE)/tcl \
	$(SCIBASE)/.binary

tarbindist:
	touch .binary
	strip $(SCIDIR)/bin/scilex
	cd .. ; tar cvf $(SCIDIR)/$(SCIBASE)-bin.tar $(BINDISTFILES)
	$(RM) .binary
