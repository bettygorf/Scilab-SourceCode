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

/* Christophe Canus 1997-98 */

#ifndef _MFAM_oscillation_h_
#define _MFAM_oscillation_h_
#include "MFAM_include.h"

typedef enum
{
  MFAM_OSC=0,
  MFAM_OSCDELTA=2,
  MFAM_LINFTY=3,
  MFAM_LP=4
} MFAMt_osc;

#define MFAM_OSCSTR "osc"
#define MFAM_OSCDELTASTR "oscdelta"
#define MFAM_LINFTYSTR "linfty"
#define MFAM_LPSTR "l"

#ifndef __STDC__
extern int MFAM_oscstr();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAM_oscstr();
#else /* __STDC__ */
extern int MFAM_oscstr(char*,MFAMt_osc*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
extern int MFAM_osc_eta_x();
extern int MFAM_osc_eta_deltax();
extern int MFAM_Linfty_eta_x();
extern int MFAM_Lp_eta_x();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAM_osc_eta_x();
extern int MFAM_osc_eta_deltax();
extern int MFAM_Linfty_eta_x();
extern int MFAM_Lp_eta_x();
#else /* __STDC__ */
extern int MFAM_osc_eta_x(int,double,double*,double,double*);
extern int MFAM_osc_eta_deltax(int,double,double*,double,double*,double*);
extern int MFAM_Linfty_eta_x(int,double,double*,double,double*);
extern int MFAM_Lp_eta_x(int,double,double*,double,double,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */


#endif /*_MFAM_oscillation_h_*/

