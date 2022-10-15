#!/bin/sh
SCI="SCILAB_DIRECTORY"
export SCI
MANPATH=$SCI/man/Man-Part1:$SCI/man/Man-Part2
export MANPATH
x="Xman*manualFontNormal:-misc-fixed-medium-r-normal--*-130-*-*-c-*-iso8859-1"
y="Xman*manualFontBold:-adobe-times-bold-r-normal--*-100-*-*-p-*-iso8859-1"
z="Xman*manualFontItalic:-adobe-times-medium-i-normal--*-100-*-*-p-*-iso8859-1"
xman -xrm $x -xrm $y -xrm $z -bothshown -notopbox 2>/dev/null &
#xman  -bothshown -notopbox 2>/dev/null &
