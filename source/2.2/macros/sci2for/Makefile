SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = s2flib
NAM = sci2for

MACROS = adderr.sci basparam.sci cla2for.sci cod2for.sci \
	exp2for.sci f_argn.sci f_cos.sci f_ent.sci f_error.sci f_eye.sci \
	f_maxi.sci f_mini.sci f_norm.sci f_sin.sci f_size.sci forparam.sci \
	freewrk.sci getwrk.sci indent.sci indentfor.sci ins2for.sci \
	isnum.sci lin2for.sci makeargs.sci mltopsfor.sci \
	modlst.sci  op2for.sci outname.sci setparam.sci f_abs.sci newlab.sci\
	f_exp.sci f_gener.sci f_tan.sci typconv.sci warning.sci \
	get2f.sci num2f.sci func2f.sci str2f.sci getlocal.sci gencall.sci \
	genif.sci f_cond.sci f_rank.sci f_svd.sci dclfun.sci callfun.sci 

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
