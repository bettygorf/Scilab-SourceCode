C/MEMBR ADD NAME=IDAMAX,SSI=0
      integer function idamax(n,dx,incx)
c
c!but
c
c     la fonction idamax determine le plus petit indice i tel
c     que dx(i) est egal au max des modules des composantes du
c     vecteur double precision dx.
c
c!liste d'appel
c
c     integer function idamax(n,dx,incx)
c
c     n: entier, taille du vecteur dx.
c
c     dx: vecteur double precision.
c
c     incx: entier, increment entre deux composantes consecutives
c     de dx.
c
c!auteur
c
c     jack dongarra, linpack, 3/11/78.
c
c!
c
      double precision dx(*),dmax
      integer i,incx,ix,n
c
      idamax = 0
      if( n .lt. 1 ) return
      idamax = 1
      if(n.eq.1)return
      if(incx.eq.1)go to 20
c
c code for increment not equal to 1
c
      ix = 1
      dmax = abs(dx(1))
      ix = ix + incx
      do 10 i = 2,n
         if(abs(dx(ix)).le.dmax) go to 5
         idamax = i
         dmax = abs(dx(ix))
    5    ix = ix + incx
   10 continue
      return
c
c code for increment equal to 1
c
   20 dmax = abs(dx(1))
      do 30 i = 2,n
         if(abs(dx(i)).le.dmax) go to 30
         idamax = i
         dmax = abs(dx(i))
   30 continue
      return
      end
