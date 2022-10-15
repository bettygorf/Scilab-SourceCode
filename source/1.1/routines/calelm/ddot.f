C/MEMBR ADD NAME=DDOT,SSI=0
      double precision function ddot(n,dx,incx,dy,incy)
c!but
c
c     cette fonction calcule le produit scalaire de deux
c     vecteurs double precision. dans le cas ou l'increment est
c     negatif les composantes sont prises en ordre inverse.
c
c!liste d'appel
c
c      double precision function ddot(n,dx,incx,dy,incy)
c
c     n: entier, taille des vecteurs.
c
c     dx, dy: vecteurs double precision.
c
c     incx, incy: increments entre les composantes des vecteurs.
c
c!auteur
c     jack dongarra, linpack, 3/11/78.
c!
c
      double precision dx(*),dy(*),dtemp
      integer i,incx,incy,ix,iy,n
c
      ddot = 0.0d+0
      dtemp = 0.0d+0
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
        dtemp = dtemp + dx(ix)*dy(iy)
        ix = ix + incx
        iy = iy + incy
   10 continue
      ddot = dtemp
      return
c
c code for both increments equal to 1
c
   20 continue
      do 30 i = 1,n
        dtemp = dtemp + dx(i)*dy(i)
   30 continue
      ddot = dtemp
c
      end
