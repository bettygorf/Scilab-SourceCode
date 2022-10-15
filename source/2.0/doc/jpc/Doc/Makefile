# ----------------------------------------------------------
# Everything in this directory 
# except Doc.tex,Makefile,Change and Ctex.l
# can be destroyed
#-----------------------------------------------------------

TESTDIR=../../../routines/X11/XGraphic-test

FILESC = TestCh.c Test2D.c  TestC.c TestP3D.c Test3D.c 
FILESF = TestChF.f Test2DF.f  TestCF.f TestP3DF.f Test3DF.f 
FILEMORE = debut.c debutF.f

FILESC1 = Test2D2.c Test2D3.c Test2D4.c 

DOCSC  = $(FILESC:%.c=%-C.tex) 
DESC   = $(FILESC:%.c=%.ps)

DOCSC1  = $(FILESC1:%.c=%-C.tex) 
DESC1   = $(FILESC1:%.c=%.ps)

DOCSF  = $(FILESF:%.f=%-F.tex)
DESF   = $(FILESF:%.f=%.ps)

%-C.tex : $(TESTDIR)/%.c 
	@echo "Translating C source file " $< " to TeX code"
	Ctex -n < $< > $@

%-F.tex : $(TESTDIR)/%.f
	@echo "Translating Fortran source file " $< " to TeX code"
	@echo "\\begin{verbatim}" > $@
	@cat $< >> $@
	@echo "\\end{verbatim}" >> $@

%.ps  : %
	@echo "Running Test File :" $(TESTDIR)/$< $@
	@ $(TESTDIR)/$< $@
	@Change $@0
	@rm $@0 
	@mv N$@0 $@

% : 	$(TESTDIR)/%
	@echo "cd " $(TESTDIR) "; Compiling the Test File " $(@F)
	@cd $(TESTDIR) ; $(MAKE) $(@F)


doc : Ctex $(DOCSC)  $(DESC) $(DOCSF) $(DESF) $(DOCSC1) $(DESC1) debut-C.tex debutF-F.tex
	@echo "Compile Doc.tex to get the doc"


# pour creer Ctex 
LDLIBS=-ll 

clean	:
	@ echo "removing "  $(DOCSC)  $(DESC) $(DOCSF) $(DESF) $(DOCSC1) $(DESC1)
	@for f in $(DOCSC)  $(DESC) $(DOCSF) $(DESF) $(DOCSC1) $(DESC1) ;\
	     do rm -f $$f ;\
	done
	@ echo "removing " Ctex  debut-C.tex debutF-F.tex  \
	Doc.dvi Doc.aux. Doc.log
	@for f in  Ctex Ctex.c  debut-C.tex debutF-F.tex  Doc.dvi \
		Doc.aux Doc.log;\
	      do rm -f $$f; \
	done








	
	




	

