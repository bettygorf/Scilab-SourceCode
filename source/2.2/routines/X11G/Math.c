/*------------------------------------------------------------------------
    Missile 
    XWindow and Postscript library for 2D and 3D plotting 
    Copyright (C) 1990 Chancelier Jean-Philippe

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 1, or (at your option)
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

    jpc@arletty.enpc.fr 
    Phone : 43.04.40.98 poste : 3327 

--------------------------------------------------------------------------*/
#include "Math.h"

double Mini(vect,n)
     double vect[];
     integer n;
{
  int i;
  double vmin;
  vmin= vect[0];
  for (i =0 ; i < n ; i++)
    if (vect[i] < vmin) vmin=vect[i];
  return(vmin);
}


double Maxi(vect,n)
     double vect[];
     integer n;
{
  int i;
  double maxi;
  maxi= vect[0];
  for (i =0 ; i < n ; i++)
    if (vect[i] > maxi) maxi=vect[i];
  return(maxi);
}


