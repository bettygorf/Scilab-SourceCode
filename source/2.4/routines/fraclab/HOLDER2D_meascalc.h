/* This Software is ( Copyright INRIA . 1998  1 )                    */
/*                                                                   */
/* INRIA  holds all the ownership rights on the Software.            */
/* The scientific community is asked to use the SOFTWARE             */
/* in order to test and evaluate it.                                 */
/*                                                                   */
/* INRIA freely grants the right to use modify the Software,         */
/* integrate it in another Software.                                 */
/* Any use or reproduction of this Software to obtain profit or      */
/* for commercial ends being subject to obtaining the prior express  */
/* authorization of INRIA.                                           */
/*                                                                   */
/* INRIA authorizes any reproduction of this Software.               */
/*                                                                   */
/*    - in limits defined in clauses 9 and 10 of the Berne           */
/*    agreement for the protection of literary and artistic works    */
/*    respectively specify in their paragraphs 2 and 3 authorizing   */
/*    only the reproduction and quoting of works on the condition    */
/*    that :                                                         */
/*                                                                   */
/*    - "this reproduction does not adversely affect the normal      */
/*    exploitation of the work or cause any unjustified prejudice    */
/*    to the legitimate interests of the author".                    */
/*                                                                   */
/*    - that the quotations given by way of illustration and/or      */
/*    tuition conform to the proper uses and that it mentions        */
/*    the source and name of the author if this name features        */
/*    in the source",                                                */
/*                                                                   */
/*    - under the condition that this file is included with          */
/*    any reproduction.                                              */
/*                                                                   */
/* Any commercial use made without obtaining the prior express       */
/* agreement of INRIA would therefore constitute a fraudulent        */
/* imitation.                                                        */
/*                                                                   */
/* The Software beeing currently developed, INRIA is assuming no     */
/* liability, and should not be responsible, in any manner or any    */
/* case, for any direct or indirect dammages sustained by the user.  */
/*                                                                   */
/* Any user of the software shall notify at INRIA any comments       */
/* concerning the use of the Sofware (e-mail : FracLab@inria.fr)     */
/*                                                                   */
/* This file is part of FracLab, a Fractal Analysis Software         */

#ifdef SHORT
#define TYPIN  short
#else
#define TYPIN  double
#endif
#define TYPOUT double

#ifndef __STDC__
void AlphaMoyGrain();
void AlphaVarGrain();
void AlphaEcartGrain();
void AlphaMinGrain();
void AlphaMaxGrain();
void AlphaIsoGrain();
void AlphaRIsoGrain(); 
void AlphaAsymGrain();
void AlphaAplaGrain();
void AlphaContGrain(); 
void AlphaLognormGrain();
void AlphaVarlogGrain();
void AlphaRhoGrain();
void AlphaPowGrain();
void AlphaLogpowGrain();
void AlphaGrain();
void AlphaFrontMaxGrain();
void AlphaFrontMinGrain();
#else /* __STDC__ */
void AlphaMoyGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaVarGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaEcartGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaMinGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaMaxGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaIsoGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py, TYPOUT param);
void AlphaRIsoGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py, TYPOUT param); 
void AlphaAsymGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaAplaGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaContGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py); 
void AlphaLognormGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaVarlogGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaRhoGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaPowGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py, TYPOUT p);
void AlphaLogpowGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py, TYPOUT p);
void AlphaGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaFrontMaxGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
void AlphaFrontMinGrain(TYPIN *in, TYPOUT *out, int sx, int sy, int res, int N, int Ux, int Uy, int Px, int Py);
#endif /* __STDC__ */
