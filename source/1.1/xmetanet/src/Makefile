# Makefile generated by imake - do not edit!
# $XConsortium: imake.c,v 1.65 91/07/25 17:50:17 rws Exp $
#
# The cpp used on this machine replaces all newlines and multiple tabs and
# spaces in a macro expansion with a single space.  Imake tries to compensate
# for this, but is not always successful.
#

# -------------------------------------------------------------------------
# Makefile generated from "Imake.tmpl" and <Imakefile>
# $XConsortium: Imake.tmpl,v 1.139 91/09/16 08:52:48 rws Exp $
#
# Platform-specific parameters may be set in the appropriate <vendor>.cf
# configuration files.  Site-specific parameters should be set in the file
# site.def.  Full rebuilds are recommended if any parameters are changed.
#
# If your C preprocessor does not define any unique symbols, you will need
# to set BOOTSTRAPCFLAGS when rebuilding imake (usually when doing
# "make World" the first time).
#

# -------------------------------------------------------------------------
# site-specific configuration parameters that need to come before
# the platform-specific parameters - edit site.def to change

# site:  $XConsortium: site.def,v 1.2 91/07/30 20:26:44 rws Exp $

# -------------------------------------------------------------------------
# platform-specific configuration parameters - edit sun.cf to change

# platform:  $XConsortium: sun.cf,v 1.72.1.1 92/03/18 13:13:37 rws Exp $

# operating system:  SunOS 4.1.1

# $XConsortium: sunLib.rules,v 1.7 91/12/20 11:19:47 rws Exp $

# -------------------------------------------------------------------------
# site-specific configuration parameters that go after
# the platform-specific parameters - edit site.def to change

# site:  $XConsortium: site.def,v 1.2 91/07/30 20:26:44 rws Exp $

            SHELL = /bin/sh

              TOP = ../../.
      CURRENT_DIR = ./xmetanet/src

               AR = ar clq
  BOOTSTRAPCFLAGS =
               CC = cc
               AS = as

         COMPRESS = compress
              CPP = /lib/cpp $(STD_CPP_DEFINES)
    PREPROCESSCMD = cc -E $(STD_CPP_DEFINES)
          INSTALL = install
               LD = ld
             LINT = lint
      LINTLIBFLAG = -C
         LINTOPTS = -axz
               LN = ln -s
             MAKE = make
               MV = mv
               CP = cp

           RANLIB = ranlib
  RANLIBINSTFLAGS =

               RM = rm -f
            TROFF = psroff
         MSMACROS = -ms
              TBL = tbl
              EQN = eqn
     STD_INCLUDES =
  STD_CPP_DEFINES =
      STD_DEFINES =
 EXTRA_LOAD_FLAGS =
  EXTRA_LIBRARIES =
             TAGS = ctags

    SHAREDCODEDEF = -DSHAREDCODE
         SHLIBDEF = -DSUNSHLIB

    PROTO_DEFINES =

     INSTPGMFLAGS =

     INSTBINFLAGS = -m 0755
     INSTUIDFLAGS = -m 4755
     INSTLIBFLAGS = -m 0644
     INSTINCFLAGS = -m 0444
     INSTMANFLAGS = -m 0444
     INSTDATFLAGS = -m 0444
    INSTKMEMFLAGS = -g kmem -m 2755

      CDEBUGFLAGS = -O
        CCOPTIONS = -pipe

      ALLINCLUDES = $(INCLUDES) $(EXTRA_INCLUDES) $(TOP_INCLUDES) $(STD_INCLUDES)
       ALLDEFINES = $(ALLINCLUDES) $(STD_DEFINES) $(EXTRA_DEFINES) $(PROTO_DEFINES) $(DEFINES)
           CFLAGS = $(CDEBUGFLAGS) $(CCOPTIONS) $(ALLDEFINES)
        LINTFLAGS = $(LINTOPTS) -DLINT $(ALLDEFINES)

           LDLIBS = $(SYS_LIBRARIES) $(EXTRA_LIBRARIES)

        LDOPTIONS = $(CDEBUGFLAGS) $(CCOPTIONS) $(LOCAL_LDFLAGS)

   LDCOMBINEFLAGS = -X -r
      DEPENDFLAGS =

        MACROFILE = sun.cf
           RM_CMD = $(RM) *.CKP *.ln *.BAK *.bak *.o core errs ,* *~ *.a .emacs_* tags TAGS make.log MakeOut

    IMAKE_DEFINES =

         IRULESRC = $(CONFIGDIR)
        IMAKE_CMD = $(IMAKE) -DUseInstalled -I$(IRULESRC) $(IMAKE_DEFINES)

     ICONFIGFILES = $(IRULESRC)/Imake.tmpl $(IRULESRC)/Imake.rules \
			$(IRULESRC)/Project.tmpl $(IRULESRC)/site.def \
			$(IRULESRC)/$(MACROFILE) $(EXTRA_ICONFIGFILES)

# -------------------------------------------------------------------------
# X Window System Build Parameters
# $XConsortium: Project.tmpl,v 1.138.1.1 92/11/11 09:49:19 rws Exp $

# -------------------------------------------------------------------------
# X Window System make variables; this need to be coordinated with rules

          PATHSEP = /
        USRLIBDIR = /usr/lib
           BINDIR = /usr/bin/X11
          INCROOT = /usr/include
     BUILDINCROOT = $(TOP)
      BUILDINCDIR = $(BUILDINCROOT)/X11
      BUILDINCTOP = ..
           INCDIR = $(INCROOT)/X11
           ADMDIR = /usr/adm
           LIBDIR = $(USRLIBDIR)/X11
        CONFIGDIR = $(LIBDIR)/config
       LINTLIBDIR = $(USRLIBDIR)/lint

          FONTDIR = $(LIBDIR)/fonts
         XINITDIR = $(LIBDIR)/xinit
           XDMDIR = $(LIBDIR)/xdm
           TWMDIR = $(LIBDIR)/twm
          MANPATH = /usr/man
    MANSOURCEPATH = $(MANPATH)/man
        MANSUFFIX = n
     LIBMANSUFFIX = 3
           MANDIR = $(MANSOURCEPATH)$(MANSUFFIX)
        LIBMANDIR = $(MANSOURCEPATH)$(LIBMANSUFFIX)
           NLSDIR = $(LIBDIR)/nls
        PEXAPIDIR = $(LIBDIR)/PEX
      XAPPLOADDIR = $(LIBDIR)/app-defaults
       FONTCFLAGS = -t

     INSTAPPFLAGS = $(INSTDATFLAGS)

            IMAKE = imake
           DEPEND = makedepend
              RGB = rgb

            FONTC = bdftopcf

        MKFONTDIR = mkfontdir
        MKDIRHIER = /bin/sh $(BINDIR)/mkdirhier

        CONFIGSRC = $(TOP)/config
       DOCUTILSRC = $(TOP)/doc/util
        CLIENTSRC = $(TOP)/clients
          DEMOSRC = $(TOP)/demos
           LIBSRC = $(TOP)/lib
          FONTSRC = $(TOP)/fonts
       INCLUDESRC = $(TOP)/X11
        SERVERSRC = $(TOP)/server
          UTILSRC = $(TOP)/util
        SCRIPTSRC = $(UTILSRC)/scripts
       EXAMPLESRC = $(TOP)/examples
       CONTRIBSRC = $(TOP)/../contrib
           DOCSRC = $(TOP)/doc
           RGBSRC = $(TOP)/rgb
        DEPENDSRC = $(UTILSRC)/makedepend
         IMAKESRC = $(CONFIGSRC)
         XAUTHSRC = $(LIBSRC)/Xau
          XLIBSRC = $(LIBSRC)/X
           XMUSRC = $(LIBSRC)/Xmu
       TOOLKITSRC = $(LIBSRC)/Xt
       AWIDGETSRC = $(LIBSRC)/Xaw
       OLDXLIBSRC = $(LIBSRC)/oldX
      XDMCPLIBSRC = $(LIBSRC)/Xdmcp
      BDFTOSNFSRC = $(FONTSRC)/bdftosnf
      BDFTOSNFSRC = $(FONTSRC)/clients/bdftosnf
      BDFTOPCFSRC = $(FONTSRC)/clients/bdftopcf
     MKFONTDIRSRC = $(FONTSRC)/clients/mkfontdir
         FSLIBSRC = $(FONTSRC)/lib/fs
    FONTSERVERSRC = $(FONTSRC)/server
     EXTENSIONSRC = $(TOP)/extensions
         XILIBSRC = $(EXTENSIONSRC)/lib/xinput
        PEXLIBSRC = $(EXTENSIONSRC)/lib/PEXlib
      PHIGSLIBSRC = $(EXTENSIONSRC)/lib/PEX

# $XConsortium: sunLib.tmpl,v 1.14.1.2 92/11/11 09:55:02 rws Exp $

SHLIBLDFLAGS = -assert pure-text
PICFLAGS = -pic

  DEPEXTENSIONLIB =
     EXTENSIONLIB = -lXext

          DEPXLIB = $(DEPEXTENSIONLIB)
             XLIB = $(EXTENSIONLIB) -lX11

        DEPXMULIB = $(USRLIBDIR)/libXmu.sa.$(SOXMUREV)
       XMULIBONLY = -lXmu
           XMULIB = -lXmu

       DEPOLDXLIB =
          OLDXLIB = -loldX

      DEPXTOOLLIB = $(USRLIBDIR)/libXt.sa.$(SOXTREV)
         XTOOLLIB = -lXt

        DEPXAWLIB = $(USRLIBDIR)/libXaw.sa.$(SOXAWREV)
           XAWLIB = -lXaw

        DEPXILIB =
           XILIB = -lXi

        DEPPEXLIB =
           PEXLIB = -lPEX5

        SOXLIBREV = 4.10
          SOXTREV = 4.10
         SOXAWREV = 5.0
        SOOLDXREV = 4.10
         SOXMUREV = 4.10
        SOXEXTREV = 4.10
      SOXINPUTREV = 4.10
         SOPEXREV = 1.0

      DEPXAUTHLIB = $(USRLIBDIR)/libXau.a
         XAUTHLIB =  -lXau
      DEPXDMCPLIB = $(USRLIBDIR)/libXdmcp.a
         XDMCPLIB =  -lXdmcp

        DEPPHIGSLIB = $(USRLIBDIR)/libphigs.a
           PHIGSLIB =  -lphigs

       DEPXBSDLIB = $(USRLIBDIR)/libXbsd.a
          XBSDLIB =  -lXbsd

 LINTEXTENSIONLIB = $(LINTLIBDIR)/llib-lXext.ln
         LINTXLIB = $(LINTLIBDIR)/llib-lX11.ln
          LINTXMU = $(LINTLIBDIR)/llib-lXmu.ln
        LINTXTOOL = $(LINTLIBDIR)/llib-lXt.ln
          LINTXAW = $(LINTLIBDIR)/llib-lXaw.ln
           LINTXI = $(LINTLIBDIR)/llib-lXi.ln
          LINTPEX = $(LINTLIBDIR)/llib-lPEX5.ln
        LINTPHIGS = $(LINTLIBDIR)/llib-lphigs.ln

          DEPLIBS = $(DEPXAWLIB) $(DEPXMULIB) $(DEPXTOOLLIB) $(DEPXLIB)

         DEPLIBS1 = $(DEPLIBS)
         DEPLIBS2 = $(DEPLIBS)
         DEPLIBS3 = $(DEPLIBS)

# -------------------------------------------------------------------------
# Imake rules for building libraries, programs, scripts, and data files
# rules:  $XConsortium: Imake.rules,v 1.123 91/09/16 20:12:16 rws Exp $

# -------------------------------------------------------------------------
# start of Imakefile

SCIDIR = /usr/wolfgang2/scilab

FFOPTIONS =
FDEBUGFLAGS = -O

FLOCAL_LDFLAGS=  -Bstatic

LOCAL_LDFLAGS=  -Bstatic

LDOPTIONS = $(CDEBUGFLAGS) $(CCOPTIONS) $(LOCAL_LDFLAGS)

FFLAGS = $(FDEBUGFLAGS) $(FFOPTIONS)

FLDOPTIONS = $(FDEBUGFLAGS) $(FFOPTIONS) $(FLOCAL_LDFLAGS)

PATHSP=$(SCIDIR)/routines
PATHO=$(SCIDIR)/libs

.SUFFIXES: .sci .bin .dia .tst $(SUFFIXES)

     TERMCAPLIB = -ltermcap

SYS_LIBRARIES = 	-lm
DEPLIBS =
LOCAL_LIBRARIES = 	$(XAWLIB) $(XMULIB) $(XTOOLLIB) $(XLIB)

SRCS =	actions.c alert.c attributes.c bezier.c choose.c color.c \
	create.c dialog.c dialogs.c draw.c file.c find.c graph.c \
	graphics.c init.c \
	list.c load.c menu.c message.c metanet.c modify.c movedraw.c \
	name.c save.c scilab.c show.c socket.c study.c text.c

OBJS =	actions.o alert.o attributes.o bezier.o choose.o color.o \
	create.o dialog.o dialogs.o draw.o file.o find.o graph.o \
	graphics.o init.o \
	list.o load.o menu.o message.o metanet.o modify.o movedraw.o \
	name.o save.o scilab.o show.o socket.o study.o text.o

PROGRAM = $(SCIDIR)/bin/xmetanet

all:: $(PROGRAM)

$(PROGRAM): $(OBJS) $(DEPLIBS)
	$(RM) $@
	$(CC) -o $@ $(OBJS) $(LDOPTIONS) $(LOCAL_LIBRARIES) $(LDLIBS) $(SYS_LIBRARIE) $(EXTRA_LOAD_FLAGS)

clean::
	$(RM) $(PROGRAM)

depend::
	$(DEPEND) $(DEPENDFLAGS) -s "# DO NOT DELETE" -- $(ALLDEFINES) -- $(SRCS)

distclean:: clean

# -------------------------------------------------------------------------
# common rules for all Makefiles - do not edit

emptyrule::

clean::
	$(RM_CMD) "#"*

Makefile::
	-@if [ -f Makefile ]; then set -x; \
	$(RM) Makefile.bak; $(MV) Makefile Makefile.bak; \
	else exit 0; fi
	$(IMAKE_CMD) -DTOPDIR=$(TOP) -DCURDIR=$(CURRENT_DIR)

tags::
	$(TAGS) -w *.[ch]
	$(TAGS) -xw *.[ch] > TAGS

saber:
	# load $(ALLDEFINES) $(SRCS)

osaber:
	# load $(ALLDEFINES) $(OBJS)

# -------------------------------------------------------------------------
# empty rules for directories that do not have SUBDIRS - do not edit

install::
	@echo "install in $(CURRENT_DIR) done"

install.man::
	@echo "install.man in $(CURRENT_DIR) done"

Makefiles::

includes::

# -------------------------------------------------------------------------
# dependencies generated by makedepend

# DO NOT DELETE

actions.o: /usr/include/X11/Intrinsic.h /usr/include/X11/Xlib.h
actions.o: /usr/include/sys/types.h /usr/include/sys/stdtypes.h
actions.o: /usr/include/sys/sysmacros.h /usr/include/X11/X.h
actions.o: /usr/include/X11/Xfuncproto.h /usr/include/X11/Xosdefs.h
actions.o: /usr/include/stddef.h /usr/include/X11/Xutil.h
actions.o: /usr/include/X11/Xresource.h /usr/include/string.h
actions.o: /usr/include/X11/Core.h /usr/include/X11/Composite.h
actions.o: /usr/include/X11/Constraint.h /usr/include/X11/Object.h
actions.o: /usr/include/X11/RectObj.h graphics.h menus.h
alert.o: /usr/include/stdio.h /usr/include/X11/Intrinsic.h
alert.o: /usr/include/X11/Xlib.h /usr/include/sys/types.h
alert.o: /usr/include/sys/stdtypes.h /usr/include/sys/sysmacros.h
alert.o: /usr/include/X11/X.h /usr/include/X11/Xfuncproto.h
alert.o: /usr/include/X11/Xosdefs.h /usr/include/stddef.h
alert.o: /usr/include/X11/Xutil.h /usr/include/X11/Xresource.h
alert.o: /usr/include/string.h /usr/include/X11/Core.h
alert.o: /usr/include/X11/Composite.h /usr/include/X11/Constraint.h
alert.o: /usr/include/X11/Object.h /usr/include/X11/RectObj.h
alert.o: /usr/include/X11/Shell.h /usr/include/X11/StringDefs.h
alert.o: /usr/include/X11/Xaw/Box.h /usr/include/X11/Xmu/Converters.h
alert.o: /usr/include/X11/Xaw/Command.h /usr/include/X11/Xaw/Label.h
alert.o: /usr/include/X11/Xaw/Simple.h metawin.h graphics.h
attributes.o: list.h graph.h /usr/include/stdio.h menus.h
bezier.o: /usr/include/X11/Intrinsic.h /usr/include/X11/Xlib.h
bezier.o: /usr/include/sys/types.h /usr/include/sys/stdtypes.h
bezier.o: /usr/include/sys/sysmacros.h /usr/include/X11/X.h
bezier.o: /usr/include/X11/Xfuncproto.h /usr/include/X11/Xosdefs.h
bezier.o: /usr/include/stddef.h /usr/include/X11/Xutil.h
bezier.o: /usr/include/X11/Xresource.h /usr/include/string.h
bezier.o: /usr/include/X11/Core.h /usr/include/X11/Composite.h
bezier.o: /usr/include/X11/Constraint.h /usr/include/X11/Object.h
bezier.o: /usr/include/X11/RectObj.h bezier.h /usr/include/X11/Xproto.h
bezier.o: /usr/include/X11/Xmd.h /usr/include/X11/Xprotostr.h
choose.o: /usr/include/X11/Intrinsic.h /usr/include/X11/Xlib.h
choose.o: /usr/include/sys/types.h /usr/include/sys/stdtypes.h
choose.o: /usr/include/sys/sysmacros.h /usr/include/X11/X.h
choose.o: /usr/include/X11/Xfuncproto.h /usr/include/X11/Xosdefs.h
choose.o: /usr/include/stddef.h /usr/include/X11/Xutil.h
choose.o: /usr/include/X11/Xresource.h /usr/include/string.h
choose.o: /usr/include/X11/Core.h /usr/include/X11/Composite.h
choose.o: /usr/include/X11/Constraint.h /usr/include/X11/Object.h
choose.o: /usr/include/X11/RectObj.h /usr/include/X11/Shell.h
choose.o: /usr/include/X11/StringDefs.h /usr/include/X11/Xaw/Box.h
choose.o: /usr/include/X11/Xmu/Converters.h /usr/include/X11/Xaw/Command.h
choose.o: /usr/include/X11/Xaw/Label.h /usr/include/X11/Xaw/Simple.h
choose.o: /usr/include/X11/Xaw/List.h metawin.h graphics.h
color.o: list.h graph.h /usr/include/stdio.h color.h metio.h
create.o: /usr/include/malloc.h /usr/include/string.h
create.o: /usr/include/sys/stdtypes.h metadir.h list.h graph.h
create.o: /usr/include/stdio.h metio.h
dialog.o: /usr/include/stdio.h /usr/include/X11/Intrinsic.h
dialog.o: /usr/include/X11/Xlib.h /usr/include/sys/types.h
dialog.o: /usr/include/sys/stdtypes.h /usr/include/sys/sysmacros.h
dialog.o: /usr/include/X11/X.h /usr/include/X11/Xfuncproto.h
dialog.o: /usr/include/X11/Xosdefs.h /usr/include/stddef.h
dialog.o: /usr/include/X11/Xutil.h /usr/include/X11/Xresource.h
dialog.o: /usr/include/string.h /usr/include/X11/Core.h
dialog.o: /usr/include/X11/Composite.h /usr/include/X11/Constraint.h
dialog.o: /usr/include/X11/Object.h /usr/include/X11/RectObj.h
dialog.o: /usr/include/X11/Shell.h /usr/include/X11/StringDefs.h
dialog.o: /usr/include/X11/Xaw/Box.h /usr/include/X11/Xmu/Converters.h
dialog.o: /usr/include/X11/Xaw/Command.h /usr/include/X11/Xaw/Label.h
dialog.o: /usr/include/X11/Xaw/Simple.h /usr/include/X11/Xaw/Dialog.h
dialog.o: /usr/include/X11/Xaw/Form.h metawin.h graphics.h
dialogs.o: /usr/include/X11/Intrinsic.h /usr/include/X11/Xlib.h
dialogs.o: /usr/include/sys/types.h /usr/include/sys/stdtypes.h
dialogs.o: /usr/include/sys/sysmacros.h /usr/include/X11/X.h
dialogs.o: /usr/include/X11/Xfuncproto.h /usr/include/X11/Xosdefs.h
dialogs.o: /usr/include/stddef.h /usr/include/X11/Xutil.h
dialogs.o: /usr/include/X11/Xresource.h /usr/include/string.h
dialogs.o: /usr/include/X11/Core.h /usr/include/X11/Composite.h
dialogs.o: /usr/include/X11/Constraint.h /usr/include/X11/Object.h
dialogs.o: /usr/include/X11/RectObj.h /usr/include/X11/Shell.h
dialogs.o: /usr/include/X11/StringDefs.h /usr/include/X11/Xaw/Box.h
dialogs.o: /usr/include/X11/Xmu/Converters.h /usr/include/X11/Xaw/Command.h
dialogs.o: /usr/include/X11/Xaw/Label.h /usr/include/X11/Xaw/Simple.h
dialogs.o: /usr/include/X11/Xaw/Dialog.h /usr/include/X11/Xaw/Form.h
dialogs.o: metawin.h graphics.h
draw.o: /usr/include/stdio.h /usr/include/X11/Intrinsic.h
draw.o: /usr/include/X11/Xlib.h /usr/include/sys/types.h
draw.o: /usr/include/sys/stdtypes.h /usr/include/sys/sysmacros.h
draw.o: /usr/include/X11/X.h /usr/include/X11/Xfuncproto.h
draw.o: /usr/include/X11/Xosdefs.h /usr/include/stddef.h
draw.o: /usr/include/X11/Xutil.h /usr/include/X11/Xresource.h
draw.o: /usr/include/string.h /usr/include/X11/Core.h
draw.o: /usr/include/X11/Composite.h /usr/include/X11/Constraint.h
draw.o: /usr/include/X11/Object.h /usr/include/X11/RectObj.h
draw.o: /usr/include/X11/StringDefs.h /usr/include/X11/Xaw/Box.h
draw.o: /usr/include/X11/Xmu/Converters.h /usr/include/X11/Xaw/Label.h
draw.o: /usr/include/X11/Xaw/Simple.h /usr/include/X11/Xaw/Viewport.h
draw.o: /usr/include/X11/Xaw/Form.h /usr/include/X11/Xaw/Reports.h
draw.o: metaconst.h metawin.h bezier.h /usr/include/X11/Xproto.h
draw.o: /usr/include/X11/Xmd.h /usr/include/X11/Xprotostr.h color.h
draw.o: graphics.h
file.o: /usr/include/errno.h /usr/include/sys/errno.h /usr/include/string.h
file.o: /usr/include/sys/stdtypes.h metadir.h list.h graph.h
file.o: /usr/include/stdio.h metio.h
find.o: /usr/include/X11/Intrinsic.h /usr/include/X11/Xlib.h
find.o: /usr/include/sys/types.h /usr/include/sys/stdtypes.h
find.o: /usr/include/sys/sysmacros.h /usr/include/X11/X.h
find.o: /usr/include/X11/Xfuncproto.h /usr/include/X11/Xosdefs.h
find.o: /usr/include/stddef.h /usr/include/X11/Xutil.h
find.o: /usr/include/X11/Xresource.h /usr/include/string.h
find.o: /usr/include/X11/Core.h /usr/include/X11/Composite.h
find.o: /usr/include/X11/Constraint.h /usr/include/X11/Object.h
find.o: /usr/include/X11/RectObj.h metaconst.h list.h graph.h
find.o: /usr/include/stdio.h metio.h graphics.h
graph.o: /usr/include/malloc.h /usr/include/string.h
graph.o: /usr/include/sys/stdtypes.h /usr/include/stdio.h metaconst.h list.h
graph.o: graph.h metio.h
graphics.o: /usr/include/X11/Intrinsic.h /usr/include/X11/Xlib.h
graphics.o: /usr/include/sys/types.h /usr/include/sys/stdtypes.h
graphics.o: /usr/include/sys/sysmacros.h /usr/include/X11/X.h
graphics.o: /usr/include/X11/Xfuncproto.h /usr/include/X11/Xosdefs.h
graphics.o: /usr/include/stddef.h /usr/include/X11/Xutil.h
graphics.o: /usr/include/X11/Xresource.h /usr/include/string.h
graphics.o: /usr/include/X11/Core.h /usr/include/X11/Composite.h
graphics.o: /usr/include/X11/Constraint.h /usr/include/X11/Object.h
graphics.o: /usr/include/X11/RectObj.h /usr/include/math.h
graphics.o: /usr/include/floatingpoint.h /usr/include/sys/ieeefp.h
graphics.o: /usr/include/malloc.h /usr/include/stdio.h metaconst.h list.h
graphics.o: graph.h color.h menus.h metio.h graphics.h
init.o: /usr/include/dirent.h /usr/include/sys/types.h
init.o: /usr/include/sys/stdtypes.h /usr/include/sys/sysmacros.h
init.o: /usr/include/sys/dirent.h /usr/include/stdlib.h /usr/include/string.h
init.o: list.h graph.h /usr/include/stdio.h metio.h
list.o: /usr/include/malloc.h list.h graph.h /usr/include/stdio.h metio.h
load.o: /usr/include/dirent.h /usr/include/sys/types.h
load.o: /usr/include/sys/stdtypes.h /usr/include/sys/sysmacros.h
load.o: /usr/include/sys/dirent.h /usr/include/malloc.h /usr/include/stdio.h
load.o: /usr/include/string.h /usr/include/math.h
load.o: /usr/include/floatingpoint.h /usr/include/sys/ieeefp.h metaconst.h
load.o: metadir.h list.h graph.h menus.h metio.h
menu.o: /usr/include/X11/Intrinsic.h /usr/include/X11/Xlib.h
menu.o: /usr/include/sys/types.h /usr/include/sys/stdtypes.h
menu.o: /usr/include/sys/sysmacros.h /usr/include/X11/X.h
menu.o: /usr/include/X11/Xfuncproto.h /usr/include/X11/Xosdefs.h
menu.o: /usr/include/stddef.h /usr/include/X11/Xutil.h
menu.o: /usr/include/X11/Xresource.h /usr/include/string.h
menu.o: /usr/include/X11/Core.h /usr/include/X11/Composite.h
menu.o: /usr/include/X11/Constraint.h /usr/include/X11/Object.h
menu.o: /usr/include/X11/RectObj.h /usr/include/X11/StringDefs.h
menu.o: /usr/include/X11/Xaw/Box.h /usr/include/X11/Xmu/Converters.h
menu.o: /usr/include/X11/Xaw/Command.h /usr/include/X11/Xaw/Label.h
menu.o: /usr/include/X11/Xaw/Simple.h /usr/include/X11/Xaw/Form.h
menu.o: /usr/include/X11/Xaw/MenuButton.h /usr/include/X11/Xaw/SimpleMenu.h
menu.o: /usr/include/X11/Shell.h /usr/include/X11/Xaw/SmeBSB.h
menu.o: /usr/include/X11/Xaw/Sme.h /usr/include/X11/bitmaps/xlogo11
menu.o: metaconst.h metawin.h list.h graph.h /usr/include/stdio.h graphics.h
menu.o: menus.h
metanet.o: /usr/include/stdio.h /usr/include/string.h
metanet.o: /usr/include/sys/stdtypes.h /usr/include/X11/cursorfont.h
metanet.o: /usr/include/X11/Intrinsic.h /usr/include/X11/Xlib.h
metanet.o: /usr/include/sys/types.h /usr/include/sys/sysmacros.h
metanet.o: /usr/include/X11/X.h /usr/include/X11/Xfuncproto.h
metanet.o: /usr/include/X11/Xosdefs.h /usr/include/stddef.h
metanet.o: /usr/include/X11/Xutil.h /usr/include/X11/Xresource.h
metanet.o: /usr/include/X11/Core.h /usr/include/X11/Composite.h
metanet.o: /usr/include/X11/Constraint.h /usr/include/X11/Object.h
metanet.o: /usr/include/X11/RectObj.h /usr/include/X11/Shell.h
metanet.o: /usr/include/X11/StringDefs.h /usr/include/X11/Xaw/Form.h
metanet.o: /usr/include/X11/Xaw/Label.h /usr/include/X11/Xaw/Simple.h
metanet.o: /usr/include/X11/Xmu/Converters.h defs.h color.h graphics.h
metanet.o: menus.h
modify.o: metaconst.h list.h graph.h /usr/include/stdio.h menus.h metio.h
movedraw.o: /usr/include/X11/StringDefs.h /usr/include/X11/IntrinsicP.h
movedraw.o: /usr/include/X11/Intrinsic.h /usr/include/X11/Xlib.h
movedraw.o: /usr/include/sys/types.h /usr/include/sys/stdtypes.h
movedraw.o: /usr/include/sys/sysmacros.h /usr/include/X11/X.h
movedraw.o: /usr/include/X11/Xfuncproto.h /usr/include/X11/Xosdefs.h
movedraw.o: /usr/include/stddef.h /usr/include/X11/Xutil.h
movedraw.o: /usr/include/X11/Xresource.h /usr/include/string.h
movedraw.o: /usr/include/X11/Core.h /usr/include/X11/Composite.h
movedraw.o: /usr/include/X11/Constraint.h /usr/include/X11/Object.h
movedraw.o: /usr/include/X11/RectObj.h /usr/include/X11/CoreP.h
movedraw.o: /usr/include/X11/CompositeP.h /usr/include/X11/ConstrainP.h
movedraw.o: /usr/include/X11/ObjectP.h /usr/include/X11/RectObjP.h
movedraw.o: /usr/include/X11/Xaw/ViewportP.h /usr/include/X11/Xaw/Viewport.h
movedraw.o: /usr/include/X11/Xaw/Form.h /usr/include/X11/Xaw/Reports.h
movedraw.o: /usr/include/X11/Xaw/FormP.h metaconst.h metawin.h
name.o: /usr/include/malloc.h metaconst.h list.h graph.h /usr/include/stdio.h
name.o: metio.h
save.o: /usr/include/malloc.h /usr/include/stdio.h /usr/include/string.h
save.o: /usr/include/sys/stdtypes.h metaconst.h metadir.h list.h graph.h
save.o: metio.h
scilab.o: /usr/include/malloc.h list.h graph.h /usr/include/stdio.h metio.h
show.o: list.h graph.h /usr/include/stdio.h metio.h
socket.o: /usr/include/malloc.h /usr/include/stdio.h
socket.o: /usr/include/X11/Intrinsic.h /usr/include/X11/Xlib.h
socket.o: /usr/include/sys/types.h /usr/include/sys/stdtypes.h
socket.o: /usr/include/sys/sysmacros.h /usr/include/X11/X.h
socket.o: /usr/include/X11/Xfuncproto.h /usr/include/X11/Xosdefs.h
socket.o: /usr/include/stddef.h /usr/include/X11/Xutil.h
socket.o: /usr/include/X11/Xresource.h /usr/include/string.h
socket.o: /usr/include/X11/Core.h /usr/include/X11/Composite.h
socket.o: /usr/include/X11/Constraint.h /usr/include/X11/Object.h
socket.o: /usr/include/X11/RectObj.h graphics.h message.h
socket.o: /usr/include/sys/socket.h /usr/include/sys/ioctl.h
socket.o: /usr/include/sys/ttychars.h /usr/include/sys/ttydev.h
socket.o: /usr/include/sys/ttold.h /usr/include/sys/ioccom.h
socket.o: /usr/include/sys/ttycom.h /usr/include/sys/filio.h
socket.o: /usr/include/sys/sockio.h /usr/include/netinet/in.h
socket.o: /usr/include/netdb.h /usr/include/signal.h
socket.o: /usr/include/sys/signal.h /usr/include/vm/faultcode.h
socket.o: /usr/include/unistd.h /usr/include/fcntl.h
socket.o: /usr/include/sys/fcntlcom.h /usr/include/sys/stat.h
study.o: list.h graph.h /usr/include/stdio.h menus.h
text.o: /usr/include/stdio.h /usr/include/X11/Intrinsic.h
text.o: /usr/include/X11/Xlib.h /usr/include/sys/types.h
text.o: /usr/include/sys/stdtypes.h /usr/include/sys/sysmacros.h
text.o: /usr/include/X11/X.h /usr/include/X11/Xfuncproto.h
text.o: /usr/include/X11/Xosdefs.h /usr/include/stddef.h
text.o: /usr/include/X11/Xutil.h /usr/include/X11/Xresource.h
text.o: /usr/include/string.h /usr/include/X11/Core.h
text.o: /usr/include/X11/Composite.h /usr/include/X11/Constraint.h
text.o: /usr/include/X11/Object.h /usr/include/X11/RectObj.h
text.o: /usr/include/X11/Shell.h /usr/include/X11/StringDefs.h
text.o: /usr/include/X11/Xaw/Box.h /usr/include/X11/Xmu/Converters.h
text.o: /usr/include/X11/Xaw/Command.h /usr/include/X11/Xaw/Label.h
text.o: /usr/include/X11/Xaw/Simple.h /usr/include/X11/Xaw/AsciiText.h
text.o: /usr/include/X11/Xaw/Text.h /usr/include/X11/Xaw/TextSink.h
text.o: /usr/include/X11/Xaw/TextSrc.h /usr/include/X11/Xaw/AsciiSrc.h
text.o: /usr/include/X11/Xaw/AsciiSink.h metaconst.h metawin.h graphics.h
