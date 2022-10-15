//Example #3
host('make /tmp/ext3f.o');
link('/tmp/ext3f.o','ext3f');
a=[1,2,3];b=[4,5,6];n=3;yes=str2code('yes');
c=fort('ext3f',yes,1,'c',n,2,'i',a,3,'d',b,4,'d','out',[1,3],5,'d')
c-(sin(a)+cos(b))
yes=str2code('no');
c=fort('ext3f',yes,1,'c',n,2,'i',a,3,'d',b,4,'d','out',[1,3],5,'d')
c-(a+b)

