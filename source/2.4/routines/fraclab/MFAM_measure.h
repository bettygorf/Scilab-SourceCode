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

#ifndef _MFAS_measure_h_
#define _MFAS_measure_h_
#include "MFAM_include.h"

typedef enum
{
  MFAM_ASYMMETRIC=0,
  MFAM_STAR=1,
  MFAM_CENTERED=2
} MFAMt_ball;

#define MFAM_ASYMMETRICSTR "asym"
#define MFAM_STARSTR "star"
#define MFAM_CENTEREDSTR "cent"


#ifndef __STDC__
extern int MFAM_ballstr();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAM_ballstr();
#else /* __STDC__ */
extern int MFAM_ballstr(char*,MFAMt_ball*);
#endif /* __STDC__ */
#endif /* __STDC__ */

typedef enum
{
  MFAM_NOBORD=0,
  MFAM_MIRROR=1,
  MFAM_PERIOD=2,
} MFAMt_bord;

#define MFAM_NOBORDSTR "nobord"
#define MFAM_MIRRORSTR "mir"
#define MFAM_PERIODSTR "per"

#ifndef __STDC__
extern int MFAM_bordstr();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAM_bordstr();
#else /* __STDC__ */
extern int MFAM_bordstr(char*,MFAMt_bord*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
extern double MFAM_mu_S1d();
extern double MFAM_mu_S2d();
#else /* __STDC__ */
#ifndef __STDC__
extern double MFAM_mu_S1d();
extern double MFAM_mu_S2d();
#else /* __STDC__ */
extern double MFAM_mu_S1d(double*,int);
extern double MFAM_mu_S2d(double*,int,int,int);
#endif /* __STDC__ */
#endif /* __STDC__ */
int FRflg;
#ifndef __STDC__
extern double MFAM_mu_P1d();
extern double MFAM_mu_2_n_x();
extern double MFAM_mu_star_2_n_x();
extern double MFAM_mu_n_x();
extern double MFAM_mu_eta();
extern double MFAM_mu_eta_x();
extern double MFAM_mu_eta_star_x();
extern double MFAM_mu_eta_c_x();
extern double MFAM_mu_eta_b_x();
#else /* __STDC__ */
#ifndef __STDC__
extern double MFAM_mu_P1d();
extern double MFAM_mu_2_n_x();
extern double MFAM_mu_star_2_n_x();
extern double MFAM_mu_n_x();
extern double MFAM_mu_eta();
extern double MFAM_mu_eta_x();
extern double MFAM_mu_eta_star_x();
extern double MFAM_mu_eta_c_x();
extern double MFAM_mu_eta_b_x();
#else /* __STDC__ */
extern double MFAM_mu_P1d(int,double*,int);
extern double MFAM_mu_2_n_x(short,double*,double*,double,int);
extern double MFAM_mu_star_2_n_x(short,double*,double*,double);
extern double MFAM_mu_n_x(int,double*,double*,double);
extern double MFAM_mu_eta(int,double*,int,double);
extern double MFAM_mu_eta_x(int,double*,double*,double,double,double,double);
extern double MFAM_mu_eta_star_x(int,double*,double*,double,double,double,double);
extern double MFAM_mu_eta_c_x(int,double*,double*,double,double,double,double);
extern double MFAM_mu_eta_b_x(int,double*,double*,double,double,double,double,MFAMt_ball,MFAMt_bord);
#endif /* __STDC__ */
#endif /* __STDC__ */

#endif /*_MFAS_measure_h_*/
