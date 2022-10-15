FFLAGS = $(FC_OPTIONS)
CFLAGS = $(CC_OPTIONS)
RESOURCES= routines/wsci/Rscilab.res 

bin/Nscilex.exe : $(DEFAULTS1) $(LIBRSCI)
	@echo Linking $*.exe 
	@$(LINKER) $(LINKER_FLAGS) $(GUIFLAGS) -OUT:"$*.exe"  \
		$(DEFAULTS) $(RESOURCES) $(LIBR) $(XLIBS) 
	@echo Link done

DEFAULTS1 = routines/wsci/winmain.obj	\
	routines/default/Ex-colnew.obj \
	routines/default/Ex-corr.obj \
	routines/default/Ex-feval.obj \
	routines/default/Ex-fsolve.obj \
	routines/default/Ex-impl.obj \
	routines/default/Ex-intg.obj \
	routines/default/Ex-int2d.obj \
	routines/default/Ex-int3d.obj \
	routines/default/Ex-ode-more.obj \
	routines/default/Ex-ode.obj\
	routines/default/Ex-odedc.obj \
	routines/default/Ex-optim.obj \
	routines/default/Ex-schur.obj \
	routines/default/Ex-fort.obj\
	routines/default/Ex-dasrt.obj \
	routines/default/Ex-dassl.obj \
	routines/default/Ex-fbutn.obj \
	routines/default/FTables.obj \
	routines/default/mainwin95.obj \
	routines/default/matusr.obj \
	routines/default/matus2.obj \
	routines/default/Funtab.obj \
	routines/default/msgstxt.obj \
	routines/default/scimem.obj \
	routines/default/callinterf.obj

bin/LibScilab.dll: $(DEFAULTS1) $(LIBRSCI)
	@echo Creation of $*.dll and import lib $*.lib
	@$(LINKER) $(LINKER_FLAGS) $(RESOURCES) $(DEFAULTS1) $(LIBR) $(XLIBS) \
	 /dll /out:"$*.dll" /implib:"$*.lib" /def:"$*.def" 

bin/scilex.exe : bin/LibScilab.dll
	@$(LINKER) $(LINKER_FLAGS) -OUT:"$*.exe"  $(RESOURCES) \
	routines/f2c/libf2c/main.obj bin/LibScilab.lib $(XLIBS) 

