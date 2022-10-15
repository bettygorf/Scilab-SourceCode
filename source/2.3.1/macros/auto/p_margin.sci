function [phm,fr]=p_margin(h)

//-compat type(h)<>15 retained for list/tlist compatibility
if type(h)<>15&type(h)<>16 then error(97,1),end
flag=h(1)
select flag(1)
 case 'r' then ,
 case 'lss' then h=ss2tf(h)
 else error(97,1),
end;
//
//if h(4)<>'c' then error(93,1),end
//
[n,d]=h(2:3);w=poly(0,'w')
// 
niw=horner(n,%i*w);diw=horner(d,%i*w)
w=roots(real(niw*conj(niw)-diw*conj(diw)))
//recherche des racines reelles positives
eps=1.e-7
ws=w(find((abs(imag(w))<eps)&(real(w)>0)))
if ws=[] then phm=[],fr=[],return,end
//
f=freq(n,d,%i*ws);
phm=atan(imag(f),real(f))
phm=180*phm(:)/%pi 
fr=real(ws)/(2*%pi) 



