#!/bin/sh
RM='rm -f'
SCI=../..
LOGFILE='get_examples.log'

$RM prov $LOGFILE  

echo '//' `date` > prov 
echo '' >> prov
echo '' >> examples.tst
do_example()
{
echo '//====================================================' >> prov
echo '//' "$1" >> prov
echo '//====================================================' >> prov

res=`grep 'SH EXAMPLE' $1 2> /dev/null`
if test -n "$res"
then
	name=`basename $1`
	out=$name.tst

	newest=`ls -t -1 $1 $out 2>/dev/null |sed -n -e '1p'`
	if [ "$newest" = "$1" ]; then
	    echo "clear;lines(0);" >> $out
	    sed -e '1,/^.SH EXAMPLE/d' $1 > prov1
	    sed -e '1d' prov1 > prov2
	    sed -e '/^.fi/,$d' -e 's/\\\\/\\/g' prov2 >> $out
	    $RM prov1 prov2
	    t=`grep -f visualpat $out`
	    if test "$t" != ""; then
		mv $out $name.vtst
	    fi
	    echo "$1" PROCESSED >> $LOGFILE
	    #echo "for k=winsid(),xdel(k);end" >> $out
	fi
else
	echo "$1" NO EXAMPLE >> $LOGFILE
fi

}

for j in arma comm control dcd elementary graphics linear metanet nonlinear polynomials programming robust scicos signal sound tdcs translation tksci
do
	echo -n "Processing man/$j "
	for f in $SCI/man/$j/*.man
	do
		echo -n '.'
		do_example $f
	done
	echo ""
done

echo ''
echo `grep PROCESSED $LOGFILE|wc -l` examples extracted from `cat  $LOGFILE|wc -l` manual files.

$RM prov
