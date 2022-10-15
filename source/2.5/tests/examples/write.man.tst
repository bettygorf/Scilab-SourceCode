clear;lines(0);
if MSDOS then unix('del asave');
else unix('rm -f asave'); end
A=rand(5,3); write('asave',A); A=read('asave',5,3);
write(%io(2),A,'('' | '',3(f10.3,'' | ''))')
write(%io(2),string(1:10))
write(%io(2),strcat(string(1:10),','))
write(%io(2),1:10,'(10(i2,3x))')

if MSDOS then unix('del foo');
else unix('rm -f foo'); end
write('foo',A)
