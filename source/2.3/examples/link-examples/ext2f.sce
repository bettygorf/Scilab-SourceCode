//Simple example #2
host('make /tmp/ext2f.o');
link('/tmp/ext2f.o','ext2f');
a=[1,2,3];b=[4,5,6];n=3;
c=fort('ext2f',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d')
c-(sin(a)+cos(b))

