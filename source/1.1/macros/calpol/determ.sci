function [res]=determ(W,k)
// determinant of a real polynomial matrix by FFT
// W=square polynomial matrix
// k=``predicted'' degree of the determinant of W i.e. k is
// an integer larger or equal to the actual degree of W.
// Method: evaluate the determinant of W for the Fourier frequencies
// and apply inverse fft to the coefficients of the determinant.
// See also detr
//F.D.!
[lhs,rhs]=argn(0);
[n1,n1]=size(W);maj=n1*maxi(degree(W))+1;
if rhs==1 then 
k=1;
while k < maj
k=2*k;end;
end
if n1>8 then write(%io(2),'Computing determinant: Be patient...');end
e=0*ones(k,1);e(2)=1;
if k=1 then ksi=1,else ksi=fft(e,-1);end
fi=[];
for kk=1:k,fi=[fi,det(freq(W,ones(W),ksi(kk)))];end
res=clean(real(poly(fft(fi,1),varn(W),'c')));
//if 2*int(n1/2)<>n1 then res=-res;end






