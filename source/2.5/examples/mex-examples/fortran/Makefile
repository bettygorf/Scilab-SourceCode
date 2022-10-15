SCIDIR=../../..

include $(SCIDIR)/Makefile.incl

CFLAGS = $(CC_OPTIONS) $(CC_PICFLAGS) -I$(SCIDIR)/routines
FFLAGS = $(FC_OPTIONS) $(FC_PICFLAGS) -I$(SCIDIR)/routines

################# List of source mexfiles ######################
CMEXSOURCES = 

FORTRANMEXSOURCES = fmexfunction1.f fmexfunction2.f

################# List of associated Scilab functions  ##########
#               (= by default the name of the mexfunction)      #
FCTS = $(CMEXSOURCES:.c=) $(FORTRANMEXSOURCES:.f=)

################## List of routines used by the mexfiles ########
OTHERCSOURCES = 

OTHERFORTRANSOURCES = 

################## Name of startup file (default = "startup.sce") #

STARTUP = startup

################## Name of gateway file (default = "generic_gateway.c #

GENERIC = generic
########## Do not edit below this line #############

MEXOBJS = $(CMEXSOURCES:.c=.o) $(FORTRANMEXSOURCES:.f=.o)

OTHEROBJS = $(OTHERCSOURCES:.c=.o) $(OTHERFORTRANSOURCES:.f=.o)

OTHERSOURCES = $(OTHERCSOURCES) $(OTHERFORTRANSOURCES)

MEXSOURCES = $(CMEXSOURCES) $(FORTRANMEXSOURCES)

OBJS = $(MEXOBJS) $(OTHEROBJS) $(GENERIC)_gateway.o

all	::  rmold $(GENERIC)_gateway.c $(OBJS) $(STARTUP).sce message

clean	::
	$(RM) *.o so_locations $(STARTUP).sce $(GENERIC)_gateway.c

distclean ::
	$(RM) *.o so_locations $(STARTUP).sce $(GENERIC)_gateway.c

$(GENERIC)_gateway.c $(STARTUP).sce:
	@echo "-- Generating the C function $(GENERIC)_gateway.c";
	@echo "-- ... and the Scilab script $(STARTUP).sce";
	@echo $(FCTS) > tmp_arg1;
	@echo $(OTHEROBJS) > tmp_arg2;
	@echo $(MEXSOURCES) > tmp_arg3; 
	@echo $(STARTUP) $(GENERIC) > tmp_arg4;
	@$(SCIDIR)/macros/Gengatsce Xtmp_arg1 Xtmp_arg2 Xtmp_arg3 Xtmp_arg4;
	@$(RM) tmp_arg1 tmp_arg2 tmp_arg3 tmp_arg4; 
	@echo "-------------- done ----------------------------";

message:
	@echo "------------------------------------------";
	@echo "To load $(FCTS)";
	@echo "        functions, at Scilab prompt, enter:";
	@echo "-->exec $(STARTUP).sce";
	@echo "------------------------------------------";

tests	: mexfort.dia

mexfort.dia	: mexfort.tst $(OBJS)  $(STARTUP).sce
	@$(SCIDIR)/util/scidem $(SCIDIR) mexfort.tst mexfort.dia

rmold:
	@$(RM) $(STARTUP).sce $(GENERIC)_gateway.c

