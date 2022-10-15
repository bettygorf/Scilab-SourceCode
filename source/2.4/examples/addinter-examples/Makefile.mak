SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

DUMPEXTS=$(SCIDIR1)\bin\dumpexts
SCIIMPLIB=$(SCIDIR)/bin/LibScilab.lib
F2C=$(SCIDIR1)\bin\f2c

include ../../Makefile.incl.mak 

FFLAGS = $(FC_OPTIONS) 
CFLAGS = $(CC_OPTIONS) -DFORDLL  -I$(SCIDIR)/routines/f2c

.f.obj	:
	@$(F2C) $*.f 
	@$(CC) $(CFLAGS) $*.c 
	@del $*.c 

all:: info

world: info

info:
	@echo "Type \"make test\" to compile all programs (in /tmp)"
	@echo "Type \"make pgm.obj\" to compile pgm program"

OBJSF = ex1f.obj ex1fi.obj ex2f.obj ex2fi.obj \
	ex3f.obj ex3fi.obj  ex4fi.obj \
	ex6f.obj ex6fi.obj ex5f.obj ex5fm.obj ex7fi.obj ex8fi.obj

OBJSC = ex1c.obj ex1cI.obj ex2c.obj ex2cI.obj \
	ex3c.obj ex3cI.obj ex4cI.obj \
	ex5cI.obj ex5c.obj ex5cm.obj ex6c.obj ex6cI.obj \
	ex5fI.obj

test : $(OBJSF) $(OBJSC)


clean::
	@del  *.obj

distclean:: clean

ex1c.dll : ex1cI.obj ex1c.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex1cI.obj ex1c.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 

ex1f.dll : ex1fi.obj ex1f.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex1fi.obj ex1f.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 


ex2c.dll : ex2cI.obj ex2c.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex2cI.obj ex2c.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 

ex2f.dll : ex2fi.obj ex2f.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex2fi.obj ex2f.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 

ex3c.dll : ex3cI.obj ex3c.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex3cI.obj ex3c.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 

ex3f.dll : ex3fi.obj ex3f.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex3fi.obj ex3f.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 

ex4c.dll : ex4cI.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex4cI.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 

ex4f.dll : ex4fi.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex4fi.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 


ex5c.dll : ex5cI.obj ex5c.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex5cI.obj ex5c.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 



ex5f.dll : ex5fi.obj ex5f.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex5fi.obj ex5f.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 



ex5cm.dll :  ex5cm.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex5cm.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 


ex5fm.dll :  ex5fm.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex5fm.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 


ex6c.dll : ex6cI.obj ex6c.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex6cI.obj ex6c.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 


ex6f.dll : ex6fi.obj ex6f.obj
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex6fi.obj ex6f.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 


ex7f.dll : ex7fi.obj 
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex7fi.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 


ex8f.dll : ex8fi.obj 
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) ex8fi.obj $(SCIIMPLIB) $(XLIBS) $(TERMCAPLIB) /nologo /dll /out:"$*.dll" /implib:"$*.ilib" /def:"$*.def" 


##----------------------  test all the example  

EXAMPLES=ex1c.sce + ex1f.sce + ex2c.sce + ex2f.sce + ex3c.sce + \
	ex3f.sce + ex4c.sce + ex4f.sce + ex5c.sce + ex6c.sce + ex6f.sce + ex7f.sce + ex8f.sce

tests	:
	@del zlink.dia	
	@copy  $(EXAMPLES)  zlink.tst 		
	$(SCIDIR1)\bin\scilex.exe  -f zlink.tst 

clean	::
	@del zlink.dia 
	@del zlink.tst 
	@del *.dll 
	@del *.ilib 
	@del *.ilk 
	@del *.pdb 	
	@del *.def 
	@del *.exp

distclean:: clean 
	@del *.obj 




