SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/intersci.lib

OBJSC = cchar.obj ccharf.obj cdouble.obj cdoublef.obj cerro.obj cint.obj cintf.obj cout.obj \
	cstringf.obj stringc.obj int2cint.obj dbl2cdbl.obj freeptr.obj

OBJSF = erro.obj out.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak

erro.obj:       ../stack.h
out.obj:       ../stack.h

cchar.obj: ../machine.h
ccharf.obj: ../machine.h
cdouble.obj: ../machine.h
cdoublef.obj: ../machine.h
cerro.obj: ../machine.h
cint.obj: ../machine.h
cintf.obj: ../machine.h
cout.obj: ../machine.h
cstringf.obj: ../machine.h
stringc.obj: ../machine.h
int2cint.obj: ../machine.h
dbl2cdbl.obj: ../machine.h
