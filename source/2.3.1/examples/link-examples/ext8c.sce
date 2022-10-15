//argument function for ode
//call ext8c argument function with dynamic link
host('make /tmp/ext8c.o');
link('/tmp/ext8c.o','ext8c','C');
ode([1;0;0],0,[0.4,4],'ext8c')
