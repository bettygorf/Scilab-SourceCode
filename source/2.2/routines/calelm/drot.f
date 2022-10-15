C/MEMBR ADD NAME=DROT,SSI=0
      subroutine  drot (n,dx,incx,dy,incy,c,s)
c
c!but
c
c     etant donne deux vecteurs colonnes dx et dy, on applique
c     la transformation plane:
c
c                                      |c  -s|
c                   |dx  dy| = |dx dy|*|     |
c                                      |s   c|
c
c     dans le cas ou les increments sont negatifs cette
c     subroutine prend les composantes en ordre inverse.
c
c!liste d'appel
c
c     subroutine  drot (n,dx,incx,dy,incy,c,s)
c
c     n: entier, taille des vecteurs.
c
c     dx, dy: vecteurs double precision.
c
c     incx, incy: increments entre les elements des vecteurs.
c
c     c, s: double precision. ils sont supposes etre cosinus et
c     sinus, respectivement, du meme angle, mais on n'effectue
c     pas de verification.
c
c!auteur
c
c     jack dongarra, linpack, 3/11/78.
c
c!
c
      double precision dx(*),dy(*),dtemp,c,s
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
        dtemp = c*dx(ix) + s*dy(iy)
        dy(iy) = c*dy(iy) - s*dx(ix)
        dx(ix) = dtemp
        ix = ix + incx
        iy = iy + incy
   10 continue
      return
c
c code for both increments equal to 1
c
   20 do 30 i = 1,n
        dtemp = c*dx(i) + s*dy(i)
        dy(i) = c*dy(i) - s*dx(i)
        dx(i) = dtemp
   30 continue
      return
      end
