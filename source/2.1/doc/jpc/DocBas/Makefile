


FILES = xgrid.tex xtitle.tex contour.tex fcontour.tex fplot2d.tex fplot3d.tex plot3d.tex plot3d1.tex param3d.tex fchamp.tex champ.tex plot2d.tex plot2d1.tex plot2d2.tex plot2d3.tex plot2d4.tex errbar.tex 

FILESPS=$(FILES:%.tex=%.ps)
FILESPSN=$(FILES:%.tex=%.ps.n)

%.tex	: %.ps
	Blatexpr 1.0 1.0 $< 

all	: PS  $(FILES)

basjob	:
	echo "posok=1" > temp$$; cat temp$$ exec.bas > startup.bas ; rm temp$$
	basile
	\rm -f startup.bas

clean	: 
	\rm -f -r $(FILES) $(FILESPS) $(FILESPSN) *.[0-9]*

PS	: 
	mv xgrid.0 xgrid.ps
	mv xtitle.1 xtitle.ps
	mv contour.2 contour.ps
	mv fcontour.3 fcontour.ps
	mv fplot2d.4 fplot2d.ps
	mv fplot3d.5 fplot3d.ps
	mv plot3d.6 plot3d.ps
	mv plot3d1.7 plot3d1.ps
	mv param3d.8 param3d.ps
	mv fchamp.9 fchamp.ps
	mv champ.10 champ.ps
	mv plot2d.11 plot2d.ps
	mv plot2d1.12 plot2d1.ps
	mv plot2d2.13 plot2d2.ps
	mv plot2d3.14 plot2d3.ps
	mv plot2d4.15	plot2d4.ps
	mv errbar.16	errbar.ps 
	

	
