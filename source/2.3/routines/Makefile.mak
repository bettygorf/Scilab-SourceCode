SHELL = /bin/sh

include ../Makefile.incl.mak

SCIDIRS = graphics calelm comm control default integ interf intersci lapack \
	libcomm metanet optim poly signal sparse sun system system2  \
	menusX scicos sound wsci xdr 

SUBDIRS = $(XAW_LOCAL_SUBDIR) $(DLD_SUBDIR) $(SCIDIRS)


all::
	Makesubdirs.bat


