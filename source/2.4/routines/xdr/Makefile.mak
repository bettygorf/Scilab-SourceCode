SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/xdr.lib
CFLAGS = $(CC_OPTIONS) -I.
FFLAGS = $(FC_OPTIONS)

OBJSC =	xdr.obj xdr_array.obj xdr_float.obj xdr_mem.obj \
	xdr_rec.obj xdr_reference.obj xdr_stdio.obj

OBJSF = 

include ../../Makefile.incl.mak
include ../Make.lib.mak


