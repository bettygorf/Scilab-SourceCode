SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = roblib
NAM = robust

MACROS = bstap.sci copfac.sci dcf.sci dtsi.sci fstabst.sci leqe.sci \
	gtild.sci hankelsv.sci linf.sci lqg_ltr.sci nehari.sci riccati.sci \
	smga.sci des2ss.sci fspec.sci cfspec.sci fourplan.sci augment.sci \
	gcare.sci gfare.sci h_cl.sci h_inf.sci h_inf_st.sci h_norm.sci \
	lcf.sci macglov.sci ccontrg.sci entropy.sci fspecg.sci leqr.sci \
	gamitg.sci lft.sci linfn.sci parrot.sci ric_desc.sci sensi.sci \
	tf2des.sci h2norm.sci rowinout.sci colinout.sci \
	dhnorm.sci

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
