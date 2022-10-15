function [gm,fr]=g_margin(h)
inf=1e30 //machine dependant (ieee inf= %inf)

//-compat type(h)<>15 retained for list/tlist compatibility
if type(h)<>15&type(h)<>16 then error(97,1),end
select h(1)
 case 'r' then ,
 case 'lss' then h=ss2tf(h)
 else error(97,1),
end;
//
if h(4)<>'c' then error(93,1),end
[n,d]=h(2:3);
if type(n)=1 then n=poly(n,varn(d),'c'),end
w=roots( imag(horner(n,%i*poly(0,'w')) *...
         conj(horner(d,%i*poly(0,'w')))) )
eps=1.e-7
ws=[];for i=w',
        if abs(imag(i))<eps then
           if real(i)>0 then  ws=[ws;real(i)],end
        end,
end;
if ws=[] then gm=inf,fr=[],return,end
//
[mingain,k]=mini(real(freq(n,d,%i*ws)))
if mingain=0 then gm=inf,return,end
gm=-20*log(abs(mingain))/log(10)
fr=abs(ws(k)/(2*%pi)) // choix de la frequence positive



