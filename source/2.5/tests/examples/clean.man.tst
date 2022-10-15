clear;lines(0);
x=poly(0,'x');
w=[x,1,2+x;3+x,2-x,x^2;1,2,3+x]/3;
w*inv(w)
clean(w*inv(w))
