SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

EXAMPLES= Ex-colnew.obj Ex-corr.obj  Ex-feval.obj  Ex-fsolve.obj  Ex-impl.obj  Ex-intg.obj \
	Ex-ode-more.obj  Ex-ode.obj  Ex-odedc.obj  Ex-optim.obj  Ex-schur.obj  Ex-fort.obj \
	Ex-dasrt.obj  Ex-dassl.obj  Ex-fbutn.obj 


OBJS =  FTables.obj $(EXAMPLES) mainsci.obj matusr.obj matus2.obj Funtab.obj  msgstxt.obj \
	scimem.obj 

# jpc win32 
OBJS =  FTables.obj $(EXAMPLES) mainwin95.obj matusr.obj matus2.obj Funtab.obj  msgstxt.obj \
	scimem.obj 

world: all

all:: $(OBJS)

FTables.obj : FTables.h 

FTables.h : Flist 
	./FCreate

Funtab.obj : fundef 

$(EXAMPLES) : ../stack.h 

distclean::
	$(RM) $(OBJS)



.f.obj	:
	f2c  $*.f 
	$(CC) $(CFLAGS) $*.c 
	$(RM) $*.c 
