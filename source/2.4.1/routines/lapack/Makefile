SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/lapack.a

OBJSC =

OBJSF = dgelqf.o dgels.o  dgeqrf.o dlae2.o dlaev2.o \
	dlarf.o dlarfg.o dlartg.o dlascl.o dlaset.o dlasr.o dlasrt.o \
	dlassq.o dopgtr.o dorg2l.o dorg2r.o dormqr.o dpptrf.o dspev.o \
	dspgst.o dspgv.o  dsptrd.o dsptrf.o dorgqr.o \
	dsteqr.o  lsame.o dtrcon.o dgebal.o dgebak.o \
	ilaenv.o dlamch.o dlabad.o dlange.o dormlq.o dlansp.o \
	dsterf.o dgeqr2.o dlarft.o dlarfb.o dorm2r.o dgelq2.o dlanst.o \
	dlapy2.o dlantr.o dlacon.o dlatrs.o drscl.o dorml2.o \
	slamch.o dggbal.o dggbak.o dlacpy.o dlaic1.o dgeqpf.o \
	dlatzm.o dtzrqf.o dgerqf.o dorgrq.o dgerq2.o \
	dgerfs.o dgetrs.o dlaswp.o dorgr2.o dormrq.o dormr2.o dlapmt.o

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

include ../Make.lib

all:: Makefile.mak

Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile


