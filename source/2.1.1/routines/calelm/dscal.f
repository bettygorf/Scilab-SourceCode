C/MEMBR ADD NAME=DSCAL,SSI=0
      subroutine  dscal(n,da,dx,incx)
c
c!but
c
c     etant donne un vecteur double precision dx de taille n et
c     une constante double precision da, calcule dx=a*dx. dans
c     le cas ou l'increment est egal a 1 cette subroutine fait
c     des boucles "epanouis".
c
c!liste d'appel
c
c     subroutine  dscal(n,da,dx,incx)
c
c     n: entier, taille de dx.
c
c     da: constante double precision.
c
c     dx: vecteur double precision.
c
c     incx: entier, increment entre deux composantes du
c     vecteur dx.
c
c!auteur
c
c     jack dongarra, linpack, 3/11/78.
c
c!
c
      double precision da,dx(*)
      integer i,incx,n,nincx
c
      if(n.le.0)return
      if(incx.eq.1)go to 20
c
c code for increment not equal to 1
c
      nincx = n*incx
      do 10 i = 1,nincx,incx
        dx(i) = da*dx(i)
   10 continue
      return
c
c code for increment equal to 1
c
   20 continue
      do 30 i = 1,n
        dx(i) = da*dx(i)
   30 continue
c
      end
