//creating vector c in scilab internal stack
host('make /tmp/ext7f.o');
link('/tmp/ext7f.o','ext7f')
a=[1,2,3]; b=[2,3,4];
//c does not exist (c made by ext7f)
fort('ext7f',a,1,'d',b,2,'d','out',1);
//c now exists
c-(a+2*b)
