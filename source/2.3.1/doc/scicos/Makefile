SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

TEXFILES = scicos.tex 

all:: $(SCIDOC)/Scicos.ps


$(SCIDOC)/Scicos.ps: $(TEXFILES)
	latex scicos
	latex scicos
	latex scicos
	$(RM) $(SCIDOC)/Scicos.ps
	dvips -o $(SCIDOC)/Scicos.ps scicos.dvi

clean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc

