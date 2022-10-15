SHELL = /bin/sh

SCIDIR=../..
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS) $(XFLAGS)

EXTRA_LIBS = $(SCIDIR)/libs/comm.a

OBJS = actions.o alert.o attributes.o bezier.o choose.o color.o \
	comm.o dialog.o draw.o file.o find.o font.o graph.o \
	graphics.o help.o init.o \
	list.o load.o menu.o message.o metanet.o modify.o movedraw.o \
	myhsearch.o name.o save.o show.o study.o text.o

PROGRAM = $(SCIDIR)/bin/xmetanet
XMETANET_DEFAULT = $(SCIDIR)/X11_defaults/Metanet-color
XMETANET_HELP = $(SCIDIR)/X11_defaults/MetanetBegin.help \
	$(SCIDIR)/X11_defaults/MetanetStudy.help \
	$(SCIDIR)/X11_defaults/MetanetModify.help

all:: $(PROGRAM) $(XMETANET_DEFAULT) $(XMETANET_HELP)

$(PROGRAM): $(OBJS) $(XAW_LOCAL_LIB) $(EXTRA_LIBS)
	$(RM) $@
	$(CC) -o $@ $(OBJS) $(CC_LDFLAGS) $(XLIBS) $(EXTRA_LIBS) -lm

clean::
	$(RM) $(OBJS)
distclean::
	$(RM) $(OBJS) $(PROGRAM)

$(XMETANET_DEFAULT): Metanet-color.ad
	$(RM) $@
	$(INSTALL) -m 644 Metanet-color.ad $(XMETANET_DEFAULT)

$(SCIDIR)/X11_defaults/MetanetBegin.help: MetanetBegin.help
	$(RM) $@
	$(INSTALL) -m 644 MetanetBegin.help $@

$(SCIDIR)/X11_defaults/MetanetStudy.help: MetanetStudy.help
	$(RM) $@
	$(INSTALL) -m 644 MetanetStudy.help $@

$(SCIDIR)/X11_defaults/MetanetModify.help: MetanetModify.help
	$(RM) $@
	$(INSTALL) -m 644 MetanetModify.help $@

distclean::
	$(RM) $(XMETANET_DEFAULT)

actions.o: graphics.h menus.h list.h graph.h
alert.o: metaconst.h metawin.h graphics.h
attributes.o: list.h graph.h menus.h
bezier.o: bezier.h
choose.o: metaconst.h metawin.h graphics.h
color.o: list.h graph.h color.h metio.h
comm.o: defs.h metaconst.h list.h graph.h graphics.h menus.h metadir.h \
	metio.h color.h libCalCom.h libCom.h
dialog.o: metaconst.h metawin.h graphics.h
draw.o: metaconst.h metawin.h bezier.h color.h graphics.h font.h
find.o: metaconst.h list.h graph.h metio.h graphics.h
font.o: graphics.h metio.h
graph.o: defs.h metaconst.h list.h graph.h metio.h
graphics.o: metaconst.h list.h graph.h color.h menus.h metio.h graphics.h \
	font.h
help.o:  metaconst.h metadir.h metawin.h graphics.h
init.o: list.h graph.h metio.h menus.h
list.o: list.h graph.h metio.h
load.o: mysearch.h defs.h metaconst.h metadir.h list.h graph.h menus.h \
	metio.h color.h
menu.o: metaconst.h metawin.h list.h graph.h graphics.h menus.h font.h metio.h
metanet.o: defs.h color.h list.h graph.h graphics.h menus.h metadir.h \
	libCalCom.h libCom.h
modify.o: metaconst.h list.h graph.h menus.h metio.h
movedraw.o: metaconst.h metawin.h
myhsearch.o: mysearch.h
name.o: metaconst.h list.h graph.h metio.h graphics.h
save.o: metaconst.h metadir.h list.h graph.h metio.h menus.h
show.o: list.h graph.h menus.h metio.h libCom.h
study.o: list.h graph.h menus.h
text.o: metaconst.h metawin.h graphics.h
