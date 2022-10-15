clear;lines(0);
a=[1;2;3];n=size(a,'*');
norm(1/n*exp(2*%i*%pi*(0:n-1)'.*.(0:n-1)/n)*a -fft(a,1))
norm(exp(-2*%i*%pi*(0:n-1)'.*.(0:n-1)/n)*a -fft(a,-1))  
