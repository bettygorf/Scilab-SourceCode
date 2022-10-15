SHELL = /bin/sh

SCIDIR=../../..
include ../../../Makefile.incl

.SUFFIXES: .gcode .code .ps .epsf .tex $(SUFFIXES)

BLATEXPR = $(SCIDIR)/bin/Blatexpr

TEX = d7-1.tex d7-2.tex d7-3.tex d7-4.tex d7-5.tex d7-6.tex d7-7.tex \
	d7-8.tex d7-9.tex d7-10.tex \
	d7a11.tex d1-14.tex d1-7.tex d6-1.tex d6-2.tex \
	example1.tex example2.tex example3x.tex frame.tex

PS = $(TEX:.tex=.ps)
EPSF = $(TEX:.tex=.epsf)
DIAGS = $(TEX:.tex=.dia)
CODE = $(TEX:.tex=.code)

all::  $(TEX)

clean::
	$(RM) $(DIAGS)

distclean::
	$(RM) $(DIAGS) $(TEX) $(EPSF) $(PS) 

.gcode.tex:
	@$(RM) x.dat $*.ps $*.ps[0-9]
	@$(SCIDIR)/util/scidoc $(SCIDIR) $*.gcode $*.dia
	@$(RM) $*.dia
	@$(SCIDIR)/bin/Blatexprs $* $*.ps[1-4]
	@$(RM) $*.ps[1-4]

.code.tex:
	@if [ -f $*.ps  ]; then	$(RM) $*.ps;fi;
	@if [ -f $*.epsf  ]; then $(RM) $*.epsf;fi;
	@if [ -f x.dat  ]; then $(RM) x.dat;fi;
	@$(SCIDIR)/util/scidoc $(SCIDIR) $*.code $*.dia
	@$(RM) $*.dia
	@$(BLATEXPR) 1.0 1.0 $*.ps
	@$(RM)  $*.ps

