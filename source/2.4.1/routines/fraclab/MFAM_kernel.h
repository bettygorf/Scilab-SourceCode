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

#ifndef _MFAM_kernel_h_
#define _MFAM_kernel_h_

#include "MFAM_include.h"
#ifndef TWOPI
#define TWOPI 6.2831853 /* 2.*PI */
#endif /* TWOPI */

#ifndef SQRTTWOPI
#define SQRTTWOPI 2.5066283 /* sqrt(TWOPI) */
#endif /* SQRTTWOPI */

#ifndef MOLLIFIER
#define MOLLIFIER 0.4439938162
#endif /* MOLLIFIERT */

#ifndef SQRTFIVE
#define SQRTFIVE 2.236068 /* sqrt(5.) */
#endif /* SQRTFIVE */

#ifndef EPANECHNIKOV
#define EPANECHNIKOV 1.677051 /* 3./4.*sqrt(5.) */
#endif /* EPANECHNIKOV */

#define MFAM_INTEGRATEDSTR "integrated"
#define MFAM_BOXCARSTR "box"
#define MFAM_TRIANGLESTR "tri"
#define MFAM_GAUSSIANSTR "gau"
#define MFAM_MOLLIFIERSTR "mol"
#define MFAM_EPANECHNIKOVSTR "epa"

typedef enum
{
  MFAM_INTEGRATED=0,
  MFAM_BOXCAR=1,
  MFAM_TRIANGLE=2,
  MFAM_GAUSSIAN=3,
  MFAM_MOLLIFIER=4,
  MFAM_EPANECHNIKOV=5
} MFAMt_kern;

#ifndef __STDC__
extern double MFAM_boxcar();
extern double MFAM_triangle();
extern double MFAM_gauss();
extern double MFAM_mol();
extern double MFAM_epa();
#else /* __STDC__ */
#ifndef __STDC__
extern double MFAM_boxcar();
extern double MFAM_triangle();
extern double MFAM_gauss();
extern double MFAM_mol();
extern double MFAM_epa();
#else /* __STDC__ */
extern double MFAM_boxcar(double);
extern double MFAM_triangle(double);
extern double MFAM_gauss(double);
extern double MFAM_mol(double);
extern double MFAM_epa(double);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
extern int MFAM_kernelstr();
#else /* __STDC__ */
#ifndef __STDC__
extern int MFAM_kernelstr();
#else /* __STDC__ */
extern int MFAM_kernelstr(char*,MFAMt_kern*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#endif /*_MFAM_kernel_h_*/ 
