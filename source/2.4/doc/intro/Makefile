SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

INTROFILES = chap4.tex chap0.tex chap1.tex chap2.tex \
	chap5.tex intro.tex chap3.tex \
	appendices.tex chap6.tex intro.tex

all:: $(SCIDOC)/Intro.ps

$(SCIDOC)/Intro.ps: subs  $(INTROFILES)
	latex intro
	makeindex -s intro.isty intro
	latex intro
	$(RM) $@
	dvips -o $(SCIDOC)/Intro.ps intro.dvi

clean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc

SUBDIRS = diary figures fort macros

subs:
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
