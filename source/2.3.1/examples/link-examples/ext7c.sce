//creating vector c in scilab internal stack
host('make /tmp/ext7c.o');
link('/tmp/ext7c.o','ext7c','C')
a=[1,2,3]; b=[2,3,4];
//c does not exist (c made by ext7c)
fort('ext7c',a,1,'d',b,2,'d','out',1);
//c now exists
c-(a+2*b)
