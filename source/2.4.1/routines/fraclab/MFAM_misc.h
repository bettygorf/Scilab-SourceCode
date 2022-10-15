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

#ifndef _MFAM_misc_h_
#define _MFAM_misc_h_
#include "MFAM_include.h"

#ifndef __STDC__
extern int MFAM_compare();
extern int MFAM_base();
extern int MFAM_zeros();
extern int MFAM_iszeros();
extern int MFAM_linspace();
extern int MFAM_logspace();
extern int MFAM_decspace();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAM_compare();
extern int MFAM_base();
extern int MFAM_zeros();
extern int MFAM_iszeros();
extern int MFAM_linspace();
extern int MFAM_logspace();
extern int MFAM_decspace();
#else /* __STDC__ */
extern int MFAM_compare(double*,double*);
extern int MFAM_base(int,short*);
extern int MFAM_zeros(int,double*);
extern int MFAM_iszeros(int,double*);
extern int MFAM_linspace(int,double,double,double*);
extern int MFAM_logspace(int,double,double,double*);
extern int MFAM_decspace(int,int,double,double,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

typedef enum
{ 
  MFAM_LIN=0,
  MFAM_LOG=1,
  MFAM_DEC=2
} MFAMt_prog;

#define MFAM_DECSTR "dec"
#define MFAM_LINSTR "lin"
#define MFAM_LOGSTR "log"

#ifndef __STDC__
extern int MFAM_progstr();
extern int MFAM_scale();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAM_progstr();
extern int MFAM_scale();
#else /* __STDC__ */
extern int MFAM_progstr(char*,MFAMt_prog*);
extern int MFAM_scale(int,double,double,short,double*,MFAMt_prog);
#endif /* __STDC__ */
#endif /* __STDC__ */

typedef enum
{
  MFAM_DECSIZE=0,
  MFAM_LINPART=1,
  MFAM_LOGPART=2,
  MFAM_DECPART=3
} MFAMt_part;

#define MFAM_DECSIZESTR "decsize"
#define MFAM_LINPARTSTR "linpart"
#define MFAM_LOGPARTSTR "logpart"
#define MFAM_DECPARTSTR "decpart"

#ifndef __STDC__
extern int MFAM_partstr();
extern int MFAM_partspace();
extern int MFAM_decsizespace();
extern int MFAM_bilogspace();
extern int MFAM_weights();
extern int MFAM_weights2d();
extern int MFAM_min_max();
extern int MFAM_min_max_dev();
extern int MFAM_norm();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAM_partstr();
extern int MFAM_partspace();
extern int MFAM_decsizespace();
extern int MFAM_bilogspace();
extern int MFAM_weights();
extern int MFAM_weights2d();
extern int MFAM_min_max();
extern int MFAM_min_max_dev();
extern int MFAM_norm();
#else /* __STDC__ */
extern int MFAM_partstr(char*,MFAMt_part*);
extern int MFAM_partspace(int,MFAMt_part,int,double,double,double*);
extern int MFAM_decsizespace(int,int,double,double,double*);
extern int MFAM_bilogspace(int,short,double,double,double*);
extern int MFAM_weights(short,double*);
extern int MFAM_weights2d(short,short,double*);
extern int MFAM_min_max(int,double*,double*,double*);
extern int MFAM_min_max_dev(int,double*,double*,double*);
extern int MFAM_norm(int,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#endif /*_MFAM_misc_h_*/
