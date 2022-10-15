#!/bin/sh
SCI="SCILAB_DIRECTORY"
export SCI
MANPATH=$SCI/man/Man-Part1:$SCI/man/Man-Part2
export MANPATH
#man "$@"
if [ $1 = -k ] ; then grep $2 $SCI/man/Man-Part1/whatis;
grep $2  $SCI/man/Man-Part2/whatis;
else man "$@";
fi ;


