function [maxmap] = findWTLM(wt,scale,depth)

// function [maxmap] = findWTLM(wt,scale,depth)
// Finds the local modulus maxima of a continuous wavelet transform
//
// Intputs:
//	wt	continuous wavelet coefficients matrix
//		matrix of size [N_scale,N]
//	scale	scale vector [1,N_scale]
//	[depth]	maximum relative depth for the peaks search [scalar]
//		Default value is 1 (all found peaks) 
// Outputs:
//	maxmap	0/1 matrix (same size as cw) indicating weither the 
//		corresponding WT coefficient in wt is (1) or is not (0) a
//		local maxima
//		matrix of size [N_scale,N] 

[nargout,nargin] = argn(0) ;
if nargin == 2
  depth = 1 ;
elseif nargin == 3
  depth = min(1,depth) ;
end

n = size(wt,2) ;
s = size(wt,1) ;

maxmap = zeros(s,n) ; maxmap = (maxmap == 0) ;

x = 1:n ;
xplus = [x(2:n) x(1)] ; 
xminus = [x(n) x(1:n-1)] ;
wt = abs(wt) ;


for k = 1:s
  maxdepth = (1-depth) * max(wt(k,:)) 
  maxmap(k,x) = wt(k,x) > wt(k,xminus) & wt(k,x) > wt(k,xplus) & wt(k,x) >= maxdepth ;
end






