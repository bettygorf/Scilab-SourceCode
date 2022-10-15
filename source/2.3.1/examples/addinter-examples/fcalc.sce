host('make /tmp/fcalcint.o');
host('make /tmp/fcalc.o');
host('make /tmp/fcalc2.o');
tmpobjects=['/tmp/fcalcint.o','/tmp/fcalc.o','/tmp/fcalc2.o'];
scifuncs=['calc','calc2'];
addinter(tmpobjects,'fcalcentry',scifuncs);

calc('two')-2
calc('one')-1
calc('junk')+1

calc2()



