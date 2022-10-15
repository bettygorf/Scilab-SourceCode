clear;lines(0);
file3='test3.bin'
fd1= mopen(file3,'wb');
for i=1:10, mput(i,'d'); end 
mseek(0);
mput(678,'d');
mseek(0,fd1,'end');
mput(932,'d');
mclose(fd1)
fd1= mopen(file3,'rb');
res=mget(11,'d')
res1=[1:11]; res1(1)=678;res1($)=932;
if res1<>res ;write(%io(2),'Bug');end;
mseek(0,fd1,'set');
// trying to read more than stored data 
res1=mget(100,'d',fd1);
if res1<>res ;write(%io(2),'Bug');end;
meof(fd1)
mclearerr(fd1)
mclose(fd1);
