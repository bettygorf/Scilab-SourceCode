SHELL = /bin/sh

include ../Version.incl
SCIDIR=..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
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
	$(RM) $(OBJ) $(PROGRAM) *.fundef ex*.f

test: $(SCIDIR)/bin/intersci
	$(SCIDIR)/bin/intersci ex1 1
	$(SCIDIR)/bin/intersci ex2 1
	$(SCIDIR)/bin/intersci ex3 1
	$(SCIDIR)/bin/intersci ex4 1

intersci.o: intersci.h

LATEX = olatex209

world:: $(SCIDOC)/Intersci.ps.Z

$(SCIDOC)/Intersci.ps.Z: intersci.tex
	$(LATEX) intersci
	$(LATEX) intersci
	dvips -o $(SCIDOC)/Intersci.ps intersci.dvi
	$(RM) $(SCIDOC)/Intersci.ps.Z
	compress $(SCIDOC)/Intersci.ps

clean::
	$(RM) *.aux *.log Chap*.tex *.dvi *.ind *.idx *.ilg  *.toc *.lot

distclean::
	$(RM) *.aux *.log Chap*.tex *.dvi *.ind *.idx *.ilg *.toc *.lot
