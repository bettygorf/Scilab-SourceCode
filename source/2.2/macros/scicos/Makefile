SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = scicoslib
NAM = scicos

BLOCKS=SPLIT_f.sci  GAIN_f.sci IN_f.sci CLKIN_f.sci OUT_f.sci CLKOUT_f.sci \
	QUANT_f.sci CLKSPLIT_f.sci CLKSOM_f.sci EVTDLY_f.sci\
	SAT_f.sci SOM_f.sci SUPER_f.sci SCOPE_f.sci CLSS_f.sci DLSS_f.sci\
	CLR_f.sci DLR_f.sci ZCROSS_f.sci m_sin.sci TRASH_f.sci BOUND_f.sci \
	CONST_f.sci DELAY_f.sci SELECT_f.sci PROD_f.sci TEXT_f.sci CLOCK_f.sci\
	FOR_f.sci EVTGEN_f.sci IFTHEL_f.sci func_block.sci scifunc_block.sci\
	EXPBLK_f.sci WFILE_f.sci SINBLK_f.sci COSBLK_f.sci TANBLK_f.sci\
	INVBLK_f.sci LOGBLK_f.sci POWBLK_f.sci HALT_f.sci GENSIN_f.sci \
	RAND_f.sci ABSBLK_f.sci LOOKUP_f.sci TIME_f.sci NEGTOPOS_f.sci\
	POSTONEG_f.sci GENERAL_f.sci REGISTER_f.sci CLINDUMMY_f.sci\
	GENSQR_f.sci MFCLCK_f.sci SAWTOOTH_f.sci MCLOCK_f.sci TCLSS_f.sci\
	SCOPXY_f.sci EVENTSCOPE_f.sci INTEGRAL_f.sci RFILE_f.sci ANIMXY_f.sci

SYS=clickin.sci draw.sci drawblock.sci drawlink.sci drawobj.sci drawobjs.sci \
	drawpal.sci getblock.sci getinputs.sci getlink.sci getobj.sci \
	getorigin.sci getoutputs.sci gridpoint.sci scicos.sci \
	standard_draw.sci standard_inputs.sci standard_origin.sci \
	standard_outputs.sci systshow.sci \
	analyse.sci default_color.sci do_move.sci do_compile.sci \
	prt_align.sci standard_block.sci mark_prt.sci get_connected.sci \
	c_pass1.sci c_pass2.sci set_palette.sci modipar.sci do_setup.sci \
	standard_define.sci sci_block.sci stripblanks.sci get_tree_elt.sci \
	change_tree_elt.sci choosefile.sci lstfiles.sci \
	projaff.sci do_delete.sci check_io.sci do_tild.sci do_copy.sci \
	save_super.sci genfunc.sci genfunc1.sci drawtitle.sci getparpath.sci \
	save_csuper.sci do_help.sci do_run.sci


MACROS = $(BLOCKS) $(SYS)


OBJ = $(BLOCKS:.sci=.bin) $(SYS:.sci=.bin)
MACROSN = $(BLOCKS:.sci=) $(SYS:.sci=)

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
