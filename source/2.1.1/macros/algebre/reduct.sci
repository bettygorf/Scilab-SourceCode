function [Ep,Fp,M]=reduct(E,F)
Ep=E;Fp=F;M=eye(E*E');
  [p,q]=size(Ep);
  [Sig,rk]=colcomp(Ep);
while rk<>q
   E1=Ep*Sig;E1=E1(:,q+1-rk:q);
   F12=Fp*Sig;
   F1=F12(:,q+1-rk:q);F2=F12(:,1:q-rk);
   [W,r1]=rowcomp(F2);
   N=w(r1+1:p,:);
   Ep=N*E1;Fp=N*F1;M=N*M;
  [p,q]=size(Ep);
  [Sig,rk]=colcomp(Ep);
end
