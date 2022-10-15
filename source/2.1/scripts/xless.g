#!/bin/sh
SCI="SCILAB_DIRECTORY"
XAPPLRESDIR=$SCI/X11_defaults
export XAPPLRESDIR
XLESSHELPFILE=$SCI/X11_defaults/xless.help
export XLESSHELPFILE
$SCI/bin/Xless $*
