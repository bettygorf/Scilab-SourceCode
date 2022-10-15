function [wt,a,f,scalo,wavescaled]=contwtmir(x,fmin,fmax,N,wave);

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




[nargout,nargin] = argn(0) ;

//  CHECK INPUT FORMATS

[xr,xc] = size(x) ;
if xr ~= 1 & xc ~= 1
  error('1-D signals only')
elseif xc == 1
  x = conj(x') ;
end

//  DEFAULT VALUES

nt = length(x) ;
if exists('wave') == 0 
  wave = 0 ;
end

if nargin == 1
  XTF = fft(mtlb_fftshift(x),-1) ;
  sp = (abs(XTF(1:nt/2))).^2 ;
  f = linspace(0,0.5,nt/2+1) ; f = f(1:nt/2) ;
  plot(f,sp) ; 
  fmin = input('lower frequency bound = ') ;
  fmax = input('upper frequency bound = ') ;
  N = input('Frequency samples = ') ;
  fmin_s = string(fmin) ; fmax_s = string(fmax) ; 
  N_s = string(N) ;
  disp(['frequency runs from ',fmin_s,' to ',fmax_s,' over ',N_s,' points']) ;
end
if nargin == 5
  if fmin >= fmax
    error('fmax must be greater to fmin') ;
  end
end

f = logspace(log10(fmax),log10(fmin),N) ;
a = logspace(log10(1),log10(fmax/fmin),N) ; amax = max(a) ;

if length(wave) == 1
  if abs(wave) > 0
    nh0 = abs(wave) ;
    for ptr = 1:N
      nha = round(nh0 * a(ptr)) ; 
      ha = conj(morlet(f(ptr),nha,~mtlb_isreal(wave))) ;
      nbmir = min(nt,nha) ;
      x_mir = [x(nbmir:-1:2) x x(nt-1:-1:nt-nbmir+1)] ;
      detail = convol(ha,x_mir) ;
      wt(ptr,1:nt) = detail(nha + nbmir  : nha + nbmir + nt -1 ) ;
    end
  elseif wave == 0
    for ptr = 1:N
      ha = mexhat(f(ptr)) ; nha = (length(ha)-1)/2 ;
      nbmir = min(nt,nha) ;
      x_mir = [x(nbmir:-1:2) x x(nt-1:-1:nt-nbmir+1)] ;
      detail = convol(ha,x_mir) ;
      wt(ptr,1:nt) = detail(nha + nbmir  : nha + nbmir + nt -1 ) ;     
    end  
  end
  wavescaled = wave ;
elseif length(wave) > 1 
  wavef = fft(wave,-1) ; nwave = length(wave) ; 
  f0 = find(abs(wavef(1:nwave/2)) == max(abs(wavef(1:nwave/2)))) ;
  f0 = mtlb_mean((f0-1).*(1/nwave)) ;
  disp(['mother wavelet centered at f0 = ',string(f0)]) ;
  f = logspace(log10(fmax),log10(fmin),N) ;
  a = logspace(log10(f0/fmax),log10(f0/fmin),N) ; amax = max(a) ;
  B = 0.99 ; R = B/((1.001)/2) ; 
  nscale = max(128,round((B*nwave*(1+2/R)*log((1+R/2)/(1-R/2)))/2)) ;
  [wavescaled,nt_a] = dilate(wave,a,0.001,0.5,nscale) ;
  wavescaled = real(wavescaled) ;
  for ptr = 1:N
    ha = wavescaled(2:wavescaled(1,ptr),ptr) ;  
    firstindice = (wavescaled(1,ptr)-mtlb_rem(wavescaled(1,ptr),2))/2 ;
    nbmir = min(nt,firstindice) ;
    x_mir = [x(nbmir:-1:2) x x(nt-1:-1:nt-nbmir+1)] ;
    detail = convol(ha,x_mir) ;
    detail = detail(firstindice + nbmir  : firstindice + nbmir + nt -1 ) ;
    wt(ptr,1:nt) = conj(detail(:)') ;
  end
end

if nargout >= 4
  scalo = real(wt.*conj(wt)) ;
end
