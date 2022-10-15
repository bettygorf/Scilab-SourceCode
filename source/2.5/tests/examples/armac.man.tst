clear;lines(0);
a=[1,-2.851,2.717,-0.865].*.eye(2,2)
b=[0,1,1,1].*.[1;1];
d=[1,0.7,0.2].*.eye(2,2);
sig=eye(2,2);
ar=armac(a,b,d,2,1,sig)
// extract polynomial matrices from ar representation 
[A,B,D]=arma2p(ar);
