SHELL = /bin/sh

# SCIDIR must be bound to your running Scilab directory 
# SCIDIR1 also for msvc Makfile 

SCIDIR=../..
SCIDIR1=..\..

include  $(SCIDIR)/Makefile.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = utillib
NAM = util

MACROS = f.sci g.sci 

include  $(SCIDIR)/macros/Make.lib

tests	:: all

