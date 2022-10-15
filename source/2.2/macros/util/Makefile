SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = utillib
NAM = util

MACROS = sysconv.sci readc_.sci lin.sci \
	strcat.sci halt.sci bloc2exp.sci \
	pol2tex.sci texprint.sci bloc2ss.sci \
	cmb_lin.sci eval.sci evstr.sci solve.sci \
	trianfml.sci trisolve.sci sci2map.sci mac2for.sci \
	logspace.sci linspace.sci ssprint.sci ssrand.sci \
	sysdiag.sci syslin.sci syssize.sci trfmod.sci c_link.sci manedit.sci \
	x_matrix.sci typeof.sci isdef.sci zeros.sci edit.sci \
	g_ones.sci g_rand.sci g_eye.sci g_diag.sci g_triu.sci g_tril.sci\
	mlog.sci msin.sci mcos.sci msign.sci \
	msqrt.sci mpow.sci g_size.sci colnew.sci g_inv.sci g_det.sci \
	g_real.sci g_imag.sci g_int.sci g_floor.sci g_ceil.sci \
	getvalue.sci usermenu.sci macrovar.sci input.sci sci2exp.sci \
	demos.sci whereami.sci\
	printf.sci fprintf.sci sprintf.sci scanf.sci fscanf.sci sscanf.sci \
	xdialog.sci unix_g.sci unix_s.sci unix_x.sci unix_w.sci \
	addinter.sci x_choices.sci odeoptions.sci

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
