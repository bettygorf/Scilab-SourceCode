clear;lines(0);
deff('y=f(t)','y=exp(-t^2)');
erf(0.5)-2/sqrt(%pi)*intg(0,0.5,f)
