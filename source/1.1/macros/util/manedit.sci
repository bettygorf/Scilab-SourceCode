function []=manedit(manitem,editor)
// manitem : character string giving a manitem 
//
[lhs,rhs]=argn(0)
if rhs<=1, editor ="lemacs -w =80x50  ";end
fname='fname=`ls $SCI/man/*/man*/'+manitem+'.[0-9ln] 2>/dev/null `;';
unixstr=fname+"if [ $fname ] ; then "+editor+" $fname;else echo No man ; fi";
unix(unixstr)
//end







