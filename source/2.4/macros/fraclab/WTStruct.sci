function [ScIndex, ScLength] = WTStruct(WT)

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


// Returns the index of the first element of each scale 
// in the WT array and the length of each scale
// If the WT has been computed at N scales, the two resulting array 
// are (1,N+1) matrixes because the "last scale" is in fact the last
// low pass projection.
//
// Scindex contains the index of the first element
// ScLength contains the length of each scale
//
//
// Example: plot( WT(ScIndex(2):ScIndex(2)+SCLength(2)-1))
// shows the 2nd scale wavelet coefficients on a graph
//
// See also : FWT, IWT, NbScales
//
// Bertrand Guiheneuf 1996
//

	SignalLength = int(WT(1));
	NbScales = int(WT(2));
	QMFlength = int( WT(3) + WT(4) +1 );
	
	ScIndex=zeros(1,NbScales+1);
	ScLength=zeros(1,NbScales+1);

	ScIndex(1)=5 + QMFlength;
	Sc=1;
	for k=1:NbScales, 
		SignalLength = floor( (SignalLength +1)/2 ),
		ScLength(Sc)=SignalLength,
		Sc = Sc + 1,
		ScIndex(Sc) = ScIndex(Sc-1) + SignalLength,	
	end;
	ScLength(Sc) = int(SignalLength);

// END OF WTStruct

