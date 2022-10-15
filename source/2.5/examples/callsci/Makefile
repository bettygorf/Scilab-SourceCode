SHELL = /bin/sh

# SCIDIR must be bound to your running Scilab directory 

SCIDIR=../..

include $(SCIDIR)/Makefile.incl

OBJS=callsci.o

all:: 
	@./Init $(SCIDIR)
	@make all -f Makefile.more SCIDIR=$(SCIDIR)

distclean::
	@echo Cleaning callsci
	@$(RM) -f -r config 
	@$(RM) callsci.o callsci 



