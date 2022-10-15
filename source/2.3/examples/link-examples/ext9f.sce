host('make /tmp/ext9f.o');
link('/tmp/ext9f.o','ext9f')
//passing a parameter to ext9f routine by a list:
param=[0.04,10000,3d+7];    
y=ode([1;0;0],0,[0.4,4],list('ext9f',param))
