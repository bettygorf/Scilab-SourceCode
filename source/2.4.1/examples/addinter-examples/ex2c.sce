// Copyright INRIA

// Example with optional argument specified with the 
// arg=value syntax
// [a,b,c] = funcf1(x1,{ v1= arg1, v2=arg2}) , arg1 default value 99
//					       arg2 default value 3
// only v1 and v2 are recognized as optional argument names 
// the return value are a<--x1, b = 2*v2 , c = 3*v2 
//

files=G_make(['/tmp/ex2cI.o','/tmp/ex2c.o'],'ex2c.dll');
addinter(strcat(files,' '),'testcentry',['funcf1']);

[a,b,c]=funcf1('test');

if norm([99*2,3*3]-[b,c]) > %eps then pause,end

[a,b,c]=funcf1('test',v1=[10,20]);

if norm([[10,20]*2,3*3]-[b,c]) > %eps then pause,end

[a,b,c]=funcf1('test',v1=[10,20],v2=8);

if norm([[10,20]*2,8*3]-[b,c]) > %eps then pause,end

[a,b,c]=funcf1('test',v2=8,v1=[10]);

if norm([10*2,8*3]-[b,c]) > %eps then pause,end







