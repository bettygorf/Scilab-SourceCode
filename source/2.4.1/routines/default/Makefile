# Generated automatically from Makefile.in by configure.
SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

EXAMPLES= Ex-colnew.o Ex-corr.o  Ex-feval.o  Ex-fsolve.o  Ex-impl.o  \
	Ex-intg.o \
	Ex-ode-more.o  Ex-ode.o  Ex-odedc.o  Ex-optim.o  Ex-schur.o  \
	Ex-fort.o \
	Ex-dasrt.o  Ex-dassl.o  Ex-fbutn.o Ex-int2d.o Ex-int3d.o

OBJS =  FTables.o $(EXAMPLES) mainsci.o matusr.o matus2.o Funtab.o  \
	msgstxt.o scimem.o callinterf.o

world: all

all:: $(OBJS)

FTables.o : FTables.h 

FTables.h : Flist 
	./FCreate

Funtab.o : fundef ../machine.h ../fraclab/fundef.fraclab

$(EXAMPLES) : ../stack.h 

distclean::
	$(RM) *.o

Ex-fort.o Ex-ode.o Ex-odedc.o msgstxt.o matus2.o matusr.o userf2.o :   ../stack.h
callinterf.o : ../machine.h  callinterf.h ../sun/addinter.h
