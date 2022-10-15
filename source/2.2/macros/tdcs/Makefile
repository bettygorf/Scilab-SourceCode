SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = tdcslib
NAM =tdcs

MACROS=	artest.sci  boucle.sci comric.sci  \
	exemple.sci  finit.sci  gaincom.sci gainobs.sci gpeche.sci  \
	logr.sci  lotest.sci mineInit.sci  obs_cont.sci \
	obsric.sci  portrait.sci portr3d.sci recur.sci  tangent.sci \
	tdinit.sci  test_d.sci chaintest.sci bifish.sci systems.sci \
	BInit.sci

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
