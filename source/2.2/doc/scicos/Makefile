SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

TEXFILES = scicos.tex 

all:: $(SCIDOC)/Scicos.ps.Z


$(SCIDOC)/Scicos.ps.Z: $(TEXFILES)
	olatex209 scicos
	olatex209 scicos
	dvips -o $(SCIDOC)/Scicos.ps scicos.dvi
	$(RM) $(SCIDOC)/Scicos.ps.Z
	compress $(SCIDOC)/Scicos.ps

clean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc

