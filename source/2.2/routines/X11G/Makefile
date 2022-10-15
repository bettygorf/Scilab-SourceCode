SHELL = /bin/sh

SCIDIR=../..
include ../../Version.incl
include ../../Makefile.incl

CFLAGS =  $(CC_OPTIONS) $(XFLAGS) 

FFLAGS = $(FC_OPTIONS)

LIBRARY = $(SCIDIR)/libs/X11G.a

OBJSC = periX11.o periPos.o periFig.o Xcall.o Xcall1.o\
	Contour.o Plo3d.o Math.o Axes.o Champ.o Plo2d.o \
	Plo2d1.o Plo2d2.o Plo2d3.o Plo2d4.o Plo2dEch.o Rec.o Gray.o \
	Alloc.o FeC.o SGraph.o Xloop.o xwidgets.o \
	asynchron.o RecLoad.o RecSave.o 

OBJSF =

OBJS = $(OBJSC) $(OBJSF)

all:: $(LIBRARY)

world: all

$(LIBRARY): $(OBJS)
	@echo Creation of $(LIBRARY)
	@$(RM) $@
	@$(AR) $@ $(OBJS)
	@$(RANLIB) $@

clean::
	$(RM) $(OBJS)libs/X11G.a
distclean::
	$(RM) $(OBJS) $(LIBRARY)

version.h: version.g $(SCIDIR)/Version.incl
	@$(RM) version.h
	@sed -e "s+SCILAB_VERSION+$(SCIVERSION)+" \
	version.g > version.h;
	@chmod g+w version.h
	@echo version.h created

Alloc.o: Math.h
Axes.o: Math.h
Champ.o: Math.h
Contour.o: Math.h
FeC.o: Math.h
Gray.o: Math.h
Math.o: Math.h
Plo2d.o: Math.h
Plo2d1.o: Math.h
Plo2d2.o: Math.h
Plo2d3.o: Math.h
Plo2d4.o: Math.h
Plo2dEch.o: Math.h
Plo3d.o: Math.h
RecSave.o RecLoad.o Rec.o: Math.h Rec.h
SGraph.o: Math.h
Xcall.o: Math.h
Xcall.o: periX11.h
Xcall.o: periPos.h
Xcall.o: periFig.h
Xcall1.o: Math.h
Xloop.o: Math.h
Xloop.o: ../xsci/Xscilab.ad.h
asynchron.o: Math.h
periFig.o: periFig.h
periFig.o: Math.h
periMac.o: Math.h
periMac.o: periMac.h
periPos.o: periPos.h
periPos.o: Math.h
periX11.o: Math.h
periX11.o: periX11.h
periX11.o: version.h
printdlg.o: ../machine.h
xwidgets.o: Math.h
Math.h: ../machine.h






