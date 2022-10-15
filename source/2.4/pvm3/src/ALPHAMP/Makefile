#
# $Id: Makefile,v 1.3 1997/06/18 15:46:58 pvmsrc Exp $
#

PVMDIR		=	../..
SDIR		=	$(PVMDIR)/src

PVM_ARCH	=	ALPHAMP
CONFFILE	=	$(PVMDIR)/conf/$(PVM_ARCH).def
LIBDIR		=	$(PVMDIR)/lib/$(PVM_ARCH)


all:
	make -f $(CONFFILE) -f $(SDIR)/Makefile.aimk all-shm

install:
	make -f $(CONFFILE) -f $(SDIR)/Makefile.aimk install-shm

clean:
	make -f $(CONFFILE) -f $(SDIR)/Makefile.aimk clean

