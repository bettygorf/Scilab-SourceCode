#!/bin/sh 
if test "$SCI" = ""; then
  SCI="SCILAB_DIRECTORY"
fi
export SCI
$SCI/util/Slatdocs $*
