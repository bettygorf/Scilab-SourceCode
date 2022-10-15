SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl

CFLAGS = $(CC_OPTIONS)

all:: $(SCIDIR)/bin/Slpr $(SCIDIR)/bin/Slatexprs $(SCIDIR)/bin/Slatexpr2

world: all

$(SCIDIR)/bin/Slpr: Slpr.o
	$(RM) $@
	$(CC) -o $@ Slpr.o $(CC_LDFLAGS)

clean::
	$(RM) Slpr.o
distclean::
	$(RM) Slpr.o $(SCIDIR)/bin/Slpr

$(SCIDIR)/bin/Slatexprs: Slatexprs.o
	$(RM) $@
	$(CC) -o $@ Slatexprs.o $(CC_LDFLAGS)

clean::
	$(RM) Slatexprs.o
distclean::
	$(RM) Slatexprs.o $(SCIDIR)/bin/Slatexprs

$(SCIDIR)/bin/Slatexpr2: Slatexpr2.o
	$(RM) $@
	$(CC) -o $@ Slatexpr2.o $(CC_LDFLAGS)

clean::
	$(RM) Slatexpr2.o
distclean::
	$(RM) Slatexpr2.o $(SCIDIR)/bin/Slatexpr2
