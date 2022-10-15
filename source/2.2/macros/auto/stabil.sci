function F=stabil(A,B,alfa)
//returns F such that A+B*F is stable if
//pair (A,B) is stabilizable 
//assignable poles are set to alfa(1),alfa(2),...
// If (A,B) is not stabilizable a warning is displayed
//and assignable poles are set to alfa(1),alfa(2),...
//Example:
// Sys=ssrand(2,2,5,list('st',2,3,3));
// A=Sys(2);B=Sys(3); F=stabil(A,B);
// spec(A)   
//2 controllable modes 2 unstable uncontrollable modes
//  and one stable uncontrollable mode
//spec(A+B*F) 
//the two controllable modes are set to -1.
//
[ns,nc,U,sl]=st_ility(syslin('c',A,B,[]));
[LHS,RHS]=argn(0)
[nx,nx]=size(A);[nn,nu]=size(B);
if ns<nx then warning('stabil: pair A,B not stabilizable!');end
if RHS=2 then 
  alfa=-ones(1,nx);
end
if prod(size(alfa))==1 then
  alfa=-alfa*ones(1,nx);
end
An=U'*A*U;Bn=U'*B;
F=-ppol(An(1:nc,1:nc),Bn(1:nc,:),alfa(1:nc));
F=[F,zeros(nu,nx-nc)]*U';



