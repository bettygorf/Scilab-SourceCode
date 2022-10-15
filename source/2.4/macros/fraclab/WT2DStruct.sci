function [ScIndex, ScLength] = WT2DStruct(WT)

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



// See also : FWT, IWT, NbScales
//
// Bertrand Guiheneuf 1996
//

SignalHeight = int(WT(1));
SignalWidth = int(WT(2));
NbScales = int(WT(3));
QMFlength = int( WT(4) + WT(5) +1 );
	
ScIndex=zeros(NbScales,4);
ScLength=zeros(NbScales,2);

Index=6 + QMFlength;
	
for Sc=1:NbScales, 
  SignalHeight = floor( (SignalHeight +1)/2 ),
  SignalWidth = floor( (SignalWidth +1)/2 ),
  SignalLength = SignalHeight*SignalWidth;

  ScLength(Sc,1)=SignalHeight,
  ScLength(Sc,2)=SignalWidth,
		
  for j=1:3,
    ScIndex(Sc,j) = Index ,
    Index = Index + SignalLength,
  end;
  ScIndex(Sc,4) = 0,
		
end;
ScIndex(NbScales,4) = Index;

// END OF WTStruct

