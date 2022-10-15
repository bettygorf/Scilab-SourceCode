SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)-doc
include ../../Makefile.incl

FILES = Chap1.tex Chap2.tex Chap3.tex Chap4.tex Chap5.tex Chap6.tex Chap7.tex Chap8.tex \
	Chap2-1.tex Chap2-2.tex Chap2-3.tex Chap2-4.tex Chap2-5.tex 

MAN1 = $(SCIDIR)/man/Man-Part1
MAN2 = $(SCIDIR)/man/Man-Part2

TR2TEX = tr2latex/tr2tex
LATEX =olatex209

all:: $(SCIDOC)/Manual.ps.Z

SUBDIRS = tr2latex Test Sample

clean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making" clean "in LaTeX-doc/$$i..."; \
			$(MAKE) $(MFLAGS)  clean); \
	done

distclean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making" distclean "in LaTeX-doc/$$i..."; \
			$(MAKE) $(MFLAGS)  distclean); \
	done

$(SCIDOC)/Manual.ps.Z: $(TR2TEX) chapters couvert.tex couv2.ps
	$(LATEX) Docu
	makeindex -s Docu.isty Docu
	$(LATEX) Docu
	dvips -o $(SCIDOC)/Manual.ps Docu.dvi
	$(RM) $(SCIDOC)/Manual.ps.Z
	compress $(SCIDOC)/Manual.ps

couv2.ps: couv2.tex
	$(LATEX) couv2
	dvips -o couv2.ps couv2.dvi

chapters: $(FILES)

$(TR2TEX) : tr2latex/*.c tr2latex/*.h
	cd tr2latex ; $(MAKE) $(MFLAGS)

Chap1.tex : $(TR2TEX) $(MAN1)/man1/?*.1
	$(TR2TEX)  -m $(MAN1)/man1/?*.1 > /tmp/Chap1.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap1.tex > Chap1.tex
	$(RM) /tmp/Chap1.tex

Chap2.tex : $(TR2TEX) $(MAN1)/man2/?*.2
	$(TR2TEX)  -m $(MAN1)/man2/?*.2 > /tmp/Chap2.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2.tex > Chap2.tex
	$(RM) /tmp/Chap2.tex

Chap3.tex : $(TR2TEX) $(MAN1)/man3/?*.3
	$(TR2TEX)  -m $(MAN1)/man3/?*.3 > /tmp/Chap3.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap3.tex > Chap3.tex
	$(RM) /tmp/Chap3.tex

Chap4.tex : $(TR2TEX) $(MAN1)/man4/?*.4
	$(TR2TEX)  -m $(MAN1)/man4/?*.4 > /tmp/Chap4.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap4.tex > Chap4.tex
	$(RM) /tmp/Chap4.tex

Chap5.tex : $(TR2TEX) $(MAN1)/man5/?*.5
	$(TR2TEX)  -m $(MAN1)/man5/?*.5 > /tmp/Chap5.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap5.tex > Chap5.tex
	$(RM) /tmp/Chap5.tex

Chap6.tex : $(TR2TEX) $(MAN1)/man6/?*.6
	$(TR2TEX)  -m $(MAN1)/man6/?*.6 > /tmp/Chap6.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap6.tex > Chap6.tex
	$(RM) /tmp/Chap6.tex

Chap7.tex : $(TR2TEX) $(MAN1)/man7/?*.7
	$(TR2TEX)  -m $(MAN1)/man7/?*.7 > /tmp/Chap7.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap7.tex > Chap7.tex
	$(RM) /tmp/Chap7.tex

Chap8.tex : $(TR2TEX) $(MAN1)/man8/?*.8
	$(TR2TEX)  -m $(MAN1)/man8/?*.8 > /tmp/Chap8.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap8.tex > Chap8.tex
	$(RM) /tmp/Chap8.tex

Chap2-1.tex : $(TR2TEX) $(MAN2)/man1/?*.1
	$(TR2TEX)  -m $(MAN2)/man1/?*.1 > /tmp/Chap2-1.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-1.tex > Chap2-1.tex
	$(RM) /tmp/Chap2-1.tex

Chap2-2.tex : $(TR2TEX) $(MAN2)/man2/?*.2
	$(TR2TEX)  -m $(MAN2)/man2/?*.2 > /tmp/Chap2-2.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-2.tex > Chap2-2.tex
	$(RM) /tmp/Chap2-2.tex

Chap2-3.tex : $(TR2TEX) $(MAN2)/man3/?*.3
	$(TR2TEX)  -m $(MAN2)/man3/?*.3 > /tmp/Chap2-3.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-3.tex > Chap2-3.tex
	$(RM) /tmp/Chap2-3.tex

Chap2-4.tex : $(TR2TEX) $(MAN2)/man4/?*.4
	$(TR2TEX)  -m $(MAN2)/man4/?*.4 > /tmp/Chap2-4.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-4.tex > Chap2-4.tex
	$(RM) /tmp/Chap2-4.tex

Chap2-5.tex : $(TR2TEX) $(MAN2)/man5/?*.5
	$(TR2TEX)  -m $(MAN2)/man5/?*.5 > /tmp/Chap2-5.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-5.tex > Chap2-5.tex
	$(RM) /tmp/Chap2-5.tex


clean::
	$(RM) *.aux *.log Chap*.tex *.dvi *.ind *.idx *.ilg  *.toc *.lot

distclean::
	$(RM) *.aux *.log Chap*.tex *.dvi *.ind *.idx *.ilg *.toc *.lot
