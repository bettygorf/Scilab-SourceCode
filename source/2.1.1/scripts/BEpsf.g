#!/bin/csh 
#-------------------------------------------------------------------
# Usage : BEpsf filename.ps
# filename.ps is a file from Scilab
# produces a filename.eps which can be printed or inserted in an other
# Postscript document 
#--------------------------------------------------------------------
set SCI="SCILAB_DIRECTORY"
set IMP=$SCI/imp/NperiPos.ps
set base=$1:r
set base=$base:r
set FILE=$1
if ( `grep "PS-Adobe-2.0" $1 | wc -l` != 0) then 
	echo "This file doesn't need to be processed through `basename $0`"
	exit
endif
if ( $base.eps == $1) then 
	echo Warning : Renaming your original file $1:r.ps since I create a $1:r.eps file
	mv $1 $1:r.ps
	set FILE=$1:r.ps
endif
if ( -f $base.eps ) then 
	echo File $base.eps exists, moving it to $base.eps.bak
	mv $base.eps $base.eps.bak 
endif 
if ( $#argv != 1) then 
	echo "Usage : `basename $0` filename.ps" 
else 
	echo "%\!PS-Adobe-2.0 EPSF-2.0" >! $base.eps
	echo "%%BoundingBox: 0 200 600 624" >> $base.eps
	cat $IMP  $FILE | grep -v "%\!PS-ADOBE" >> $base.eps
	sed -e "s/\[0.5 10 div 0 0 0.5 10 div neg  0 2120 10 div\] concat/[0.5 5 div 0 0 0.5 5 div neg  0 3120 5 div] concat/" $base.eps > $base.eps.$$
	\rm -f $base.eps
	mv $base.eps.$$ $base.eps
endif



