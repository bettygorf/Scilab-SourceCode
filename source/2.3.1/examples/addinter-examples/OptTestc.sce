// Example with optional argument specified with the 
// arg=value syntax
// [a,b,c] = funcf1(x1,{ v1= arg1, v2=arg2}) , arg1 default value 99
//					       arg2 default value 3
// only v1 and v2 are recognized as optional argument names 
// the return value are a<--x1, b = 2*v2 , c = 3*v2 
//


host("make /tmp/OptTestc.o");  //Interface
host("make /tmp/opttest.o");  //Called routines

scifuncs=['funcf1'];  //Scilab functions

addinter(['/tmp/OptTestc.o','/tmp/opttest.o'],'testfentry',scifuncs)

[a,b,c]=funcf1('test')

[a,b,c]=funcf1('test',v1=[10,20])

[a,b,c]=funcf1('test',v1=[10,20],v2=8)

[a,b,c]=funcf1('test',v2=8,v1=[10])







