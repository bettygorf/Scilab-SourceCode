function [QMF] = MakeQMF(name,number)

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


// Returns a QMF indexed by its name and a length parameter
// The valid Parameters are
// 'daubechies' : 2,4,6,8,10,12,14,16,18,20
// 'coiflet' : 6,12,18,24
//
// The format of tyhe resulting QMF is 
// [NegInd, PosInd, QMF(NegInd), QMF(NegInd+1), ..., QMF(0), ..., QMF(PosInd)]
// Where NegInd is of course the number of negative indexes in the QMF 
// And PosInd the number of positive indexes in the QMF
//
// See also : MakeCQF, FWT, IWT
//
// Bertrand Guiheneuf 1996
//
	number = int(number);
	select name,
	
	case 'daubechies', 

		select number,
		case 2, QMF=[0 1 0.707107 0.707107],
		case 4, QMF=[0 3 0.482962 0.836516 0.224143 -0.129409],
		case 6, QMF=[0 5 0.332670 0.806891 0.459877 -0.135011 -0.0854412 0.0352262],
		case 8, QMF=[0 7 0.230377  0.714846 0.630880 -0.027983 -0.187034 0.030841 0.032883 -0.010597],
		case 10, QMF=[0 9 0.160102 0.603829 0.724308 0.138428 -0.242294 -0.032244 0.077571 -0.006241 -0.012580 0.003335],
		case 12, QMF=[0 11 0.111540 0.494623 0.751133 0.315250 -0.226264 -0.129766 0.097501 0.027522 -0.031582 0.000553 0.004777 -0.001077],
		case 14, QMF=[0 13 0.077852 0.396539 0.729132 0.469782 -0.143906 -0.224036 0.071309 0.080612 -0.038029 -0.016574 0.012550 0.000429 -0.001801 0.000353],
		case 16, QMF=[0	15 0.054415 0.312871 0.675630 0.585354 -0.015829 -0.284015 0.000472 0.128747 -0.017369 -0.044088 -0.013981 0.008746 -0.004870 -0.000391 0.000675 -0.000117],
		case 18, QMF=[0 17 0.038077 0.243834 0.604823 0.657288 0.133197 -0.293273 -0.096840 0.148540 0.030725 -0.067632 0.000250 0.022361 -0.004723 -0.004281 0.001847 0.000230 -0.000251 0.000039],
		case 20, QMF=[0 19 0.026670 0.188176 0.527201 0.688459 0.281172 -0.249846 -0.195946 0.127369 0.093057 -0.071394 -0.029457 0.033212 0.003606 -0.010733 0.001395 0.001992 -0.000685 -0.000116 0.000093 -0.000013],
		else, disp('No Daubechies wavelet associated to  this number'), QMF=[0 0 0], 
		end,

	case 'coiflet',

		select number,
		case 6, QMF=[2 3 -.07251489 .33688989 .85003119 .38371740 -.07251489 -.01560870],
		case 12, QMF=[4 7 0.011587 -0.029320 -0.047639 0.273021 0.574682 0.294867 -0.054085 -0.042026 0.016744 0.003967 -0.001289 -0.000509],
		case 18, QMF=[6 11 -0.002682 0.005503 0.016583 -0.046507 -0.043220 0.286503 0.561285 0.302983 -0.050770 -0.058196 0.024434 0.011229 -0.006369 -0.001820 0.000790 0.000329 -0.000050 -0.000024],
		case 24, QMF=[8 15 0.000630 -0.001152 -0.005194 0.011362 0.018867 -0.057464 -0.039652 0.293667 0.553126 0.307157 -0.047112 -0.068038 0.027813 0.017735 -0.010756 -0.004001 0.002652 0.000895 -0.000416 -0.000183 0.000044 0.000022 -0.000002 -0.000001],
		else, disp('No Coiflet associated to this number'), QMF=[0 0 0],
		end,

	else,  disp('No wavelet associated to this name'), QMF=[0 0 0],
	end,

// END OF MakeQMF

