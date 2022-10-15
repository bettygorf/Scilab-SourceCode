
SHELL = /bin/sh

SCIDIR=../
include ../Makefile.incl

all	:: info 


info	:
	@echo "Type \"make tests\" in examples directory"
	@echo "  to test link and addinter features"

SUBDIRS = addinter-examples intersci-examples link-examples \
	misc-examples man-examples macros-examples mex-examples addinter-lapack \
	mex-examples


distclean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making distclean in examples/$$i..."; \
		$(MAKE) $(MFLAGS)  distclean); \
	done

clean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making clean in examples/$$i..."; \
		$(MAKE) $(MFLAGS) clean); \
	done

TEST_SUBDIRS = addinter-examples intersci-examples link-examples \
	misc-examples man-examples macros-examples mex-examples addinter-lapack \
	mex-examples

tests::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(TEST_SUBDIRS) ;\
	do \
		(cd $$i ; echo "making tests in examples/$$i..."; \
		$(MAKE) $(MFLAGS)  distclean; \
		$(MAKE) $(MFLAGS)  tests); \
	done
