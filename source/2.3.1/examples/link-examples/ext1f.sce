//(very) simple example 1
host('make /tmp/ext1f.o');
link('/tmp/ext1f.o','ext1f');
a=[1,2,3];b=[4,5,6];n=3;
c=fort('ext1f',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d')
c-(a+b)
