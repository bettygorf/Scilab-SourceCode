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

#ifndef _MFAM_regression_h_
#define _MFAM_regression_h_
#include "MFAM_misc.h"
#include "MFAM_lepskii.h"

typedef enum
{
  MFAM_LSLR=0,
  MFAM_WLSLR=1,
  MFAM_PLSLR=2, 
  MFAM_MLSLR=3, 
  MFAM_MLLR=4, 
  MFAM_LAPLSLR=5
} MFAMt_lr;

#define MFAM_LSLRSTR "ls"
#define MFAM_WLSLRSTR "wls"
#define MFAM_PLSLRSTR "pls"
#define MFAM_MLSLRSTR "mls"
#define MFAM_MLLRSTR "ml"
#define MFAM_LAPLSSTR "lapls"

#ifndef __STDC__
extern int MFAM_lrstr();
extern int MFAM_lr();
extern int MFAM_lslr();
extern int MFAM_wlslr();
extern int MFAM_uniform_w();
extern int MFAM_plslr();
extern int MFAM_normal_w();
extern int MFAM_mlslr();
extern int MFAM_mllr();
extern int MFAM_ml_w();
extern int MFAM_laplslr();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAM_lrstr();
extern int MFAM_lr();
extern int MFAM_lslr();
extern int MFAM_wlslr();
extern int MFAM_uniform_w();
extern int MFAM_plslr();
extern int MFAM_normal_w();
extern int MFAM_mlslr();
extern int MFAM_mllr();
extern int MFAM_ml_w();
extern int MFAM_laplslr();
#else /* __STDC__ */
extern int MFAM_lrstr(char*,MFAMt_lr*);
extern int MFAM_lr(int,double*,double*,MFAMt_lr,double,double*,double*,short,double,double,double*,double*,double*,double*,double*,double*,double*,double*,double*,double*,double*);
extern int MFAM_lslr(int,double*,double*,double*,double*,double*,double*,double*);
extern int MFAM_wlslr(int,double*,double*,double*,double*,double*,double*,double*,double*);
extern int MFAM_uniform_w(int,double*);
extern int MFAM_plslr(int,double*,double*,double*,double*,double*,double*,double*,double*,short,double,double);
extern int MFAM_normal_w(int,double*,double,double,double*);
extern int MFAM_mlslr(int,double*,double*,double*,double*,double*,double*,double*);
extern int MFAM_mllr(int,double*,double*,double*,double*,double*,double*,double*,double*,double*);
extern int MFAM_ml_w(int,double*,double*);
extern int MFAM_laplslr(int,double*,double*,double*,double*,double*,double*,double*,double,double*,double*,double*,double*,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#endif /*_MFAM_regression_h_*/
