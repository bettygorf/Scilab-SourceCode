SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

INTROFILES = basicprimitives.tex chap0.tex chap1.tex datatypes.tex \
	graphics.tex intersci.tex intro.tex programming.tex \
	demosession.tex maple2scilab.tex intro.tex

INTERNALFILES = compl0.tex compl1.tex intersci.tex chap8.tex

all:: subs $(SCIDOC)/Intro.ps.Z $(SCIDOC)/Internals.ps.Z

$(SCIDOC)/Intro.ps.Z: subs  $(INTROFILES)
	olatex209 intro
	makeindex -s intro.isty intro
	olatex209 intro
	dvips -o $(SCIDOC)/Intro.ps intro.dvi
	$(RM) $(SCIDOC)/Intro.ps.Z
	compress $(SCIDOC)/Intro.ps

$(SCIDOC)/Internals.ps.Z: $(INTERNALFILES)
	olatex209 compl
	makeindex -s compl.isty compl
	olatex209 compl
	dvips -o $(SCIDOC)/Internals.ps compl.dvi
	$(RM) $(SCIDOC)/Internals.ps.Z
	compress $(SCIDOC)/Internals.ps

clean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc

SUBDIRS = diary figures fort

subs::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making" subs "in intro/$$i..."; \
			$(MAKE) $(MFLAGS) all); \
	done

clean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making" clean "in intro/$$i..."; \
			$(MAKE) $(MFLAGS) clean); \
	done

distclean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making" distclean "in intro/$$i..."; \
			$(MAKE) $(MFLAGS) distclean); \
	done
