
SCIDIR=.
include Makefile.incl.mak 

all ::  bin/scilex

world:: scilex-lib-world bin/scilex

# win32 
LIBRSCI = libs/system.lib libs/interf.lib libs/system2.lib libs/optim.lib \
	libs/integ.lib libs/control.lib routines/control/fstair.obj routines/control/wexchn.obj \
	routines/control/wshrsl.obj libs/scicos.lib libs/signal.lib \
	libs/poly.lib libs/calelm.lib libs/lapack.lib libs/graphics.lib \
	libs/sparse.lib libs/metanet.lib libs/system.lib libs/sun.lib \
	libs/intersci.lib  libs/graphics.lib libs/menusX.lib libs/comm.lib libs/xdr.lib \
	libs/wsci.lib libs/graphics.lib libs/wsci.lib libs/sun.lib \
	libs/sound.lib libs/libcomm.lib libs/control.lib libs/libf77.lib libs/libi77.lib

LIBR = $(XAW_LOCAL_LIB) $(LIBRSCI) $(DLDLIB)

DEFAULTS = routines/wsci/winmain.obj	\
	routines/default/Ex-colnew.obj \
	routines/default/Ex-corr.obj \
	routines/default/Ex-feval.obj \
	routines/default/Ex-fsolve.obj \
	routines/default/Ex-impl.obj \
	routines/default/Ex-intg.obj \
	routines/default/Ex-ode-more.obj \
	routines/default/Ex-ode.obj\
	routines/default/Ex-odedc.obj \
	routines/default/Ex-optim.obj \
	routines/default/Ex-schur.obj \
	routines/default/Ex-fort.obj\
	routines/default/Ex-dasrt.obj \
	routines/default/Ex-dassl.obj \
	routines/default/Ex-fbutn.obj \
	routines/default/FTables.obj \
	routines/default/mainwin95.obj \
	routines/default/matusr.obj \
	routines/default/matus2.obj \
	routines/default/Funtab.obj \
	routines/default/msgstxt.obj \
	routines/default/scimem.obj 

include config/Makefile.mak


