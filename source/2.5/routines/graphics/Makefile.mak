# Generated automatically from Makefile.in by configure.
SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..
include ../../Version.incl

LIBRARY = $(SCIDIR)/libs/graphics.lib

OBJSC = periWin.obj periPos.obj periFig.obj periGif.obj Xcall.obj Xcall1.obj \
	Contour.obj Plo3d.obj Math.obj Axes.obj Champ.obj Plo2d.obj \
	Plo2d1.obj Plo2d2.obj Plo2d3.obj Plo2d4.obj Plo2dEch.obj Rec.obj Gray.obj \
	Alloc.obj FeC.obj RecLoad.obj RecSave.obj Tests.obj Actions.obj \
	gsort.obj qsort.obj nues1.obj

OBJSF = 

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) $(XFLAGS) 

include ../Make.lib.mak

version.h: version.g $(SCIDIR)/Version.incl
	@$(RM) version.h
	@sed -e "s+SCILAB_VERSION+$(SCIVERSION)+" \
	version.g > version.h;
	@chmod g+w version.h
	@echo version.h created

Math.h: ../machine.h

Alloc.obj: Math.h
Axes.obj: Math.h
Champ.obj: Math.h
Contour.obj: Math.h
FeC.obj: Math.h
Gray.obj: Math.h
Math.obj: Math.h
Plo2d.obj: Math.h
Plo2d1.obj: Math.h
Plo2d2.obj: Math.h
Plo2d3.obj: Math.h
Plo2d4.obj: Math.h
Plo2dEch.obj: Math.h
Plo3d.obj: Math.h
RecSave.obj RecLoad.obj Rec.obj: Math.h Rec.h
SGraph.obj: Math.h
Xcall.obj: Math.h periX11.h periPos.h periFig.h
Xcall1.obj: Math.h
Xloop.obj: Math.h ../xsci/Xscilab.ad.h
asynchron.obj: Math.h
periFig.obj: periFig.h Math.h color.h 
periMac.obj: Math.h periMac.h color.h
periPos.obj: periPos.h Math.h color.h
periX11.obj: Math.h periX11.h version.h color.h
printdlg.obj: ../machine.h
xwidgets.obj: Math.h
gsort.obj: Math.h gsort-int.h gsort-double.h
nues1.obj: Math.h ../machine.h
