SHELL = /bin/sh

SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/sparse.a

OBJSC = lu.o spBuild.o spFortran.o spSolve.o spAllocate.o spFactor.o \
	spOutput.o spUtils.o

OBJSF = dperm.o iperm.o dspdsp.o wspdsp.o  dspasp.o dspssp.o \
	wspasp.o wspssp.o isort1.o dspmsp.o wspmsp.o \
	dspms.o dsmsp.o wspms.o wsmsp.o dspt.o wspt.o \
	dspxsp.o wspxsp.o dspxs.o wspxs.o dspe2.o wspe2.o \
	dspcle.o wspcle.o dspisp.o  dspis.o wspisp.o wspis.o\
	dsposp.o lspdsp.o dspos.o dsosp.o wsposp.o wspos.o wsosp.o \
	sz2ptr.o findl.o dcompa.o wcompa.o lcompa.o\
	dspcsp.o wspcsp.o \
	lspt.o lspcsp.o lspe2.o lspisp.o lspis.o lsosp.o lspos.o \
	lsposp.o lspasp.o lspxsp.o\
	dful2sp.o wful2sp.o lful2sp.o dspful.o wspful.o lspful.o \
	dij2sp.o wij2sp.o lij2sp.o dspmax.o dspmin.o \
	dspmat.o wspmat.o lspmat.o sp2col.o spsort.o spord.o wperm.o \
	spcho1.o spcho2.o sparspak.o

OBJS = $(OBJSC) $(OBJSF)

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

include ../Make.lib

lu.o: spConfig.h spmatrix.h spDefs.h  ../machine.h
spBuild.o: spConfig.h  spmatrix.h spDefs.h
spFortran.o: spConfig.h  spmatrix.h spDefs.h
spSolve.o: spConfig.h  spmatrix.h spDefs.h
spAllocate.o: spConfig.h  spmatrix.h spDefs.h
spFactor.o: spConfig.h spmatrix.h spDefs.h
spOutput.o: spConfig.h spmatrix.h spDefs.h
spUtils.o: spConfig.h spmatrix.h spDefs.h
