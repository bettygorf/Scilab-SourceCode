host('make /tmp/Examplf.o');
host('make /tmp/foubare2f.o');
addinter(['/tmp/Examplf.o','/tmp/foubare2f.o'],'foobar','foubare');
a=1:10;b=a+1;c=ones(2,3)+2;
[x,y,z,t]=foubare('mul',a,b,c)
[x,y,z,t]=foubare('add',a,b,c)




