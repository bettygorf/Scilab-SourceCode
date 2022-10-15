host('make /tmp/Examplc.o');
host('make /tmp/foubare2c.o');
addinter(['/tmp/Examplc.o','/tmp/foubare2c.o'],'foobar','foubare');
a=1:10;b=a+1;c=ones(2,3)+2;
[x,y,z,t]=foubare('mul',a,b,c)
[x,y,z,t]=foubare('add',a,b,c)




