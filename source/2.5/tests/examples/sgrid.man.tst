clear;lines(0);
H=syslin('c',352*poly(-5,'s')/poly([0,0,2000,200,25,1],'s','c'));
evans(H,100)
sgrid()
sgrid(0.6,2,7)
