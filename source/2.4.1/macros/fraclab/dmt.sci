function     [mellin,beta] = dmt(s,fmin,fmax,N);

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

[ys,xs]=size(s) ; 
if ys>xs , s = conj(s') ; else, end;
M = length(s);
Tmin = 1;
Tmax = M;
T = Tmax-Tmin;
if nargin==1
  s = mtlb_fftshift(s) ; STF = fft(s,-1) ; s = mtlb_fftshift(s);
  sp = (abs(STF(1:M/2))).^2;
  f = linspace(0,0.5,M/2+1) ; f = f(1:M/2);
    again = 'n';
    while (again=='n' | again=='N')
      plot(f,sp) ; 
      title('Analyzed Signal Spectrum');
      fmin = input('lower frequency bound = ') ;
      fmax = input('upper frequency bound = ') ;
      B = fmax-fmin ; R = B/((fmin+fmax)/2) ;
      Nmin = (B*T*(1+2/R)*log((1+R/2)/(1-R/2)));
      disp(['Number of frequency samples (N) should be greater or equal to ',string(ceil(Nmin))]);
      again = input('OK ? y/n = ','s');
    end;
    N = input('Frequency samples = ') ;

elseif nargin==4 

  B = fmax-fmin ; R = B/((fmin+fmax)/2) ; 

end
if fmax ~= 0.5 
   disp('--- WARNING --- Inverse Mellin transform requires that fmax = 1/2')
end



// Geometric sampling of the analyzed spectrum

k = 1:N/2;
q = (fmax/fmin)^(1/(N/2-1)) ;

t = [0:M-1];  

flog(k) = fmin*(exp((k-1).*log(q))) ; 

tfmatx = zeros(M,N/2);
tfmatx = exp(-2*%i*(t(1:M))'*flog*%pi);
S = s*tfmatx ; 
S(N/2+1:N) = zeros(1,N/2);
 


// Mellin transform computation of the analyzed signal


mellin = conj(mtlb_fftshift(fft(S,1))') ;
k = 1:N ;
beta(k) = -1/(2*log(q))+(k-1)./(N*log(q));
beta = beta(:) ;



