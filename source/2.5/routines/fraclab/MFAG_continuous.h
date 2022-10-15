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

#ifndef _MFAG_continuous_h_
#define _MFAG_continuous_h_
#include "MFAM_include.h"
#include "MFAM_kernel.h"
#include "MFAG_misc.h"
#include "MFAG_hoelder.h"

typedef enum
{
  MFAG_HORI2=0,
  MFAG_HORIANYBASE=1,
  MFAG_HORINOKERN=2,
  MFAG_HORIKERN=3,
  MFAG_VERTNOKERN=4,
  MFAG_VERTKERN=5
} MFAGt_cont;

#define MFAG_HORI2STR "h2"
#define MFAG_HORIANYBASESTR "hany"
#define MFAG_HORINOKERNSTR "hnokern"
#define MFAG_HORIKERNSTR "hkern"
#define MFAG_VERTNOKERNSTR "vnokern"
#define MFAG_VERTKERNSTR "vkern"

#ifndef __STDC__
extern int MFAG_contstr();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_contstr();
#else /* __STDC__ */
extern int MFAG_contstr(char*,MFAGt_cont*);
#endif /* __STDC__ */
#endif /* __STDC__ */

/*****************************************************************************/
/*****************************************************************************/
/* horizontal sections                                                       */
/*****************************************************************************/
/*****************************************************************************/

/* horizontal sections, without precision, without scale (base 2)            */

#ifndef __STDC__
extern int MFAG_cp2();
extern int MFAG_star_2_n_x();
extern int MFAG_cfg2();
extern int MFAG_mcfg2();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_cp2();
extern int MFAG_star_2_n_x();
extern int MFAG_cfg2();
extern int MFAG_mcfg2();
#else /* __STDC__ */
extern int MFAG_cp2(short,double*,double*,int,double*,double*);
extern int MFAG_star_2_n_x(short,double*,double*,double,double,int*,double*);
extern int MFAG_cfg2(short,double*,double*,MFAGt_norm,short,double*,double*,double*);
extern int MFAG_mcfg2(short,double*,double*,MFAGt_norm,short,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

/* with horizontal sections, with precision, without scale (base 2)          */

#ifndef __STDC__
extern int MFAG_2_m_x_epsilon();
extern int MFAG_2_m_x_interpol();
extern int MFAG_2_m_x_lr();
extern int MFAG_fgc_2_n_epsilon();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_2_m_x_epsilon();
extern int MFAG_2_m_x_interpol();
extern int MFAG_2_m_x_lr();
extern int MFAG_fgc_2_n_epsilon();
#else /* __STDC__ */
extern int MFAG_2_m_x_epsilon(short,double*,double*,double,double,int*,double*);
extern int MFAG_2_m_x_interpol(short,double*,double*,double,int*,double*);
extern int MFAG_2_m_x_lr(short,double*,double*,double,double,double*,double*,int*);
extern int MFAG_fgc_2_n_epsilon(short,short,double*,double*,short,double*,double,int,int,int,int,double*,double*,int);
#endif /* __STDC__ */
#endif /* __STDC__ */

/* with horizontal sections, without precision, without scale (any base)     */

#ifndef __STDC__
extern int MFAG_cpn();
extern int MFAG_cfgn();
extern int MFAG_mcfgn();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_cpn();
extern int MFAG_cfgn();
extern int MFAG_mcfgn();
#else /* __STDC__ */
extern int MFAG_cpn(int,double*,double*,int,double*,double*);
extern int MFAG_cfgn(int,double*,double*,MFAGt_norm,short,double*,double*,double*);
extern int MFAG_mcfgn(int,double*,double*,MFAGt_norm,short,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

/* with horizontal sections, with scale, without precision                   */

#ifndef __STDC__
extern int MFAG_cp();
extern int MFAG_cfg();
extern int MFAG_mcfg();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_cp();
extern int MFAG_cfg();
extern int MFAG_mcfg();
#else /* __STDC__ */
extern int MFAG_cp(double,int,double*,double*,int,double*,double*);
extern int MFAG_cfg(short,double*,int,double*,double*,MFAGt_norm,short,double*,double*,double*);
extern int MFAG_mcfg(int,double*,double*,MFAMt_prog,MFAMt_ball,short,double,double,int,double*,double*,double*,MFAGt_norm,short,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

/* with horizontal sections, with scale, with precision, with/without kernel */

#ifndef __STDC__
extern double MFAG_ke();
extern int MFAG_kcpe();
extern int MFAG_kcfge();
extern int MFAG_mkcfge();
extern int MFAG_fkcfge();
#else /* __STDC__ */
#ifndef __STDC__
extern double MFAG_ke();
extern int MFAG_kcpe();
extern int MFAG_kcfge();
extern int MFAG_mkcfge();
extern int MFAG_fkcfge();
#else /* __STDC__ */
extern double MFAG_ke(double(*)(double),double,double,double);
extern int MFAG_kcpe(double,int,double*,double*,double(*)(double),short,double*,double*,double*);
extern int MFAG_kcfge(short,double*,int,double*,double*,MFAGt_adap,MFAMt_kern,MFAGt_norm,short,double*,double*,double*,double*,double*);
extern int MFAG_mkcfge(int,double*,double*,MFAMt_ball,MFAMt_prog,short,double,double,int,double*,double*,double*,MFAGt_adap,MFAMt_kern,MFAGt_norm,short,double*,double*,double*,double*,double*);
extern int MFAG_fkcfge(int,double*,double*,MFAMt_prog,MFAMt_osc,double,double,double,short,double*,double*,short,double*,MFAGt_adap,MFAMt_kern,MFAGt_norm,double*,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

/*****************************************************************************/
/*****************************************************************************/
/* vertical sections                                                         */
/*****************************************************************************/
/*****************************************************************************/

/* with vertical sections, with scale, with precision, without kernel        */

#ifndef __STDC__
extern double MFAG_g_eta_epsilon_x_y();
extern int MFAG_vpc_eta_epsilon_y();
extern int MFAG_vcfge();
extern int MFAG_mvcfge();
#else /* __STDC__ */
#ifndef __STDC__
extern double MFAG_g_eta_epsilon_x_y();
extern int MFAG_vpc_eta_epsilon_y();
extern int MFAG_vcfge();
extern int MFAG_mvcfge();
#else /* __STDC__ */
extern double MFAG_g_eta_epsilon_x_y(int,double,double*,int,double,double,double);
extern int MFAG_vpc_eta_epsilon_y(int,double,double*,double,short,double,double*,double*);
extern int MFAG_vcfge(int,double,double*,double,MFAGt_norm,short,double*,double*,double*,double*);
extern int MFAG_mvcfge(int,double*,double*,int,double,int,MFAGt_norm,short,double*,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

/* with vertical sections, with scale, with precision, with kernel           */

#ifndef __STDC__
extern double MFAG_kg_eta_epsilon_x_alpha();
extern int MFAG_vkcpe();
extern int MFAG_mvkcfge();
#else /* __STDC__ */
#ifndef __STDC__
extern double MFAG_kg_eta_epsilon_x_alpha();
extern int MFAG_vkcpe();
extern int MFAG_mvkcfge();
#else /* __STDC__ */
extern double MFAG_kg_eta_epsilon_x_alpha(int,double,double*,int,double,double,double(*)(double),double);
extern int MFAG_vkcpe(int,double,double*,double,double(*)(double),int,double,double*,double*);
extern int MFAG_mvkcfge(int,double*,double*,int,double,MFAMt_kern,MFAGt_norm,short,double*,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

/*****************************************************************************/

#ifndef __STDC__
extern int MFAG_cfg1d();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_cfg1d();
#else /* __STDC__ */
extern int MFAG_cfg1d(short,double*,int,double*,double*,short,double*,MFAGt_cont,MFAGt_adap,MFAMt_kern,MFAGt_norm,double*,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
extern int MFAG_mcfg1d();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_mcfg1d();
#else /* __STDC__ */
extern int MFAG_mcfg1d(int,double*,double*,double,double,short,MFAMt_prog,MFAMt_ball,double*,int,double*,double*,short,double*,MFAGt_cont,MFAGt_adap,MFAMt_kern,MFAGt_norm,double*,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
extern int MFAG_fcfg1d();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_fcfg1d();
#else /* __STDC__ */
extern int MFAG_fcfg1d(int,double*,double*,MFAMt_prog,MFAMt_osc,double,double,double,short,double*,double*,short,double*,MFAGt_cont,MFAGt_adap,MFAMt_kern,MFAGt_norm,double*,double*,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#endif /*_MFAG_continuous_h_*/
