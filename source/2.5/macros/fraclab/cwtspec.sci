function [alpha,f_alpha,logpart,tau] = cwtspec(wt,scale,Q,FindMax,ChooseReg)

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



// function [alpha,f_alpha,logpart] = cwtspec(wt,scale,Q,FindMax,ChooseReg)
// Computed the Legendre Spectrum from the coefficients (or the local Maxima)
// of a Continuous L1 Wavelet Transform.
//
// Inputs:
//	wt		the wavelet coefficients computed from cwt.
//			Matrix of size [N_scales,N]
//	scale		analyzed scale vector
//			Vector of size [1,N_scale]
//	Q		exponents of the partition function
//			vector of size [1,N_Q]
//	FindMax		0/1 : (1) finds the indices of the local Maxima
//			coefficients of the wavelet transform
//			Default value is FindMax = 1 
//	ChooseReg	0/1 : (1) asks online the scale indices for linear
//			regression of the partition function.
//			Default value is ChooseReg = 0 (full range regression)
//			ChooseReg can also contain directly the scale indices
//			for the regression region.
//			Vector of size [1,N_reg <= N_scale]
// Outputs:
//	alpha		singularity exponents
//	f_alpha		singularity spectrum
//	logpart		logarithm (base 2) of the partition function
//	tau		mass exponents
//
// Example:
//	N = 2048 ; H = 0.3 ; Q = -10:10 ;
//	[x] = fbmlevinson(N,H) ;
//	[wt,scale] = cwt(x,2^(-8),2^(-1),16,8) ;
//	[alpha,f_alpha,logpart,tau] = cwtspec(wt,scale,Q,1,5:16) ;
//	clf, subplot(221), plot(mtlb_log2(scale),logpart) ;
//	title('partition function S_n(q)'), xlabel('log_{2}(scale)')
//	subplot(222), plot(Q,tau), title('\tau(q)'), xlabel('Q')
//	subplot(212), plot(alpha,f_alpha,'o',alpha,f_alpha),
//	title('f_{\alpha}'), xlabel('\alpha'),


// 	Check input arguments and prefix undefined input arguments

[nargout,nargin] = argn(0) ;
select nargin
  case 3, FindMax = 1 ; ChooseReg = 0 ;
  case 4, ChooseReg = 0 ;
end

nscale = length(scale) ;

if FindMax == 1 
  maxmap = findWTLM(wt,scale) ;
elseif FindMax == 0
  maxmap = ones(wt) ;
end

// matrix reshape of the wavelet coefficients

detail = abs(conj(wt')) ;
maxmap = maxmap' ;
logscale = mtlb_log2(scale(:)) ;

// computation of the partition function and the mass function

for nq = 1:length(Q)
  for j=1:nscale
    max_idx = find(maxmap(:,j) == %T) ;
    max_idx = max_idx(:) ;
    DetPowQ = detail(max_idx,j).^Q(nq) ;
    logpart(j,nq) = mtlb_log2(mtlb_mean(DetPowQ)) ; 
  end
end

if ChooseReg == 1
  xbasc()
  xsetech([0 0 0.5 1.0]) 
  logscalePlot = logscale(:,ones(size(logpart,2),1)) ;
  plot2d(logscalePlot,logpart) 
  xsetech([0.5 0 0.5 1.0]) 
  plot2d(logscalePlot(2:nscale,Q >= 0),mtlb_diff(logpart(:,Q >= 0)))
  reg = input('Reg. range [vector] = ') ;
  if isempty(reg), reg = 1:nscale ; end,
  xbasc(), xsetech([0 0 1.0 1.0]) 
elseif ChooseReg == 0
  reg = 1:nscale ;
elseif length(ChooseReg) > 1
  reg = ChooseReg ;
end

for nq = 1:length(Q) 
  slope = reglin(logscale(reg(:))',logpart(reg(:),nq)') ;
  tau(nq) = slope - 1 ;
end

// computation of the Legendre spectrum
 
[f_alpha,alpha] = flt(Q,tau) ;


