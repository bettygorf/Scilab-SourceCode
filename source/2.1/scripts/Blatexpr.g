#!/bin/csh 
#-------------------------------------------------------------------
# Usage : Blatex xs ys filename.ps
# xs ys are the scaling factor 
# filename.ps is a file from Scilab or Neoclo
# 
# This script creates a tex file which include this ps file 
# in a LaTeX style, the ps file is modified
#--------------------------------------------------------------------
set SCI="SCILAB_DIRECTORY"
set IMP=$SCI/imp/NperiPos.ps
set base=$3:r
set base=$base:r
if ( $#argv != 3) then 
	echo "Usage : Blatexpr xscale yscale filename.ps" 
	echo "  example : Blatexpr 1.0 1.0 filename.ps "
else 
	echo "%\!PS-Adobe-2.0 EPSF-2.0" >! /tmp/Missile$$
	echo "%%BoundingBox: 0 0 300 212" >> /tmp/Missile$$
	cat $IMP  $3 | grep -v "%\!PS-ADOBE" >> $base.epsf
	set wide=`echo " 300  $1 * p"|dc `
	set high=`echo " 212  $2 * p"|dc `
	set widecm=`echo "$wide 2.835 / p"|dc`
	set highcm=`echo "$high 2.835 / p"|dc`
	set hscale=`echo "$1 100 * p"|dc`
	set vscale=`echo "$2 100 * p"|dc`
	cat <<END >! $base.tex
	\long\def\Checksifdef#1#2#3{%
	   \expandafter\ifx\csname #1\endcsname\relax#2\else#3\fi}
	\Checksifdef{Figdir}{\gdef\Figdir{}}{}
	\def\dessin#1#2{
	\begin{figure}[hbtp]
	\begin{center}
	%If you prefer cm use the followin two lines
	%\setlength{\unitlength}{1mm}
	%\fbox{\begin{picture}($widecm,$highcm)
	\fbox{\begin{picture}($wide,$high)
	\special{psfile=\Figdir $base.epsf hscale=$hscale vscale=$vscale}
	\end{picture}}
	\end{center}
	\caption{\label{#2}#1}
	\end{figure}}
END
	endif
endif
\rm -f /tmp/Missile$$


