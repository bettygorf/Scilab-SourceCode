SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

all:: info

world: info

info:
	@echo "Type \"make /tmp/pgm.o\" to compile pgm program"


FFLAGS = $(FC_OPTIONS)

CFLAGS = $(CC_OPTIONS)

/tmp/wfex.o: src/wfex.f
	$(FC) $(FFLAGS) -c src/wfex.f  -o /tmp/wfex.o

/tmp/wjex.o: src/wjex.f
	$(FC) $(FFLAGS) -c src/wjex.f  -o /tmp/wjex.o

/tmp/wfexab.o: src/wfexab.f
	$(FC) $(FFLAGS) -c src/wfexab.f  -o /tmp/wfexab.o

/tmp/res22.o: src/res22.f
	$(FC) $(FFLAGS) -c src/res22.f  -o /tmp/res22.o

/tmp/jac22.o: src/jac22.f
	$(FC) $(FFLAGS) -c src/jac22.f  -o /tmp/jac22.o

/tmp/gr22.o: src/gr22.f
	$(FC) $(FFLAGS) -c src/gr22.f  -o /tmp/gr22.o


clean::
	$(RM) /tmp/res22.o /tmp/jac22.o /tmp/gr22.o /tmp/fexab2.o so_locations *.o

distclean:: clean


