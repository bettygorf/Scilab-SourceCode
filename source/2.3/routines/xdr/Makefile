SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/xdr.a
CFLAGS = $(CC_OPTIONS) -I.
FFLAGS = $(FC_OPTIONS)

OBJSC =	xdr.o xdr_array.o xdr_float.o xdr_mem.o \
	xdr_rec.o xdr_reference.o xdr_stdio.o

OBJSF = 

include ../../Makefile.incl
include ../Make.lib

