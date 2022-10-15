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

#include "MFAM_kernel.h"

/*****************************************************************************/
/* compact support                                                           */
/*****************************************************************************/

/* boxcar kernel */
#ifndef __STDC__
double MFAM_boxcar(x)
     double x;
#else /* __STDC__ */
double MFAM_boxcar(double x)
#endif /* __STDC__ */
{
  if(fabs(x)>.5)
    return 0.;
  else
    return 1.;
}

/* triangle kernel */
#ifndef __STDC__
double MFAM_triangle(x)
     double x;
#else /* __STDC__ */
double MFAM_triangle(double x)
#endif /* __STDC__ */
{
  if(fabs(x)>.5)
    return 0.;
  else if(x>0.)
    return 1-2.*x;
  else 
    return 1+2.*x;
}

/* Mollifier kernel */
#ifndef __STDC__
double MFAM_mol(x)
     double x;
#else /* __STDC__ */
double MFAM_mol(double x)
#endif /* __STDC__ */
{
  if(fabs(x)>.5)
    return 0.;
  else
    return exp(-1/fabs(1-x*x))/MOLLIFIER;
}

/* Epanechnikov kernel */
#ifndef __STDC__
double MFAM_epa(x)
     double x;
#else /* __STDC__ */
double MFAM_epa(double x)
#endif /* __STDC__ */
{
  if(fabs(x)>SQRTFIVE)
    return 0.;
  else
    return EPANECHNIKOV*(1-x*x/5.);
}

/*****************************************************************************/
/* non-compact support                                                       */
/*****************************************************************************/

/* normalized reduced Gaussian kernel */
#ifndef __STDC__
double MFAM_gauss(x)
     double x;
#else /* __STDC__ */
double MFAM_gauss(double x)
#endif /* __STDC__ */
{
  return exp(-x*x/2.)/SQRTTWOPI;
}

/*****************************************************************************/

#ifndef __STDC__
int MFAM_kernelstr(kernelstr, t_kern)
     char *kernelstr;
     MFAMt_kern *t_kern;
#else /* __STDC__ */
int MFAM_kernelstr(char* kernelstr,MFAMt_kern* t_kern)
#endif /* __STDC__ */
{
  if(strcmp(MFAM_INTEGRATEDSTR,kernelstr)==0)
    *t_kern=MFAM_INTEGRATED;
  else if(strcmp(MFAM_BOXCARSTR,kernelstr)==0)
    *t_kern=MFAM_BOXCAR;
  else if(strcmp(MFAM_TRIANGLESTR,kernelstr)==0)
    *t_kern=MFAM_TRIANGLE;
  else if(strcmp(MFAM_GAUSSIANSTR,kernelstr)==0)
    *t_kern=MFAM_GAUSSIAN;   
  else if(strcmp(MFAM_MOLLIFIERSTR,kernelstr)==0)
    *t_kern=MFAM_MOLLIFIER;
  else if(strcmp(MFAM_EPANECHNIKOVSTR,kernelstr)==0)
    *t_kern=MFAM_EPANECHNIKOV; 
  else 
    return 0;
  return 1;
}
