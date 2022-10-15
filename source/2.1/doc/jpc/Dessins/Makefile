#
# TransFig makefile
#
ALL= DesBasile.tex DesLotus.tex DesEpsf.tex pointselle.tex Bas2.tex

all	:$(ALL)
	latex All.tex 

DesBasile.tex : 	DesBasile.ps
	Blatexpr  0.5 0.7 DesBasile.ps

Bas2.tex : DesBasile.ps DesBasile1.ps 
	Blatexprs Bas2 DesBasile.ps DesBasile1.ps 

DesLotus.tex	: DesLotus.ps
	LotusEpsf 0.5 0.5 DesLotus.ps 

DesEpsf.tex	: DesEpsf.epsf 
	TeXEpsf 0.3 0.3 DesEpsf.epsf

pointselle.tex	: pointselle.fig
	XFlatexpr 0.5 pointselle.fig

clean 	:
	\rm -f $(ALL) *.ps.n  Bas2.ps pointselle.ps

