clear;lines(0);
A=['x','y';'0','z'];b=['0';'1'];
w=trisolve(A,b)
x=5;y=2;z=4;
evstr(w)
inv(evstr(A))*evstr(b)
