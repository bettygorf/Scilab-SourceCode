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



readgif(pnf)
struct extimage **pnf;
{
	register struct extimage *nfgif;
	nfgif = *pnf;
	LZWDecode(pnf);
	if(nfgif->interlace)
		un_interlace(nfgif);
}

/* image gif entrelacee :
lignes de 8 en 8 a partir de 0 (0,8,16),
puis de 8 en 8 a partir de 4 (4,12,20),
puis de 4 en 4 a partir de 2 (2, 6,10),
enfin de 2 en 2 a partir de 1 (1,3,5)
*/
static char line_incr[]= {8,8,4,2};
static char line_start[] = {0,4,2,1};
un_interlace(nfgif)
register struct extimage *nfgif;
{
	int incr[4], start[4];
	register i, j, nx, ny, dy, y, incp;
	register unsigned char *data2;
	register unsigned char *p1, *p2;
	nx = nfgif->dimx;
	ny = nfgif->dimy;
	data2 = (char *)i_malloc(nx * ny);
	for(i=0;i<4;i++) {
		incr[i] = line_incr[i] * nx;
		start[i] = line_start[i] * nx;
	}
	p1 = nfgif->data;
	for(j=0;j<4;j++) {
		y = line_start[j];
		p2 = data2 + start[j];
		dy = line_incr[j];
		incp = incr[j];
		while(y < ny) {
			memcpy(p2,p1,nx);
			p1 += nx;
			p2 += incp;
			y += dy;
		}
	}
	i_Free(&nfgif->data);
	nfgif->data = data2;
}
