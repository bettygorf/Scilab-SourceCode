include ../Path.incl

#
# $Id: Makefile,v 1.8 1997/08/11 14:38:47 pvmsrc Exp $
#
# top-level PVM3 makefile
#

SHELL	=	/bin/sh

AIMKSTR	=	-here -f ./conf/`./lib/pvmtmparch`.def -f ./Makefile.aimk

default:
	@PVM_ROOT=$(SCIDIR)/pvm3; export PVM_ROOT; ./lib/aimk $(AIMKSTR) default

clean:
	PVM_ROOT=$(SCIDIR)/pvm3; export PVM_ROOT; ./lib/aimk $(AIMKSTR) clean
