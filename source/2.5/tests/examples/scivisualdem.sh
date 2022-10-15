#!/bin/sh 
# scilab batch execution for testing 
# scidem scidir fn fileres  flag

# Copyright INRIA
echo ------------------- File $2--------------------
SCI1=$1
if [ -f $3  ]; then rm $3;fi;
trap "rm -f /tmp/$2.$$ /tmp/$2.$$.res /tmp/$2.$$.err /tmp/$2.$$.diff\
        ;exit 1"  1 2 13 15
echo "metanet_sync(1);diary('$3');" >> /tmp/$2.$$ ;
cat $2 >> /tmp/$2.$$ ;
echo "if x_message('Ok?',['Yes','No'])<>1 then write(%io(2),'error on test'),end;diary(0);exit;" >> /tmp/$2.$$ ;
($SCI1/bin/scilab -nw < /tmp/$2.$$ > /tmp/$2.$$.res ) 2> /tmp/$2.$$.err ;
cat $3
sed -e "s/ \./0\./g" -e "s/E+/D+/g" -e "s/E-/D-/g" -e "s/-\./-0\./g" \
       -e "s/^-->//g" -e "s/^-1->//g" $3 > $3.n
grep -v "diary(" $3.n > $3
rm -f $3.n
if ( grep error /tmp/$2.$$.res >  /dev/null ) ; then 
        if [ $# != 4 ]; then 
                echo "Test failed ERROR DETECTED  while executing $2" ;
        else if (grep "$4" /tmp/$2.$$.res >  /dev/null ) ; 
             then  echo Test skipped ;
             else echo "Test failed ERROR DETECTED  while executing $2" ;
             fi;
        fi;
else if [ -f $3.ref ];then 
        if ( diff -w $3 $3.ref > /tmp/$2.$$.diff ) ;
        then  echo Test passed ;
        else  echo Test Failed SEE : diff -w  $3 $3.ref ;
        fi;
      fi;
fi;
echo ---------------------------------------------------------- 
#rm -f /tmp/$2.$$ /tmp/$2.$$.res /tmp/$2.$$.err /tmp/$2.$$.diff
exit 0
