function [Sli]=invrs(Sl,alfa);
// Sli=invrs(Sl,alfa) computes Sli, the PSSD
// inverse of PSSD Sl.
//!
D=sl(5);
if type(D)=2 then s=poly(0,varn(D));
Sl(5)=horner(Sl(5),s+alfa);end
Sl(2)=Sl(2)-alfa*eye(sl(2));

[Sreg,Wss]=rowregul(Sl,0,0);
   if rcond(Sreg(5)) >1.d-6 then
      Sli=Wss*invsysli(Sreg);
   else
      error('square but singular system');end
[Q,M]=pbig(Sli(2),0.001,'d');
Sli=projsl(Sli,Q,M);

Sli(2)=Sli(2)+alfa*eye;
if type(sli(5))=2 then 
Sli(5)=horner(Sli(5),s-alfa);end


