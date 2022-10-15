SHELL = /bin/sh

include ../Makefile.incl

SCIDIRS = X11G calelm comm control default integ interf intersci lapack \
	metanet optim poly signal sparse sun system system2 xsci xwindow \
	scicos

SUBDIRS = $(XAW_LOCAL_SUBDIR) $(DLD_SUBDIR) $(SCIDIRS)

all::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making all in routines/$$i..."; \
		$(MAKE) $(MFLAGS) all); \
	done

world::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making world in routines/$$i..."; \
		$(MAKE) $(MFLAGS) world); \
	done

distclean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making distclean in routines/$$i..."; \
		$(MAKE) $(MFLAGS)  distclean); \
	done

clean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making clean in routines/$$i..."; \
		$(MAKE) $(MFLAGS) clean); \
	done
