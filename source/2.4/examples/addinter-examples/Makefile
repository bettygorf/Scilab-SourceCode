SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

all:: info

world: info

info:
	@echo "Type \"make test\" to compile all programs (in /tmp)"
	@echo "Type \"make /tmp/pgm.o\" to compile pgm program"


FFLAGS = $(FC_OPTIONS) $(FC_PICFLAGS)

CFLAGS = $(CC_OPTIONS) $(CC_PICFLAGS)

OBJSF = /tmp/ex1f.o /tmp/ex1fi.o /tmp/ex2f.o /tmp/ex2fi.o \
	/tmp/ex3f.o /tmp/ex3fi.o  /tmp/ex4fi.o \
	/tmp/ex6f.o /tmp/ex6fi.o /tmp/ex5f.o /tmp/ex5fm.o

OBJSC = /tmp/ex1c.o /tmp/ex1cI.o /tmp/ex2c.o /tmp/ex2cI.o \
	/tmp/ex3c.o /tmp/ex3cI.o /tmp/ex4cI.o \
	/tmp/ex5cI.o /tmp/ex5c.o /tmp/ex5cm.o /tmp/ex6c.o /tmp/ex6cI.o \
	/tmp/ex5fI.o

test : $(OBJSF) $(OBJSC)

/tmp/ex1f.o: ex1f.f
	$(FC) $(FFLAGS) -c ex1f.f  -o /tmp/ex1f.o

/tmp/ex1fi.o: ex1fi.f
	$(FC) $(FFLAGS) -c ex1fi.f  -o /tmp/ex1fi.o

/tmp/ex1c.o: ex1c.c
	$(CC) $(CFLAGS) -c ex1c.c  -o /tmp/ex1c.o

/tmp/ex1cI.o: ex1cI.c
	$(CC) $(CFLAGS) -c ex1cI.c  -o /tmp/ex1cI.o

/tmp/ex2f.o: ex2f.f
	$(FC) $(FFLAGS) -c ex2f.f  -o /tmp/ex2f.o

/tmp/ex2fi.o: ex2fi.f
	$(FC) $(FFLAGS) -c ex2fi.f  -o /tmp/ex2fi.o

/tmp/ex2c.o: ex2c.c
	$(CC) $(CFLAGS) -c ex2c.c  -o /tmp/ex2c.o

/tmp/ex2cI.o: ex2cI.c
	$(CC) $(CFLAGS) -c ex2cI.c  -o /tmp/ex2cI.o

/tmp/ex3f.o: ex3f.c
	$(CC) $(CFLAGS) -c ex3f.c  -o /tmp/ex3f.o

/tmp/ex3fi.o: ex3fi.f
	$(FC) $(FFLAGS) -c ex3fi.f  -o /tmp/ex3fi.o

/tmp/ex3c.o: ex3c.c
	$(CC) $(CFLAGS) -c ex3c.c  -o /tmp/ex3c.o

/tmp/ex3cI.o: ex3cI.c
	$(CC) $(CFLAGS) -c ex3cI.c  -o /tmp/ex3cI.o

/tmp/ex4fi.o: ex4fi.f
	$(FC) $(FFLAGS) -c ex4fi.f  -o /tmp/ex4fi.o

/tmp/ex4cI.o: ex4cI.c
	$(CC) $(CFLAGS) -c ex4cI.c  -o /tmp/ex4cI.o

/tmp/ex5c.o: ex5c.c
	$(CC) $(CFLAGS) -c ex5c.c  -o /tmp/ex5c.o

/tmp/ex5cm.o: ex5cm.c
	$(CC) $(CFLAGS) -c ex5cm.c  -o /tmp/ex5cm.o

/tmp/ex5cI.o: ex5cI.c
	$(CC) $(CFLAGS) -c ex5cI.c  -o /tmp/ex5cI.o

/tmp/ex5fI.o: ex5fI.c
	$(CC) $(CFLAGS) -c ex5fI.c  -o /tmp/ex5fI.o

/tmp/ex5f.o: ex5f.f
	$(FC) $(FFLAGS) -c ex5f.f  -o /tmp/ex5f.o

/tmp/ex5fm.o: ex5fm.f
	$(FC) $(FFLAGS) -c ex5fm.f  -o /tmp/ex5fm.o


/tmp/ex6f.o: ex6f.f
	$(FC) $(FFLAGS) -c ex6f.f  -o /tmp/ex6f.o

/tmp/ex6fi.o: ex6fi.f
	$(FC) $(FFLAGS) -c ex6fi.f  -o /tmp/ex6fi.o

/tmp/ex6c.o: ex6c.c
	$(CC) $(CFLAGS) -c ex6c.c  -o /tmp/ex6c.o

/tmp/ex6cI.o: ex6cI.c
	$(CC) $(CFLAGS) -c ex6cI.c  -o /tmp/ex6cI.o

/tmp/ex7fi.o: ex7fi.f
	$(FC) $(FFLAGS) -c ex7fi.f  -o /tmp/ex7fi.o

/tmp/ex8fi.o: ex8fi.f
	$(FC) $(FFLAGS) -c ex8fi.f  -o /tmp/ex8fi.o

clean::
	@echo Cleaning addinter-examples
	@$(RM) $(OBJSF) $(OBJSC)

distclean:: clean


##----------------------  test all the example  

EXAMPLES=ex1c.sce ex1f.sce ex2c.sce ex2f.sce ex3c.sce \
	ex3f.sce ex4c.sce ex4f.sce ex5c.sce ex6c.sce ex6f.sce ex7f.sce ex8f.sce

tests	:
	@$(RM) zlink.dia	
	@cat $(EXAMPLES) > zlink.tst 		
	@$(SCIDIR)/util/scidem $(SCIDIR) zlink.tst zlink.dia

clean	::
	@$(RM) zlink.dia zlink.tst 

distclean::
	@$(RM) zlink.dia zlink.tst $(OBJSC) $(OBJSF) 



