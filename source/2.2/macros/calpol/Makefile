SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = polylib
NAM = calpol

MACROS = cmndred.sci coffg.sci colcompr.sci \
	denom.sci derivat.sci determ.sci detr.sci \
	diophant.sci gcd.sci hermit.sci horner.sci \
	hrmt.sci htrianr.sci invr.sci lcm.sci \
	numer.sci pdiv.sci pol2des.sci \
	pol2str.sci polfact.sci routh_t.sci rowcompr.sci \
	sylm.sci systmat.sci pfactors.sci factors.sci

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
