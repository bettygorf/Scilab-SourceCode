SCIDIR = ../../..

#Insert here pairs: name-of-the-scilab-function/associated-mexfile#
#C mexfiles in FCTMEX and Fortran mexfiles in FORTRANFCTMEX 
#                         Fortran mexfiles must have .F suffix
#FCTMEX = mexfunction1/mexfilesource1.c mexfunction2/mexfilesource2.c etc
FCTMEX = pipo1/pipo.c pipo2/popi.c
FORTRANFCTMEX = pipo3/foof.F

#OTHEROBJECTS .o (.obj) object files needed by the mexfiles (no mexFunction here)
OTHEROBJECTS = 

#LIBRARY = name of the library: prefix lib is compulsory!
LIBRARY = libmylib

#LIBPATH = Pathname prefix of the library (same as LD_LIBRARY_PATH);
#If LIBPATH = (empty)  , use the LD_LIBRARY_PATH environment variable

LIBPATH = ./

#LIBPATH = `pwd`


#############   Do not edit below this line   ###################
include $(SCIDIR)/Makefile.incl

include $(SCIDIR)/Makemex

tests	: mexso.dia

mexso.dia	: mexso.tst all
	@$(SCIDIR)/util/scidem $(SCIDIR) mexso.tst mexso.dia
