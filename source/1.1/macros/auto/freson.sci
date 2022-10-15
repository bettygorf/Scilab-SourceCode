function [fr,g]=freson(h,selec)
[lhs,rhs]=argn(0)
[n,d]=h(2:3);
if type(n)=1 then n=poly(n,varn(d),'c'),end
d0=coeff(d,0)
if d0=0 then
   error('infinite gain at zero frequency'),
end;
ar0=abs(coeff(n,0)/d0)^2
//recherche des "pulsations" telles que la derivee
//du module soit nulle
niw=horner(n,%i*poly(0,'w'));
diw=horner(d,%i*poly(0,'w'))
niw=real(niw*conj(niw));diw=real(diw*conj(diw));
modul_d=derivee(niw/diw);w=roots(modul_d(2));
//recherche des racines reelles positives ...
eps=1.e-7
fr=[];g=[];for i=w',
        if abs(imag(i))<eps then
           if real(i)>0 then
             mod2=abs(freq(niw,diw,real(i)))
             if mod2>ar0 then
                fr=[fr;real(i)],g=[g;mod2],
             end;
           end;
        end,
end;
if fr=[] then return,end
fr=fr/(2*%pi);
if rhs=1 then
      g=sqrt(g/ar0)
else
      if part(selec(1),1)='f' then g=sqrt(g/ar0)
                              else g=10*log(g)/log(10)
      end;
end;
