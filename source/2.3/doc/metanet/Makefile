SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

all:: $(SCIDOC)/Metanet.ps

$(SCIDOC)/Metanet.ps: metanet.tex
	touch metanet.ind
	latex metanet
	makeindex metanet
	latex metanet
	$(RM) $(SCIDOC)/Metanet.ps
	dvips -o $(SCIDOC)/Metanet.ps metanet.dvi

clean::
	$(RM) *.aux *.log  *.dvi *.idx *.ind *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.idx *.ind *.ilg *.lof *.lot *.toc
