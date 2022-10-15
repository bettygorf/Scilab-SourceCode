function [x] = icontwt(wt,f,wave)

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




[N,nt] = size(wt) ;
fmin = min(f) ; fmax = max(f) ;
a = logspace(log10(1),log10(fmax/fmin),N) ; amax = max(a) ;

if length(wave) == 1
  if abs(wave) > 0
    nh0 = abs(wave) ;
    for ptr = 1:N
      nha = round(nh0 * a(ptr)) ; 
      ha = mtlb_fliplr(morlet(f(ptr),nha,~mtlb_isreal(wave))) ;
      detail = convol(ha,wt(ptr,:)) ;
      resol(ptr,1:nt) = detail(nha+1:nha+nt)./(a(ptr)^2) ;
    end
  elseif wave == 0
    for ptr = 1:N
      ha = mtlb_fliplr(mexhat(f(ptr))) ;
      nha = (length(ha)-1)/2 ;
      detail = convol(ha,wt(ptr,:)) ;
      resol(ptr,1:nt) = detail(nha+1:nha+nt)./(a(ptr)^2) ;
    end  
  end
elseif length(wave) > 1 
  for ptr = 1:N
    ha = mtlb_fliplr(conj(wave(2:wave(1,ptr),ptr)')) ; 
    firstindice = (wave(1,ptr)-mtlb_rem(wave(1,ptr),2))/2 ;
    detail = convol(ha,wt(ptr,:)) ;
    resol(ptr,1:nt) = detail(firstindice+1:firstindice+nt)./(a(ptr)^2) ;
  end
end

x = integ(resol,a) ;
