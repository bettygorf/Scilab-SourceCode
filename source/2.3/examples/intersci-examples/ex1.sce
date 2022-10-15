//ex1 example
//1-Creating interface source file 
// from intex1.desc file by call to intersci
host('../../bin/intersci intex1');
host('./sedprov intex1');
//2-Making object files
// Interface file
host('make /tmp/intex1.o');
ifile='/tmp/intex1.o'
// User's files
host('make /tmp/fcalc.o');
ufiles=['/tmp/fcalc.o'];
//3-Link object files .o with addinter
//addinter([ifiles,ufiles],'intex1',intex1_funs);
exec('intex1.sce');
//Run Scilab functions:
calc('one')-1
calc('two')-2
calc('other')+1
