host('make /tmp/ext5f.o');
link('/tmp/ext5f.o','ext5f')
// reading vector a in scilab internal stack
a=[1,2,3];b=[2,3,4];
c=fort('ext5f',b,1,'d','out',[1,3],2,'d')
c=a+2*b
