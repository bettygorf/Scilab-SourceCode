SHELL = /bin/sh

SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/lapack.lib

OBJSC =

OBJSF = dgelqf.obj dgels.obj dgemm.obj dgemv.obj dgeqrf.obj dger.obj dlae2.obj dlaev2.obj \
	dlarf.obj dlarfg.obj dlartg.obj dlascl.obj dlaset.obj dlasr.obj dlasrt.obj \
	dlassq.obj dopgtr.obj dorg2l.obj dorg2r.obj dormqr.obj dpptrf.obj dspev.obj \
	dspgst.obj dspgv.obj dspmv.obj dspr.obj dspr2.obj dsptrd.obj dsptrf.obj \
	dsteqr.obj dtpmv.obj dtpsv.obj lsame.obj xerbla.obj dtrcon.obj \
	ilaenv.obj dlamch.obj dlabad.obj dlange.obj dtrsm.obj dormlq.obj dlansp.obj \
	dsterf.obj dgeqr2.obj dlarft.obj dlarfb.obj dorm2r.obj dgelq2.obj dlanst.obj \
	dlapy2.obj dlantr.obj dlacon.obj dlatrs.obj drscl.obj dorml2.obj dtrmv.obj \
	dtrmm.obj dtrsv.obj slamch.obj dggbal.obj dggbak.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak

