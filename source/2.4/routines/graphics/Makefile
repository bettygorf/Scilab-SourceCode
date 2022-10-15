# Generated automatically from Makefile.in by configure.
SHELL = /bin/sh
SCIDIR=../..
include ../../Version.incl

LIBRARY = $(SCIDIR)/libs/graphics.a

OBJSC = periX11.o periPos.o periFig.o Xcall.o Xcall1.o \
	Contour.o Plo3d.o Math.o Axes.o Champ.o Plo2d.o \
	Plo2d1.o Plo2d2.o Plo2d3.o Plo2d4.o Plo2dEch.o Rec.o Gray.o \
	Alloc.o FeC.o RecLoad.o RecSave.o Tests.o Actions.o \
	gsort.o qsort.o

OBJSF =

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS) $(XFLAGS) 

include ../Make.lib

version.h: version.g $(SCIDIR)/Version.incl
	@$(RM) version.h
	@sed -e "s+SCILAB_VERSION+$(SCIVERSION)+" \
	version.g > version.h;
	@chmod g+w version.h
	@echo version.h created

Alloc.o: Math.h ../machine.h
Axes.o: Math.h ../machine.h
Champ.o: Math.h ../machine.h
Contour.o: Math.h ../machine.h
FeC.o: Math.h ../machine.h
Gray.o: Math.h ../machine.h
Math.o: Math.h ../machine.h
Plo2d.o: Math.h ../machine.h
Plo2d1.o: Math.h ../machine.h
Plo2d2.o: Math.h ../machine.h
Plo2d3.o: Math.h ../machine.h
Plo2d4.o: Math.h ../machine.h
Plo2dEch.o: Math.h ../machine.h
Plo3d.o: Math.h ../machine.h
RecSave.o RecLoad.o Rec.o: Math.h Rec.h ../machine.h
SGraph.o: Math.h ../machine.h
Xcall.o: Math.h periX11.h periPos.h periFig.h ../machine.h
Xcall1.o: Math.h ../machine.h
Xloop.o: Math.h ../xsci/Xscilab.ad.h ../machine.h
periFig.o: periFig.h Math.h color.h  ../machine.h
periMac.o: Math.h periMac.h color.h ../machine.h
periPos.o: periPos.h Math.h color.h ../machine.h
periX11.o: Math.h periX11.h version.h color.h ../machine.h
xwidgets.o: Math.h ../machine.h
gsort.o: Math.h gsort-int.h gsort-double.h gsort-string.h  ../machine.h
