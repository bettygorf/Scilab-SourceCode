C/MEMBR ADD NAME=DSWAP,SSI=0
      subroutine  dswap (n,dx,incx,dy,incy)
c
c!but
c
c     cette subroutine echange le contenu de deux vecteurs double
c     precision dx et dy. dans le cas ou les deux increments sont
c     egaux a 1 elle emploie des boucles "epanouis".
c     dans le cas ou les increments sont negatifs cette
c     subroutine prend les composantes en ordre inverse.
c
c!liste d'appel
c
c     subroutine  dswap (n,dx,incx,dy,incy)
c
c     n: entier, nombre d'elements de dx ou dy.
c
c     dx, dy: vecteurs double precision.
c
c     incx, incy: entiers, increments entre deux composantes
c     des vecteurs dx et dy, respectivament.
c
c!auteur
c
c     jack dongarra, linpack, 3/11/78.
c
c!
c
      double precision dx(*),dy(*),dtemp
      integer i,incx,incy,ix,iy,n
c
      if(n.le.0)return
      if(incx.eq.1.and.incy.eq.1)go to 20
c
c code for unequal increments or equal increments not equal to 1
c
      ix = 1
      iy = 1
      if(incx.lt.0)ix = (-n+1)*incx + 1
      if(incy.lt.0)iy = (-n+1)*incy + 1
      do 10 i = 1,n
        dtemp = dx(ix)
        dx(ix) = dy(iy)
        dy(iy) = dtemp
        ix = ix + incx
        iy = iy + incy
   10 continue
      return
c
c code for both increments equal to 1
c
   20 continue
      do 30 i = 1,n
        dtemp = dx(i)
        dx(i) = dy(i)
        dy(i) = dtemp
   30 continue
c
      end
