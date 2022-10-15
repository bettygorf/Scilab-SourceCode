SHELL = /bin/sh

# This is a template Makefile which can be used if you 
# want to create your own additional man pages 
# SCIDIR must be bound to your running Scilab directory 

SCIDIR=../..

# You add here all the man directories that you want to add to Scilab 

DIR1 = $(SCIDIR)/examples/man-examples/helpdir1
TITLE1 = Title1

DIR2 = $(SCIDIR)/examples/man-examples/helpdir2
TITLE2 = Title2

DIRS = $(DIR1) $(DIR2) 
TITLES = $(TITLE1) $(TITLE2) 
all	:: allman 

#################################
# Do not change below this line #
#################################

allman :
	$(SCIDIR)/man/formatman $(DIRS)
	@echo "%helps = [%helps; " > help.sce
	@echo "\"%s\", \"%s\";\n" > format;
	@echo $(DIRS) > args;
	@echo $(TITLES) > args2;
	@echo help.sce >> file;
	@$(SCIDIR)/macros/Tomake Xformat Xargs Xargs2 Xfile;
	@echo "];" >>help.sce
	@echo "----------------------------------------"
	@echo "To add help files defined in $(DIRS), enter:"
	@echo " "
	@echo "    ....or, equivalently:"
	@echo " "
	@echo "exec help.sce"
	@echo " "
	@echo "at scilab prompt -->";
	@echo "----------------------------------------"
	@rm -f format args args2 file;

world:: all

clean::
	@for i in $(DIRS) ;\
	do \
		(cd $$i ; echo "making clean in $$i..."; \
		rm -f  *.cat whatis ) ; \
	done

distclean:: clean 










