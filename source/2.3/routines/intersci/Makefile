SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/intersci.a

OBJSC = cchar.o ccharf.o cdouble.o cdoublef.o cerro.o cint.o cintf.o cout.o \
	cstringf.o stringc.o int2cint.o dbl2cdbl.o freeptr.o

OBJSF = erro.o out.o

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

include ../Make.lib

erro.o:       ../stack.h
out.o:       ../stack.h

cchar.o: ../machine.h
ccharf.o: ../machine.h
cdouble.o: ../machine.h
cdoublef.o: ../machine.h
cerro.o: ../machine.h
cint.o: ../machine.h
cintf.o: ../machine.h
cout.o: ../machine.h
cstringf.o: ../machine.h
stringc.o: ../machine.h
int2cint.o: ../machine.h
dbl2cdbl.o: ../machine.h
freeptr.o: ../machine.h
