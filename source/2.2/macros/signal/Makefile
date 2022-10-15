SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = siglib
NAM = signal

MACROS = %k.sci %asn.sci %sn.sci analpf.sci bilt.sci \
	buttmag.sci  casc.sci cheb1mag.sci cheb2mag.sci chepol.sci \
	cspect.sci czt.sci dft.sci ell1mag.sci eqfir.sci \
	eqiir.sci faurre.sci ffilt.sci findm.sci find_freq.sci \
	frmag.sci fsfirlin.sci fwiir.sci group.sci hank.sci \
	hilb.sci iir.sci iirgroup.sci iirlp.sci iirmod.sci intdec.sci \
	jmat.sci kalm.sci lattn.sci lev.sci levin.sci yulewalk.sci \
	lindquist.sci mese.sci mfft.sci phc.sci pspect.sci \
	remezb.sci sinc.sci sincd.sci srfaur.sci sskf.sci convol.sci \
	srkf.sci system.sci trans.sci wfir.sci wiener.sci \
	wigner.sci window.sci zpbutt.sci zpch1.sci zpch2.sci zpell.sci

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
