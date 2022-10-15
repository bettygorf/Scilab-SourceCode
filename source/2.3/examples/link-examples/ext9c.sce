host('make /tmp/ext9c.o');
link('/tmp/ext9c.o','ext9c','C');
//passing a parameter to ext9c routine by a list:
param=[0.04,10000,3d+7];    
y=ode([1;0;0],0,[0.4,4],list('ext9c',param))
