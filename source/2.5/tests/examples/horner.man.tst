clear;lines(0);
s=poly(0,'s');M=[s,1/s];
horner(M,1)
horner(M,%i)
horner(M,1/s)
