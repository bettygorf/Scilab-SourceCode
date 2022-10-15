SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

all:: info

world: info

info:
	@echo "Type \"make test\" to compile all programs (in /tmp)"
	@echo "Type \"make /tmp/pgm.o\" to compile pgm program"


FFLAGS = $(FC_OPTIONS)

CFLAGS = $(CC_OPTIONS)

OBJSF = /tmp/Examplf.o /tmp/foubare2f.o

OBJSC = /tmp/Examplc.o /tmp/foubare2c.o

test : $(OBJSF) $(OBJSC)

/tmp/Examplf.o: Examplf.f
	$(FC) $(FFLAGS) -c Examplf.f  -o /tmp/Examplf.o 

/tmp/foubare2f.o: src/foubare2f.f
	$(FC) $(FFLAGS) -c src/foubare2f.f  -o /tmp/foubare2f.o

/tmp/Examplc.o: Examplc.c
	$(CC) $(CFLAGS) -c Examplc.c  -o /tmp/Examplc.o

/tmp/foubare2c.o: src/foubare2c.c
	$(CC) $(CFLAGS) -c src/foubare2c.c  -o /tmp/foubare2c.o

/tmp/dgemmint.o: dgemmint.f
	$(FC) $(FFLAGS) -c dgemmint.f  -o /tmp/dgemmint.o

/tmp/fcalcint.o: fcalcint.f
	$(FC) $(FFLAGS) -c fcalcint.f  -o /tmp/fcalcint.o

/tmp/fcalc.o: src/fcalc.f
	$(FC) $(FFLAGS) -c src/fcalc.f  -o /tmp/fcalc.o

/tmp/fcalc2.o: src/fcalc2.f
	$(FC) $(FFLAGS) -c src/fcalc2.f  -o /tmp/fcalc2.o

/tmp/Testf.o: Testf.f
	$(FC) $(FFLAGS) -c Testf.f  -o /tmp/Testf.o

/tmp/OptTestf.o: OptTestf.f
	$(FC) $(FFLAGS) -c OptTestf.f  -o /tmp/OptTestf.o

/tmp/OptTestc.o: OptTestc.c
	$(CC) $(CFLAGS) -c OptTestc.c  -o /tmp/OptTestc.o

/tmp/opttest.o: src/opttest.c
	$(CC) $(CFLAGS) -c src/opttest.c  -o /tmp/opttest.o 


/tmp/testfc.o: src/testfc.c
	$(CC) $(CFLAGS) -c src/testfc.c  -o /tmp/testfc.o

/tmp/Testc.o: Testc.c
	$(CC) $(CFLAGS) -c Testc.c  -o /tmp/Testc.o

/tmp/testcc.o: src/testcc.c
	$(CC) $(CFLAGS) -c src/testcc.c  -o /tmp/testcc.o

clean::
	$(RM) /tmp/Examplf.o /tmp/Examplc.o /tmp/foubare2c.o /tmp/foubare2f.o /tmp/fcalcint.o /tmp/fcalc.o /tmp/fcalc2.o /tmp/dgemmint.o /tmp/testfc.o /tmp/Testf.o /tmp/testcc.o /tmp/Testc.o so_locations *.o

distclean:: clean


