#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/lapack.lib

OBJSC =

OBJSF = dgelqf.obj dgels.obj  dgeqrf.obj dlae2.obj dlaev2.obj \
	dlarf.obj dlarfg.obj dlartg.obj dlascl.obj dlaset.obj dlasr.obj dlasrt.obj \
	dlassq.obj dopgtr.obj dorg2l.obj dorg2r.obj dormqr.obj dpptrf.obj dspev.obj \
	dspgst.obj dspgv.obj  dsptrd.obj dsptrf.obj dorgqr.obj \
	dsteqr.obj  lsame.obj dtrcon.obj dgebal.obj dgebak.obj \
	ilaenv.obj dlamch.obj dlabad.obj dlange.obj dormlq.obj dlansp.obj \
	dsterf.obj dgeqr2.obj dlarft.obj dlarfb.obj dorm2r.obj dgelq2.obj dlanst.obj \
	dlapy2.obj dlantr.obj dlacon.obj dlatrs.obj drscl.obj dorml2.obj \
	slamch.obj dggbal.obj dggbak.obj dlacpy.obj dlaic1.obj dgeqpf.obj \
	dlatzm.obj dtzrqf.obj dgerqf.obj dorgrq.obj dgerq2.obj \
	dgerfs.obj dgetrs.obj dlaswp.obj dorgr2.obj dormrq.obj dormr2.obj dlapmt.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak



Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile


