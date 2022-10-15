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

#define MaxCode(number_bits)  ((1 << (number_bits))-1)
#define MaxHashTable  5003
#define MaxLZWBits  12
#define MaxLZWTable  (1 << MaxLZWBits)
#define LZWOutputCode(code) \
{ \
  /*  \
    Emit a code. \
  */ \
  if (bits > 0) \
    datum|=((long) code << bits); \
  else \
    datum=(long) code; \
  bits+=number_bits; \
  while (bits >= 8)  \
  { \
    /*  \
      Add a character to current packet. \
    */ \
    packet[byte_count++]=(unsigned char) (datum & 0xff); \
    if (byte_count >= 254) \
      { \
        (void) putc(byte_count,file); \
        (void) fwrite((char *) packet,1,byte_count,file); \
        byte_count=0; \
      } \
    datum>>=8; \
    bits-=8; \
  } \
  if (free_code > max_code)  \
    { \
      number_bits++; \
      if (number_bits == MaxLZWBits) \
        max_code=MaxLZWTable; \
      else \
        max_code=MaxCode(number_bits); \
    } \
}

unsigned int LZWEncode(pnf)
struct extimage **pnf;
{
	FILE *file;
	struct extimage *nfgif;
	int bits, byte_count, next_pixel, number_bits, data_size;

	long datum;

	register int displacement, i, j;

	register unsigned char *buf;

	short clear_code, end_of_information_code, free_code,
	*hash_code, *hash_prefix, index, max_code, waiting_code;

	unsigned char *packet, *hash_suffix;

	/*
	   Allocate encoder tables.
	   */
	packet=(unsigned char *) i_malloc(256*sizeof(unsigned char));
	hash_code=(short *) i_malloc(MaxHashTable*sizeof(short));
	hash_prefix=(short *) i_malloc(MaxHashTable*sizeof(short));
	hash_suffix=(unsigned char *) i_malloc(MaxHashTable*sizeof(unsigned char));
	nfgif = *pnf;
	file = nfgif->file;
	buf = nfgif->data;
	/*
	   Initialize LZW encoder.
	   */
	data_size= nfgif->nbits + 1;
	if(data_size < 3)
		data_size = 3;
	number_bits = data_size;
	max_code= MaxCode(number_bits);
	clear_code=((short) 1 << (data_size - 1));
	end_of_information_code=clear_code+1;
	free_code=clear_code+2;
	byte_count=0;
	datum=0;
	bits=0;
	for (i=0; i < MaxHashTable; i++)
		hash_code[i]=0;
	LZWOutputCode(clear_code);
	/*
	   Encode pixels.
	   */

	waiting_code= *buf;
	for (i=1; i < nfgif->size; i++) {
		/*
		   Probe hash table.
		   */
		buf++;
#if 0
		index = *buf & 0xff;
#else
		index = *buf;
#endif
		j=(int) ((int) index << (MaxLZWBits-8))+waiting_code;
		if (j >= MaxHashTable)
			j-=MaxHashTable;
		if (hash_code[j] > 0) {
			if ((hash_prefix[j] == waiting_code) && (hash_suffix[j] == index)) {
				waiting_code=hash_code[j];
				continue;
			}
			if (j == 0)
				displacement=1;
			else
				displacement=MaxHashTable-j;
			next_pixel=0;
			for ( ; ; ) {
				j-=displacement;
				if (j < 0)
					j+=MaxHashTable;
				if (hash_code[j] == 0)
					break;
				if ((hash_prefix[j] == waiting_code) && (hash_suffix[j] == index)) {
					waiting_code=hash_code[j];
					next_pixel= 1;
					break;
				}
			}
			if (next_pixel == 1)
				continue;
		}
		LZWOutputCode(waiting_code);
		if (free_code < MaxLZWTable) {
			hash_code[j]=free_code++;
			hash_prefix[j]=waiting_code;
			hash_suffix[j]=index;
		} else {
			/*
			   Fill the hash table with empty entries.
			   */
			for (j=0; j < MaxHashTable; j++)
				hash_code[j]=0;
			/*
			   Reset compressor and issue a clear code.
			   */
			free_code=clear_code+2;
			LZWOutputCode(clear_code);
			number_bits = data_size;
			max_code=MaxCode(number_bits);
		}
		waiting_code=index;
	}
	/*
	   Flush out the buffered code.
	   */
	LZWOutputCode(waiting_code);
	LZWOutputCode(end_of_information_code);
	if (bits > 0) {
		/*
		   Add a character to current packet.
		   */
		packet[byte_count++]=(unsigned char) (datum & 0xff);
		if (byte_count >= 254) {
			(void) putc(byte_count,file);
			(void) fwrite((char *) packet,1,byte_count,file);
			byte_count=0;
		}
	}
	/*
	   Flush accumulated data.
	   */
	if (byte_count > 0) {
		(void) putc(byte_count,file);
		(void) fwrite((char *) packet,1,byte_count,file);
	}
	/*
	   Free encoder memory.
	   */
	(void) free((char *) hash_suffix);
	(void) free((char *) hash_prefix);
	(void) free((char *) hash_code);
	(void) free((char *) packet);
	return(0);
}
