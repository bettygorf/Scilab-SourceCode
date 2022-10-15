SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = armalib
NAM = arma

MACROS = armap.sci armax.sci armax1.sci arsimul.sci arspec.sci \
	epred.sci exar1.sci exar2.sci \
	exar3.sci gbruit.sci narsimul.sci odedi.sci prbs_a.sci  \
	vpmacr.sci armac.sci reglin.sci acf.sci sdiff.sci

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
