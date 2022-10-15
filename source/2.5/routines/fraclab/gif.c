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
#include <string.h>
#include "gif.h"
#include "imgif_const.h"
extern errno;


static int gif_read(pnf,buf,n)
struct extimage **pnf;
register char *buf;
register n;
{
	register i;
	if(n <= 0)
		return 0;
	if((i = fread(buf,1,n,(*pnf)->file)) < 0) {
		fermgif(pnf);
		/* imerror(1,"read err %d\n",errno); */
	}
	return i;
}

int gif_write(pnf,buf,n)
struct extimage **pnf;
register char *buf;
register n;
{
	register i;
	if(n <= 0)
		return 0;
	if((i = fwrite(buf,1,n,(*pnf)->file)) < 0) {
		gif_err(pnf,1,"write err %d\n",errno);
	}
	if(i != n)
		gif_err(pnf,9,"GIF Truncated write (%d -> %d)\n",n,i);
	return i;
}

/* read a count (1 byte) and then the data 
returns the nb of data bytes */
int gif_rdblock(pnf,buf)
register struct extimage **pnf;
register char *buf;
{
	register n, i;
	if((n = getc((*pnf)->file)) == EOF) {
		fprintf(stderr,"GIF block count read err %d\n",errno);
		return -1;
	}
	
	if((i = gif_read(pnf,buf,n)) != n) {
		fprintf(stderr,"GIF block read (%d) errno %d\n",i,errno);
		return i;
	}
	return n;
}
/* skip blocks */
static int skipblks(pnf)
register struct extimage **pnf;
{
	register n;
	while(1) {
		if((n = getc((*pnf)->file)) == EOF)
			gif_err(pnf,1,"GIF read err %d\n",errno);
		if(n == 0) return 0;
		while(n-- > 0) {
			if(getc((*pnf)->file) == EOF)
				gif_err(pnf,1,"GIF read err %d\n",errno);
		}
	}
}

static int rdcmap (pnf)
register struct extimage **pnf;
{
	char tmp[3*256];
	register numcols, n, i;
	numcols = (*pnf)->numcols;
	if(debug_)
		fprintf(stderr,"read GIF colormap (%d colors)\n",numcols);
	if(gif_read(pnf,tmp,3 * numcols) != (3 * numcols))
		gif_err(pnf,9,"could not read GIF colormap\n");
	n = 0;
	for(i=0;i<numcols;i++) {
		(*pnf)->rbuf[i] = tmp[n++];
		(*pnf)->gbuf[i] = tmp[n++];
		(*pnf)->bbuf[i] = tmp[n++];
	}

}

int gif_err(pnf,code,txt,p1,p2,p3,p4)
struct extimage **pnf;
int code;
char *txt;
char *p1, *p2, *p3, *p4;
{
  char errtxt[1000];
  fermgif(pnf);
  /* imerror(code,txt,p1,p2,p3,p4); */
  sprintf(errtxt,txt,p1,p2);
  InterfError(errtxt);

	
}
struct extimage *opengif(name)
char *name;
{
	unsigned char tmp[16];
	register i, n, flgc, c;
	FILE *f;
	register nbits, numcols;
	int screenw, screenh;
	struct extimage *nfgif;
	nfgif = (struct extimage *)i_calloc(1,sizeof(struct extimage));
	strcpy(nfgif->name,name);
	if(!name || ((*name == '<') && (*(name + 1) == 0))) {
		f = stdin;
	} else {
		if(!(f = fopen(name,"r")))
		  {
			gif_err(&nfgif,2,"open err %d on %s\n",errno,name);
			return(0);
		  }
	}
	nfgif->file = f;
	n = 0;
	if(gif_read(&nfgif,tmp,6) != 6)
		n = -1;
	else if(strncmp(tmp,"GIF8",4) != 0)
		n = -1;
	if(n) {
		gif_err(&nfgif,9,"%s: not a GIF file\n",name);
		return(0);
	}
	if(tmp[4] == '9')
		nfgif->flg89 = 1;
	/* read gif header */
	if(gif_read(&nfgif,tmp,7) != 7) 
	  {
		gif_err(&nfgif,9,"incorrect GIF file %s\n",name);
		return(0);
	  }
	screenw = tmp[0] + 256 * tmp[1];
	screenh = tmp[2] + 256 * tmp[3];
	flgc = tmp[4] & 0x80;
	nbits = (tmp[4] & 7) + 1;
	numcols = flgc ? 1 << nbits : 0;
	nfgif->nbits = nbits;
	nfgif->numcols = numcols;
	if(flgc) { /* read colormap */
		rdcmap(&nfgif);
	}
	/* goto begining of 1st image */
	while(1) {
		if((c = getc(f)) == EOF)
		  {
			gif_err(&nfgif,1,"GIF read err %d\n",errno);
			return(0);
		  }
		switch(c) {
		case ';' :  /* terminator */
		  {
			gif_err(&nfgif,9,"Terminator char found!!\n");
			return(0);
		  }
		case '!' : /* extension block */
			if((c = getc(f)) == EOF)
			  {
			    gif_err(&nfgif,1,"GIF read err %d\n",errno);
			    return(0);
			  }
			switch(c) {
			case 0xf9 :  /* tranparency */
				if(debug_)
					fprintf(stderr,"%s: transparency extension block ignored\n",name);
				skipblks(&nfgif);
				break;
			case 0xfe:  /* comment */
				if(debug_)
					fprintf(stderr,"%s: comment extension block ignored\n",name);
				skipblks(&nfgif);
				break;
			default:
				skipblks(&nfgif);
			}
			break;
		case ',': /* image separator */
			/* read image parameters */
			if(gif_read(&nfgif,tmp,9) != 9)
			  {
				gif_err(&nfgif,9,"could not read GIF image format\n");
				return(0);
			  }
			nfgif->dimx = tmp[4] + 256 * tmp[5];
			nfgif->dimy = tmp[6] + 256 * tmp[7];
			nfgif->size = nfgif->dimx * nfgif->dimy * ((nfgif->nbits + 7) / 8);
			nfgif->interlace = tmp[8] & 0x40;
			if(tmp[8] & 0x80) { /* local colormap */
				nfgif->numcols = 1 << ((tmp[8] & 7) + 1);
				rdcmap(&nfgif);
			}
			nfgif->data = (unsigned char *)i_malloc(nfgif->size);
			if(debug_)
				fprintf(stderr,"open GIF file %s, dimx %d, dimy %d, %d bits/pixel,%d colors, interlace: %d\n",
					name,nfgif->dimx,nfgif->dimy,nbits,numcols,nfgif->interlace);
			return nfgif;
		default:
			gif_err(&nfgif,9,"bad info in GIF file\n");
			return(0);
		}
	}
}



fermgif(pnf)
register struct extimage **pnf;
{
	register struct extimage *nfgif;
	if(!(nfgif = *pnf)) return;
	if(nfgif->file == NULL) return;
	fclose(nfgif->file);
	if(nfgif->data)
		i_Free(&nfgif->data);
	if(nfgif->cindex)
		i_Free(&nfgif->cindex);
	i_Free(pnf);
}
