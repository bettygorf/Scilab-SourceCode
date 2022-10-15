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

#ifndef _MFAG_misc_h_
#define _MFAG_misc_h_
#include "MFAM_include.h"
#include "MFAM_misc.h"

#ifndef __STDC__
extern int MFAG_hoelder();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_hoelder();
#else /* __STDC__ */
extern int MFAG_hoelder(int,short,double*,int,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */

typedef enum
{ 
  MFAG_MAXDEV=0,
  MFAG_MINDEV=1,
  MFAG_MEANDEV=2,
  MFAG_MEANADAPTDEV=3,
  MFAG_MAXADAPTDEV=4,
  MFAG_ONEMODADAPTDEV=5,
} MFAGt_adap;

#define MFAG_MAXDEVSTR "maxdev"
#define MFAG_MINDEVSTR "mindev"
#define MFAG_MEANDEVSTR "meandev"
#define MFAG_MEANADAPTDEVSTR "meanadaptdev"
#define MFAG_MAXADAPTDEVSTR "maxadaptdev"
#define MFAG_ONEMODADAPTDEVSTR "onemodadaptdev"

#ifndef __STDC__
extern int MFAG_adapstr();
extern int MFAG_adaptation();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_adapstr();
extern int MFAG_adaptation();
#else /* __STDC__ */
extern int MFAG_adapstr(char*,MFAGt_adap*);
extern int MFAG_adaptation(int,double*,int,double*,double*,MFAGt_adap);
#endif /* __STDC__ */
#endif /* __STDC__ */

typedef enum
{ 
  MFAG_NONORM=0,
  MFAG_SUPPDF=1,
  MFAG_SUPFG=2,
  MFAG_INFSUPPDF=3,
  MFAG_INFSUPFG=4
} MFAGt_norm;

#define MFAG_NONORMSTR "nonorm"
#define MFAG_SUPPDFSTR "suppdf"
#define MFAG_SUPFGSTR "supfg"
#define MFAG_INFSUPPDFSTR "infsuppdf"
#define MFAG_INFSUPFGSTR "infsupfg"

#ifndef __STDC__
extern int MFAG_normstr();
extern int MFAG_norm();
extern int MFAG_alpha_eta_x_extrema();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAG_normstr();
extern int MFAG_norm();
extern int MFAG_alpha_eta_x_extrema();
#else /* __STDC__ */
extern int MFAG_normstr(char*,MFAGt_norm*);
extern int MFAG_norm(MFAGt_norm,double,short,double*,double*,double*);
extern int MFAG_alpha_eta_x_extrema(int,double,double*,double,double,double*,double*);
#endif /* __STDC__ */
#endif /* __STDC__ */


#endif /*_MFAG_misc_h_*/
