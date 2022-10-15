#!/bin/sh
SCI="SCILAB_DIRECTORY"
export SCI
MANPATH=$SCI/man/Man-Part1:$SCI/man/Man-Part2
export MANPATH
man "$@"
