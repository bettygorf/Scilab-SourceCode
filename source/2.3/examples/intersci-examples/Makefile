SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

all:: info

world: info

info:
	@echo "Type \"make /tmp/pgm.o\" to compile pgm program"

FFLAGS = $(FC_OPTIONS)

CFLAGS = $(CC_OPTIONS)

/tmp/intmatusr.o: intmatusr.f
	$(FC) $(FFLAGS) -c intmatusr.f  -o /tmp/intmatusr.o

/tmp/matusr-f.o: src/matusr-f.f
	$(FC) $(FFLAGS) -c src/matusr-f.f  -o /tmp/matusr-f.o

/tmp/matusr-c.o: src/matusr-c.c
	$(CC) $(CFLAGS) -c src/matusr-c.c  -o /tmp/matusr-c.o

/tmp/intdaxpy.o: intdaxpy.f
	$(FC) $(FFLAGS) -c intdaxpy.f  -o /tmp/intdaxpy.o

/tmp/intfoobar.o: intfoobar.f
	$(FC) $(FFLAGS) -c intfoobar.f  -o /tmp/intfoobar.o

/tmp/foubare2.o: src/foubare2.f
	$(FC) $(FFLAGS) -c src/foubare2.f  -o /tmp/foubare2.o

/tmp/intex1.o: intex1.f
	$(FC) $(FFLAGS) -c intex1.f  -o /tmp/intex1.o

/tmp/fcalc.o: src/fcalc.f
	$(FC) $(FFLAGS) -c src/fcalc.f  -o /tmp/fcalc.o

/tmp/intex2.o: intex2.f
	$(FC) $(FFLAGS) -c intex2.f  -o /tmp/intex2.o

/tmp/fsom.o: src/fsom.f
	$(FC) $(FFLAGS) -c src/fsom.f  -o /tmp/fsom.o

/tmp/intex4.o: intex4.f
	$(FC) $(FFLAGS) -c intex4.f  -o /tmp/intex4.o

/tmp/contr.o: src/contr.f
	$(FC) $(FFLAGS) -c src/contr.f  -o /tmp/contr.o

clean::
	$(RM) /tmp/intmatusr.o /tmp/matusr-c.o /tmp/matusr-f.o intmatusr.f intmatusr.sce matusr.tmp matusr.fundef /tmp/intdaxpy.o intdaxpy.f intdaxpy.sce /tmp/intfoobar.o intfoobar.f intfoobar.sce /tmp/foubare2.o foobar.f /tmp/intex1.o /tmp/fcalc.o intex1.f intex1.sce /tmp/intex2.o /tmp/fsom.o intex2.f intex2.sce /tmp/intex4.o /tmp/contr.o intex4.f intex4.sce *.fundef *.tmp so_locations *.o

distclean:: clean


