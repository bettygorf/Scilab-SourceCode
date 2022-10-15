host("make /tmp/Testf.o");  //Interface
host("make /tmp/testfc.o");  //Called routines
scifuncs=['funcf1','funcf2','funcf3','funcf4','funcf5'];  //Scilab functions

addinter(['/tmp/Testf.o','/tmp/testfc.o'],'testfentry',scifuncs)
//matrix (double) created by C function
funcf1()
//matrix (int) created by C function
funcf2()
//Character string created by C function
funcf3()
//a's to o's
funcf4('gaad')
//variable read in Scilab stack
param=1:10;funcf5()


