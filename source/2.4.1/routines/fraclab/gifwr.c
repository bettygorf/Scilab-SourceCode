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

#include <stdio.h>
#include "gif.h"
#include "imgif_const.h"
extern errno;



static int wrcmap (pnf)
register struct extimage **pnf;
{
	char tmp[3*256];
	register numcols, n, i;
	numcols = (*pnf)->numcols;
	if(debug_)
		fprintf(stderr,"write GIF colormap (%d colors)\n",numcols);
	n = 0;
	for(i=0;i<numcols;i++) {
		tmp[n++] = (*pnf)->rbuf[i];
		tmp[n++] = (*pnf)->gbuf[i];
		tmp[n++] = (*pnf)->bbuf[i];
	}
	gif_write(pnf,tmp,3 * numcols);

}

/* true_color != 0  => quantization
   true_color < 0  => quantization sans tester si on peut l'eviter
*/
struct extimage *creategif(name,buf,dimx,dimy,true_color,nodither,numcols,graphic_ext,comment,r,g,b)
char *name, *buf;
int dimx, dimy, true_color,numcols,graphic_ext, nodither;
char *comment;
unsigned char *r, *g, *b;
{
	unsigned char tmp[16];
	register i, n, flag, c;
	FILE *f;
	register nbits;
	int screenw, screenh;
	int newnbcols;
	struct extimage *nfgif;
	register unsigned char *outbuf;
	nfgif = (struct extimage *)i_calloc(1,sizeof(struct extimage));
	strcpy(nfgif->name,name);
	if(!name || ((*name == '>') && (*(name + 1) == 0))) {
		f = stdout;
	} else {
		if(!(f = fopen(name,"w+")))
			gif_err(&nfgif,2,"create err %d on %s\n",errno,name);
	}
	nfgif->file = f;
	nfgif->dimx = dimx;
	nfgif->dimy = dimy;
	nfgif->size = dimx * dimy;
	nfgif->interlace = 0;
	nbits = 8;
	if(comment && *comment) 
		nfgif->flg89 = 1;
	if(nfgif->flg89)
		gif_write(&nfgif,"GIF89a",6);
	else
		gif_write(&nfgif,"GIF87a",6);
	nfgif->data = (unsigned char *)buf;
	if(true_color) {
		flag = nodither ? 1 : 0;
		if(true_color < 0)
			flag |= 2;
/*		quantize(&nfgif,nodither); */
		outbuf = (unsigned char *)i_malloc(nfgif->size);
		quantize(nfgif->data,outbuf,nfgif->dimx,nfgif->dimy,numcols,&newnbcols,
			 flag,nfgif->rbuf,nfgif->gbuf,nfgif->bbuf);
		i_Free(&nfgif->data);
		nfgif->data = outbuf;
	} else {
		newnbcols = numcols;
		for(i=0;i<numcols;i++) {
			nfgif->rbuf[i] = r[i];
			nfgif->gbuf[i] = g[i];
			nfgif->bbuf[i] = b[i];
		}
	}
	numcols = newnbcols;
	tmp[0] = dimx & 0xff;
	tmp[1] = dimx >> 8;
	tmp[2] = dimy & 0xff;
	tmp[3] = dimy >> 8;
	if(numcols) {
		if(numcols > 256)
			numcols = 256;
		i = 256;
		nbits = 8;
		while (i) {
			if( i < numcols)
				break;
			i >>= 1;
			nbits--;
		}
		if(!i)
			gif_err(&nfgif,9,"creategif: bad number of colors\n");
		tmp[4] = 0xf0 | nbits;
		nbits++;
	} else
		tmp[4] = 0;
	tmp[5] = 0;
	tmp[6] = 0;
	nfgif->nbits = nbits;
	nfgif->numcols = 1 << nbits;
	if(debug_)
		fprintf(stderr,"create gif file %s, dimx %d, dimy %d, %d bits/pixel,%d colors\n",
			name,nfgif->dimx,nfgif->dimy,nbits,numcols);
	gif_write(&nfgif,tmp,7);
	wrcmap(&nfgif);
	/* write comments and extents */
	if(comment && *comment) {
		tmp[0] = '!';
		tmp[1] = 0xfe;
		gif_write(&nfgif,tmp,2);
		i = strlen(comment);
		n = 255;
		while(i) {
			if(n > i)
				n = i;
			putc(n,nfgif->file);
			gif_write(&nfgif,comment,n);
			i -= n;
		}
		putc(0,nfgif->file);
	}
	if(graphic_ext >= 0) {
		tmp[0] = '!';
		tmp[1] = 0xf9;
		tmp[2] = 4;
		tmp[3] = 1;
		tmp[4] = 0;
		tmp[5] = 0;
		tmp[6] = graphic_ext;
		tmp[7] = 0;
		gif_write(&nfgif,tmp,8);
	}
	tmp[0] = ',';  /* image separator */
	tmp[1] = 0;
	tmp[2] = 0;
	tmp[3] = 0;
	tmp[4] = 0;
	tmp[5] = dimx & 0xff;
	tmp[6] = dimx >> 8;
	tmp[7] = dimy & 0xff;
	tmp[8] = dimy >> 8;
	tmp[9] = 0;   /* use global colormap */
	gif_write(&nfgif,tmp,10);
	return nfgif;
}

writegif(pnf)
struct extimage **pnf;
{
	char tmp[2];
	register struct extimage *nfgif;
	register n;
	nfgif = *pnf;
	n = nfgif->nbits;
	if(n < 2) n = 2;
	putc(n,nfgif->file);
	n = LZWEncode(pnf);
	tmp[0] = 0;
	tmp[1] = ';';
	gif_write(pnf,tmp,2);
	return n;
}

