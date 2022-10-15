//Passing a parameter to argument funtion of ode
host('make /tmp/ext10f.o');
param=[0.04,10000,3d+7];
link('/tmp/ext10f.o','ext10f')
y=ode([1;0;0],0,[0.4,4],'ext10f')
//param must be defined as a scilab variable upon calling ode

