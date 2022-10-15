include ../Makefile.incl.mak 
SCIDIR=..
SCIDIR1=..
DUMPEXTS=$(SCIDIR1)\bin\dumpexts
SCIIMPLIB=$(SCIDIR)/bin/LibScilab.lib

OBJS = externals.obj

all :: externals.dll

clean ::
	@del externals.obj 
	@del externals.dll
	@del *.dia 
	@del examples.tst 
	@del get_examples.log 
	@del *.graph 
	@del test.wav 
	@del one_man.tst 
	@del test_macro_exec 
	@del asave 
	@del results 
	@del *.bin

distclean:: clean 

externals.dll : $(OBJS) 
	@echo Creation of dll $(DLL) and import lib 
	@$(DUMPEXTS) -o "$*.def" "$*.dll" $**
	@$(LINKER) $(LINKER_FLAGS) $(OBJS) $(GUILIBS) $(SCIIMPLIB) \
	/subsystem:windows /dll /out:"$*.dll" /implib:"$*.lib" /def:$*.def 

CFLAGS=$(CC_OPTIONS) -I../routines/f2c

.f.obj	:
	..\bin\f2c  $*.f 
	$(CC) $(CFLAGS) $*.c 
	$(RM) $*.c 














	
