clear;lines(0);
// create a script file
write(TMPDIR+'/myscript','a=1;b=2')
// execute it
exec(TMPDIR+'/myscript')
who

//create a function
deff('y=foo(x)','a=x+1;y=a^2')
clear a b
//execute the function
foo(1)
// a is a variable created in the environment of the function foo
//    it is destroyed when foo returns
who 

x=1 //create x to make it known by the script foo
exec(foo)
// a and y are created in the current environment
who
