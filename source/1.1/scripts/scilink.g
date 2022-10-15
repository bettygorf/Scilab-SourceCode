#!/bin/sh 
# This scrit is used to produce a local scilex 
# usage scilink args 
# where args is the list of object files or library files that you want to add 
# to produce a new scilex
# If in the list of object files  some names are known scilex names 
# ( form routines/default ) then the scilex default files 
#  are omited and replaced with the given ones 
# Ex : scilink C/interf.o C/evol.o 
# will create a new scilex with routines/default/interf.o replaced by 
#      C/interf.o

SCI="SCILAB_DIRECTORY"
export SCI
LOCALPOS=`pwd`
cd $SCI
make bin/scilex -n > /tmp/SciLink$$
tail -2 /tmp/SciLink$$ > /tmp/SciLink$$1
sed -e "s+routines/default+\$SD+g"  -e "s+libs+\$SL+g" /tmp/SciLink$$1 > /tmp/SciLink$$2
for i in $*
do
  x=`basename $i`
  sed "s+\$SD/$x++g" /tmp/SciLink$$2 > /tmp/SciLink$$3
  rm -f /tmp/SciLink$$2
  mv /tmp/SciLink$$3 /tmp/SciLink$$2
done
echo "#!/bin/sh" > /tmp/SciLink$$3
echo "SCI=SCILAB_DIRECTORY" >>  /tmp/SciLink$$3
echo "SD=\$SCI/routines/default" >>  /tmp/SciLink$$3
echo "SL=\$SCI/libs" >>  /tmp/SciLink$$3
echo "LOCAL=\"$*\"" >>  /tmp/SciLink$$3
sed -e "s+\$SL+ \$LOCAL \$SL+" -e "s+bin/scilex+scilex+" /tmp/SciLink$$2 >> /tmp/SciLink$$3
cd $LOCALPOS
mv /tmp/SciLink$$3 Script
chmod +x Script 
echo "Linking a new Scilab with " $*
./Script 
echo "I've created : scilex and xscilab which uses that scilex"
sed -e "s+\$SCI/bin/scilex+`pwd`/scilex+" $SCI/bin/xscilab > xscilab 
chmod +x xscilab 
rm -f /tmp/SciLink*

