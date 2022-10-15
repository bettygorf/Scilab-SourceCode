clear;lines(0);
if MSDOS then unix('del foo');
else unix('rm -f foo'); end
A=rand(3,5); write('foo',A);
B=read('foo',3,5)
B=read('foo',-1,5)
read(%io(1),1,1,'(a)')  // waits for user's input
