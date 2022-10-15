//same example as # 10 with call to matptr
//param must be defined as a scilab variable
host('make /tmp/ext11c.o');
link('/tmp/ext11c.o','ext11c','C');
param=[0.04,10000,3d+7];
y=ode([1;0;0],0,[0.4,4],'ext11c')
