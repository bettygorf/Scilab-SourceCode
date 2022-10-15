SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

all:: $(SCIDOC)/Metanet.ps.Z

$(SCIDOC)/Metanet.ps.Z: metanet.tex
	touch metanet.ind
	latex metanet
	makeindex metanet
	latex metanet
	dvips -o $(SCIDOC)/Metanet.ps metanet.dvi
	$(RM) $(SCIDOC)/Metanet.ps.Z
	compress $(SCIDOC)/Metanet.ps

clean::
	$(RM) *.aux *.log  *.dvi *.idx *.ind *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.idx *.ind *.ilg *.lof *.lot *.toc
