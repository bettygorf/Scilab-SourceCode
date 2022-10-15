SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl.mak

# just add -DEPSFIG 
# il you prefer epsfig to special to insert postscript files in LaTeX 

CFLAGS = $(CC_OPTIONS)

all:: $(SCIDIR)/bin/Slpr.exe $(SCIDIR)/bin/Slatexprs.exe \
	$(SCIDIR)/bin/Slatexpr2.exe \
	$(SCIDIR)/util/Slatdocs.exe $(SCIDIR)/bin/SEpsf.exe \
	 $(SCIDIR)/bin/Slatexpr.exe \
	 $(SCIDIR)/util/Slatdoc.exe

world: all

$(SCIDIR)/bin/Slpr.exe: Slpr.obj
	$(RM) $@
	$(LINKER) -SUBSYSTEM:console -OUT:"$@" Slpr.obj $(GUILIBS)

clean::
	$(RM) Slpr.obj
distclean::
	$(RM) Slpr.obj $(SCIDIR)/bin/Slpr.exe

$(SCIDIR)/bin/SEpsf.exe: SEpsf.obj
	$(RM) $@
	$(LINKER) -SUBSYSTEM:console -OUT:"$@" SEpsf.obj $(GUILIBS)

clean::
	$(RM) SEpsf.obj
distclean::
	$(RM) SEpsf.obj $(SCIDIR)/bin/SEpsf.exe

$(SCIDIR)/bin/Slatexpr.exe: Slatexpr.obj
	$(RM) $@
	$(LINKER) -SUBSYSTEM:console -OUT:"$@" Slatexpr.obj $(GUILIBS)

clean::
	$(RM) Slatexpr.obj
distclean::
	$(RM) Slatexpr.obj $(SCIDIR)/bin/Slatexpr.exe

$(SCIDIR)/bin/Slatexprs.exe: Slatexprs.obj
	$(RM) $@
	$(LINKER) -SUBSYSTEM:console -OUT:"$@" Slatexprs.obj $(GUILIBS)

clean::
	$(RM) Slatexprs.obj
distclean::
	$(RM) Slatexprs.obj $(SCIDIR)/bin/Slatexprs.exe

$(SCIDIR)/bin/Slatexpr2.exe: Slatexpr2.obj
	$(RM) $@
	$(LINKER) -SUBSYSTEM:console -OUT:"$@" Slatexpr2.obj $(GUILIBS)

clean::
	$(RM) Slatexpr2.obj
distclean::
	$(RM) Slatexpr2.obj $(SCIDIR)/bin/Slatexpr2.exe

$(SCIDIR)/util/Slatdocs.exe: Slatdocs.obj
	$(CC) $(CFLAGS) -DDOC Slatexprs.c
	$(LINKER) -SUBSYSTEM:console -OUT:"$@" Slatdocs.obj $(GUILIBS)
clean::
	$(RM) Slatdocs.obj

distclean::
	$(RM) $(SCIDIR)/util/Slatdocs.exe 

$(SCIDIR)/util/Slatdoc.exe: Slatdoc.obj
	$(LINKER) -SUBSYSTEM:console -OUT:"$@" Slatdoc.obj $(GUILIBS)

distclean::
	$(RM) $(SCIDIR)/util/Slatdoc.exe

clean::
	$(RM) Slatdoc.obj
