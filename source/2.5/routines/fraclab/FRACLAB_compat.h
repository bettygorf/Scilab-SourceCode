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

#include <stdlib.h>


#ifndef INCLUDE_FRACLAB_COMPAT
#define INCLUDE_FRACLAB_COMPAT
#if defined(_MSC_VER) || defined(__CYGWIN32__) || (defined __ABSC__)
/* for window compilation */


#ifndef maxaleatoire
#define maxaleatoire RAND_MAX
#endif 

#if defined(_MSC_VER) || (defined __ABSC__)
extern double lrand48();

#ifndef __STDC__
extern void  srand48();
#else /* __STDC__ */
extern void  srand48( long int );
#endif /* __STDC__ */      

extern double drand48();
#endif

#else

#ifndef maxaleatoire
#define maxaleatoire pow(2.,31.)
#endif 

#endif /* WIN */

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif /* M_PI */

#ifndef PI
#define PI 3.14159265358979323846
#endif /* PI */

#ifndef RAND_MAX
#define RAND_MAX pow(2.,31.)-1
#endif /* RAND_MAX */

#ifndef HUGE
#define HUGE 1e6
#endif /* HUGE */

#ifdef MAXFLOAT
#undef HUGE
#define HUGE MAXFLOAT
#endif /* MAXFLOAT */





#endif /* INCLUDE_FRACLAB_COMPAT */
