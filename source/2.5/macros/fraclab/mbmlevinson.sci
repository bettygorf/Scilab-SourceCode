function [x,y,r] = mbmlevinson(N,H,seed) ;

// This Software is ( Copyright INRIA . 1998  1 )
// 
// INRIA  holds all the ownership rights on the Software. 
// The scientific community is asked to use the SOFTWARE 
// in order to test and evaluate it.
// 
// INRIA freely grants the right to use modify the Software,
// integrate it in another Software. 
// Any use or reproduction of this Software to obtain profit or
// for commercial ends being subject to obtaining the prior express
// authorization of INRIA.
// 
// INRIA authorizes any reproduction of this Software.
// 
//    - in limits defined in clauses 9 and 10 of the Berne 
//    agreement for the protection of literary and artistic works 
//    respectively specify in their paragraphs 2 and 3 authorizing 
//    only the reproduction and quoting of works on the condition 
//    that :
// 
//    - "this reproduction does not adversely affect the normal 
//    exploitation of the work or cause any unjustified prejudice
//    to the legitimate interests of the author".
// 
//    - that the quotations given by way of illustration and/or 
//    tuition conform to the proper uses and that it mentions 
//    the source and name of the author if this name features 
//    in the source",
// 
//    - under the condition that this file is included with 
//    any reproduction.
//  
// Any commercial use made without obtaining the prior express 
// agreement of INRIA would therefore constitute a fraudulent
// imitation.
// 
// The Software beeing currently developed, INRIA is assuming no 
// liability, and should not be responsible, in any manner or any
// case, for any direct or indirect dammages sustained by the user.
// 
// Any user of the software shall notify at INRIA any comments 
// concerning the use of the Sofware (e-mail : FracLab@inria.fr)
// 
// This file is part of FracLab, a Fractal Analysis Software"


oldrnd=rand('info');
if length(H) ~= N
  t = linspace(0,1,N) ;
  H =  eval(ht) ;
end

[nargout,nargin] = argn(0) ;

H = min(ones(H) .* 0.9999 , H) ;
H = max(ones(H) .* %eps , H) ;

tmax = N-1 ;  
shift = 1 ;  
if nargin < 3 ; rand ('uniform') ; seed = rand(1) * 1e6 ; end
t = linspace(0,tmax,N) ;
s = %eps ;
alpha = 2*H(:) ; sigma = 1 ;

r = (sigma^2*(exp(alpha(:)*log(abs(t+shift-s))) + ...
exp(alpha(:)*log(abs(t-s-shift))) - ...
2*exp(alpha(:)*log(abs(t-s))))/2)' ;

rand('normal')
rand('seed',seed) ;
y = rand(N,1) ;

x = zeros(N,N) ;

inter1 = r ;
inter2 = [zeros(1,N) ; r(2:N,:) ; zeros(1,N)] ; 
Y = y(1)*r ;

k = -inter2(2,:) ;
aa = sqrt(r(1,:)) ; 

for j = 2:N

  aa = aa.*sqrt(1-k.^2) ;
  inter = k(ones(N-j+1,1),:).*inter2(j:N,:) + inter1(j-1:N-1,:) ;
  inter2(j:N,:) = inter2(j:N,:) + k(ones(N-j+1,1),:).*inter1(j-1:N-1,:) ;
  inter1(j:N,:) = inter ;					
  bb = y(j)*aa.^(-1) ; ;
  x(j:N,:) = x(j:N,:) + bb(ones(N-j+1,1),:).*inter1(j:N,:) ;
  k = -inter2(j+1,:)./(aa.^2) ;

end

coef = sigma.*((N.^H).^(-1)) ;
x = diag(cumsum(x,'r').*coef(ones(N,1),:)) ; 

rand(oldrnd)
