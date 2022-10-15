//argument function for ode
//call ext8f argument function with dynamic link
host('make /tmp/ext8f.o')
link('/tmp/ext8f.o','ext8f');
ode([1;0;0],0,[0.4,4],'ext8f')
