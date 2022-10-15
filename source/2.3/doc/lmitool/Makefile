SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

TEXFILES = lmidoc.tex

all:: $(SCIDOC)/Lmi.ps

$(SCIDOC)/Lmi.ps: $(TEXFILES)
	latex lmidoc
	latex lmidoc
	$(RM) $@
	dvips -o $(SCIDOC)/Lmi.ps lmidoc.dvi

clean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc
