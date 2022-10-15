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
#include "imgif_const.h"
/*
#include <inrimage/image.h>
#include "gif.h"
*/


#define DEBUG 0
#define ALTERNATE 1  /* changement de sens dithering a chaque ligne */

#define COLMAX 255
#define NBCOLMAX (COLMAX +1)
#define COLSHIFT 8

#if 1
#define CSHIFT 3
#define CSHIFTB CSHIFT
#define CLGR (1 << (8 - CSHIFT))
#define CLGRB CLGR
#define GSHIFT (8 - CSHIFT)
#define RSHIFT (8 -CSHIFT + GSHIFT)
#define CMASK (CLGR - 1)
#define CMASKB CMASK
#define LGHISTO (1 << (3 * GSHIFT))
#else
#define CSHIFT 2
#define CSHIFTB 3
#define CLGR (1 << (8 - CSHIFT))
#define CLGRB (1 << (8 - CSHIFTB))
#define GSHIFT (8 - CSHIFTB)
#define RSHIFT (8 -CSHIFT + GSHIFT)
#define CMASK (CLGR - 1)
#define CMASKB (CLGRB - 1)
#define LGHISTO (1 << (2 * (8 - CSHIFT) + (8 - CSHIFTB)))
#endif
struct cube {
	unsigned char rgbmin[3];
	unsigned char lgrs[3];  /* taille du cube */
	long nbp;  /* nb of pixels */
#if DEBUG
	int nbc;  /* actual nb of different colors */
#endif
	short nonsplit;
	unsigned char rgb[3];  /* couleur associe'e */
};
static struct cube *cubes;
static int *histo;
int nbcub;
static int imsize, dimx, dimy, numcols, newnumcols;
static unsigned char *data, *bufout, *rbuf, *gbuf, *bbuf;

static int nberr= 0;
/*
 cherche la meilleure representation de couleurs sur 8 bits
pour image IN (ndimv=3)
resultat OUT sur 8bits, avec tables couleur dans RTAB,GTAB,BTAB
DX,DY= tailles en X et Y
NC nb couleurs demandees
NEWNC= nb couleurs apres traitement
FLAG=  +1 si no dithering, +2 si no check nb of colors
*/
quantize(in,out,dx,dy,nc,newnc,flag,rtab,gtab,btab)
unsigned char *in, *out, *rtab, *gtab, *btab;
int flag, dx, dy, nc;
int *newnc;
{
	register unsigned char *buf;
	register nbcols, n, i, s;
	int nodither, nocheck;
	/* copy args in static variables */
	data = in;
	bufout = out;
	dimx = dx;
	dimy = dy;
	imsize = dx * dy;
	if(nc > NBCOLMAX) nc = NBCOLMAX;
	numcols = nc;
	rbuf = rtab;
	gbuf = gtab;
	bbuf = btab;

	buf = data;
	nbcols = numcols;
	nodither = flag & 1;
	nocheck = flag & 2;
	if(debug_) {
		if(nodither)
			fprintf(stderr,"quantize image\n");
		else
			fprintf(stderr,"quantize and dither image\n");
	}
	/* tester si on a plus  de nbcols couleurs */
	if(!nocheck) {
		if(tstnbcols(nbcols)) {
			if(debug_)
				fprintf(stderr,"%d colors  no quantization necessary\n",newnumcols);
			*newnc = newnumcols;
			return;
		}
	}
	cubes = (struct cube *)i_malloc(nbcols * sizeof(struct cube));
	/* make histogram */
	n = makehisto();
#if DEBUG
	if(debug_)
		fprintf(stderr,"image quantization : %d colors\n",n);
	n = 0;
	s = 0;
	for(i=0;i< (CLGR * CLGR * CLGRB);i++)
		if(*(histo + i)) {
			n++;
			s += *(histo + i);
		}
	fprintf(stderr,"%d col, %d pix\n",n,s);
#endif
	splitcubes();
#if DEBUG
	if(debug_)
		tstcubes();
#endif
	makecmap();  /* build cmap */
	*newnc = newnumcols;
	if(nodither)
		applycmap(); /* modif pixels */
	else
		dither();
	i_Free(&histo);
	i_Free(&cubes);
}

/* calcule colormap et remplace nb par num de couleur dans histogramme */
makecmap()
{
	register i;
	register int *ph;
	register struct cube *pcub;
	pcub = cubes;
	ph = histo;
	for(i=0;i<LGHISTO;i++,ph++)
		if(!*ph) *ph = -1;
	for(i=0;i<= nbcub;i++, pcub++) {
		findcolor(i);
		rbuf[i] = pcub->rgb[0];
		gbuf[i] = pcub->rgb[1];
		bbuf[i] = pcub->rgb[2];
	}
	newnumcols = nbcub + 1;
}

/* calcule meilleure couleur  et remplace nb par num de couleur dans histogramme */
findcolor(numcub)
int numcub;
{
	register struct cube *pcub;
	register int *ph;
	register np, nc;
	register ib, ig;
	register ir;
	register r, g, b;
	register float sr, sg, sb;
	register float v;
	register inc0, inc1;
	pcub = cubes + numcub;
	r = pcub->rgbmin[0];
	g = pcub->rgbmin[1];
	b = pcub->rgbmin[2];
	inc0 = CLGRB - pcub->lgrs[2];
	inc1 = CLGR * CLGRB - (CLGRB * pcub->lgrs[1]);
	ph = histo + ((r << RSHIFT) | (g << GSHIFT) | b);
	sr = 0;
	sg = 0;
	sb = 0;
	np = pcub->nbp;
	for(ir=0;ir<pcub->lgrs[0];ir++) {
		for(ig=0;ig<pcub->lgrs[1];ig++) {
			for(ib=0;ib<pcub->lgrs[2];ib++) {
				if(v = *ph) {
					*ph = numcub;
					v /= np;
					sr += (ir * v); 
					sg += (ig * v);
					sb += (ib * v);
				} else 
					*ph = numcub;  /* forcer  couleur du cube */
				ph++;
			}
			ph += inc0;
		}
		ph += inc1;
	}
#if 1
#if 0
	pcub->rgb[0] = (unsigned char )((sr  + pcub->rgbmin[0]) * (255. / CMASK));
	pcub->rgb[1] = (unsigned char )((sg  + pcub->rgbmin[1] ) * (255. / CMASK));
	pcub->rgb[2] = (unsigned char )((sb  + pcub->rgbmin[2] ) * (255. / CMASKB));
#else
	/* donne le + petit nb de couleurs a retrouver */
	pcub->rgb[0] = (unsigned char )((pcub->lgrs[0] / 2  + pcub->rgbmin[0]) * (255. / CMASK));
	pcub->rgb[1] = (unsigned char )((pcub->lgrs[1] / 2   + pcub->rgbmin[1] ) * (255. / CMASK));
	pcub->rgb[2] = (unsigned char )((pcub->lgrs[2] / 2   + pcub->rgbmin[2] ) * (255. / CMASKB));
#endif
#else
#if 0
	pcub->rgb[0] = (unsigned char )(sr  + pcub->rgbmin[0]) << CSHIFT;
	pcub->rgb[1] = (unsigned char )(sg  + pcub->rgbmin[1] ) << CSHIFT;
	pcub->rgb[2] = (unsigned char )(sb  + pcub->rgbmin[2] ) << CSHIFTB;
#else
	pcub->rgb[0] = (unsigned char )((pcub->lgrs[0] / 2  + pcub->rgbmin[0]) << CSHIFT);
	pcub->rgb[1] = (unsigned char )((pcub->lgrs[1] / 2   + pcub->rgbmin[1] ) << CSHIFT);
	pcub->rgb[2] = (unsigned char )((pcub->lgrs[2] / 2   + pcub->rgbmin[2] ) << CSHIFTB);
#endif
#endif
}

applycmap()
{
	register int *ph;
	register k, i;
	register unsigned char *buf, *pix;
	ph = histo;
	buf = data;
	pix = bufout;
	for(i=0;i<imsize;i++) {
		k = (*buf++ >> CSHIFT) << RSHIFT;
		k |= (*buf++ >> CSHIFT) << GSHIFT;
		k |= (*buf++ >> CSHIFTB);
		*pix++ = *(ph + k);
	}  
}

/* 
en chaque point on calcule l'erreur que l'on repartit sur les points voisins
par ex err =   r - rbuf[pix]
P(i,j+k) += 7/16 * err
P(i+1,j-k) += 3/16 * err
P(i+1,j) += 5/16 * err
P(i+1,j+k) += 1/16 * err
Pour les lignes paires k = 1, et balayage de gauche a droite
lignes impaires: k = -1 , de droite a gouche
*/
/*!!#define GETPIX(pc,v) {if((v = *pc) < 0) v = 0;else if(v > COLMAX) v = COLMAX;} */
#define GETPIX(v) (v = pixlimit[NBCOLMAX + *buf++ + *err0++])
#define SPLITERR(ic,col) {if(col > 0) {x7[ic] = tab7[col];x3[ic] = tab3[col];\
x5[ic] = tab5[col];x1[ic] = tab1[col];} else { col = -col;\
x7[ic] = -tab7[col];x3[ic] = -tab3[col];x5[ic] = -tab5[col];x1[ic] = -tab1[col];}}
dither()
{
	/* tables pour 1/16, 3/16, etc avec arrondi */
	short tab1[2*NBCOLMAX], tab3[2*NBCOLMAX], tab5[2*NBCOLMAX], tab7[2*NBCOLMAX];
	unsigned char pixlimit[3 * NBCOLMAX];
	register int *ph;
	register k, i, j;
	register unsigned char *buf, *pix;
	register short *err0, *err1;
	register short *tmp0, *tmp1;
	short *ptmp0, *ptmp1;
	register r, g, b, v, k1;
	register k0, sens;
	int dx3, dx;

	for(i=0;i<NBCOLMAX;i++) {
		v = (i + 8) / 16;
		tab1[NBCOLMAX + i] = v;
		tab1[NBCOLMAX - i] = -v;
		v = ((i * 3) + 8) / 16;
		tab3[NBCOLMAX + i] = v;
		tab3[NBCOLMAX - i] = -v;
		v = ((i * 5) + 8) / 16;
		tab5[NBCOLMAX + i] = v;
		tab5[NBCOLMAX - i] = -v;
		v = ((i * 7) + 8) / 16;
		tab7[NBCOLMAX + i] = v;
		tab7[NBCOLMAX - i] = -v;
		pixlimit[i] = 0;
		pixlimit[NBCOLMAX + i] = i;
		pixlimit[2 * NBCOLMAX + i] = COLMAX;
	}
	/* on laisse un pixele avant debut et apres fin de ligne pour eviter les tests */
	ptmp0 = (short *)i_calloc(3 * (dimx + 2), sizeof(short));
	ptmp1 = (short *)i_calloc(3 * (dimx + 2), sizeof(short));
	tmp0 = ptmp0 + 3;
	tmp1 = ptmp1 + 3;
	err1 = tmp1;
	dx = dimx;
	dx3 = 3 * (dimx - 1);
	for(i=0;i<dimx;i++) {
		*err1++ = 0;
		*err1++ = 0;
		*err1++ = 0;
	}
	ph = histo;
	i = dimy;
#if ALTERNATE
	pix = bufout -dx - 1;
	buf = data -dx3 - 6;
	k1 = -6;
#else
	pix = bufout;
	buf = data;
	k1 = 0;
	k = 3;
#endif
	while(i-- > 0) {
		/* echanger buffers */
		err0 = tmp1;
		tmp1 = tmp0;
		tmp0 = err0;
		err1 = tmp1;
#if ALTERNATE
		if(k1) {
			k = 3;
			k1 = 0;
			pix += dx + 1;
			buf += dx3 + 6;
		} else {
			k = -3;
			k1 = -6;
			err0 += dx3;
			err1 += dx3;
			pix += dx - 1;
			buf += dx3;
		}
#endif
		/* mettre a 0 la 1e err de la ligne suivante */
		*err1 = 0;
		*(err1 + 1) = 0;
		*(err1 + 2) = 0;
		j = dimx;
		while(j-- > 0) {
			GETPIX(r);
			GETPIX(g);
			GETPIX(b);
			err0 += k1;
			buf += k1;
			k0 = ((r >> CSHIFT) << RSHIFT) +
				((g >> CSHIFT) << GSHIFT) + (b >> CSHIFTB);
			v = *(ph + k0);
			if(v < 0) {
				v = nearest(r,g,b);
				*(ph + k0) = v;
				nberr++;
			}
			if(k1)
				*pix-- = v;
			else
				*pix++ = v;
			r -= rbuf[v];
			g -= gbuf[v];
			b -= bbuf[v];
			if(i) {
				if(r) {
					*err0 += tab7[NBCOLMAX + r];
					*err1 += tab5[NBCOLMAX + r];
					*(err1 + k) = tab1[NBCOLMAX + r];
					*(err1++ - k) += tab3[NBCOLMAX + r];
				} else
					*(err1++ + k) = 0;
				if(g) {
					*(err0 + 1) += tab7[NBCOLMAX + g];
					*err1 += tab5[NBCOLMAX + g];
					*(err1 + k) = tab1[NBCOLMAX + g];
					*(err1++ - k) += tab3[NBCOLMAX + g];
				} else
					*(err1++ + k) = 0;
				if(b) {
					*(err0 + 2) += tab7[NBCOLMAX + b];
					*err1 += tab5[NBCOLMAX + b];
					*(err1 + k) = tab1[NBCOLMAX + b];
					*(err1++ - k) += tab3[NBCOLMAX + b];
				} else
					*(err1++ + k) = 0;
				err1 += k1;
			} else if(j) {
				*err0 += tab7[NBCOLMAX + r];
				*(err0 + 1) += tab7[NBCOLMAX + g];
				*(err0 + 2) += tab7[NBCOLMAX + b];
			}
		}
			
	}  
	i_Free(&ptmp0);
	i_Free(&ptmp1);
	if(debug_) 
		fprintf(stderr,"calc %d distances\n",nberr);
}
#define RCOEF  20 /* .300 * .300 * 256 = 23 */
#define GCOEF 39 /* .586 * .586 * 256 = 88 */
#define BCOEF 8  /* .114 * .114 * 256 =  3 */

nearest(r,g,b)
register r, g, b;
{
	register i, imin, d, dist;
	register struct cube *pcub;
	register dmin;
	dmin = 0x7fffffff;
	pcub = cubes;
 	for(i=0;i<= nbcub;i++,pcub++) {
		d = pcub->rgb[0] - r;
		dist = d * d * RCOEF;
		d = pcub->rgb[1] - g;
		dist += d * d * GCOEF;
		d = pcub->rgb[2] - b;
		dist += d * d * BCOEF;
		if(dist < dmin) {
			dmin = dist;
			imin = i;
		}
	}
	return imin;
}

/* test du nb de couleur : on cherche par dichotomie dans la liste
courante */
tstnbcols(nc)
register nc;
{
	register unsigned char *buf, *pix;
	int tmpmap[NBCOLMAX];
	register int *p1;
	register n, i, j;
	register j1, j2;
	register int v, v0;
	if(nc > NBCOLMAX) return 0;
	buf = data;
	pix = bufout;
	n = 1;
	v = *buf++ << (2 * COLSHIFT);
	v |= *buf++ << COLSHIFT;
	v |= *buf++;
	tmpmap[0] = v;
	p1 = tmpmap;
	for(i=1;i < imsize;i++) {
		v = *buf++ << (2 * COLSHIFT);
		v |= *buf++ << COLSHIFT;
		v |= *buf++;
		/* recherche par dichotomie */
		j1 = 0;
		j2 = n -1;
		while(j1 <= j2) {
			j = (j1 + j2) / 2;
			if(!(v0 = v - *(p1 +j))) goto next;  /* egal */
			if(v0 < 0) {
				j2 = j - 1;
			} else {
				j1 = j + 1;
			}
		}
		if(n >= nc) {
			if(debug_)
				fprintf(stderr,"found more than %d colors after %d tests\n",
					nc,i);
			return 0;
		}
		p1 = &tmpmap[n];
		for(j=n-1;j >= j1; j--, p1--) {
			*p1 = *(p1 - 1);
		}
		tmpmap[j1] = v;
		p1 = tmpmap;
		n++;
next:		continue;
	}
	newnumcols = n;
	/* set colormaps */
	for(i=0;i<n;i++) {
		v = tmpmap[i];
		rbuf[i] = v >> (2 * COLSHIFT);
		gbuf[i] = (v >> COLSHIFT) & COLMAX;
		bbuf[i] = v & COLMAX;
	}
	for(;i < nc;i++) {
		rbuf[i] = 0;
		gbuf[i] = 0;
		bbuf[i] = 0;
	}
	buf = data;
	n--;
	p1 = tmpmap;
	/* set pixel values */
	for(i=0;i<imsize;i++) {
		v = *buf++ << (2 * COLSHIFT);
		v |= *buf++ << COLSHIFT;
		v |= *buf++;
		j1 = 0;
		j2 = n;
		while(j1 < j2) {
			j = (j1 + j2) / 2;
			if(!(v0 = v - *(p1 +j))) { /* egal */
				j1 = j;
				break;
			}
			if(v0 < 0) {
				j2 = j - 1;
			} else {
				j1 = j + 1;
			}
		}
		*pix++ = j1;
	}
	return 1;
}

makehisto()
{
	register unsigned char *buf;
	register i, k;
	register r, g, b;
	register rmin, rmax, gmin, gmax, bmin, bmax;
#if DEBUG
	register nc;
	nc = 0;
#endif
	buf = data;
	rmin = rmax = *buf >> CSHIFT;
	gmin = gmax = *(buf+1) >> CSHIFT;
	bmin = bmax = *(buf+2) >> CSHIFTB;
	histo = (int *)i_calloc(LGHISTO, sizeof(int));
	for(i=0;i < imsize;i++) {
		r = (*buf++ >> CSHIFT);
		g = (*buf++ >> CSHIFT);
		b = (*buf++ >> CSHIFTB);
		if(r < rmin) rmin = r;
		else if(r > rmax) rmax = r;
		if(g < gmin) gmin = g;
		else if(g > gmax) gmax = g;
		if(b < bmin) bmin = b;
		else if(b > bmax) bmax = b;
		k = (r << RSHIFT) | (g << GSHIFT) | b;
#if DEBUG
		if(!(*(histo + k))++ ) nc++;
#else
		(*(histo + k))++;
#endif
	}
	cubes->rgbmin[0] = rmin;
	cubes->rgbmin[1] = gmin;
	cubes->rgbmin[2] = bmin;
	cubes->lgrs[0] = rmax - rmin + 1;
	cubes->lgrs[1] = gmax - gmin + 1;
	cubes->lgrs[2] = bmax - bmin + 1;
	cubes->nbp = imsize;
#if DEBUG
	cubes->nbc = nc;
#endif
	cubes->nonsplit = 0;
	nbcub = 0;
	if((rmax == rmin) && (gmax == gmin) && (bmax == bmin))
		cubes->nonsplit = 1;
#if DEBUG
	return nc;
#else
	return 0;
#endif
}

splitcubes() 
{
	register icub;
	while(nbcub < numcols - 1) {
		if((icub = biggestcube()) < 0) break;
		splitcube(icub);
	}
}

biggestcube()
{
	register struct cube *pcub;
	register i, smax, nc;
	pcub = cubes;
	smax = -1;
	nc = -1;
	for(i=0;i<= nbcub;i++) {
#if DEBUG
		if((pcub->nbc > 1) && (! pcub->nonsplit)) { /* !!! */
#else
		if(! pcub->nonsplit) { 
#endif
			if(smax < pcub->nbp) {
				smax = pcub->nbp;
				nc = i;
			}
		}
		pcub++;
	}
	return nc;
}

splitcube(num)
register num;
{
	register struct cube *pcub, *pcub2;
	register i, lmax;
	pcub = cubes + num;
	i = 0;
	lmax = pcub->lgrs[0];
	if(lmax < pcub->lgrs[1]) {
		lmax = pcub->lgrs[1];
		i = 1;
	}
	if(lmax < pcub->lgrs[2]) {
		lmax = pcub->lgrs[2];
		i = 2;
	}
	nbcub++;
	pcub2 = cubes + nbcub;
	memcpy(pcub2,pcub,sizeof(struct cube));
	if(i == 0)
		rsplit(pcub,pcub2);
	else if(i == 1)
		gsplit(pcub,pcub2);
	else
		bsplit(pcub,pcub2);
	tstcub(pcub,num);
	tstcub(pcub2,nbcub);
}


rsplit(pcub,pcub2)
register struct cube *pcub, *pcub2;
{
	register int *ph;
	register nc, nb0, nb1;
	register ib, ig;
	register ir;
	register s, s2, n;
	register inc0, inc1;
	register bmin, bmax;
	register gmin, gmax;
	register rmin, rmax;
	int r, g, b, k;
	int maxc;
	r = pcub->rgbmin[0];
	g = pcub->rgbmin[1];
	b = pcub->rgbmin[2];
	k = (r << RSHIFT) | (g << GSHIFT) | b;
	inc0 = CLGRB - pcub->lgrs[2];
	inc1 = CLGR * CLGRB - (CLGRB * pcub->lgrs[1]);
	s2 = pcub->nbp / 2;
	s = 0;
	nc = 0;
#if DEBUG
	maxc = pcub->nbc - 1;
#endif
	ph = histo + k;
	rmin = -1;
	gmin = bmin = NBCOLMAX;
	bmax = gmax = 0;
	for(ir= 0;ir<pcub->lgrs[0] -1;ir++) {
		nb1 = 0;
		for(ig=0;ig<pcub->lgrs[1];ig++) {
			nb0 = 0;
			for(ib=0;ib<pcub->lgrs[2];ib++) {
				if(n = *ph) {
					nc++;
					nb0++;
					s += n;
					if(ib < bmin)
						bmin = ib;
					if(ib > bmax)
						bmax = ib;
				}
				ph++;
			}
			if(nb0) {
				nb1++;
				if(ig < gmin) gmin = ig;
				if(ig > gmax) gmax = ig;
			}
			ph += inc0;
		}
		if(nb1) {
			if(rmin < 0) rmin = ir;
#if DEBUG
			if((nc >= maxc) || (s >= s2))
#else
			if(s >= s2)
#endif
				goto found;
		}
		ph += inc1;
	}
	ir--;
found:	
	ir++;
	pcub->lgrs[0] = ir - rmin;
	pcub->rgbmin[0] += rmin;
	pcub->rgbmin[1] += gmin;
	pcub->rgbmin[2] += bmin;
	pcub->lgrs[1] = gmax - gmin + 1;
	pcub->lgrs[2] = bmax - bmin + 1;
#if DEBUG
	pcub->nbc = nc;
	pcub2->nbc -= nc;
#endif
	pcub->nbp = s;
	if((pcub->lgrs[0] == 1) && (pcub->lgrs[1] == 1) && (pcub->lgrs[2] == 1))
		pcub->nonsplit = 1;
	pcub2->nbp -= s;
	if((s < 0) || (s > imsize) || (pcub2->nbp < 0))
	  /* imerror(9,"bad cube\n")*/;
	if(pcub2->nbp == 0) {
		nbcub--;
		return;
	}
	pcub2->rgbmin[0] += ir;
	pcub2->lgrs[0] -= ir;
	cubmmx(pcub2);  /* calcule min et max */
	/* min et max 2e cube */
}

gsplit(pcub,pcub2)
register struct cube *pcub, *pcub2;
{
	register int *ph, *ph0;
	register nc, nb0, nb1;
	register ib, ig;
	register ir;
	register s, s2, n;
	register inc0;
	register bmin, bmax;
	register gmin, gmax;
	register rmin, rmax;
	int r, g, b, k;
	int maxc;
	r = pcub->rgbmin[0];
	g = pcub->rgbmin[1];
	b = pcub->rgbmin[2];
	k = (r << RSHIFT) | (g << GSHIFT) | b;
	inc0 = CLGR * CLGRB - pcub->lgrs[2];
	s2 = pcub->nbp / 2;
	s = 0;
	nc = 0;
#if DEBUG
	maxc = pcub->nbc - 1;
#endif
	ph0 = histo + k;
	gmin = -1;
	rmin = bmin = NBCOLMAX;
	bmax = rmax = 0;
	for(ig= 0;ig<pcub->lgrs[1] -1;ig++) {
		nb1 = 0;
		ph = ph0;
		for(ir=0;ir<pcub->lgrs[0];ir++) {
			nb0 = 0;
			for(ib=0;ib<pcub->lgrs[2];ib++) {
				if(n = *ph) {
					nc++;
					nb0++;
					s += n;
					if(ib < bmin)
						bmin = ib;
					if(ib > bmax)
						bmax = ib;
				}
				ph++;
			}
			if(nb0) {
				nb1++;
				if(ir < rmin) rmin = ir;
				if(ir > rmax) rmax = ir;
			}
			ph += inc0;
		}
		if(nb1) {
			if(gmin < 0) gmin = ig;
#if DEBUG
			if((nc >= maxc) || (s >= s2))
#else
			if(s >= s2)
#endif
				goto found;
		}
		ph0 += CLGRB;
	}
	ig--;
found:	
	ig++;
	pcub->lgrs[1] = ig - gmin;
	pcub->rgbmin[1] += gmin;
	pcub->rgbmin[0] += rmin;
	pcub->rgbmin[2] += bmin;
	pcub->lgrs[0] = rmax - rmin + 1;
	pcub->lgrs[2] = bmax - bmin + 1;
#if DEBUG
	pcub->nbc = nc;
	pcub2->nbc -= nc;
#endif
	pcub->nbp = s;
	pcub2->nbp -= s;
	if((pcub->lgrs[0] == 1) && (pcub->lgrs[1] == 1) && (pcub->lgrs[2] == 1))
		pcub->nonsplit = 1;
	if((s < 0) || (s > imsize) || (pcub2->nbp < 0))
	  /* imerror(9,"bad cube\n") */;
	if(pcub2->nbp == 0) {
		nbcub--;
		return;
	}
	pcub2->rgbmin[1] += ig;
	pcub2->lgrs[1] -= ig;
	cubmmx(pcub2);  /* calcule min et max */
	/* min et max 2e cube */
}

bsplit(pcub,pcub2)
register struct cube *pcub, *pcub2;
{
	register int *ph, *ph0;
	register nc, nb0, nb1;
	register ib, ig;
	register ir;
	register s, s2, n;
	register inc0;
	register bmin, bmax;
	register gmin, gmax;
	register rmin, rmax;
	int r, g, b, k;
	int maxc;
	r = pcub->rgbmin[0];
	g = pcub->rgbmin[1];
	b = pcub->rgbmin[2];
	k = (r << RSHIFT) | (g << GSHIFT) | b;
	inc0 = CLGR * CLGRB - (CLGRB * pcub->lgrs[1]);
	s2 = pcub->nbp / 2;
	s = 0;
	nc = 0;
#if DEBUG
	maxc = pcub->nbc - 1;
#endif
	ph0 = histo + k;
	bmin = -1;
	rmin = gmin = NBCOLMAX;
	gmax = rmax = 0;
	for(ib= 0;ib<pcub->lgrs[2] -1;ib++) {
		nb1 = 0;
		ph = ph0;
		for(ir=0;ir<pcub->lgrs[0];ir++) {
			nb0 = 0;
			for(ig=0;ig<pcub->lgrs[1];ig++) {
				if(n = *ph) {
					nc++;
					nb0++;
					s += n;
					if(ig < gmin)
						gmin = ig;
					if(ig > gmax)
						gmax = ig;
				}
				ph += CLGRB;
			}
			if(nb0) {
				nb1++;
				if(ir < rmin) rmin = ir;
				if(ir > rmax) rmax = ir;
			}
			ph += inc0;
		}
		if(nb1) {
			if(bmin < 0) bmin = ib;
#if DEBUF
			if((nc >= maxc) || (s >= s2))
#else
			if(s >= s2)
#endif
				goto found;
		}
		ph0++;
	}
	ib--;
found:	
	ib++;
	pcub->lgrs[2] = ib - bmin;
	pcub->rgbmin[2] += bmin;
	pcub->rgbmin[0] += rmin;
	pcub->rgbmin[1] += gmin;
	pcub->lgrs[0] = rmax - rmin + 1;
	pcub->lgrs[1] = gmax - gmin + 1;
#if DEBUG
	pcub->nbc = nc;
	pcub2->nbc -= nc;
#endif
	pcub->nbp = s;
	pcub2->nbp -= s;
	if((pcub->lgrs[0] == 1) && (pcub->lgrs[1] == 1) && (pcub->lgrs[2] == 1))
		pcub->nonsplit = 1;
	if((s < 0) || (s > imsize) || (pcub2->nbp < 0))
	  /* imerror(9,"bad cube\n")*/;
	if(pcub2->nbp == 0) {
		nbcub--;
		return;
	}
	pcub2->rgbmin[2] += ib;
	pcub2->lgrs[2] -= ib;
	cubmmx(pcub2);  /* calcule min et max */
	/* min et max 2e cube */
}


cubmmx(pcub)
register struct cube *pcub;
{
	register int *ph;
	register nc, nbb, nbg;
	register ib, ig;
	register ir;
	int r, g, b, k;
	register bmin, bmax;
	register gmin, gmax;
	register rmin, rmax;
	register inc0, inc1;
	r = pcub->rgbmin[0];
	g = pcub->rgbmin[1];
	b = pcub->rgbmin[2];
	k = (r << RSHIFT) | (g << GSHIFT) | b;
	inc0 = CLGRB - pcub->lgrs[2];
	inc1 = CLGR * CLGRB - (CLGRB * pcub->lgrs[1]);
	gmin = bmin = NBCOLMAX;
	bmax = gmax = 0;
	rmin = -1;
	ph = histo + k;
	for(ir=0;ir<pcub->lgrs[0];ir++) {
		nbg = 0;
		for(ig=0;ig<pcub->lgrs[1];ig++) {
			nbb = 0;
			for(ib=0;ib<pcub->lgrs[2];ib++) {
				if(*ph) {
					nbb++;
					if(ib < bmin)
						bmin = ib;
					if(ib > bmax)
						bmax = ib;
				}
				ph++;
			}
			if(nbb) {
				nbg++;
				if(ig < gmin) gmin = ig;
				if(ig > gmax) gmax = ig;
			}
			ph += inc0;
		}
		if(nbg) {
			if(rmin < 0) rmin = ir;
			rmax = ir;
		}
		ph += inc1;
	}
	pcub->rgbmin[0] = r + rmin;
	pcub->rgbmin[1] = g + gmin;
	pcub->rgbmin[2] = b + bmin;
	pcub->lgrs[0] = rmax - rmin + 1;
	pcub->lgrs[1] = gmax - gmin + 1;
	pcub->lgrs[2] = bmax - bmin + 1;
	if((rmax == rmin) && (gmax == gmin) && (bmax == bmin))
		pcub->nonsplit = 1;
}

#if DEBUG
tstcubes()
{
	register n, s, i, j;
	register vol;
	register struct cube *pc;
	register float dc, dp;
	n = 0;s = 0;
	pc = cubes;
	for(i=0;i<= nbcub;i++,pc++) {
		n += pc->nbc;
		s += pc->nbp;
		vol = pc->lgrs[0] * pc->lgrs[1] * pc->lgrs[2];
		dc = (float)pc->nbc / (float) vol;
		dp = (float)pc->nbp / (float) vol;
		if(debug_)
			fprintf(stderr,"%d: v= %d, dc= %f, dp= %f\n",i,vol,dc,dp);
		tstcub(pc,i);
	}
	fprintf(stderr,"%d col, %d pix\n",n,s);
}
#endif

tstcub(pc,i)
register struct cube *pc;
register i;
{
	register j;
	if(((pc->rgbmin[0] + pc->lgrs[0]) > CLGR) || (pc->lgrs[0] <= 0) ||
	   ((pc->rgbmin[1] + pc->lgrs[1]) > CLGR) || (pc->lgrs[1] <= 0) ||
	   ((pc->rgbmin[2] + pc->lgrs[2]) > CLGRB) || (pc->lgrs[2] <= 0))
	  /* imerror(9,"bad lgrs cube %d\n",i) */;
}
