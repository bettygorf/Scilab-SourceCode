# version for VC++

RM = rm -f
AR = ar cq
FILES_TO_CLEAN = *.CKP *.ln *.BAK *.bak core errs ,* *~ *.a .emacs_* tags TAGS make.log MakeOut .*~ *.trace 

all::

clean::
	$(RM) $(FILES_TO_CLEAN)
distclean::
	$(RM) $(FILES_TO_CLEAN)

RANLIB = ranlib

TERMCAPLIB = 

##################################################################
# NOTE: the following schemes for compiling and linking are not  #
#       exactly used for the main executable scilex; for it, see #
#       the files Makefile.<host>                                #
##################################################################
SHELL= /bin/sh.exe
MAKE=nmake /f Makefile.mak
############
# C compiler
# typically, for compiling use: CFLAGS = $(CC_OPTIONS)
# and for linking: $(CC) -o $(PROGRAM) $(OBJS) $(CC_LDFLAGS)
###########
# CC = 
CC=cl
LINKER=link
#GUIFLAGS=-SUBSYSTEM:windows
GUIFLAGS=-SUBSYSTEM:console
GUILIBS=-DEFAULTLIB:comctl32.lib wsock32.lib shell32.lib winspool.lib user32.lib gdi32.lib comdlg32.lib 
RC=rc
RCVARS=-r -DWIN32
# debug 
#CC_OPTIONS = -D__MSC__ -DWIN32 -c -DSTRICT -nologo -Z7 -W3 -Od -I../f2c
# optimize 
CC_OPTIONS = -D__MSC__ -DWIN32 -c -DSTRICT -nologo -O2 -I../f2c
# -G3 -Ow -W3 -Zp -Tp
CC_LDFLAGS = 

XLIBS= $(GUILIBS) libc.lib

.c.obj	:
	$(CC) $(CFLAGS) $< 


