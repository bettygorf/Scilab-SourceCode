# Generated automatically from Makefile.in by configure.
SHELL = /bin/sh

include ../Path.incl
include ../Version.incl
include ../Makefile.incl

IP = $(SCIDIR)/Path.incl
IV = $(SCIDIR)/Version.incl

SBIN = $(SCIDIR)/bin

PROGRAMS = $(SBIN)/scilab $(SBIN)/Blatexpr $(SBIN)/Blatexpr2 \
	$(SBIN)/Blatexprs $(SBIN)/Blpr $(SBIN)/BEpsf 

all:: $(PROGRAMS)

world: all

$(SBIN)/scilab: scilab.g $(IP) $(IV)
	@$(RM) $(SBIN)/scilab
	@sed  	-e "s+SCILAB_DIRECTORY+$(SCIDIR)+" \
	-e "s+SCILAB_VERSION+$(SCIVERSION)+" \
	-e "s+SCILAB_DATE+$(SCIDATE)+" \
	-e "s+SCILABGS+sh+" \
	-e "s+SCILABG+g+" scilab.g > scilab;
	@$(INSTALL) scilab $(SBIN)
	@$(RM) scilab
	@echo $(SBIN)/scilab created

distclean::
	$(RM) $(SBIN)/scilab

$(SBIN)/Blatexpr: Blatexpr.g $(IP)
	@$(RM) $(SBIN)/Blatexpr
	@sed  	-e "s+SCILAB_DIRECTORY+$(SCIDIR)+" Blatexpr.g > Blatexpr;
	@$(INSTALL) Blatexpr $(SBIN)
	@$(RM) Blatexpr
	@echo $(SBIN)/Blatexpr created

distclean::
	$(RM) $(SBIN)/Blatexpr

$(SBIN)/BEpsf: BEpsf.g $(IP)
	@$(RM) $(SBIN)/BEpsf
	@sed  	-e "s+SCILAB_DIRECTORY+$(SCIDIR)+" BEpsf.g > BEpsf;
	@$(INSTALL) BEpsf $(SBIN)
	@$(RM) BEpsf
	@echo $(SBIN)/BEpsf created

distclean::
	$(RM) $(SBIN)/BEpsf


$(SBIN)/Blatexpr2: Blatexpr2.g $(IP)
	@$(RM) $(SBIN)/Blatexpr2
	@sed  	-e "s+SCILAB_DIRECTORY+$(SCIDIR)+" Blatexpr2.g > Blatexpr2;
	@$(INSTALL) Blatexpr2 $(SBIN)
	@$(RM) Blatexpr2
	@echo $(SBIN)/Blatexpr2 created

distclean::
	$(RM) $(SBIN)/Blatexpr2

$(SBIN)/Blatexprs: Blatexprs.g $(IP)
	@$(RM) $(SBIN)/Blatexprs
	@sed  	-e "s+SCILAB_DIRECTORY+$(SCIDIR)+" Blatexprs.g > Blatexprs;
	@$(INSTALL) Blatexprs $(SBIN)
	@$(RM) Blatexprs
	@echo $(SBIN)/Blatexprs created

distclean::
	$(RM) $(SBIN)/Blatexprs

$(SBIN)/Blpr: Blpr.g $(IP)
	@$(RM) $(SBIN)/Blpr
	@sed  	-e "s+SCILAB_DIRECTORY+$(SCIDIR)+" Blpr.g > Blpr;
	@$(INSTALL) Blpr $(SBIN)
	@$(RM) Blpr
	@echo $(SBIN)/Blpr created

distclean::
	$(RM) $(SBIN)/Blpr
