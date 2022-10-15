SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

TEXFILES = bibli.tex chap0.tex chap1.tex chap2.tex chap3.tex chap4.tex \
	chap5.tex chap6.tex chap7.tex chap8.tex chap9.tex

all:: $(SCIDOC)/Signal.ps

$(SCIDOC)/Signal.ps: subs $(TEXFILES)
	latex Toolbox
	latex Toolbox
	makeindex -s Toolbox.isty Toolbox
	latex Toolbox
	$(RM) $(SCIDOC)/Signal.ps
	dvips -o $(SCIDOC)/Signal.ps Toolbox.dvi

clean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc
distclean::
	$(RM) *.aux *.log  *.dvi *.ind *.idx *.ilg *.lof *.lot *.toc

SUBDIRS = Nsource_diary Nfigs_source

subs:
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making" subs "in signal/$$i..."; \
			$(MAKE) $(MFLAGS) all); \
	done

clean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making" clean "in signal/$$i..."; \
			$(MAKE) $(MFLAGS) clean); \
	done

distclean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making" distclean "in signal/$$i..."; \
			$(MAKE) $(MFLAGS) distclean); \
	done
