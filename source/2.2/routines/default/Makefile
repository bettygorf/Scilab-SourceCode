SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

PROGRAM = $(SCIDIR)/bin/newfun

all:: $(PROGRAM)

world: all

$(PROGRAM): newfun.f
	$(RM) $@
	$(FC) -o $@ newfun.f $(FC_LDFLAGS)

clean::
	$(RM) newfun.o
distclean::
	$(RM) newfun.o $(PROGRAM)

OBJS = interf.o bidon.o \
	fydot.o fjac.o \
	fydotd.o \
	ffeval.o  \
	foptim.o \
	fsolvf.o fsolvj.o \
	fintg.o \
	fschur.o \
	dgetx.o dgety.o \
	fres.o fadda.o \
	fj2.o aplusp.o \
	fsurf.o fsurfd.o \
	fresd.o fjacd.o \
	fcol.o \
	mainsci.o \
	matusr.o matus2.o \
	funtab.o  msgstxt.o\
	scimem.o\
	fbutn.o

all:: $(OBJS)

funtab.f: fundef newfun.f
	$(RM) funtab.f.new funtab.f.old
	cp funtab.f funtab.f.old
	$(SCIDIR)/bin/newfun
	mv funtab.f.new funtab.f

distclean::
	$(RM) $(OBJS)

dgetx.o: ../stack.h
dgety.o: ../stack.h
fadda.o: ../stack.h
fcol.o: ../stack.h
ffeval.o: ../stack.h
fintg.o: ../stack.h
fj2.o: ../stack.h
fjac.o: ../stack.h
fjacd.o: ../stack.h
foptim.o: ../stack.h
fres.o: ../stack.h
fresd.o: ../stack.h
fschur.o: ../stack.h
fsolvf.o: ../stack.h
fsolvj.o: ../stack.h
fsurf.o: ../stack.h
fsurfd.o: ../stack.h
funtab.o: ../stack.h
fydot.o: ../stack.h
interf.o: ../stack.h
matus2.o: ../stack.h
matusr.o: ../stack.h
msgstxt.o: ../stack.h
scimem.o: ../machine.h
newfun.o: ../stack.h
fbutn.o: ../stack.h
