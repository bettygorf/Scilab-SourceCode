function [wtout] = WTShrink(wtin, trshld, mod)

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



	[nargout nargin]=argn(0);
	if (nargin < 3), mod='s'; end;
	if (nargin < 1), error('WTShrink : You must give at least a wavelet transform'); end;
	
	wsz = WTOrigSize(wtin);
	wnbsc = WTNbScales(wtin);

	if (nargin < 2), trshld=1; end;


	tsz = size(trshld);
	if (max(tsz)>1), mod='m'; end;

	if ( (mod~='s') &  (mod~='m') ), error('WTShrink : mode must be s (single) or m (multi)'); end;

	if ( (min(tsz) > 1 ) | ( (wnbsc+1) < max(tsz) ) ),
		error('WTShrink : threshold vector size is not correct.');
	end;

	[wti wtl] = WTStruct(wtin);
	wtout = wtin;
	if ((mod=='m')),
		for sc=1:max(size(trshld)),
			wtout( wti(sc):(wti(sc)+wtl(sc)-1) ) = wtshrink(wtin(wti(sc):(wti(sc)+wtl(sc)-1)), trshld(sc));
		end;

	
	else,
		for sc=1:(wnbsc+1),
			t=sqrt(2*log(wtl(sc))) * trshld;
			wtout( wti(sc):(wti(sc)+wtl(sc)-1) ) = wtshrink(wtin(wti(sc):(wti(sc)+wtl(sc)-1)), t);
		end;
		
	end;


function [out] = wtshrink(in,s)

	tmp = abs(in)-s;
	out = tmp .* sign(in) .* (ones(tmp) + sign(tmp))/2;
	
