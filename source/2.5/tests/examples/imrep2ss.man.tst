clear;lines(0);
s=poly(0,'s');
H=[1/(s+0.5);2/(s-0.4)]   //strictly proper
np=20;w=ldiv(H('num'),H('den'),np);
rep=[w(1:np)';w(np+1:2*np)'];   //The impulse response
H1=ss2tf(imrep2ss(rep))
z=poly(0,'z');
H=(2*z^2-3.4*z+1.5)/(z^2-1.6*z+0.8)     //Proper transfer function
u=zeros(1,20);u(1)=1;
rep=rtitr(H('num'),H('den'),u);   //Impulse rep. 
//   <=> rep=ldiv(H('num'),H('den'),20)
w=z*imrep2ss(rep)   //Realization with shifted impulse response 
// i.e strictly proper to proper
H2=ss2tf(w);
