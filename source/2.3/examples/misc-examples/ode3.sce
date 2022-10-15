// Dynamic call of fexab2 which reads A and B in Scilab's stack
deff('xd=f(t,x)','xd=A*x+B*sin(3*t)')
A=rand(10,10)-4.5*eye;B=rand(10,1);
x=ode(ones(10,1),0,[1,2,3],f);
host("make /tmp/wfexab.o");
link("/tmp/wfexab.o","wfexab");
x-ode(ones(10,1),0,[1,2,3],'wfexab')

