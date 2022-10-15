SHELL = /bin/sh

SCIDIR=../..
include ../../Version.incl
include ../../Makefile.incl

CFLAGS = $(CC_OPTIONS) $(XFLAGS)

FFLAGS = $(FC_OPTIONS)

LIBRARY = $(SCIDIR)/libs/xsci.a

OBJSC = wf_w_dir.o wf_w_file.o wf_w_util.o wf_w_cursor.o \
	wf_f_util.o wf_f_read.o \
	wf_w_msgpanel.o wf_w_setup.o wf_e_edit.o wf_w_init.o \
	jpc_windows.o jpc_command.o  jpc_utils.o jpc_inter.o   \
	x_button.o x_charproc.o x_cursor.o \
	x_data.o x_input.o \
	x_main.o x_menu.o x_misc.o x_screen.o \
	x_scrollbar.o x_tabs.o \
	x_util.o x_VTPrsTbl.o x_zzledt.o \
	h_help.o

all:: $(LIBRARY)

world: help-headers all

$(LIBRARY): $(OBJSC)
	@echo Creation of $(LIBRARY)
	@$(RM) $@
	@$(AR) $@ $(OBJSC)
	@$(RANLIB) $@

clean::
	$(RM) $(OBJSC)
	cd help; $(MAKE) $(MFLAGS) clean

distclean:: clean
	$(RM) $(OBJSC) $(LIBRARY)
	cd help; $(MAKE) $(MFLAGS) distclean

XSCILAB_DEFAULT = $(SCIDIR)/X11_defaults/Xscilab

all:: $(XSCILAB_DEFAULT)

Xscilab.ad.h: Xscilab.ad
	./ad2c.script Xscilab.ad > Xscilab.ad.h

$(XSCILAB_DEFAULT): Xscilab.ad
	$(RM) $(XSCILAB_DEFAULT)
	$(INSTALL) -m 644 Xscilab.ad $(XSCILAB_DEFAULT)

help-headers:
	cd help; $(MAKE) $(MFLAGS) all

distclean::
	$(RM) $(XSCILAB_DEFAULT)

version.h: version.g $(SCIDIR)/Version.incl
	@$(RM) version.h
	@sed -e "s+SCILAB_VERSION+$(SCIVERSION)+" \
	-e "s+SCILAB_DATE+$(SCIDATE)+" version.g > version.h;
	@chmod g+w version.h
	@echo version.h created

OBJTEST = x_test_loop.o

# $(SCIDIR)/libs/xgc.a 

test: $(OBJTEST) ../sun/zzledt.o ../sun/sync.o ../sun/flags.o $(OBJSC)
	cd ../X11G; make ;cd ../xsci
	$(RM) $@
	$(CC) -g -o $@ $(OBJTEST) ../sun/zzledt.o ../sun/sync.o ../sun/flags.o \
	$(OBJSC) $(SCIDIR)/libs/X11G.a $(SCIDIR)/libs/xwindow.a \
	$(CC_LDFLAGS) $(XLIBS) $(TERMCAPLIB) -lm

clean::
	$(RM) $(OBJTEST)
distclean::
	$(RM) $(OBJTEST) test

OBJWFTEST = wf_xcommand.o

wf_test: $(OBJWFTEST) $(OBJS)
	$(RM) $@
	$(CC) -o $@ $(OBJWFTEST) $(OBJS) $(CC_LDFLAGS) $(XLIBS) -lm

clean::
	$(RM) $(OBJWFTEST)
distclean::
	$(RM) $(OBJWFTEST) wf_test

h_main_help.o: Xscilab.ad.h

help_test: h_main_help.o h_help.o
	$(RM) $@
	$(CC) -o $@ h_main_help.o h_help.o $(CC_LDFLAGS) $(XLIBS) -lm

clean::
	$(RM) h_main_help.o
distclean::
	$(RM) h_main_help.o help_test

wf_w_dir.o: wf_w_util.h wf_fig.h wf_figx.h wf_resources.h wf_mode.h \
	wf_w_dir.h wf_w_setup.h wf_w_drawprim.h
wf_w_file.o: wf_fig.h wf_figx.h wf_resources.h wf_mode.h wf_w_drawprim.h \
	wf_w_dir.h wf_w_util.h wf_w_setup.h
wf_w_util.o: wf_fig.h wf_figx.h wf_resources.h wf_w_drawprim.h wf_w_util.h \
	wf_w_setup.h
wf_w_cursor.o: wf_fig.h wf_figx.h wf_resources.h
wf_f_util.o: wf_fig.h wf_resources.h wf_mode.h wf_w_util.h
wf_f_read.o: wf_fig.h wf_figx.h wf_resources.h wf_mode.h wf_w_setup.h \
	wf_w_util.h
wf_w_msgpanel.o: wf_fig.h
wf_w_msgpanel.o: wf_figx.h 
wf_w_msgpanel.o: wf_resources.h wf_mode.h wf_w_util.h 
wf_w_msgpanel.o: wf_w_setup.h 
wf_w_setup.o: wf_fig.h 
wf_w_setup.o: wf_resources.h wf_w_setup.h
wf_w_setup.o: wf_w_util.h 
wf_e_edit.o: wf_fig.h wf_figx.h wf_resources.h wf_mode.h wf_w_drawprim.h \
	wf_w_util.h
wf_w_init.o: wf_fig.h wf_figx.h wf_resources.h
jpc_windows.o: x_ptyx.h x_data.h jpc_global.h jpc_defs.h x_xbas.icon.X \
	version.h
jpc_command.o: ../machine.h jpc_global.h jpc_defs.h
jpc_utils.o: jpc_global.h jpc_defs.h 
jpc_inter.o: x_ptyx.h x_data.h ../machine.h
x_button.o: x_ptyx.h x_data.h x_error.h x_menu.h
x_charproc.o: ../machine.h x_ptyx.h x_VTparse.h x_data.h x_error.h x_menu.h \
	x_main.h 
x_cursor.o: x_ptyx.h 
x_data.o: x_ptyx.h x_data.h
x_input.o: x_ptyx.h 
x_main.o: version.h ../machine.h x_ptyx.h x_data.h x_error.h x_menu.h \
	Xscilab.ad.h
x_menu.o: x_ptyx.h x_data.h x_menu.h
x_misc.o: x_ptyx.h x_data.h x_error.h x_menu.h 
x_screen.o: x_ptyx.h x_error.h x_data.h ../machine.h
x_scrollbar.o: x_ptyx.h x_data.h x_error.h x_menu.h
x_tabs.o: x_ptyx.h 
x_util.o: x_ptyx.h x_data.h x_error.h x_menu.h
x_VTPrsTbl.o: x_VTparse.h
h_help.o: help/help-list1.h help/help-list2.h help/help-list3.h \
	help/help-list4.h help/help-list5.h help/help-list6.h \
	help/help-list7.h help/help-list8.h help/help-list9.h \
	help/help-list10.h help/help-list11.h help/help-list12.h \
	help/help-text1.h help/help-text2.h help/help-text3.h \
	help/help-text4.h help/help-text5.h help/help-text6.h \
	help/help-text7.h help/help-text8.h help/help-text9.h \
	help/help-text10.h help/help-text11.h help/help-text12.h \
	version.h
