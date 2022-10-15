//reading  vector with name='a' in scilab internal stack
host('make /tmp/ext6f.o');
link('/tmp/ext6f.o','ext6f');
a=[1,2,3];b=[2,3,4];name=str2code('a');
c=fort('ext6f',name,1,'c',b,2,'d','out',[1,3],3,'d')
c-(a+2*b)
