# This is a template Makefile which can be used if you 
# want to create your own additional man pages 
# SCIDIR must be bound to your running Scilab directory 

SCIDIR=../..

include $(SCIDIR)/Makefile.incl 

SHELL = /bin/sh

# You add here all the man directories that you want to add to Scilab 
# and You must add them in the file Chapters.add

CH1 = Test1
DIR1 = test1

CH2 = Test2
DIR2 = test2

DIRS = $(DIR1) $(DIR2) 

all	:: allman 

$(CH1):
	@./formatman $(DIR1)

$(CH2):
	@./formatman $(DIR2)


#############################
# Do not change bellow this line 
#############################

UTILITIES=Chapters formatman mkwhatis strip.sed sci.an 

allman : $(UTILITIES)
	@./formatman $(DIRS)
	@echo "set the variable MANCHAPTERS to `pwd`/Chapters "
	@echo "to use the new manual pages"

world:: all

clean::
	for i in $(DIRS) ;\
	do \
		(cd $$i ; echo "making clean in man/$$i..."; \
		$(RM)  $(FILES_TO_CLEAN)); \
	done
	$(RM) $(UTILITIES) 

distclean:: clean 
	for i in $(DIRS) ;\
	do \
		(cd $$i ; echo "making clean in man/$$i..."; \
		$(RM)  *.cat whatis ) ; \
	done


Chapters : Chapters.add $(SCIDIR)/man/Chapters 
	@cat $(SCIDIR)/man/Chapters Chapters.add > Chapters 

formatman : $(SCIDIR)/man/formatman 
	@ln -s $(SCIDIR)/man/formatman  .

mkwhatis : $(SCIDIR)/man/mkwhatis 
	@ln -s $(SCIDIR)/man/mkwhatis  .

strip.sed : $(SCIDIR)/man/strip.sed 
	@ln -s $(SCIDIR)/man/strip.sed  .

sci.an : $(SCIDIR)/man/sci.an 
	@ln -s $(SCIDIR)/man/sci.an  .
