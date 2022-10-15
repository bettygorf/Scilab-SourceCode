function [x,Fj,Fs] = oscillsing(alpha,beta,sing_pos,N,show) ;

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



// [x,fj,fsample] = oscillsing(alpha,beta,N,sing_pos) ;
// 	Generates a signal defined on the interval [-1,1] and 
//	composed of oscillating singularities:
//
//	x(t) = Sum_{i} |x-sing_pos|^alpha(i) sin(2.pi.|x-sing_pos|^{-beta(i)})
//
// Inputs:
//	alpha 		vector of Holder exponents (all positive)
//	beta		vector of power law modulations (all positive)
//	N		length of the synthetized signal
//	sing_pos	vector of singular points position
// Outputs:
//	x		synthetized signal
//	Fj		instantaneous freqeuncies
//	Fs		sampling frequency

nsing = length(alpha) ;

if ~and(sing_pos <= 1) | ~and(sing_pos >= -1)
  error('sing_pos must be in the interval [-1,1]') ;
end
x = zeros(1,N) ;
Fj = zeros(N,nsing) ;
t = linspace(-1,1,N) ;
Fs = N/2 ;
for j = 1:nsing
  xj = (abs(t-sing_pos(j)).^alpha(j)).*sin(2*%pi*abs(t-sing_pos(j)).^(-beta(j))) ;
  f = beta(j).*abs(t-sing_pos(j)).^(-beta(j)-1) ;
  Fj(1:N,j) = f(:) ;
  x = x + xj ;
end

if exists('show')

  if show == 1

    xbasc()
    xsetech([0.05 0.05 0.9 0.4]) ; 
    logf = log(Fj) ;  
    T = t(ones(nsing,1),:)' ; 
    plot2d([T T t(:)],[logf logf log(Fs*ones(N,1))],[ones(1,nsing)*17 ones(1,nsing)*(-1) 19]) ; 
    xgrid(3)
    xsetech([0.05 0.55 0.9 0.4]) ; 
    plot2d(t,x) 

  end

end
