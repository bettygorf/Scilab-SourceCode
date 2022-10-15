#!/bin/sh
SCI=../..
checkafile()
{
    $SCI/util/scidem $SCI $1.tst $1.dia
}
checkfiles()
{
	while [ $# -gt 0 ]
	do
	file=`echo $1|sed -e 's/\.tst$//'`
	newest=`ls -t -1 $1 $file.dia 2>/dev/null |sed -n -e '1p'`
	if [ "$newest" = "$1" ]; then
		checkafile $file
	fi
	shift
	done
}
tfiles=`ls *.tst`

checkfiles $tfiles
