clear;lines(0);
a=eye(2,2);b=ones(a);
oldsave('TMPDIR/val.dat',a,b);
clear a
clear b
oldload('TMPDIR/val.dat','a','b');
// sequential save into a file

fd=file('open','TMPDIR/foo','unformatted','unknown')
for k=1:4, x=k^2;oldsave(fd,x,k),end
file('close',fd)
fd=file('open','TMPDIR/foo','old','unknown')
for i=1:4, oldload(fd,'x','k');x,k,end
file('close',fd)
