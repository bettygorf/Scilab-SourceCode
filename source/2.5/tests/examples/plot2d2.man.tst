clear;lines(0);
// plots a step function of value i on the segment [i,i+1]
// the last segment is not drawn
plot2d2("gnn",[1:4]',[1:4]',1,"111","step function",[0,0,5,5])
// compare the following with plot2d1
x=[0:0.1:2*%pi]';
xbasc()
plot2d2("onn",x,[sin(x) sin(2*x) sin(3*x)])
