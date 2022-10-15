


FILES= doc1.tex  doc2.tex  doc3.tex  doc4.tex doc5.tex doc6.tex  doc.tex 
DVI=$(FILES:%.tex=%.dvi)

%.dvi : %.tex 
	latex $*.tex 

all:	graph.tex
	cd ../; make texdoc 
	make alldvi 

alldvi	:  $(DVI)

BF=../../../New-macro/bas/plot.bas 

graph.tex : $(BF)
		Bastex -n  < $(BF) > $@

doc1.dvi	: TdAuto1.tex 
doc2.dvi	: TdAuto2.tex 
doc3.dvi	: TdAuto3.tex 
doc4.dvi	: TdAuto4.tex 
doc5.dvi	: TdAuto5.tex 
doc6.dvi	: TdAuto6.tex 
doc.dvi		: TdAuto.tex 
