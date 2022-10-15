SHELL = /bin/sh

include ../Makefile.incl

SUBDIRS = algebre arma auto calpol \
	elem metanet optim percent robust sci2for \
	signal tdcs util xdess scicos

all::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making all in macros/$$i..."; \
		$(MAKE) $(MFLAGS) all); \
	done

world: all

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
