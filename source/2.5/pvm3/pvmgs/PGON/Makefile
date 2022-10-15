#
# $Id: Makefile,v 1.4 1997/06/27 13:45:43 pvmsrc Exp $
#

PVMDIR		=	../..
SDIR		=	$(PVMDIR)/pvmgs

PVM_ARCH	=	PGON
CONFFILE	=	$(PVMDIR)/conf/$(PVM_ARCH).def
LIBDIR		=	$(PVMDIR)/lib/$(PVM_ARCH)

#
install:	default $(LIBDIR)
		
default:    
	make -f $(CONFFILE) -f $(SDIR)/Makefile.aimk install-mpp

clean:
	make -f $(CONFFILE) -f $(SDIR)/Makefile.aimk clean
	
$(LIBDIR):
	mkdir $(LIBDIR)

