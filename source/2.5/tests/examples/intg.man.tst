clear;lines(0);
deff('[y]=f(x)','y=x*sin(30*x)/sqrt(1-((x/(2*%pi))^2))')
exact=-2.5432596188;
abs(exact-intg(0,2*%pi,f))
// See file routines/default/Ex-intg.f 
abs(exact-intg(0,2*%pi,'intgex'))
