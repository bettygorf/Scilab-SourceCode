#!/bin/sh
SCI=../..
checkafile()
{
    ./scivisualdem.sh $SCI $1.vtst $1.dia
}
checkfiles()
{
	while [ $# -gt 0 ]
	do
	file=`echo $1|sed -e 's/\.vtst$//`
	newest=`ls -t -1 $1 $file.dia 2>/dev/null |sed -n -e '1p'`
	if [ "$newest" = "$1" ]; then
		checkafile $file
	fi
	shift
	done
}
tfiles=`ls *.vtst`

checkfiles $tfiles
