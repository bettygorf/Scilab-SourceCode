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

#ifndef _MFAM_tree_h_
#define _MFAM_tree_h_
#include "MFAM_include.h"

typedef struct _bnode
{
   char* x;
   short n;
   int   k;
   double* c;
   double* h;
   struct _bnode* lnode;
   struct _bnode* rnode;
} bnode;

typedef struct _btree
{
   short N;
   double** c_level;
   double** h_level;
   unsigned char** s_level;
   bnode* root;
} btree;


#ifndef __STDC__
bnode *bnode_create();
void bnode_read();
void bnode_delete();
#else /* __STDC__ */
#ifndef __STDC__
bnode *bnode_create();
void bnode_read();
void bnode_delete();
#else /* __STDC__ */
bnode *bnode_create(bnode*,char*,short,int,short);
void bnode_read(bnode*);
void bnode_delete(bnode*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
btree *btree_create();
void btree_read();
#else /* __STDC__ */
#ifndef __STDC__
btree *btree_create();
void btree_read();
#else /* __STDC__ */
btree *btree_create(short);
void btree_read(btree*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
int btree_ccreate();
#else /* __STDC__ */
#ifndef __STDC__
int btree_ccreate();
#else /* __STDC__ */
int btree_ccreate(btree*,short);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
int btree_cread();
void bnode_cread();
#else /* __STDC__ */
#ifndef __STDC__
int btree_cread();
void bnode_cread();
#else /* __STDC__ */
int btree_cread(btree*);
void bnode_cread(bnode*,btree*);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
void bnode_cset();
btree *btree_binomial();
void bnode_binomial();
#else /* __STDC__ */
#ifndef __STDC__
void bnode_cset();
btree *btree_binomial();
void bnode_binomial();
#else /* __STDC__ */
void bnode_cset(bnode*,btree*,double);
btree *btree_binomial(short,double);
void bnode_binomial(bnode*,btree*,double,double);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
int btree_h();
#else /* __STDC__ */
#ifndef __STDC__
int btree_h();
#else /* __STDC__ */
int btree_h(btree*,short,short);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
int btree_hcreate();
int btree_hset();
void bnode_hread();
int btree_hread();
int btree_h_levelread();
#else /* __STDC__ */
#ifndef __STDC__
int btree_hcreate();
int btree_hset();
void bnode_hread();
int btree_hread();
int btree_h_levelread();
#else /* __STDC__ */
int btree_hcreate(btree*,short,short);
int btree_hset(btree*,short,short);
void bnode_hread(bnode*,btree*,short,short);
int btree_hread(btree*,short,short);
int btree_h_levelread(btree*,short);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
int btree_isos();
#else /* __STDC__ */
#ifndef __STDC__
int btree_isos();
#else /* __STDC__ */
int btree_isos(btree*,short,double,double);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
btree* btree_screate();
int btree_isosset();
int btree_s_levelread();
int btree_s_leveldelete();
#else /* __STDC__ */
#ifndef __STDC__
btree* btree_screate();
int btree_isosset();
int btree_s_levelread();
int btree_s_leveldelete();
#else /* __STDC__ */
btree* btree_screate(btree*,short,short);
int btree_isosset(btree*,short,double,double);
int btree_s_levelread(btree*,short);
int btree_s_leveldelete(btree*,short);
#endif /* __STDC__ */
#endif /* __STDC__ */

#ifndef __STDC__
int btree_isosN();
int bnode_isosNset();
#else /* __STDC__ */
#ifndef __STDC__
int btree_isosN();
int bnode_isosNset();
#else /* __STDC__ */
int btree_isosN(btree*,short,double,double);
int bnode_isosNset(bnode*,btree*,short,double,double);
#endif /* __STDC__ */
#endif /* __STDC__ */

#endif /*_MFAM_tree_h_*/
