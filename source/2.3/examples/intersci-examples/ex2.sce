//ex2 example
//1-Creating interface source file 
// from intex2.desc file by call to intersci
host('../../bin/intersci intex2');
host('./sedprov intex2');
//2-Making object files
// Interface file
host('make /tmp/intex2.o');
ifile='/tmp/intex2.o'
// User's files
host('make /tmp/fsom.o');
ufiles=['/tmp/fsom.o'];
//3-Link object files .o with addinter
//addinter([ifile,ufiles],'intex2',intex2_funs);
exec('intex2.sce');
//Run Scilab functions:
som(1:20,1:10)


