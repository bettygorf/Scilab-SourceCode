SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/libcomm.a

OBJSC = buf_dynam.o communicat.o format_mess.o \
	gest_memoire.o gest_messages.o list_chainees.o \
	utilitaires.o

OBJSF =

include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

include ../Make.lib

buf_dynam.o: gestion_memoire.h listes_chainees.h buffer_dynamiques.h
communicat.o: gestion_memoire.h formatage_messages.h utilitaires.h libCom.h \
	gestion_messages.h communications.h
format_mess.o: gestion_memoire.h buffer_dynamiques.h utilitaires.h \
	formatage_messages.h libCom.h
gest_memoire.o: gestion_memoire.h
gest_messages.o: utilitaires.h libCom.h formatage_messages.h \
	 gestion_memoire.h gestion_messages.h
list_chainees.o: listes_chainees.h
utilitaires.o: gestion_memoire.h buffer_dynamiques.h utilitaires.h

all:: Makefile.mak Makefile.amk

Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile

Makefile.amk	: Makefile
	$(SCIDIR)/util/Mak2ABSMak Makefile
