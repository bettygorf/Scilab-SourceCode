SHELL = /bin/sh

SCIDIR = ../..

LIBRARY = tutorial.a

#OTHERLIBS = mylib.a pipo.o
OTHERLIBS = 

#########################################################################
#    To each .o interface (C or Fortran) associate one scilab function
#    
CINTERFACES = intview.o intmatmul.o

CFUNCTIONS = view matmul 

OTHERCOBJS = 

FORTRANINTERFACES = 

FFUNCTIONS = 
 
OTHERFOBJS = 
################ do not edit below this line ############################
GATEWAY = $(LIBRARY:.a=)

STARTUP = $(LIBRARY:.a=)

include $(SCIDIR)/Makefile.incl

CFLAGS = $(CC_OPTIONS) $(CC_PICFLAGS) -I$(SCIDIR)/routines
FFLAGS = $(FC_OPTIONS) $(FC_PICFLAGS) -I$(SCIDIR)/routines

FUNCTIONS = $(CFUNCTIONS) $(FFUNCTIONS)

OBJSF = $(FORTRANINTERFACES) $(OTHERFOBJS)

OBJSC = $(CINTERFACES) $(OTHERCOBJS)

all:: rmold $(LIBRARY) $(GATEWAY)_gateway.c $(GATEWAY)_gateway.o $(STARTUP).sce message

include $(SCIDIR)/routines/Make.lib

rmold:
	$(RM) $(STARTUP).sce $(GATEWAY)_gateway.c 

$(GATEWAY)_gateway.c:
	@echo "-- Generating the C function $(GATEWAY)_gateway.c";
	@echo "#include \"mex.h\" " > $(GATEWAY)_gateway.c;
	@echo " " >> $(GATEWAY)_gateway.c;
	@echo "extern Gatefunc %s;\n" > format;
	@echo $(CINTERFACES:.o=) >> args;
	@echo $(GATEWAY)_gateway.c > file;
	@$(SCIDIR)/macros/Tomake Xformat Xargs Xfile;
	@$(RM) format args file;
	@echo "extern Gatefunc C2F(%s);\n" > format;
	@echo $(FORTRANINTERFACES:.o=) >> args;
	@echo $(GATEWAY)_gateway.c > file;
	@$(SCIDIR)/macros/Tomake Xformat Xargs Xfile;
	@$(RM) format args file;
	@echo " " >> $(GATEWAY)_gateway.c;
	@echo "static GenericTable Tab[]={"  >> $(GATEWAY)_gateway.c;
	@echo "{(Myinterfun)sci_gateway, %s,\"error msg\"},\n" > format;
	@echo $(CINTERFACES:.o=) > args;
	@echo $(GATEWAY)_gateway.c > file;
	@$(SCIDIR)/macros/Tomake  Xformat Xargs Xfile;
	@$(RM) format args file;
	@echo "{(Myinterfun)sci_gateway, C2F(%s),\"error msg\"},\n" > format;
	@echo $(FORTRANINTERFACES:.o=) > args;
	@echo $(GATEWAY)_gateway.c > file;
	@$(SCIDIR)/macros/Tomake  Xformat Xargs Xfile;
	@$(RM) format args file;
	@echo "	 };" >> $(GATEWAY)_gateway.c;
	@echo " " >> $(GATEWAY)_gateway.c;
	@echo "int C2F($(GATEWAY)_gateway)()" >> $(GATEWAY)_gateway.c;
	@echo "{  Rhs = Max(0, Rhs);" >> $(GATEWAY)_gateway.c;
	@echo "(*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);" >>  $(GATEWAY)_gateway.c;
	@echo "  return 0;" >> $(GATEWAY)_gateway.c;
	@echo "}" >>  $(GATEWAY)_gateway.c;
	@echo " " >> $(GATEWAY)_gateway.c;


$(STARTUP).sce: 
	@echo "-- Generating the Scilab script $(STARTUP).sce";
	@echo "scilab_functions =[..." > $(STARTUP).sce;
	@echo "\"%s\";\n" > format;
	@echo $(FUNCTIONS) > args;
	@echo $(STARTUP).sce > file; 
	@$(SCIDIR)/macros/Tomake Xformat Xargs Xfile;
	@$(RM) format args file;
	@echo "           ];" >> $(STARTUP).sce;
	@echo "auxiliary=\"$(OTHERLIBS)\";"  >> $(STARTUP).sce;
	@echo "files=G_make([\"$(GATEWAY)_gateway.o\",\"$(LIBRARY)\", auxiliary],\"void(Win)\");"  >>$(STARTUP).sce;
	@echo "addinter(files,\"$(GATEWAY)_gateway\",scilab_functions);" >> $(STARTUP).sce;

message:
	@echo "------------------------------------------";
	@echo "To load $(FUNCTIONS)";
	@echo "        functions, at Scilab prompt, enter:";
	@echo "-->exec $(STARTUP).sce";
	@echo "------------------------------------------";

clean	::
	$(RM) *.o *~ so_locations
	$(RM) $(GATEWAY)_gateway.c $(STARTUP).sce
	$(RM) *.dia

distclean	::
	$(RM) *.o *~ so_locations
	$(RM) $(GATEWAY)_gateway.c $(STARTUP).sce
	$(RM) *.dia

tests	: tutorial.dia

tutorial.dia	: tutorial.tst all
	@$(SCIDIR)/util/scidem $(SCIDIR) tutorial.tst tutorial.dia
