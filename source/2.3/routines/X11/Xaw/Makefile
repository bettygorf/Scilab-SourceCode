SHELL = /bin/sh

SCIDIR=../../..
include ../../../Makefile.incl

CFLAGS = $(CC_OPTIONS) $(XFLAGS)

FFLAGS = $(FC_OPTIONS)

LIBRARY = $(SCIDIR)/libs/libXaw.a

OBJSC = AllWidgets.o \
	AsciiSink.o \
	AsciiSrc.o \
	AsciiText.o \
	Box.o \
	Clock.o \
	Command.o \
	Dialog.o \
	Form.o \
	Grip.o \
	Label.o \
	List.o \
	Logo.o \
	Mailbox.o \
	MenuButton.o \
	Paned.o \
	Panner.o \
	Porthole.o \
	Repeater.o \
	Scrollbar.o \
	Simple.o \
	SimpleMenu.o \
	Sme.o \
	SmeBSB.o \
	SmeLine.o \
	StripChart.o \
	Text.o \
	TextSink.o \
	TextSrc.o \
        TextAction.o \
	TextPop.o \
	TextTr.o \
	Toggle.o \
	Tree.o \
	Vendor.o \
	Viewport.o \
	XawInit.o

OBJSF =

OBJS = $(OBJSC) $(OBJSF)

all:: $(LIBRARY)

$(LIBRARY): $(OBJS)
	@echo Creation of $(LIBRARY)
	@$(RM) $@
	@$(AR) $@ $(OBJS)
	@$(RANLIB) $@

clean::
	$(RM) $(OBJS)
distclean::
	$(RM) $(OBJS) $(LIBRARY)
