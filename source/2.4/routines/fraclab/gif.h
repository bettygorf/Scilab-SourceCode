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

#include <errno.h>
#define LG_NAME 256
struct extimage {
	char name[LG_NAME];
	FILE *file;
	int dimx, dimy, size;
	int nbits; /* bits/ pixel */
	unsigned char *data;
	unsigned char *cindex;  /* color index, used by quantize */
	int numcols;
	short interlace, flg89;
	unsigned char rbuf[256], gbuf[256], bbuf[256];  /* color tables */
};

/* gif structure (les shorts sont swappés)
1 bloc= 1 char longueur, n char data

file:
6 char : GIF87a ou GIF89a

2 short : screen width and height
1 char : flag (0x80= colormap, 0x70= nb -1 color resolution bits, 0x7 = nb bits - 1 => nb colors = 2 ** nbits)
1 char : background
1 char : aspect ratio ,   (float) (byte + 15) / 64.

3 * nbcolors char : colormap si presente (rgb,rgb,...)

1 char type :
	';'  : fin de fichier
	'!' : extension block, suivi de 
		1 char type suivi de blocks, terminés par block de taille nulle
		   types: 0xf9 transparence 
		          0xfe comment
			  0x1  plain text
	',' : image separator, suivi des données image


Image:
2 short : left offset , top offset
2 short : image width, height
1 char  : flag (0x40 = entrelacé, 0x80= colormap, 0x7 = nbits-1)
3*ncolors char si colormap
LZWencoded data


*/
