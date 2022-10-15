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

#ifndef INCLUDE_KOUTROUVELIS
#define INCLUDE_KOUTROUVELIS
typedef struct FCOMPLEX {double r,i;} fcomplex;

#ifndef __STDC__
extern fcomplex stable_Complex();
extern fcomplex stable_Cadd();
extern fcomplex stable_Cquo();
extern fcomplex  stable_phiemp();
extern double stable_Cabs();
extern void stable_reg();
#else /* __STDC__ */
extern fcomplex stable_Complex(double re, double im);
extern fcomplex stable_Cadd(fcomplex a, fcomplex b);
extern fcomplex stable_Cquo(fcomplex a, double b);
extern fcomplex  stable_phiemp(double t, double *data, int n);
extern double stable_Cabs(fcomplex z);
extern void stable_reg(double x[], double y[], int ndata, int m, double *a,
	double *b, double *siga, double *sigb);
#endif /* __STDC__ */

#endif /* INCLUDE_KOUTROUVELIS */
