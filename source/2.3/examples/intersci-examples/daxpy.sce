//daxpy example
//1-Creating interface source file 
// from intdaxpy.desc file by call to intersci
host('../../bin/intersci intdaxpy');
host('./sedprov intdaxpy');
//2-Making object files
// Interface file
host('make /tmp/intdaxpy.o');
ifile='/tmp/intdaxpy.o'
// User's files
ufiles=[];
//3-Link object files .o with addinter
//addinter([ifiles,ufiles],'daxpy',intdaxpy_funs);
exec('intdaxpy.sce');
//Run Scilab functions:
n=3;a=13;incx=2;incy=3;x=1:10;y=2*x;
ynew=scilabdaxpy(n,a,x,incx,y,incy)
y(1:incy:n*incy)=y(1:incy:n*incy)+a*x(1:incx:n*incx)
ynew-y

