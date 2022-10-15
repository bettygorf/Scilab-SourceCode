//foobar example
//1-Creating interface source file 
// from intfoobar.desc file by call to intersci
host('../../bin/intersci intfoobar');
host('./sedprov intfoobar');
//2-Making object files
// Interface file
host('make /tmp/intfoobar.o');
ifile='/tmp/intfoobar.o'
// User's files
host('make /tmp/foubare2.o');
ufiles=['/tmp/foubare2.o'];
//3-Link object files .o with addinter
//addinter([ifiles,ufiles],'foobar',intfoobar_funs);
exec('intfoobar.sce');
//Run Scilab functions:
a=1:5;b=-a;c=ones(3,3);
[a,b,c,d]=foobar('mul',a,b,c)
[a,b,c,d]=foobar('add',a,b,c)


