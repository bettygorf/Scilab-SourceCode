// Copyright INRIA

files=G_make(['/tmp/ex1cI.o','/tmp/ex1c.o'],'ex1c.dll');
addinter(strcat(files,' '),'cfoobar','foubare');

a=1:10;b=a+1;c=ones(2,3)+2;

[x,y,z,t]=foubare('mul',a,b,c);

// Check the result 
if norm(t-(a*2)) > %eps then pause,end
if norm(z-(b*2) ) > %eps then pause,end
if norm(y-(c*2)) > %eps then pause,end
deff('[y]=f(i,j)','y=i+j');
if norm(x- ( y.* feval(0:1,0:2,f))) > %eps then pause,end

[x,y,z,t]=foubare('add',a,b,c);

// Check the result 
if norm(t-(a+2)) > %eps then pause,end
if norm(z-(b+2) ) > %eps then pause,end
if norm(y-(c+2)) > %eps then pause,end
deff('[y]=f(i,j)','y=i+j');
if norm(x- ( c +2 + feval(0:1,0:2,f))) > %eps then pause,end



