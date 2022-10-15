#!/bin/sh
#-------------------------
# prints the PARAMETERS field of the man of the argument $1
# $1 can be ust a part of the name of the man file because 
# scilab truncate names to 8 chararters 
# this function is used in print.f
#-------------------------
SCI="SCILAB_DIRECTORY"
export SCI
echo Compiled macro
ll=`echo $1 | wc -c`
# the macro name given by Scilab can be shorter than it's real name in man
# because Scilab names are truncated up to 8 chars.
if [ $ll -lt 9 ] ; then 
	x=`ls -r $SCI/man/*/man*/$1.[0-9ln] 2>/dev/null `
else
	x=`ls -r $SCI/man/*/man*/$1*.[0-9ln] 2>/dev/null `
	x=`echo $x | awk '{ print  $1 }'  `
fi
if [ $x ]; then 
	y=$x
	for z in  1 2 3 4 5 6 7 8 9 n l 
	do 
		y=`basename $y .$z`
	done
	if [ -f $x ] ; then 
	$SCI/bin/scihelp $y 2> /dev/null | awk ' /NAME/, /DESCRIPTION/ '  | grep -v DESCRIPTION
	fi 
fi

