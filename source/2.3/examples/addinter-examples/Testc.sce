host("make /tmp/Testc.o");  //Interface
host("make /tmp/testcc.o");  //Called routines
scifuncs=['funcc1','funcc2','funcc3','funcc4','funcc5'];  //Scilab functions

addinter(['/tmp/Testc.o','/tmp/testcc.o'],'testcentry',scifuncs)
//matrix (double) created by C function
funcc1()
//matrix (int) created by C function
funcc2()
//Character string created by C function
funcc3()
//a's to o's
funcc4('gaad')
//variable read in Scilab stack
param=1:10;funcc5()


