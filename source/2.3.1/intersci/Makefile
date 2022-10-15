SHELL = /bin/sh

include ../Version.incl
SCIDIR=..
include ../Makefile.incl

CFLAGS = $(CC_OPTIONS)

OBJ = intersci.o
PROGRAM = $(SCIDIR)/bin/intersci

all:: $(PROGRAM)

world:: all

$(PROGRAM): $(OBJ)
	$(RM) $(PROGRAM)
	$(CC) -o $(PROGRAM) $(OBJ) $(CC_LDFLAGS)

clean::
	$(RM) $(OBJ)
distclean::
	$(RM) $(OBJ) $(PROGRAM)  *.fundef ex*.f

intersci.o: intersci.h

