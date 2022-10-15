SHELL = /bin/sh

SCIDIR=SCI_DIR
include $(SCIDIR)/Version.incl
include $(SCIDIR)/Makefile.incl


all:: callsci

LIBRSCI = SCI_LIBR

LIBR = $(XAW_LOCAL_LIB) $(LIBRSCI) $(DLDLIB)

DEFAULTS = SCI_DEF

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

