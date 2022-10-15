C/MEMBR ADD NAME=DASUM,SSI=0
      double precision function dasum(n,dx,incx)
c
c!but
c
c     cette fonction donne la somme des valeurs absolus des
c     n composantes d'un vecteur dx.
c
c!liste d'appel
c
c     double precision function dasum(n,dx,incx)
c
c     n: entier, taille du vecteur dx.
c
c     dx: double precision, vecteur dont on veut la somme des
c     valeurs absolues de ses composantes.
c
c     incx: increment entre deux composantes consecutives de dx.
c
c!auteur
c
c     jack dongarra, linpack, 3/11/78.
c!
c
      double precision dx(*),dtemp
      integer i,incx,n,nincx
c
      dasum = 0.0d+0
      dtemp = 0.0d+0
      if(n.le.0)return
      nincx = n*incx
      do 10 i = 1,nincx,incx
        dtemp = dtemp + abs(dx(i))
   10 continue
      dasum = dtemp
c
      end
