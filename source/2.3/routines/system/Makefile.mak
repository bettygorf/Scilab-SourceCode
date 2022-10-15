SHELL = /bin/sh

SCIDIR=../..
include ../../Version.incl

LIBRARY = $(SCIDIR)/libs/system.lib

OBJSC = helpap.obj

OBJSF = allops.obj  banier.obj sascii.obj \
	clause.obj comand.obj compcl.obj   \
	defmat.obj eqid.obj error.obj expr.obj fact.obj funs.obj \
	getch.obj  getlin.obj getnum.obj getstr.obj getsym.obj \
	getval.obj helpmg.obj inisci.obj \
	logops.obj macro.obj mname.obj nextj.obj parse.obj print.obj \
	putid.obj  run.obj savlod.obj msize.obj stackg.obj \
	stackp.obj terme.obj xchar.obj  scirun.obj \
	majmin.obj apropo.obj whatln.obj \
	seteol.obj setlnb.obj skpins.obj msgs.obj prntid.obj \
	cvname.obj cvstr.obj compil.obj ptover.obj ptrback.obj \
	isbrk.obj scilab.obj sciquit.obj bexec.obj scilines.obj \
	mrknmd.obj mkindx.obj mklist.obj prompt.obj 

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) 

include ../Make.lib.mak

banier.f: banier.g $(SCIDIR)/Version.incl
	@$(RM) banier.f
	@sed -e "s+SCILAB_VERSION+$(SCIVERSION)+" \
	-e "s+SCILAB_DATE+$(SCIDATE)+" banier.g > banier.f;
	@chmod g+w banier.f
	@echo banier.f created


allops.obj: ../stack.h
apropo.obj: ../stack.h
bexec.obj: ../stack.h
clause.obj: ../stack.h
comand.obj: ../stack.h
compcl.obj: ../stack.h
compil.obj: ../stack.h
cvname.obj: ../stack.h
cvname.obj: ../stack.h
cvstr.obj: ../stack.h
defmat.obj: ../stack.h
eqid.obj: ../stack.h
error.obj: ../stack.h
expr.obj: ../stack.h
fact.obj: ../stack.h
funs.obj: ../stack.h
getch.obj: ../stack.h
getlin.obj: ../stack.h
getnum.obj: ../stack.h
getstr.obj: ../stack.h
getsym.obj: ../stack.h
getval.obj: ../stack.h
helpmg.obj: ../stack.h
inisci.obj: ../stack.h
logops.obj: ../stack.h
macro.obj: ../stack.h
matla0.obj: ../stack.h ../callinter.h
mkindx.obj: ../stack.h
mklist.obj: ../stack.h
mname.obj: ../stack.h
mrknmd.obj: ../stack.h
msgs.obj: ../stack.h
nextj.obj: ../stack.h
parse.obj: ../stack.h
print.obj: ../stack.h
prntid.obj: ../stack.h
prompt.obj: ../stack.h
tover.obj: ../stack.h
ptover.obj: ../stack.h
ptrback.obj: ../stack.h
ptrback.obj: ../stack.h
putid.obj: ../stack.h
run.obj: ../stack.h
sascii.obj: ../stack.h
savlod.obj: ../stack.h
scilines.obj: ../stack.h
sciquit.obj: ../stack.h
scirun.obj: ../stack.h ../callinter.h
seteol.obj: ../stack.h
setlnb.obj: ../stack.h
size.obj: ../stack.h
skpins.obj: ../stack.h
stackg.obj: ../stack.h
stackp.obj: ../stack.h
terme.obj: ../stack.h
userlk.obj: ../stack.h
whatln.obj: ../stack.h
xchar.obj: ../stack.h

