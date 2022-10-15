SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl

CFLAGS = $(CC_OPTIONS)

OBJS = buffer_dynamiques.o connexion.o formatage_messages.o gestion_memoire.o \
	listes_chainees.o scr_applications.o scr_liaisons.o scr_messages.o \
	scruteur.o utilitaires.o
PROGRAM = $(SCIDIR)/bin/geci

all:: $(PROGRAM)

world: all

$(PROGRAM): $(OBJS)
	$(RM) $(PROGRAM)
	$(CC) -o $(PROGRAM) $(OBJS) $(CC_LDFLAGS) $(X_EXTRA_LIBS)

clean::
	$(RM) $(OBJS)
distclean::
	$(RM) $(OBJS) $(PROGRAM)

buffer_dynamiques.o: gestion_memoire.h listes_chainees.h buffer_dynamiques.h
connexion.o: connexion.h
formatage_messages.o: gestion_memoire.h buffer_dynamiques.h utilitaires.h \
	formatage_messages.h libCom.h
gestion_memoire.o: gestion_memoire.h
listes_chainees.o: listes_chainees.h
scr_applications.o: gestion_memoire.h libCom.h listes_chainees.h scruteur.h \
	scr_liaisons.h formatage_messages.h utilitaires.h scr_applications.h \
	connexion.h
scr_liaisons.o: gestion_memoire.h libCom.h listes_chainees.h scruteur.h \
	scr_liaisons.h formatage_messages.h utilitaires.h scr_applications.h \
	scr_messages.h
scr_messages.o: libCom.h formatage_messages.h utilitaires.h gestion_memoire.h \
	scr_liaisons.h listes_chainees.h scr_applications.h scr_messages.h
scruteur.o: listes_chainees.h utilitaires.h gestion_memoire.h \
	formatage_messages.h
scruteur.o: libCom.h scr_liaisons.h scr_messages.h scr_applications.h \
	scruteur.h
utilitaires.o: gestion_memoire.h buffer_dynamiques.h utilitaires.h
