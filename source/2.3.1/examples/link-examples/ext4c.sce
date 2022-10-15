host('make /tmp/ext4c.o');
link('/tmp/ext4c.o','ext4c','C');
a=[1,2,3];b=[4,5,6];n=3;yes='yes'
c=fort('ext4c',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d')
c-(sin(a)+cos(b))
yes='no'
c=fort('ext4c',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d')
c-(a+b)
//clear yes  --> undefined variable : yes

