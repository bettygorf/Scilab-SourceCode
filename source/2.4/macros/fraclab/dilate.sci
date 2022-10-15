function [sscaled,mellin,beta] = dilate(s,a,fmin,fmax,N) ;

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

M = length(s) ;
if mtlb_rem(M,2) == 0
  disp('--- WARNING --- length of signal to be scaled must be a odd number')
  disp('                S zero-padded to the nearest odd length') ;
  s = [s(:);0] ;
  M = M+1 ;
end
T = M-1;
if nargin == 2
  s = mtlb_fftshift(s) ; STF = fft(s,-1) ; s = mtlb_fftshift(s);
  sp = (abs(STF(1:M/2))).^2;
  f = linspace(0,0.5,M/2+1) ; f = f(1:M/2);
    again = 'n';
    while (again=='n' | again=='N')
      plot(f,sp) ; 
      fmin = input('lower frequency bound = ') ;
      fmax = input('upper frequency bound = ') ;
      B = fmax-fmin ; R = B/((fmin+fmax)/2) ;
      Nmin = (B*T*(1+2/R)*log((1+R/2)/(1-R/2)));
      disp(['Number of frequency samples [ N >= ',string(ceil(Nmin)),' ] ']);
      again = input('OK ? y/n = ','s');
    end;
    N = input('Frequency samples = ') ;
end

[mellin,beta] = dmt(s,fmin,fmax,N) ;

for na = 1 : length(a)
  phase =  exp((-%i*2*%pi*beta+1/2)*log(a(na))) ;
  mellin_a = phase.*mellin ;
  nta = 2*round((a(na)*M-1)/2) + 1 ;
  sscaled(1,na) = nta ;
  sscaled(2:nta+1,na) = idmt(mellin_a,beta,nta) ;
end



