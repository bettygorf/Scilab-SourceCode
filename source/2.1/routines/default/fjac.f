C/MEMBR ADD NAME=FJAC,SSI=0
      subroutine fjac (neq, t, y, ml, mu, pd, nrpd)
c!
c  interface de calcul du jacobien pour la fonction scilab ode
c!
      include '../stack.h'

      integer ml,mu,neq,nrpd
      double precision pd(nrpd,*),t,y(*)
c
      integer it1
c
      character*6   name,nam1
      common /cjac/ name
      integer         iero
      common /ierode/ iero
c
      iero=0
      call majmin(6,name,nam1)
c
c exemple d appel correspondant a l'intruction scilab
c     ode(y0,t0,t1,f,'jex') .
c pour interfacer d'autres simulateurs modifier les lignes entre c+
c qui suivent en fonction du nom de la ou des routines a appeler.
c+
      if(nam1.eq.'jex') then
       call jex(neq,t,y,ml,mu,pd,nrpd)
       return
      endif
c+
c sous programmes lies dynamiquement.
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
cc sun unix
      call dyncall(it1-1,neq,t,y,ml,mu,pd,nrpd)
cc fin
      return
c
 2000 iero=1
      buf=name
      return
      end
