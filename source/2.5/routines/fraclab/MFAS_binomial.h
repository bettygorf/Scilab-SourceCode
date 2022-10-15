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

#ifndef MFAS_binomial_h_
#define MFAS_binomial_h_
#include "MFAM_include.h"
#include "MFAM_random.h"

#ifndef __STDC__
extern int MFAS_bm1d();
extern int MFAS_recursive_bm1d();
extern int MFAS_sbm1d();
extern int MFAS_ubm1d();
extern int MFAS_rbm1d();
extern int MFAS_sumbm1d();
extern int MFAS_lumpbm1d();
extern int MFAS_sumrbm1d();
extern int MFAS_lumprbm1d();
extern int MFAS_bm1d_Z_n_q();
extern int MFAS_bm1d_tau_q();
extern int MFAS_bm1dcdf();
extern int MFAS_phi_n_k_2();
extern int MFAS_phi_n_x_2();
extern int MFAS_bm1dch();
extern int MFAS_bm1dh();
extern int MFAS_x_n_2();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAS_bm1d();
extern int MFAS_recursive_bm1d();
extern int MFAS_sbm1d();
extern int MFAS_ubm1d();
extern int MFAS_rbm1d();
extern int MFAS_sumbm1d();
extern int MFAS_lumpbm1d();
extern int MFAS_sumrbm1d();
extern int MFAS_lumprbm1d();
extern int MFAS_bm1d_Z_n_q();
extern int MFAS_bm1d_tau_q();
extern int MFAS_bm1dcdf();
extern int MFAS_phi_n_k_2();
extern int MFAS_phi_n_x_2();
extern int MFAS_bm1dch();
extern int MFAS_bm1dh();
extern int MFAS_x_n_2();
#else /* __STDC__ */
extern int MFAS_bm1d(short,double,double*);
extern int MFAS_recursive_bm1d(short,double,double*);
extern int MFAS_sbm1d(short,double,double*);
extern int MFAS_ubm1d(short,double,double*);
extern int MFAS_rbm1d(short,double,double,double*);
extern int MFAS_sumbm1d(short,double,double,double*);
extern int MFAS_lumpbm1d(short,double,double,double*);
extern int MFAS_sumrbm1d(short,double,double,double,double*);
extern int MFAS_lumprbm1d(short,double,double,double,double*);
extern int MFAS_bm1d_Z_n_q(double,int,short*,int,double*,double*);
extern int MFAS_bm1d_tau_q(double,int,double*,double*);
extern int MFAS_bm1dcdf(int,double,double*);
extern int MFAS_phi_n_k_2(short,int,int*);
extern int MFAS_phi_n_x_2(short,double,int*);
extern int MFAS_bm1dch(short,double,int,double*,double*);
extern int MFAS_bm1dh(double,double,double*);
extern int MFAS_x_n_2(short,double,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */


#endif /*MFAS_binomial_h_*/

