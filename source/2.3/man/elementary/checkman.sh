#!/bin/sh
# usage: checkman  section1,...,sectionn
SCI=/usr/local/lib/scilab-2.3

check()
{
	while [ $# -gt 0 ]
	do
	file=`echo $1|sed -e 's/.sci/.man/'`
	manfile=`ls -t -1 $SCI/man/*/$file 2>/dev/null |sed -n -e '1p'`
	if [ "$manfile" = " " ]; then
		echo $file
	fi
	shift
	done
}

for section in $*
do
  echo checking directory: $section ...
  cd $section

  allfiles=`ls -1 *.man | awk '{print " " $1 }'` 
  check $allfiles
  cd ..
done
exit 0
 
