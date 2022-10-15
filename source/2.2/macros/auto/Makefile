SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = autolib
NAM = auto

MACROS = calfrq.sci svplot.sci abcd.sci sm2ss.sci sm2des.sci \
	arhnk.sci balreal.sci observer.sci stabil.sci \
	canon.sci cont_frm.sci \
	cont_mat.sci contrss.sci unobs.sci csim.sci ctr_gram.sci \
	cls2dls.sci dscr.sci dsimul.sci dt_ility.sci \
	equil.sci equil1.sci flts.sci \
	frep2tf.sci freson.sci g_margin.sci gfrancis.sci \
	imrep2ss.sci invsyslin.sci \
	kpure.sci krac2.sci invrs.sci \
	lqe.sci lqr.sci markp2ss.sci minreal.sci \
	minss.sci obs_gram.sci obsv_mat.sci obsvss.sci \
	p_margin.sci pfss.sci \
	phasemag.sci projsl.sci des2tf.sci repfreq.sci ss2tf.sci ss2des.sci \
	ss2ss.sci  st_ility.sci statgain.sci lqg.sci lqg2stan.sci \
	obscont.sci tf2ss.sci trzeros.sci colregul.sci rowregul.sci \
	time_id.sci zeropen.sci specfact.sci abinv.sci cainv.sci

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
