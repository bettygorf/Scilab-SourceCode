//ex4 example
//1-Creating interface source file 
// from intex4.desc file by call to intersci
host('../../bin/intersci intex4');
host('./sedprov intex4');
//2-Making object files
// Interface file
host('make /tmp/intex4.o');
ifile='/tmp/intex4.o'
// User's files
host('make /tmp/contr.o');
ufiles=['/tmp/contr.o'];
//3-Link object files .o with addinter
//addinter([ifile,ufiles],'intex4',intex4_funs);
exec('intex4.sce');
//Run Scilab functions:
sys=ssrand(2,2,3,list('co',1));
n=contrb(sys,0.01)




