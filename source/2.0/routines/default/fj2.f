      subroutine fj2(ny,t,y,s,ml,mu,p,nrowp)
c!
c    interface pour l'integration des systemes implicites
c    le common /cjac/ contient le nom  de la routine a appeler
c!
c    la routine appelee doit calculer le jacobien de la
c    fonction res=g(t,y)-a(t,y)*s
c    p(i,j)=dres(i)/dy(j)
c
      include '../stack.h'
      integer ml,mu,nrowp,ny
      double precision p(nrowp,*),s(*),t,y(*)
c
      character*6   name,nam1
      common /cjac/ name
      integer         iero
      common /ierode/ iero
c
      iero=0
      call majmin(6,name,nam1)
c
c pour appeler un autre programme modifier les lignes entre c+
c+
      if(nam1.eq.'dgbydy') then
        call dgbydy(ny,t,y,s,ml,mu,p,nrowp)
        return
      endif
c+
c sous programmes lies dynamiquement.
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
cc sun unix
      call dyncall(it1-1,ny,t,y,s,ml,mu,p,nrowp)
cc fin
      return
 2000 iero=1
      buf=name
      call error(50)
      return
      end
