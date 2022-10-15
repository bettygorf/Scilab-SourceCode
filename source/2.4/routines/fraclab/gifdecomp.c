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

/* this program  was writem from compress.c of ImageMagic :
%                           Software Design                                   %
%                             John Cristy                                     %
%                              May  1993                                      %
%                                                                             %
%                                                                             %
%  Copyright 1994 E. I. du Pont de Nemours & Company                          %
%                                                                             %
%  Permission to use, copy, modify, distribute, and sell this software and    %
%  its documentation for any purpose is hereby granted without fee,           %
%  provided that the above Copyright notice appear in all copies and that     %
%  both that Copyright notice and this permission notice appear in            %
%  supporting documentation, and that the name of E. I. du Pont de Nemours    %
%  & Company not be used in advertising or publicity pertaining to            %
%  distribution of the software without specific, written prior               %
%  permission.  E. I. du Pont de Nemours & Company makes no representations   %
%  about the suitability of this software for any purpose.  It is provided    %
%  "as is" without express or implied warranty.                               %
%                                                                             %
%  E. I. du Pont de Nemours & Company disclaims all warranties with regard    %
%  to this software, including all implied warranties of merchantability      %
%  and fitness, in no event shall E. I. du Pont de Nemours & Company be       %
%  liable for any special, indirect or consequential damages or any           %
%  damages whatsoever resulting from loss of use, data or profits, whether    %
%  in an action of contract, negligence or other tortious action, arising     %
%  out of or in connection with the use or performance of this software.      %
%                                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/

unsigned int LZWDecode(pnf)
struct extimage **pnf;
{
#define MaxStackSize  4096
#define NullCode  (-1)
	struct extimage *nfgif;

	int
		available,
		clear,
		code_mask,
		code_size,
		end_of_information,
		in_code,
		old_code;

	register int
		bits,
		code,
		count,
		i;
	
	
	register unsigned char *c;
	
	register unsigned int datum;
	
	short *prefix;
	char * buf;
	unsigned char
		data_size,
		first,
		*packet,
		*pixel_stack,
		*suffix,
		*top_stack;
	
	/*
	   Allocate decoder tables.
	   */
	packet=(unsigned char *) malloc(256*sizeof(unsigned char));
	prefix=(short *) malloc(MaxStackSize*sizeof(short));
	suffix=(unsigned char *) malloc(MaxStackSize*sizeof(unsigned char));
	pixel_stack=(unsigned char *) malloc(MaxStackSize*sizeof(unsigned char));
	if ((packet == (unsigned char *) NULL) ||
	    (prefix == (short *) NULL) ||
	    (suffix == (unsigned char *) NULL) ||
	    (pixel_stack == (unsigned char *) NULL))
		return(0);
	nfgif = *pnf;
	/*
	   Initialize LZW data stream decoder.
	   */
	data_size= (unsigned char)getc(nfgif->file);
	buf = nfgif->data;
	clear=1 << data_size;
	end_of_information=clear+1;
	available=clear+2;
	old_code=NullCode;
	code_size=data_size+1;
	code_mask=(1 << code_size)-1;
	for (code=0; code < clear; code++)
		{
			prefix[code]=0;
			suffix[code]=code;
		}
	/*
	   Decode LZW pixel stream.
	   */
	datum=0;
	bits=0;
	c=0;
	count=0;
	first=0;
	top_stack=pixel_stack;
	for (i=0; i < nfgif->size; ) {
		if (top_stack == pixel_stack) {
			if (bits < code_size) {
				/*
				   Load bytes until there is enough bits for a code.
				   */
				if (count == 0) {
					/*
					   Read a new data block.
					   */
					count=gif_rdblock(pnf,(char *) packet);
					if (count <= 0)
						break;
					c=packet;
				}
				datum +=(*c) << bits;
				bits +=8;
				c++;
				count--;
				continue;
			}
			/*
			   Get the next code.
			   */
			code=datum & code_mask;
			datum>>=code_size;
			bits-=code_size;
			/*
			   Interpret the code
			   */
			if ((code > available) || (code == end_of_information))
				break;
			if (code == clear) {
				/*
				   Reset decoder.
				   */
				code_size = data_size+1;
				code_mask = (1 << code_size)-1;
				available = clear+2;
				old_code = NullCode;
				continue;
			}
			if (old_code == NullCode) {
				*top_stack++ =suffix[code];
				old_code = code;
				first = code;
				continue;
			}
			in_code = code;
			if (code == available) {
				*top_stack++ = first;
				code = old_code;
			}
			while (code > clear) {
				*top_stack++ = suffix[code];
				code = prefix[code];
			}
			first = suffix[code];
			/*
			   Add a new string to the string table,
			   */
			*top_stack++ = first;
			prefix[available]=old_code;
			suffix[available]=first;
			available++;
			if (((available & code_mask) == 0) && (available < MaxStackSize)) {
				code_size++;
				code_mask+=available;
			}
			old_code=in_code;
		}
		/*
		   Pop a pixel off the pixel stack.
		   */
		top_stack--;
		*buf++ =  *top_stack;
		i++;
	}
	/*
	   Initialize any remaining color packets to a known color.
	   */
	for ( ; i < nfgif->size; i++) {
		*buf++ = 0;
	}
	/*
	   Free decoder memory.
	   */
	(void) free((char *) pixel_stack);
	(void) free((char *) suffix);
	(void) free((char *) prefix);
	(void) free((char *) packet);
	return(1);
}
