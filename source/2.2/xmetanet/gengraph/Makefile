SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

PROGRAM1 = $(SCIDIR)/bin/make-graph-file
OBJS1 = make-graph-file.o

all:: $(PROGRAM1)

$(PROGRAM1): $(OBJS1)
	$(RM) $@
	$(CC) -o $@ $(OBJS1) $(CC_LDFLAGS)

clean::
	$(RM) $(OBJS1)
distclean::
	$(RM) $(OBJS1) $(PROGRAM1)

PROGRAM2 = $(SCIDIR)/bin/mesh
OBJS2 = carete.o getran.o mesh.o mshpts.o seed.o

all:: $(PROGRAM2)

$(PROGRAM2): $(OBJS2)
	$(RM) $@
	$(FC) -o $@ $(OBJS2) $(FC_LDFLAGS)

clean::
	$(RM) $(OBJS2)
distclean::
	$(RM) $(OBJS2) $(PROGRAM2)

PROGRAM3= $(SCIDIR)/bin/netgen2graph
OBJS3 = netgen2graph.o

all:: $(PROGRAM3)

$(PROGRAM3): $(OBJS3)
	$(RM) $@
	$(CC) -o $@ $(OBJS3) $(CC_LDFLAGS)

clean::
	$(RM) $(OBJS3)
distclean::
	$(RM) $(OBJS3) $(PROGRAM3)

PROGRAM4 = $(SCIDIR)/bin/mesh2graph
OBJS4 = mesh2graph.o

all:: $(PROGRAM4)

$(PROGRAM4): $(OBJS4)
	$(RM) $@
	$(CC) -o $@ $(OBJS4) $(CC_LDFLAGS) -lm

clean::
	$(RM) $(OBJS4)
distclean::
	$(RM) $(OBJS4) $(PROGRAM4)

PROGRAM5 = $(SCIDIR)/bin/netgen
OBJS5 = netgen.o

all:: $(PROGRAM5)

$(PROGRAM5): $(OBJS5)
	$(RM) $@
	$(FC) -o $@ $(OBJS5) $(FC_LDFLAGS)

clean::
	$(RM) $(OBJS5)
distclean::
	$(RM) $(OBJS5) $(PROGRAM5)
