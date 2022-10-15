SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = elemlib
NAM = elem

MACROS = acos.sci acosh.sci asin.sci asinh.sci atanh.sci cosh.sci \
	cotg.sci coth.sci  smooth.sci log10.sci \
	null.sci sinh.sci fix.sci \
	tan.sci tanh.sci toeplitz.sci pertrans.sci \
	g_clean.sci modulo.sci interpln.sci and.sci or.sci \
	intl.sci intc.sci integrate.sci \
	calerf.sci erf.sci erfc.sci erfcx.sci \
	speye.sci spzeros.sci sprand.sci

OBJ = $(MACROS:.sci=.bin)
MACROSN = $(MACROS:.sci=)

all:: $(OBJ) lib

lib: $(OBJ) names
	@echo generating lib and names
	@$(SCIDIR)/bin/scilab -lib $(NAME) SCI/macros/$(NAM)

names: $(OBJ)
	@$(RM) names;touch names;
	@for i in $(MACROSN); do  (echo $$i >> names );done

distclean::
	$(RM) lib names *.bin

.sci.bin:
	@$(SCIDIR)/bin/scilab -comp  $*.sci
