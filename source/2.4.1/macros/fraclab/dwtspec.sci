function [alpha,f_alpha,logpart,tau] = dwtspec(wt,Q,ChooseReg)

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



// 	Check input arguments and prefix undefined input arguments

[nargout,nargin] = argn(0) ;
select nargin
  case 2, ChooseReg = 0 ;
end

[sc_idx,sc_lg] = WTStruct(wt) ;

nscale = length(sc_idx) - 1 ;
logscale = 1:nscale ;
wt = abs(wt) ;

// computation of the partition function and the mass function

for nq = 1:length(Q)
  for j=1:nscale
    detail =  wt(sc_idx(j):sc_idx(j)+sc_lg(j)-1) ;
    logpart(j,nq) = mtlb_log2(sum(detail.^Q(nq))) ;
  end
end

if ChooseReg == 1
  xbasc()
  xsetech([0 0 0.5 1.0]) 
  logscalePlot = logscale(ones(size(logpart,2),1),:)' ;
  plot2d(logscalePlot,logpart)
  xsetech([0.5 0 0.5 1.0]) 
  plot2d(logscalePlot(2:nscale,:),mtlb_diff(logpart))
  reg = input('Reg. range [vector] = ') ;
  if isempty(reg), reg = 1:nscale ; end,
  xbasc(), xsetech([0 0 1.0 1.0]) 
elseif ChooseReg == 0
  reg = 1:nscale ;
elseif length(ChooseReg) > 1
  reg = ChooseReg ;
end

for nq = 1:length(Q) 
  slope = reglin(reg(:)',logpart(reg(:),nq)') 
  tau(nq) = slope - Q(nq)/2 ;
end

// computation of the Legendre spectrum

[f_alpha,alpha] = flt(Q,tau) ;






