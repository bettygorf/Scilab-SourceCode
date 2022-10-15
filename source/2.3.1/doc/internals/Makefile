SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

INTERNALFILES = compl0.tex internals.tex

all:: $(SCIDOC)/Internals.ps

$(SCIDOC)/Internals.ps: $(INTERNALFILES)
	latex compl
	makeindex -s compl.isty compl
	latex compl
	$(RM) $@
	dvips -o $(SCIDOC)/Internals.ps compl.dvi

clean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc

