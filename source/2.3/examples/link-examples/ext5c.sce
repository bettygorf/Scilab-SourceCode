host('make /tmp/ext5c.o');
link('/tmp/ext5c.o','ext5c','C');
// reading vector a in scilab internal stack
Amatrix=[1,2,3];b=[2,3,4];
c=fort('ext5c',b,1,'d','out',[1,3],2,'d');
c-(Amatrix+2*b)


