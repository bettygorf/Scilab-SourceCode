SHELL = /bin/sh

include ../Path.incl
include ../Makefile.incl

CFLAGS = $(CC_OPTIONS) 

SUBDIRS = algebre arma auto calpol comm \
	elem metanet optim percent robust sci2for \
	signal tdcs util xdess scicos scicos_blocks sound fraclab \
	m2sci mtlb

all:: Progs 
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making all in macros/$$i..."; \
		$(MAKE) $(MFLAGS) all); \
	done

world: all

release : Progs
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making all in macros/$$i..."; \
		$(MAKE) $(MFLAGS) release ); \
	done

distclean::
	$(RM) Lib Name

distclean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making distclean in macros/$$i..."; \
		$(MAKE) $(MFLAGS)  distclean); \
	done

clean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making clean in macros/$$i..."; \
		$(MAKE) $(MFLAGS) clean); \
	done

Progs : Lib Name 

Lib:  Lib.c 
	$(RM) $@
	$(CC) $(CFLAGS) -o $@ $?  $(CC_LDFLAGS) 

Name:  Name.c 
	$(RM) $@
	$(CC) $(CFLAGS) -o $@ $?  $(CC_LDFLAGS) 



