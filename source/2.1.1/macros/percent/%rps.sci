//<f>=%rps(f,s)
// %rps(p,n) calcule la puissance nieme (negative) d'une matrice de fractions
//rationnelles.
//!
if int(s)<>s then error('%rps: integer power only'),end
[m,n]=size(f(2))
if m<>n then error(43),end
if s=0 then f=eye(n,n),return,end
if s<0 then f=invr(f),s=-s,end
 
if s=-1 then return,end
f1=f;for k=2:s,f=f*f1;end
//end


