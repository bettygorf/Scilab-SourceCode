SHELL = /bin/sh

SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/sparse.lib

OBJSC = lu.obj spBuild.obj spFortran.obj spSolve.obj spAllocate.obj spFactor.obj \
	spOutput.obj spUtils.obj

OBJSF = dperm.obj iperm.obj dspdsp.obj wspdsp.obj  dspasp.obj dspssp.obj \
	wspasp.obj wspssp.obj isort1.obj dspmsp.obj wspmsp.obj \
	dspms.obj dsmsp.obj wspms.obj wsmsp.obj dspt.obj wspt.obj \
	dspxsp.obj wspxsp.obj dspxs.obj wspxs.obj dspe2.obj wspe2.obj \
	dspcle.obj wspcle.obj dspisp.obj  dspis.obj wspisp.obj wspis.obj\
	dsposp.obj lspdsp.obj dspos.obj dsosp.obj wsposp.obj wspos.obj wsosp.obj \
	sz2ptr.obj findl.obj dcompa.obj wcompa.obj lcompa.obj\
	dspcsp.obj wspcsp.obj \
	lspt.obj lspcsp.obj lspe2.obj lspisp.obj lspis.obj lsosp.obj lspos.obj \
	lsposp.obj lspasp.obj lspxsp.obj\
	dful2sp.obj wful2sp.obj lful2sp.obj dspful.obj wspful.obj lspful.obj \
	dij2sp.obj wij2sp.obj lij2sp.obj dspmax.obj dspmin.obj \
	dspmat.obj wspmat.obj lspmat.obj sp2col.obj spsort.obj spord.obj wperm.obj

OBJS = $(OBJSC) $(OBJSF)

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak

lu.obj: spConfig.h spmatrix.h spDefs.h  ../machine.h
spBuild.obj: spConfig.h  spmatrix.h spDefs.h
spFortran.obj: spConfig.h  spmatrix.h spDefs.h
spSolve.obj: spConfig.h  spmatrix.h spDefs.h
spAllocate.obj: spConfig.h  spmatrix.h spDefs.h
spFactor.obj: spConfig.h spmatrix.h spDefs.h
spOutput.obj: spConfig.h spmatrix.h spDefs.h
spUtils.obj: spConfig.h spmatrix.h spDefs.h
