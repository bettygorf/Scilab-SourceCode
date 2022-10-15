SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = alglib
NAM = algebre

MACROS = coff.sci colcomp.sci fineta.sci epsfin.sci \
	givens.sci im_inv.sci \
	proj.sci rowcomp.sci pen2ea.sci kroneck.sci quaskro.sci \
	spaninter.sci spanplus.sci sqroot.sci trace.sci kernel.sci \
	fullrf.sci fullrfk.sci projspec.sci penlaur.sci glever.sci \
	rowshuff.sci polar.sci orth.sci pencan.sci linsolve.sci \
	pbig.sci psmall.sci range.sci nlev.sci spantwo.sci aff2ab.sci

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
