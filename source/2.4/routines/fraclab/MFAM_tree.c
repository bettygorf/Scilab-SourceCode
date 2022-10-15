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

#include "MFAM_tree.h"

/*****************************************************************************/

#ifndef __STDC__
bnode* bnode_create(node, x, n, k, N)
     bnode *node;
     char *x;
     short int n;
     int k;
     short int N;
#else /* __STDC__ */
bnode* bnode_create(bnode* node,char* x,short n,int k,short N)
#endif /* __STDC__ */
{
  char* x0=NULL;
  char* x1=NULL;
  if (node==NULL)
  {	
    if((node=(bnode*)malloc(sizeof(bnode)))==NULL)
    { 
      fprintf(stdout,"malloc error\n");
      return NULL;
    }
    node->x=x;
    node->n=n;
    node->k=k;
    node->lnode=NULL;
    node->rnode=NULL;
  }
  if(n!=N)
  {
    x0=(char*)malloc((strlen(x)+1)*sizeof(char));
    sprintf(x0,"%s%d",x,0); 
    node->lnode=bnode_create(node->lnode,x0,n+1,2*k,N);
    x1=(char*)malloc((strlen(x)+1)*sizeof(char));
    sprintf(x1,"%s%d",x,1); 
    node->rnode=bnode_create(node->rnode,x1,n+1,2*k+1,N);
  }
  return node;
}

/*****************************************************************************/

#ifndef __STDC__
void bnode_delete(node)
     bnode *node;
#else /* __STDC__ */
void bnode_delete(bnode* node)
#endif /* __STDC__ */
{ 
  if (node!=NULL)
  {
    bnode_delete(node->lnode);
    bnode_delete(node->rnode);
    free(node->x);
    free((char*)node);
  }
}

/*****************************************************************************/

#ifndef __STDC__
void bnode_read(node)
     bnode *node;
#else /* __STDC__ */
void bnode_read(bnode* node)
#endif /* __STDC__ */
{ 
  if (node!=NULL)
  {
    fprintf(stdout,"node # x=%s,n=%d,k=%d\n",node->x,node->n,node->k);
    bnode_read(node->lnode);
    bnode_read(node->rnode);
  }
}

/*****************************************************************************/

#ifndef __STDC__
btree* btree_create(N)
     short int N;
#else /* __STDC__ */
btree* btree_create(short N)
#endif /* __STDC__ */
{
  btree* tree=NULL;  
  if((tree=(btree*)malloc(sizeof(btree)))==NULL) 
  { 
    fprintf(stdout,"malloc error\n");
    return NULL;
  }
  tree->N=N;
  tree->root=NULL;
  if((tree->root=bnode_create(tree->root,"0.",0,0,N))==NULL)
  { 
    fprintf(stdout,"root node creation error\n");
    return NULL;
  }
  if(btree_ccreate(tree,N)==0)
    return NULL;
  return tree;
}

/*****************************************************************************/

#ifndef __STDC__
void btree_delete(tree)
     btree *tree;
#else /* __STDC__ */
void btree_delete(btree* tree)
#endif /* __STDC__ */
{ 
  if (tree!=NULL)
  {
    int n=0;
    bnode_delete(tree->root);
    while(n<=tree->N)
    {
      free((char*)*(tree->c_level+n));
      n++;
    }
    free((char*)tree->c_level);
    free((char*)tree);
  }
}

/*****************************************************************************/

#ifndef __STDC__
void btree_read(tree)
     btree *tree;
#else /* __STDC__ */
void btree_read(btree* tree)
#endif /* __STDC__ */
{ 
  if (tree!=NULL)
  {
    fprintf(stdout,"tree with # N=%d,\n",tree->N);
    bnode_read(tree->root);
  }
}

/*****************/ 
#ifndef __STDC__
int btree_ccreate(tree, N)
     btree *tree;
     short int N;
#else /* __STDC__ */
int btree_ccreate(btree *tree,short N)
#endif /* __STDC__ */
{
   if(tree!=NULL)
   {
      short n=0;
      int two_pow_n=0;
      if((tree->c_level=(double**)malloc((N+1)*sizeof(double*)))==NULL)
      { 
	 fprintf(stdout,"malloc error\n");
	 return 0;
      } 
      while(n<=N)
      {
	 two_pow_n=(int)pow(2.,(double)n);
	 if((*(tree->c_level+n)=(double*)malloc(two_pow_n*sizeof(double)))==NULL) 
	 { 
	    fprintf(stdout,"malloc error\n");
	    return 0;
	 }
	 n++;
      }
      return 1;
   }
   else
   {
      fprintf(stdout,"error\n");
      return 0;
   } 
}

/*****************/
#ifndef __STDC__
int btree_cread(tree)
     btree *tree;
#else /* __STDC__ */
int btree_cread(btree *tree)
#endif /* __STDC__ */
{ 
   if(tree!=NULL)
   {
      if(tree->c_level!=NULL)
	 bnode_cread(tree->root,tree);
      else
      {
	 fprintf(stdout,"error\n");
	 return 0;
      }
      return 1;
   }
   else
   { 
      fprintf(stdout,"error\n");
      return 0;
   }
}

/*****************/
#ifndef __STDC__
void bnode_cread(node, tree)
     bnode *node;
     btree *tree;
#else /* __STDC__ */
void bnode_cread(bnode* node,btree* tree)
#endif /* __STDC__ */
{ 
   if (node!=NULL)
   {
      fprintf(stdout,"node # x=%s,n=%d,k=%d\t",node->x,node->n,node->k);
      fprintf(stdout,"c=%f\n",*(*(tree->c_level+node->n)+node->k));
      bnode_cread(node->lnode,tree);
      bnode_cread(node->rnode,tree);
   }
}

/*****************/
#ifndef __STDC__
void bnode_cset(node, tree, c)
     bnode *node;
     btree *tree;
     double c;
#else /* __STDC__ */
void bnode_cset(bnode *node,btree *tree,double c)
#endif /* __STDC__ */
{ 
   if (node!=NULL)
      *(*(tree->c_level+node->n)+node->k)=c;
}

/*****************/
#ifndef __STDC__
void bnode_binomial(node, tree, m0, mu)
     bnode *node;
     btree *tree;
     double m0;
     double mu;
#else /* __STDC__ */
void bnode_binomial(bnode *node,btree *tree,double m0,double mu)
#endif /* __STDC__ */
{ 
   if(node!=NULL)
   {
      bnode_cset(node,tree,mu);
      bnode_binomial(node->lnode,tree,m0,mu*m0);
      bnode_binomial(node->rnode,tree,m0,mu*(1-m0));
   } 
}

/*****************/
#ifndef __STDC__
btree *btree_binomial(N, m0)
     short int N;
     double m0;
#else /* __STDC__ */
btree *btree_binomial(short N,double m0)
#endif /* __STDC__ */
{ 
   btree *tree;
   if((tree=btree_create(N))==NULL)
   {
      fprintf(stdout,"btree create error\n");
      return NULL;
   }
   bnode_binomial(tree->root,tree,m0,1.);
   return tree;
}

/*****************/ 
#ifndef __STDC__
int btree_hcreate(tree, n_min, n_max)
     btree *tree;
     short int n_min;
     short int n_max;
#else /* __STDC__ */
int btree_hcreate(btree *tree,short n_min, short n_max)
#endif /* __STDC__ */
{
   if(tree!=NULL)
   {
      short n=n_min;
      if((tree->h_level=(double**)malloc((n_max+1)*sizeof(double*)))==NULL)
      { 
	 fprintf(stdout,"malloc error\n");
	 return 0;
      } 
      while(n<=n_max)
      {
	 int two_pow_n=(int)pow(2.,(double)n);
	 if((*(tree->h_level+n)=(double*)malloc(two_pow_n*sizeof(double)))==NULL) 
	 { 
	    fprintf(stdout,"malloc error\n");
	    return 0;
	 }
	 n++;
      }
      return 1;
   }
   else
   {
      fprintf(stdout,"error\n");
      return 0;
   } 
}

/*****************/
#ifndef __STDC__
void bnode_hread(node, tree, n_min, n_max)
     bnode *node;
     btree *tree;
     short int n_min;
     short int n_max;
#else /* __STDC__ */
void bnode_hread(bnode *node,btree *tree,short n_min, short n_max)
#endif /* __STDC__ */
{ 
   if (node!=NULL)
   {
      if ((node->n>=n_min)&&(node->n<=n_max))
      {
	 fprintf(stdout,"node # x=%s,n=%d,k=%d\t",node->x,node->n,node->k);
	 fprintf(stdout,"h=%f\n",*(*(tree->h_level+node->n)+node->k));
      }
      bnode_hread(node->lnode,tree,n_min,n_max);
      bnode_hread(node->rnode,tree,n_min,n_max);
   }
}
/*******************/
#ifndef __STDC__
int btree_h_levelread(tree, n)
     btree *tree;
     short int n;
#else /* __STDC__ */
int btree_h_levelread(btree *tree,short n)
#endif /* __STDC__ */
{
   if((tree!=NULL)&&(tree->h_level!=NULL)&&(*(tree->h_level+n)!=NULL))
   {
      int two_pow_n=(int)pow(2.,(double)n);
      int k=0;
      while(k<two_pow_n)
      { 
	  fprintf(stdout,"node # k=%d h=%f\n",k,*(*(tree->h_level+n)+k));
	 k++;
      }
      return 1;
   }
   else
   {
      fprintf(stdout,"error\n");
      return 0;
   } 
}

/*****************/
#ifndef __STDC__
int btree_hread(tree, n_min, n_max)
     btree *tree;
     short int n_min;
     short int n_max;
#else /* __STDC__ */
int btree_hread(btree *tree,short n_min,short n_max)
#endif /* __STDC__ */
{ 
   if(tree!=NULL)
   {
      if(tree->h_level!=NULL)
      {
	 int n=n_min-1;
	 do  
	    n++;
	 while((*(tree->h_level+n)!=NULL)&&(n<=n_max));
	 if (n<n_max+1)
	 {
	    fprintf(stdout,"error\n");
	    return 0;
	 }
	 if (n_min==n_max)
	    btree_h_levelread(tree,n_min);
	 else
	    bnode_hread(tree->root,tree,n_min,n_max);
      }
      else
      {
	 fprintf(stdout,"error\n");
	 return 0;
      }
      return 1;
   }
   else
   { 
      fprintf(stdout,"error\n");
      return 0;
   }
}

/*******************/
#ifndef __STDC__
int btree_hset(tree, n_min, n_max)
     btree *tree;
     short int n_min;
     short int n_max;
#else /* __STDC__ */
int btree_hset(btree *tree,short n_min,short n_max)
#endif /* __STDC__ */
{
   if(tree!=NULL)
   {
      short n=n_min;
      int two_pow_n=0,k=0;
      while(n<=n_max)
      {
	 two_pow_n=(int)pow(2.,(double)n);
	 k=0;
	 while(k<two_pow_n)
	 { 
	    *(*(tree->h_level+n)+k)=log(*(*(tree->c_level+n)+k))/(-n*log(2.));
	    k++;
	 }
	 n++;
      }
      return 1;
   }
   else
   {
      fprintf(stdout,"error\n");
      return 0;
   } 
}

/*******************/
#ifndef __STDC__
int btree_h(tree, n_min, n_max)
     btree *tree;
     short int n_min;
     short int n_max;
#else /* __STDC__ */
int btree_h(btree *tree,short n_min, short n_max)
#endif /* __STDC__ */
{
   if((btree_hcreate(tree,n_min,n_max))==0)
      return 0;
   if(btree_hset(tree,n_min,n_max)==0)
      return 0;	
   return 1;
}

/*****************/ 
#ifndef __STDC__
btree* btree_screate(tree, n_min, n_max)
     btree *tree;
     short int n_min;
     short int n_max;
#else /* __STDC__ */
btree* btree_screate(btree *tree,short n_min, short n_max)
#endif /* __STDC__ */
{
   if(tree!=NULL)
   {
      short n=n_min;
      if((tree->s_level=(unsigned char**)malloc((n_max+1)*sizeof(unsigned char*)))==NULL)
      { 
	 fprintf(stdout,"malloc error\n");
	 return NULL;
      } 
      while(n<=n_max)
      {
	 int two_pow_n=(int)pow(2.,(double)n);
	 if((*(tree->s_level+n)=(unsigned char*)malloc(two_pow_n*sizeof(unsigned char)))==NULL) 
	 { 
	    fprintf(stdout,"malloc error\n");
	    return NULL;
	 }
	 n++;
      }
      return tree;
   }
   else
   {
      fprintf(stdout,"error\n");
      return NULL;
   } 
}

/*******************/
#ifndef __STDC__
int btree_isos(tree, n, alpha, epsilon)
     btree *tree;
     short int n;
     double alpha;
     double epsilon;
#else /* __STDC__ */
int btree_isos(btree* tree,short n,double alpha,double epsilon)
#endif /* __STDC__ */
{
   if((tree!=NULL)&&(n>0)&&(epsilon>0.))
   {
      if((tree=btree_screate(tree,n,n))==NULL)
	 return 0;
      if(btree_isosset(tree,n,alpha,epsilon)==0)
	 return 0;
      return 1;
   }  
   else
   {
      fprintf(stdout,"btree_isos error\n");
      return 0;
   } 
}

/*******************/
#ifndef __STDC__
int btree_isosset(tree, n, alpha, epsilon)
     btree *tree;
     short int n;
     double alpha;
     double epsilon;
#else /* __STDC__ */
int btree_isosset(btree *tree,short n,double alpha,double epsilon)
#endif /* __STDC__ */
{
   if((tree!=NULL)&&(n>0)&&(epsilon>0.))
   {
      int two_pow_n=(int)pow(2.,(double)n);
      int k=0;
      while(k<two_pow_n)
      { 
	 *(*(tree->s_level+n)+k)=(unsigned char)(fabs(*(*(tree->h_level+n)+k)-alpha)<epsilon);
	 k++;
      }
      return 1;
   }
   else
   {
      fprintf(stdout,"btree_isosset error\n");
      return 0;
   } 
}
/*******************/
#ifndef __STDC__
int btree_isosN(tree, n, h, e)
     btree *tree;
     short int n;
     double h;
     double e;
#else /* __STDC__ */
int btree_isosN(btree *tree,short n,double h,double e)
#endif /* __STDC__ */
{
   if(tree!=NULL)
   {
      if((tree=btree_screate(tree,n,n))==NULL)
	 return 0;
      bnode_isosNset(tree->root,tree,n,h,e);
   }
   else
   {
      fprintf(stdout,"error\n");
      return 0;
   }
   return 1;
}

/*******************/
#ifndef __STDC__
int bnode_isosNset(node, tree, n, h, e)
     bnode *node;
     btree *tree;
     short int n;
     double h;
     double e;
#else /* __STDC__ */
int bnode_isosNset(bnode* node,btree *tree,short n,double h,double e)
#endif /* __STDC__ */
{ 
   if(node!=NULL)
   {
      int bool=0;
      /* fprintf(stdout,"node # x=%s,n=%d,k=%d\n",node->x,node->n,node->k); */
      if (node->n<n)
      {
	 bnode_isosNset(node->lnode,tree,n,h,e);
	 bnode_isosNset(node->rnode,tree,n,h,e);
      }
      else 
      {
	 bool=bnode_isosNset(node->lnode,tree,n,h,e)
	    &&bnode_isosNset(node->rnode,tree,n,h,e)
	    &&(fabs(*(*(tree->h_level+node->n)+node->k)-h)<e);
	 /* fprintf(stdout,"bool=%d\n",bool); */
	 if(node->n==n)
	    *(*(tree->s_level+node->n)+node->k)=(unsigned char)bool;
	 return bool;
      }
   }
   else
      return 0;
}

/*******************/
#ifndef __STDC__
int btree_s_levelread(tree, n)
     btree *tree;
     short int n;
#else /* __STDC__ */
int btree_s_levelread(btree* tree,short n)
#endif /* __STDC__ */
{
   if(tree!=NULL)
   {  
      int two_pow_n=(int)pow(2.,(double)n);
      int k=0;
      while(k<two_pow_n)
      { 
	  fprintf(stdout,"node # k=%d s=%d\n",k,*(*(tree->s_level+n)+k));
	 k++;
      }
      return 1;
   }
   else
   {
      fprintf(stdout,"error\n");
      return 0;
   } 
}
/*******************/
#ifndef __STDC__
int btree_s_leveldelete(tree, n)
     btree *tree;
     short int n;
#else /* __STDC__ */
int btree_s_leveldelete(btree* tree,short n)
#endif /* __STDC__ */
{
   if(tree!=NULL)
   {  
      if(*(tree->c_level+n)!=NULL)
	 free((char*)*(tree->s_level+n));
      else
	 return 0;
      return 1;
   }
   else
   {
      fprintf(stdout,"error\n");
      return 0;
   } 
}
