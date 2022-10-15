#!/bin/csh 
#-------------------------------------------------------------------
# Usage : BEpsf [-orientation] filename.ps 
# filename.ps is a file from Scilab
# orientation is p[ortrait] or l[andscape]
# produces a filename.eps which can be printed or inserted in an other
# Postscript document 
#--------------------------------------------------------------------
if ($?SCI == 0) then 
  setenv SCI "SCILAB_DIRECTORY"	
endif
set IMP=$SCI/imp/NperiPos.ps
switch ($#argv)
case 1: 
  set orientation=-p
  set FILE=$1
  breaksw
case 2: 
  set orientation=$1
  set FILE=$2
  breaksw
default:
  echo "Usage : `basename $0` [-orientation] filename.ps" 
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
  echo "Usage : `basename $0` -l[andscape] filename.ps" 
  echo "Usage : `basename $0` -p[ortrait] filename.ps" 
  exit 1
endsw


set base=$FILE:r
set base=$base:r

if ( `grep "PS-Adobe-2.0" $FILE | wc -l` != 0) then 
	echo "This file doesn't need to be processed through `basename $0`"
	exit
endif
if ( $base.eps == $FILE) then 
	echo Warning : Renaming your original file $FILE:r.ps since I create a $FILE:r.eps file
	mv $FILE $FILE:r.ps
	set FILE=$FILE:r.ps
endif
if ( -f $base.eps ) then 
	echo File $base.eps exists, moving it to $base.eps.bak
	mv $base.eps $base.eps.bak 
endif 
#echo $base $orientation
switch ($orientation)
case -p: 
  echo "%\!PS-Adobe-2.0 EPSF-2.0" >! $base.eps
  echo "%%BoundingBox: 0 200 600 624" >> $base.eps
  cat $IMP  $FILE | grep -v "%\!PS-ADOBE" >> $base.eps
  sed -e "s/\[0.5 10 div 0 0 0.5 10 div neg  0 2120 10 div\] concat/[0.5 5 div 0 0 0.5 5 div neg  0 3120 5 div] concat/" $base.eps > $base.eps.$$
  \rm -f $base.eps
  mv $base.eps.$$ $base.eps
  breaksw
case -l: 
  echo "%\!PS-Adobe-2.0 EPSF-2.0" >! $base.eps
  echo "%%BoundingBox: 0 0 600 780" >> $base.eps
  cat $IMP  $FILE | grep -v "%\!PS-ADOBE" >> $base.eps
  echo "1.3 1.3  scale" >> $base.eps
  sed -e "s/\[0.5 10 div 0 0 0.5 10 div neg  0 2120 10 div\] concat/90 rotate 10 640 neg translate [0.5 5 div 0 0 0.5 5 div neg  0 3120 5 div] concat/" $base.eps > $base.eps.$$
  \rm -f $base.eps
  mv $base.eps.$$ $base.eps
  breaksw
endsw
\rm -f $FILE


