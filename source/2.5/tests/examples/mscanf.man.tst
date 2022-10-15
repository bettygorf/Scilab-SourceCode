clear;lines(0);
[n,a1,a2]=msscanf('123 456','%i %s')
[n,a1,a2,a3]=msscanf('123 456','%i %s')
data=msscanf('123 456','%i %s')

fd=mopen(SCI+'/scilab.star','r')
mfscanf(fd,'%s %s %s')
mclose(fd)

