clear;lines(0);
n=8;omega = exp(-2*%pi*%i/n);
j=0:n-1;F=omega.^(j'*j);  //Fourier matrix
x=1:8;x=x(:);
F*x
fft(x,-1)
dft(x,-1)
inv(F)*x
fft(x,1)
dft(x,1)
