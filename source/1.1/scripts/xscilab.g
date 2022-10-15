#!/bin/sh
SCI="SCILAB_DIRECTORY"
export SCI
PATH=$PATH:$SCI:$SCI/util
export PATH
XAPPLRESDIR=$SCI/X11_defaults
export XAPPLRESDIR
$SCI/bin/xterm  $* -T Scilab-1.1 -n Scilab-1.1 -e $SCI/bin/scilab 2>/dev/null &
