#!/bin/sh
#script to compile mexfiles. To be used by Makemex

cproc()
{
 firstc=`echo $1`
}
mproc()
{
 firstn=`echo $1`
}

MEXSOURCES=$1
MEXNAMES=$2
COMPILE=`echo $3`

while [ "$MEXSOURCES" != "" ]
do
    cproc $MEXSOURCES
    MEXSOURCES=`echo $MEXSOURCES | sed -e "s/$firstc//"`
	MEXSOURCES=`echo $MEXSOURCES | sed -e "s/$$obj.c//"` ; \
    mproc $MEXNAMES
    MEXNAMES=`echo $MEXNAMES | sed -e "s/$firstn//"`
    echo " Compiling $firstc (function $firstn)"
    echo " --------------------------------------------"
    $COMPILE -DmexFunction=mex_$firstn  -c $firstc
done
