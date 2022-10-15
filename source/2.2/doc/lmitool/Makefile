SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

TEXFILES = lmidoc.tex

all:: $(SCIDOC)/Lmi.ps.Z

$(SCIDOC)/Lmi.ps.Z: $(TEXFILES)
	olatex209 lmidoc
	olatex209 lmidoc
	dvips -o $(SCIDOC)/Lmi.ps lmidoc.dvi
	$(RM) $(SCIDOC)/Lmi.ps.Z
	compress $(SCIDOC)/Lmi.ps

clean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc
