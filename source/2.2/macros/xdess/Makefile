SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = xdesslib
NAM = xdess

MACROS = errbar.sci fchamp.sci fcontour.sci fplot2d.sci fplot3d.sci \
	fgrayplot.sci fplot3d1.sci  locate.sci xbasc.sci \
	xbasimp.sci xbasr.sci   \
	xclip.sci xstringb.sci histplot.sci plot.sci eval3d.sci \
	gr_menu.sci hist3d.sci scaling.sci isoview.sci \
	milk_drop.sci xrpoly.sci rotate.sci secto3d.sci square.sci \
	titlepage.sci nyquist.sci m_circle.sci bode.sci \
	chart.sci black.sci plzr.sci gainplot.sci evans.sci xs2fig.sci \
	zgrid.sci graduate.sci  \
	fac3d.sci fac3d1.sci eval3dp.sci plotframe.sci xsetm.sci\
	edit_curv.sci drawmbar.sci getmenu.sci genfac3d.sci

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
