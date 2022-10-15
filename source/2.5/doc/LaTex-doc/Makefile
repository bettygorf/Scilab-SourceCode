SHELL = /bin/sh

include ../../Version.incl
SCIDIR=../..
SCIDOC=$(SCIDIR)/../$(SCIVERSION)/doc
include ../../Makefile.incl

FILES = Chap1.tex Chap2.tex Chap3.tex Chap4.tex Chap5.tex Chap6.tex \
	Chap7.tex Chap8.tex \
	Chap2-1.tex Chap2-2.tex Chap2-3.tex Chap2-4.tex Chap2-5.tex \
	Chap2-6.tex Chap2-7.tex \
	Chap3-1.tex Chap3-2.tex Chap3-3.tex Chap3-4.tex 

MAN = $(SCIDIR)/man/


TR2TEX = tr2latex/translate
LATEX = latex

all:: $(SCIDOC)/Manual.ps

SUBDIRS = tr2latex

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

$(SCIDOC)/Manual.ps: Tr2tex chapters couvert.tex couv2.ps
	$(LATEX) Docu.tex
	$(LATEX) Docu.tex
	$(LATEX) Docu.tex
	makeindex -s Docu.isty Docu
	$(LATEX) Docu.tex
	$(RM) $@
	dvips -o $@ Docu.dvi

pdf: Tr2tex chapters couvert.tex couv2.ps
	awk '{if ($$1~"documentstyle") \
	{printf "\\documentstyle[verbatim,tr2latex/troffman,makeidx,hyperref,times]{book}\n"} else {print $$0} }' \
	Docu.tex > Docu_pdf.tex
	$(LATEX) Docu_pdf.tex
	$(LATEX) Docu_pdf.tex
	$(LATEX) Docu_pdf.tex
	makeindex -s Docu.isty Docu_pdf
	$(LATEX) Docu_pdf.tex
	dvips -z -o Manual_pdf.ps Docu_pdf.dvi

couv2.ps: couv2.tex
	$(LATEX) couv2
	dvips -o couv2.ps couv2.dvi

chapters: $(FILES)

Tr2tex : tr2latex/*.c tr2latex/*.h
	cd tr2latex ; $(MAKE) $(MFLAGS)

Chap1.tex : $(TR2TEX) $(MAN)/programming/*.man
	$(TR2TEX)  -m $(MAN)/programming/?*.man > /tmp/Chap1.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap1.tex > Chap1.tex
	$(RM) /tmp/Chap1.tex

Chap2.tex : $(TR2TEX) $(MAN)/graphics/?*.man
	$(TR2TEX)  -m $(MAN)/graphics/?*.man > /tmp/Chap2.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2.tex > Chap2.tex
	$(RM) /tmp/Chap2.tex

Chap3.tex : $(TR2TEX) $(MAN)/elementary/?*.man
	$(TR2TEX)  -m $(MAN)/elementary/?*.man > /tmp/Chap3.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap3.tex > Chap3.tex
	$(RM) /tmp/Chap3.tex

Chap4.tex : $(TR2TEX) $(MAN)/control/?*.man
	$(TR2TEX)  -m $(MAN)/control/?*.man > /tmp/Chap4.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap4.tex > Chap4.tex
	$(RM) /tmp/Chap4.tex

Chap5.tex : $(TR2TEX) $(MAN)/robust/?*.man
	$(TR2TEX)  -m $(MAN)/robust/?*.man > /tmp/Chap5.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap5.tex > Chap5.tex
	$(RM) /tmp/Chap5.tex

Chap6.tex : $(TR2TEX) $(MAN)/nonlinear/?*.man
	$(TR2TEX)  -m $(MAN)/nonlinear/?*.man > /tmp/Chap6.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap6.tex > Chap6.tex
	$(RM) /tmp/Chap6.tex

Chap7.tex : $(TR2TEX) $(MAN)/signal/?*.man
	$(TR2TEX)  -m $(MAN)/signal/?*.man > /tmp/Chap7.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap7.tex > Chap7.tex
	$(RM) /tmp/Chap7.tex

Chap8.tex : $(TR2TEX) $(MAN)/polynomials/?*.man
	$(TR2TEX)  -m $(MAN)/polynomials/?*.man > /tmp/Chap8.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap8.tex > Chap8.tex
	$(RM) /tmp/Chap8.tex

Chap2-1.tex : $(TR2TEX) $(MAN)/linear/?*.man
	$(TR2TEX)  -m $(MAN)/linear/?*.man > /tmp/Chap2-1.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-1.tex > Chap2-1.tex
	$(RM) /tmp/Chap2-1.tex

Chap2-2.tex : $(TR2TEX) $(MAN)/metanet/?*.man
	$(TR2TEX)  -m $(MAN)/metanet/?*.man > /tmp/Chap2-2.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-2.tex > Chap2-2.tex
	$(RM) /tmp/Chap2-2.tex

Chap2-3.tex : $(TR2TEX) $(MAN)/arma/?*.man
	$(TR2TEX)  -m $(MAN)/arma/?*.man > /tmp/Chap2-3.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-3.tex > Chap2-3.tex
	$(RM) /tmp/Chap2-3.tex

Chap2-4.tex : $(TR2TEX) $(MAN)/tdcs/?*.man
	$(TR2TEX)  -m $(MAN)/tdcs/?*.man > /tmp/Chap2-4.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-4.tex > Chap2-4.tex
	$(RM) /tmp/Chap2-4.tex

Chap2-5.tex : $(TR2TEX) $(MAN)/scicos/?*.man
	@echo "\section{Scicos editor}" > /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/scicos.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/scicos_menus.man >> /tmp/Chap2-5.tex
	@echo "\section{Blocks}" >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/?*_f.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/scifunc_block.man >> /tmp/Chap2-5.tex
	@echo "\section{Data Structures}" >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/scicos_main.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/scicos_block.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/scicos_graphics.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/scicos_model.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/scicos_link.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/scicos_cpr.man >> /tmp/Chap2-5.tex
	@echo "\section{Useful Functions}" >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/standard_*.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/scicosim.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/curblock.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/getblocklabel.man >> /tmp/Chap2-5.tex
	$(TR2TEX)  -m $(MAN)/scicos/?*scicosvars.man >> /tmp/Chap2-5.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-5.tex > Chap2-5.tex
	$(RM) /tmp/Chap2-5.tex

Chap2-6.tex : $(TR2TEX) $(MAN)/sound/?*.man
	$(TR2TEX)  -m $(MAN)/sound/?*.man > /tmp/Chap2-6.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-6.tex > Chap2-6.tex
	$(RM) /tmp/Chap2-6.tex

Chap2-7.tex : $(TR2TEX) $(MAN)/dcd/?*.man
	$(TR2TEX)  -m $(MAN)/dcd/?*.man > /tmp/Chap2-7.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap2-7.tex > Chap2-7.tex
	$(RM) /tmp/Chap2-7.tex

Chap3-1.tex : $(TR2TEX) $(MAN)/fraclab/?*.man
	$(TR2TEX)  -m $(MAN)/fraclab/?*.man > /tmp/Chap3-1.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap3-1.tex > Chap3-1.tex
	$(RM) /tmp/Chap3-1.tex
Chap3-2.tex : $(TR2TEX) $(MAN)/tksci/?*.man
	$(TR2TEX)  -m $(MAN)/tksci/?*.man > /tmp/Chap3-2.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap3-2.tex > Chap3-2.tex
	$(RM) /tmp/Chap3-2.tex
Chap3-3.tex : $(TR2TEX) $(MAN)/translation/?*.man
	$(TR2TEX)  -m $(MAN)/translation/?*.man > /tmp/Chap3-3.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap3-3.tex > Chap3-3.tex
	$(RM) /tmp/Chap3-3.tex
Chap3-4.tex : $(TR2TEX) $(MAN)/pvm/?*.man $(MAN)/comm/?*.man 
	$(TR2TEX)  -m $(MAN)/pvm/?*.man > /tmp/Chap3-4.tex
	$(TR2TEX)  -m $(MAN)/comm/?*.man >> /tmp/Chap3-4.tex
	@sed -e 's/\\documentstyle/%\\documentstyle/' 			-e 's/\\end{document}//' -e 's/\\begin{document}//' /tmp/Chap3-4.tex > Chap3-4.tex
	$(RM) /tmp/Chap3-4.tex

clean::
	$(RM) *.aux *.log Chap*.tex *.dvi *.ind *.idx *.ilg  *.toc *.lot \
	Docu_pdf.* *.tmp Manual_pdf.ps Warnings

distclean:: clean 
