function [flag]=%no_choos(x)
// Utility function for use with schur
//     (see %choose)
//   %no_choos=1 (resp 0) <=> %choose=0 (resp 1)
// Copyright INRIA
ls=x(1);flag=1;s=poly(0,'s');
select ls
   case 1 then
// ASSUME x(3) NOT ZERO   (for gev pb. x(3)=0 => eval @ infty)
   vp=x(2)/x(3);pol=s-vp; //disp(pol);
   for p=%sel; if almosteq(pol,p,eps) then flag=0;end;end
   case 2 then
   pol=s^2-x(2)*s+x(3);  //disp(pol);
   for p=%sel; if almosteq(pol,p,eps) then flag=0;end;end   
end

function trfa=almosteq(pol,p,eps)
// returns %T if pol ~ p     %F if not
if degree(pol)<>degree(p) then trfa=%F;return;end
if norm((coeff(p)-coeff(pol)),1)<=eps then trfa=%T;return;end
trfa=%F;


