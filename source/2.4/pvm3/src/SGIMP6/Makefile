#
# $Id: Makefile,v 1.1 1997/08/06 22:41:14 pvmsrc Exp $
#

PVMDIR		=	../..
SDIR		=	$(PVMDIR)/src

PVM_ARCH	=	SGIMP6
CONFFILE	=	$(PVMDIR)/conf/$(PVM_ARCH).def
LIBDIR		=	$(PVMDIR)/lib/$(PVM_ARCH)


all:
	make -f $(CONFFILE) -f $(SDIR)/Makefile.aimk all-shm

install:
	make -f $(CONFFILE) -f $(SDIR)/Makefile.aimk install-shm

clean:
	make -f $(CONFFILE) -f $(SDIR)/Makefile.aimk clean

