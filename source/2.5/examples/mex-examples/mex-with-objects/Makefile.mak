SHELL = /bin/sh

SCIDIR=../../..
SCIDIR1=..\..\..

!include $(SCIDIR)/Makefile.incl.mak 

FFLAGS = $(FC_OPTIONS) -DFORDLL -I$(SCIDIR1)\routines
CFLAGS = $(CC_OPTIONS) -DFORDLL -I$(SCIDIR)/routines

################# List of source mexfiles ######################
CMEXSOURCES = mexfunction1.c mexfunction2.c mexfunction3.c \
	mexfunction4.c mexfunction5.c mexfunction6.c \
	mexfunction7.c mexfunction8.c mexfunction9.c \
	mexfunction10.c mexfunction11.c  mexfunction12.c  \
	mexfunction13.c 

FORTRANMEXSOURCES = 

################# List of associated Scilab functions  ##########
#               (= by default the name of the mexfunction)      #
FCTS = $(CMEXSOURCES:.c=) $(FORTRANMEXSOURCES:.f=)

################## List of routines used by the mexfiles ########
OTHERCSOURCES = 

OTHERFORTRANSOURCES = dcopytest.f

################## Name of startup file (default = "startup.sce") #

STARTUP = startup
################## Name of gateway file (default = "generic_gateway.c #

GENERIC = generic
########## Do not edit below this line #############

MEXOBJS = $(CMEXSOURCES:.c=.obj) $(FORTRANMEXSOURCES:.f=.obj)

OTHEROBJS = $(OTHERCSOURCES:.c=.obj) $(OTHERFORTRANSOURCES:.f=.obj)

OTHERSOURCES = $(OTHERCSOURCES) $(OTHERFORTRANSOURCES)

MEXSOURCES = $(CMEXSOURCES) $(FORTRANMEXSOURCES)

OBJS = $(MEXOBJS) $(OTHEROBJS) $(GENERIC)_gateway.obj 

DUMPEXTS=$(SCIDIR1)\bin\dumpexts
SCIIMPLIB=$(SCIDIR)/bin/LibScilab.lib

all	::  rmold $(GENERIC)_gateway.c $(OBJS)  $(GENERIC).dll startup.sce message

clean::
	@del *.obj
	@del *.dll
	@del *.def
	@del *.ilib
	@del *.exp
	@del startup.sce
	@del $(GENERIC)_gateway.c

distclean:: clean

$(GENERIC)_gateway.c $(STARTUP).sce:
	@echo "-- Generating the C function $(GENERIC)_gateway.c";
	@echo "-- ... and the Scilab script $(STARTUP).sce";
	@$(SCIDIR1)\macros\Gengatsce @<< @<< @<< @<<
$(FCTS)
<<
$(OTHEROBJS)
<<
$(MEXSOURCES)
<<
$(STARTUP) $(GENERIC)
<<

message:
	@echo "------------------------------------------";
	@echo "To load $(FCTS)";
	@echo "        functions, at Scilab prompt, enter:";
	@echo "-->exec $(STARTUP).sce";
	@echo "------------------------------------------";



$(GENERIC).dll: $(OBJS)
	@echo Creation of dll $*.dll and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) $(OBJS) $(SCIIMPLIB) $(XLIBSBIN) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 

rmold:
	$del $(GENERIC)_gateway.c $(STARTUP).sce

################# test ######################

tests	:
	@del mexobjs.dia	
	$(SCIDIR1)\bin\scilex.exe  -f mexobjs.tst 

