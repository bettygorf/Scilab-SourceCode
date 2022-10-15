function [lnum,lden,g]=factors(P,flag)
//Given a polynomial or rational P, returns in list lnum polynomials of 
//degree 1 or two which are the factors of numerators of P.
// and in lden the factors of denominator of P. g is the gain.
// if flag='c' unstable roots are reflected vs the imaginary axis 
// if flag='d' unstable roots are reflected vs unit circle 
[LHS,RHS]=argn(0);
if RHS==1 then flag=[];end
if type(P)==2 then [lnum,lden]=pfactors(P,flag);return;end
[lnum,gn]=pfactors(P(2),flag);
[lden,gd]=pfactors(P(3),flag);g=gn/gd;


