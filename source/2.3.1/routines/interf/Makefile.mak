SHELL = /bin/sh

SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/interf.lib

OBJSC = ctest.obj

OBJSF = datatf.obj lstelm.obj lstops.obj matdes.obj matdsc.obj matdsr.obj matelm.obj\
	matimp.obj matio.obj matlu.obj matnew.obj matode.obj matops.obj matopt.obj\
	matqr.obj matqz.obj matric.obj matsvd.obj matsys.obj metane.obj\
	polaut.obj polelm.obj polops.obj sigelm.obj strelm.obj strops.obj fmlelm.obj\
	logic.obj logelm.obj xawelm.obj misops.obj stack.obj \
	where.obj indxg.obj intcos.obj \
	spelm.obj lspops.obj spops.obj  coselm.obj matodc.obj dasrti.obj\
	intg.obj feval.obj bva.obj comm.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak


colnew-int.obj: ../stack.h
dasrti.obj: ../stack.h
datatf.obj: ../stack.h
fmlelm.obj: ../stack.h
indxg.obj: ../stack.h
intcos.obj: ../stack.h
logelm.obj: ../stack.h
logic.obj: ../stack.h
lspops.obj: ../stack.h
lstelm.obj: ../stack.h
lstops.obj: ../stack.h
matdes.obj: ../stack.h
matdsc.obj: ../stack.h
matdsr.obj: ../stack.h
matelm.obj: ../stack.h
matimp.obj: ../stack.h
matio.obj: ../stack.h
matlu.obj: ../stack.h
matnew.obj: ../stack.h
matodc.obj: ../stack.h
matode.obj: ../stack.h
matops.obj: ../stack.h
matopt.obj: ../stack.h
matqr.obj: ../stack.h
matqz.obj: ../stack.h
matric.obj: ../stack.h
matsvd.obj: ../stack.h
matsys.obj: ../stack.h
matusr.obj: ../stack.h
metane.obj: ../stack.h
misops.obj: ../stack.h
polaut.obj: ../stack.h
polelm.obj: ../stack.h
polops.obj: ../stack.h
sigelm.obj: ../stack.h
spelm.obj: ../stack.h
spops.obj: ../stack.h
stack-more.obj: ../stack.h
stack.obj: ../stack.h
strelm.obj: ../stack.h
strops.obj: ../stack.h
where.obj: ../stack.h
xawelm.obj: ../stack.h
ctest.obj: ../machine.h
coselm.obj: ../stack.h
