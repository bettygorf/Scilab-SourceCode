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

#ifndef _MFAG_hoelder_h_
#define _MFAG_hoelder_h_
#include "MFAM_include.h"
#include "MFAM_measure.h"
#include "MFAM_oscillation.h"
#include "MFAG_misc.h"

/*****************************************************************************/
/* on measures                                                               */
/*****************************************************************************/

#ifndef __STDC__
extern int MFAG_alpha_2_n();
extern int MFAG_alpha_2_n2d();
extern int MFAG_alpha_star_2_n();
extern int MFAG_alpha_n();
extern int MFAG_alpha_n2d();
extern int MFAG_alpha_eta();
extern int MFAG_alpha_eta_j();
extern int MFAG_alpha_eta_x();
extern int MFAG_alpha_eta_star_x();
extern int MFAG_alpha_eta_c_x();
extern int MFAG_mch1d();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_alpha_2_n();
extern int MFAG_alpha_2_n2d();
extern int MFAG_alpha_star_2_n();
extern int MFAG_alpha_n();
extern int MFAG_alpha_n2d();
extern int MFAG_alpha_eta();
extern int MFAG_alpha_eta_j();
extern int MFAG_alpha_eta_x();
extern int MFAG_alpha_eta_star_x();
extern int MFAG_alpha_eta_c_x();
extern int MFAG_mch1d();
#else /* __STDC__ */
extern int MFAG_alpha_2_n(short,double*,double*);
extern int MFAG_alpha_2_n2d(short,double*,double*);
extern int MFAG_alpha_star_2_n(short,double*,double*);
extern int MFAG_alpha_n(int,double*,double*);
extern int MFAG_alpha_n2d(int,int,double*,double*);
extern int MFAG_alpha_eta(int,double*,double,double*);
extern int MFAG_alpha_eta_j(int,double*,double,double*);
extern int MFAG_alpha_eta_x(int,double*,double*,double,int,double,double,double,double*);
extern int MFAG_alpha_eta_star_x(int,double*,double*,double,int,double,double,double,double*);
extern int MFAG_alpha_eta_c_x(int,double*,double*,double,int,double,double,double,double*);
extern int MFAG_mch1d(int,double*,double*,MFAMt_prog,MFAMt_ball,short,double,double,int,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

/*****************************************************************************/
/* on functions                                                              */
/*****************************************************************************/

#ifndef __STDC__
extern int MFAG_flh_eta();
extern int MFAG_fph_eta();
extern int MFAG_fch1d();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_flh_eta();
extern int MFAG_fph_eta();
extern int MFAG_fch1d();
#else /* __STDC__ */
extern int MFAG_flh_eta(double,int,double*,double*);
extern int MFAG_fph_eta(double,int,double*,double*,double*);
extern int MFAG_fch1d(int,double*,double*,short,double,double,MFAMt_prog,MFAMt_osc,double,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#endif /*_MFAG_hoelder_h_*/


