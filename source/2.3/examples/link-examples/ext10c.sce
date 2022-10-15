//Passing a parameter to argument funtion of ode
host('make /tmp/ext10c.o');
param=[0.04,10000,3d+7];
link('/tmp/ext10c.o','ext10c','C');
y=ode([1;0;0],0,[0.4,4],'ext10c')
//param must be defined as a scilab variable upon calling ode

