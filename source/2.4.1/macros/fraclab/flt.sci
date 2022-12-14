function [u,s,x,y] = flt(x,y,ccv) ;

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
// This file is part of FracLab, a Fractal Analysis Software



[x,I] = sortup(x) ;
y = y(I) ;
x0 = x ; y0 = y ;

if exists('ccv') == 0
  ccv = 1 ;
end
y = (-2*ccv+1)*y ;

Pdiff = -1 ;
while ~and(Pdiff >= 0)
  P = [] ; O = [] ;
  Nx = length(x) ; 
  for i = 1:Nx-1
    [slope,origin]  = reglin([x(i+1) x(i)],[y(i+1) y(i)]) ;
    P(i) = slope ;
    O(i) = origin ;
  end
  Pdiff = mtlb_diff(P) ; 
  II = find(Pdiff >= 0) ;   
  if isempty(II)
    new_idx = [1 Nx] ;
  elseif ~isempty(II)
    new_idx = [1 II+1 Nx] ;
  end
// disp(new_idx) 
  x = x(new_idx) ; // disp(x)
  y = y(new_idx) ;
end

y = (1 - 2*ccv)*y ;
u = (2*ccv - 1)*O ;
s = (1 - 2*ccv)*P ;






