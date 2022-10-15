#       Path of Scilab directory
SCIDIR=../../..
SCIDIR1=..\..\..
# Insert here pairs: name-of-the-scilab-function/associated-mexfile
# C mexfiles in FCTMEX and Fortran mexfiles in FORTRANFCTMEX 
#                         Fortran mexfiles must have .F suffix
# FCTMEX = mexfunction1/mexfilesource1.c mexfunction2/mexfilesource2.c etc
FCTMEX = pipo1/pipo.c pipo2/popi.c
FORTRANFCTMEX = pipo3/foof.F

# OTHEROBJECTS .obj object files needed by the mexfiles (no mexFunction here)
OTHEROBJECTS = 

# LIBRARY = name of the library
LIBRARY = mylib

# -------------------Do not edit below this line ----------------------

DUMPEXTS=$(SCIDIR1)\bin\dumpexts
SCIIMPLIB=$(SCIDIR)/bin/LibScilab.lib

!include $(SCIDIR1)\Makefile.incl.mak 

FFLAGS = $(FC_OPTIONS) -DFORDLL -I$(SCIDIR1)\routines
CFLAGS = $(CC_OPTIONS) -DFORDLL -I$(SCIDIR)/routines

pstarget:
	@echo -- Creating files: objects and makeall
	@$(SCIDIR1)\macros\Forwin @<< @<<
$(FCTMEX)
<<
$(FORTRANFCTMEX)
<<

all::  CLEAROLD  $(OTHEROBJECTS) $(LIBRARY)_gateway.c $(LIBRARY)_gateway.obj $(LIBRARY).dll $(LIBRARY).sce message

OBJS = $(MEXOBJECTS) $(OTHEROBJECTS) $(LIBRARY)_gateway.obj

$(LIBRARY)_gateway.c: 
	@echo -- Generating the C function $(LIBRARY)_gateway.c
	@$(SCIDIR1)\macros\Gensomex @<< @<<
$(FCTMEX) $(FORTRANFCTMEX)
<<
$(LIBRARY)
<<
	@echo int C2F($(LIBRARY)_gateway)() >> $(LIBRARY)_gateway.c
	@echo {  Rhs = Max(0, Rhs); >> $(LIBRARY)_gateway.c
 	@echo (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F); >> $(LIBRARY)_gateway.c
	@echo return 0;  >> $(LIBRARY)_gateway.c
	@echo } >> $(LIBRARY)_gateway.c
	
$(LIBRARY).sce:
	@echo  -- Generating the Scilab script $(LIBRARY).sce
	@$(SCIDIR1)\macros\Gensosce @<< @<<
$(FCTMEX) $(FORTRANFCTMEX)
<<
$(LIBRARY)
<<
	@echo files=G_make("Unix-objects","$(LIBRARY).dll"); >> $(LIBRARY).sce
	@echo addinter(files,"$(LIBRARY)_gateway",scilab_functions); >> $(LIBRARY).sce

MEX:
include objects
include makeall

message:
	@echo ------------------------------------------
	@echo - To load the function(s):     
	@echo - $(FCTMEX) $(FORTRANFCTMEX)   
	@echo - at Scilab prompt, enter:     
	@echo "-->exec $(LIBRARY).sce;"
	@echo ------------------------------------------

clean	::
	@$(RM) *.obj
	@$(RM) $(LIBRARY).sce
	@$(RM) $(LIBRARY)_gateway.c
	@$(RM) $(LIBRARY).lib
	@$(RM) *.dll
	@$(RM) *.def
	@$(RM) *.ilib
	@$(RM) *.exp
	@$(RM) *.pdb
	@echo MEXOBJECTS= > objects
	@echo VOID= > makeall

distclean:: clean 

$(LIBRARY).dll: $(OBJS)
	@echo Creation of dll $(LIBRARY).dll and import lib from ...
	@echo $(OBJS)
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) $(OBJS) $(SCIIMPLIB) $(XLIBSBIN) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 

CLEAROLD:
	@$(RM) $(LIBRARY).sce
	@$(RM) $(LIBRARY)_gateway.c



















