#!/bin/csh 
#-------------------------------------------------------------------
# Usage : Blatex [-orientation] xs ys filename.ps 
# xs ys are the scaling factor 
# orientation is p[ortrait] or l[andscape]
# filename.ps is a file from Scilab or Neoclo
# 
# This script creates a tex file which include this ps file 
# in a LaTeX style, the ps file is modified
#--------------------------------------------------------------------
if ($?SCI == 0) then 
  setenv SCI "SCILAB_DIRECTORY"	
endif
set IMP=$SCI/imp/NperiPos.ps
switch ($#argv)
case 3: 
  set orientation=-p
  set xs=$1
  set ys=$2
  set orig=$3
  breaksw
case 4: 
  set orientation=$1
  set xs=$2
  set ys=$3
  set orig=$4
  breaksw
default:
  echo "Usage : Blatexpr [-orientation] xscale yscale filename.ps" 
  echo "example : Blatexpr 1.0 1.0 filename.ps "
  exit 1
endsw

switch ($orientation)
case -l: 
case -p:
  breaksw
case -landscape: 
  set orientation=-l
  breaksw
case -portrait
  set orientation=-p
  breaksw
default:
  echo "Usage : Blatexpr -l[andscape] xscale yscale filename.ps" 
  echo "Usage : Blatexpr -p[ortrait] xscale yscale filename.ps" 
  exit 1
endsw

set base=$orig:r
#set base=$base:r
if ( $orig == $base.epsf ) then 
	mv $orig $base.ps 
	set orig=$base.ps
endif 


switch ($orientation)
case -p: 
  echo "%\!PS-Adobe-2.0 EPSF-2.0" >! $base.epsf 
  echo "%%BoundingBox: 0 0 300 212" >> $base.epsf
  cat $IMP  $orig | grep -v "%\!PS-ADOBE" >> $base.epsf
  set wide=`echo " 300  $xs * p"|dc `
  set high=`echo " 212  $ys * p"|dc `
  breaksw
case -l: 
  echo "%\!PS-Adobe-2.0 EPSF-2.0" >! $base.epsf
  echo "%%BoundingBox: 0 0 212 300" >> $base.epsf
  cat $IMP  $orig | grep -v "%\!PS-ADOBE" >> $base.epsf
  sed -e "s/\[0.5 10 div 0 0 0.5 10 div neg  0 2120 10 div\] concat/90 rotate 10 640 neg translate [0.5 10 div 0 0 0.5 10 div neg  0 3120 5 div] concat/" $base.epsf > $base.epsf.$$
  \rm -f $base.epsf
  mv $base.epsf.$$ $base.epsf
  set wide=`echo " 240  $xs * p"|dc `
  set high=`echo " 300  $ys * p"|dc `
breaksw
endsw

set widecm=`echo "$wide 2.835 / p"|dc`
set highcm=`echo "$high 2.835 / p"|dc`
set hscale=`echo "$xs 100 * p"|dc`
set vscale=`echo "$ys 100 * p"|dc`
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
rm -f $orig
