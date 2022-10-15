# CFLAGS IS CHANGED LOCALLY FOR EACH SUBDIR 
# CFLAGS = $(CC_OPTIONS) 
# or 
# CFLAGS = $(CC_OPTIONS) $(XFLAGS)

FFLAGS = $(FC_OPTIONS)

OBJS = $(OBJSC) $(OBJSF)

all:: $(LIBRARY)

world: all

$(LIBRARY): $(OBJS)
	@echo Creation of $(LIBRARY)
	link.exe -lib /nologo /out:"$@" $(OBJS) 

clean:: cleanC cleanF 

cleanC :
	$(RM) $(OBJSC)

cleanF :
	$(RM) $(OBJSCF)

distclean::
	$(RM) $(OBJS) $(LIBRARY)

.f.obj	:
	f2c  $*.f 
	$(CC) $(CFLAGS) $*.c 
	$(RM) $*.c 

