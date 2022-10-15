function [lnum,lden,g]=factors(rat,flag)
//Given a polynomial or rational rat, returns in list lnum polynomials of 
//degree 1 or two which are the factors of numerators of rat.
// and in lden the factors of denominator of rat. g is the gain.
// if flag='c' unstable roots are reflected vs the imaginary axis 
// if flag='d' unstable roots are reflected vs unit circle 
[LHS,RHS]=argn(0);
if RHS==1 then flag=[];end
if type(rat)==2 then [lnum,lden]=pfactors(rat,flag);return;end
[lnum,gn]=pfactors(rat(2),flag);
[lden,gd]=pfactors(rat(3),flag);g=gn/gd;

