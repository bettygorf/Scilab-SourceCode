//1-Creating interface source file (matusr.f)
// from intmatusr.desc file by call to intersci
host('../../bin/intersci intmatusr');
host('./sedprov intmatusr');
//2-Making object files
// Interface file
host('make /tmp/intmatusr.o');
ifile='/tmp/intmatusr.o'
// User's files
host('make /tmp/matusr-c.o');
host('make /tmp/matusr-f.o');
ufiles=['/tmp/matusr-f.o','/tmp/matusr-c.o'];
//3-Link object files .o with addinter
//addinter([ifiles,ufiles],'intmatusr',matusr_funs);
exec('intmatusr.sce');
//Test Scilab functions:
// calc1: 3 matrix input variables and at most 3 output variables of
// types double, real, int
[x,y,z]=calc1(1,[2,3],[1,2;3,4])

//calc2: creating 3 matrices (d,r,i) of fixed dimensions.
[x,y,z]=calc2()

//calc3: matrix of integer type created by C function (malloc and free).
A=calc3()

//calc4: input: matrix of character string 
//       output: matrix of character string (C function ccalc4)
w=['this' 'is'; 'naw' 'gaad']
calc4(w)

//calc5: creating a list made of a character string matrix 
calc5()

//calc6: function with a list as input and parameters
nl=calc6(list(1,2,3))

//calc7: function with two optional values, a string and a scilab variable.
bb=33;  //scilab optional variable
[a,b,c,d]=calc7(10)

//calc8: same as calc1 with two optional variables b=ddef and c=cdef
[a,b,c]=calc8(ones(2,2),2,3)
ddef=2;cdef=3;
[a,b,c]=calc8(ones(2,2))

