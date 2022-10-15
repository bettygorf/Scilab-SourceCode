function [CQF1, CQF2] = MakeCQF(number)

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


// Returns a couple of Conjugate Quadrature Filters 
// The valid parameter is : 1 (for the moment)
//
// The format of the resulting CQF's is
// [NegInd, PosInd, QMF(NegInd), CQF(NegInd+1), ..., CQF(0), ..., CQF(PosInd)]
// Where NegInd is of course the number of negative indexes in the CQF 
// And PosInd the number of positive indexes in the CQF
//
// See also : MakeQMF, FWT, IWT
//
// Bertrand Guiheneuf 1996
//
	number=int(number);

	select number,
	case 1,
		CQF1=[4 4 .01767766952966368811 -.04419417382415922027 -.07071067811865475244 .39774756441743298247 .81317279836452965306 .39774756441743298247 -.07071067811865475244 -.04419417382415922027 .01767766952966368811], 
		CQF2=[7 7 -.00071633413577230232 -.00179083534013786258 .00542714167520842959 .02252202991205450068 -.05617759403373648160 -.07397060550067185209 .40502017708757411652 .81358560108650353931 .40502017708757411652 -.07397060550067185209 -.05617759403373648160 .02252202991205450068 .00542714167520842959 -.00179083534013786258 -.00071633413577230232],
	else, disp('No biorthogonal wavelet associated to this number'), CQF1=[0 0 0], CQF2=[0 0 0],
	end,

// END OF MakeCQF

