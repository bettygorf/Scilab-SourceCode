FFLAGS = $(FC_OPTIONS)
CFLAGS = $(CC_OPTIONS)
RESOURCES= routines/wsci/Rscilab.res 

bin/scilex: 
	$(LINKER) $(GUIFLAGS) -OUT:"bin/scilex.exe"  \
		$(DEFAULTS) $(RESOURCES) $(LIBR) $(XLIBS) $(TERMCAPLIB)

