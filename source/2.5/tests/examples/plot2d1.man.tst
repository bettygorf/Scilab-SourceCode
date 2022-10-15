clear;lines(0);
// multiple plot without giving x
x=[0:0.1:2*%pi]';
plot2d1("enn",1,[sin(x) sin(2*x) sin(3*x)])
// multiple plot using only one x
xbasc()
plot2d1("onn",x,[sin(x) sin(2*x) sin(3*x)])
// logarithmic plot
x=[0.1:0.1:3]'; xbasc()
plot2d1("oll",x,[exp(x) exp(x^2) exp(x^3)])
