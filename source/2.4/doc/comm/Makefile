SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

all:: $(SCIDOC)/Comm.ps

$(SCIDOC)/Comm.ps: comm.tex
	latex comm
	latex comm
	$(RM) $@
	dvips -o $(SCIDOC)/Comm.ps comm.dvi

clean::
	$(RM) *.aux *.log  *.dvi *.idx *.ind *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.idx *.ind *.ilg *.lof *.lot *.toc

CFLAGS = $(CC_OPTIONS)

examples: alpha beta

alpha: alpha.c
	$(RM) alpha
	$(CC) -o alpha alpha.c $(CC_LDFLAGS) $(SCIDIR)/libs/libcomm.a

beta: beta.c
	$(RM) beta
	$(CC) -o beta beta.c $(CC_LDFLAGS) $(SCIDIR)/libs/libcomm.a

distclean::
	$(RM) alpha beta
