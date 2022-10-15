function [maxer,gain,trfun]=fwiir(nbit1,nbit2,w,x,y,weight,nsect)
//[maxer,gain,trfun]=fwiir(nbit1,nbit2,w,x,y,weight,nsect)
//
//macro for the optimum design of IIR filters in cascade realization,
//with prescribed number of bits.
//
//Inputs
//
//   nbit1 :   desired number of bits for coding the filter coefficients
//   nbit2 :   initial search increment
//   w     :   grid of frequencies were the specifications on the
//         :   response are given.They must be given in normalized frequency
//         :   (i.e. in [0-0.5])
//   x     :   initial "infinite precision" coefficients.
//   y     :   desired magnitude response at the specified grid of frequency
//         :   (must be equal to zero or one in the present macro)
//   weight:   weighting in each specified frequency for the error criterion
//   nsect :   number of second order sections.
//
//Outputs
//
//   maxer :   maximum error on the frequency response.
//   gain  :   gain of the finite precision filter.
//   trfun :   transfer function of the finite precision filter in
//         :   second order sections cascade form.
//
//!
m=prod(size(w));
kount=0;
work=0;
nset=100;
nx=4*nsect;
//w=2*w;//the fortran program asks for frequencies in fraction of the Nyquist
//       frequency
[work,cf]=fort('fwiir',w,1,'d',y,2,'d',weight,3,'d',m,4,'i',...
x,5,'d',kount,6,'i',nset,7,'i',nbit1,8,'i',nbit2,9,'i',...
nsect,10,'i',work,11,'d','sort',[2*ny+2,1],11,'d',[nx,1],5,'d');
trfun=work(1:ny);
er=work(ny+1:2*ny);
gain=work(2*ny+1);
maxer=work(2*ny+2)
