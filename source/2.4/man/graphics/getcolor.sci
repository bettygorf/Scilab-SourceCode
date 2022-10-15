.TH getcolor 2 "April 1993" "Scilab Group" "Scilab Function"
.so ../sci.an
.SH NAME
getcolor - dialog to select  color(s) in the current colormap
.SH CALLING SEQUENCE
.nf
c=getcolor(title [,cini])
c=getcolor()
.fi
.SH PARAMETERS
.TP 10
title
: string, dialog title
.TP 15
cini
: vector of initial color indexes. Default value is xget('pattern')
.TP
c
: Vector of selected color indexes, or [] if user has clicked on "Cancel" button
.SH DESCRIPTION
\fVgetcolor\fR opens a dialog choice box with as many palettes as \fVcini\fR vector size. Palettes depends on the current colormap.
.SH SEE ALSO
xset, xsetm
