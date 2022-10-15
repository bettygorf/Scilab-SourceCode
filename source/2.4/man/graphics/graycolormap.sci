.TH graycolormap 1 "November 1997" "Scilab Group" "Scilab Function"
.so ../sci.an
.SH NAME
graycolormap - Linear gray colormap
.SH CALLING SEQUENCE
.nf
cmap=graycolormap(n)
.fi
.SH PARAMETERS
.TP 10
n
: an integer greater or equal than 1, the "colormap" size
.TP
cmap
: matrix with 3 column, \fV[R,G,B]\fR color definition
.SH DESCRIPTION
Computes a colormap with grays colors varying linearly
.SH SEE ALSO
colormap, xset, plot3d1, hotcolormap
.SH EXAMPLE
.nf
xset('colormap',graycolormap(32))
plot3d1() 
.fi
