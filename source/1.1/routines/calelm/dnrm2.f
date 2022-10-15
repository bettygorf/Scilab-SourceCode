C/MEMBR ADD NAME=DNRM2,SSI=0
      double precision function dnrm2 ( n, dx, incx)
      integer          next
      double precision   dx(*), cutlo, cuthi, hitest, sum, xmax,zero,one
      data   zero, one /0.0d+0, 1.0d+0/
c
c!but
c
c     cette subroutine calcule la norme euclidienne (ou l2) d'un
c     vecteur dx de taille n.
c     si la taille n du vecteur est egal a 0, le resultat sera
c     nul. si la taille est plus grande ou egal a 1, ainsi
c     doit etre l'increment.
c
c!liste d'appel
c
c     double precision function dnrm2 ( n, dx, incx)
c
c     n: entier.
c
c     dx: vecteur double precision.
c
c     incx: increment entre les composantes du vecteur dx.
c
c!auteur
c
c           c.l.lawson, 1978 jan 08
c
c!methode
c
c     methode a quatre phases qui emploie deux constantes
c     fournies, qui sont heureusement applicables a toutes les
c     machines.
c         cutlo = maximum de sqrt(u/eps) sur toutes les machines
c                 connues.
c
c         cuthi = minimum of  sqrt(v)sur toutes les machines
c                 connues.
c     ou
c         eps = plus petit nombre tel que eps + 1. .gt. 1.
c         u   = plus petit nombre positif (limite underflow).
c         v   = plus grand nombre (limite overflow).
c
c!description de l'algorithme
c
c     phase 1    cherche les composantes nulles
c     va a la phase 2 quand une composante est non nulle et
c     plus petite ou egale a cutlo.
c     va a la phase 3 quand une composante est plus grande que cutlo.
c     va a la phase 4 quand una composante est plus grande ou egal a
c     cuthi/m
c     avec m = n pour x() reel et m = 2*n pour complexe.
c
c!
c     values for cutlo and cuthi..
c     from the environmental parameters listed in the imsl converter
c     document the limiting values are as follows..
c     cutlo, s.p.   u/eps = 2**(-102) for  honeywell.  close seconds are
c                   univac and dec at 2**(-103)
c                   thus cutlo = 2**(-51) = 4.44089e-16
c     cuthi, s.p.   v = 2**127 for univac, honeywell, and dec.
c                   thus cuthi = 2**(63.5) = 1.304380e+19
c     cutlo, d.p.   u/eps = 2**(-67) for honeywell and dec.
c                   thus cutlo = 2**(-33.5) = 8.231810d-11
c     cuthi, d.p.   same as s.p.  cuthi = 1.304380d+19
c     data cutlo, cuthi / 8.2320d-11,  1.3040d+19 /
c     data cutlo, cuthi / 4.4410e-16,  1.3040e+19 /
      data cutlo, cuthi / 8.2320d-11,  1.3040d+19 /
c
      if(n .gt. 0) go to 10
         dnrm2  = zero
         go to 300
c
   10 assign 30 to next
      sum = zero
      nn = n * incx
c                                                 begin main loop
      i = 1
   20    go to next,(30, 50, 70, 110)
   30 if( abs(dx(i)) .gt. cutlo) go to 85
      assign 50 to next
      xmax = zero
c
c                        phase 1.  sum is zero
c
   50 if( dx(i) .eq. zero) go to 200
      if( abs(dx(i)) .gt. cutlo) go to 85
c
c                                prepare for phase 2.
      assign 70 to next
      go to 105
c
c                                prepare for phase 4.
c
  100 i = j
      assign 110 to next
      sum = (sum / dx(i)) / dx(i)
  105 xmax = abs(dx(i))
      go to 115
c
c                   phase 2.  sum is small.
c                             scale to avoid destructive underflow.
c
   70 if( abs(dx(i)) .gt. cutlo ) go to 75
c
c                     common code for phases 2 and 4.
c                     in phase 4 sum is large.  scale to avoid overflow.
c
  110 if( abs(dx(i)) .le. xmax ) go to 115
         sum = one + sum * (xmax / dx(i))**2
         xmax = abs(dx(i))
         go to 200
c
  115 sum = sum + (dx(i)/xmax)**2
      go to 200
c
c
c                  prepare for phase 3.
c
   75 sum = (sum * xmax) * xmax
c
c
c     for real or d.p. set hitest = cuthi/n
c     for complex      set hitest = cuthi/(2*n)
c
   85 hitest = cuthi/real( n )
c
c                   phase 3.  sum is mid-range.  no scaling.
c
      do 95 j =i,nn,incx
      if(abs(dx(j)) .ge. hitest) go to 100
   95    sum = sum + dx(j)**2
      dnrm2 = sqrt( sum )
      go to 300
c
  200 continue
      i = i + incx
      if ( i .le. nn ) go to 20
c
c              end of main loop.
c
c              compute square root and adjust for scaling.
c
      dnrm2 = xmax * sqrt(sum)
  300 continue
      return
      end
