//Simple example #2
host('make /tmp/ext2c.o');
link('/tmp/ext2c.o','ext2c','C');
a=[1,2,3];b=[4,5,6];n=3;
c=fort('ext2c',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d')
c-(sin(a)+cos(b))

