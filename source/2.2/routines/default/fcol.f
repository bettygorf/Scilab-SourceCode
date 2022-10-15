      subroutine fcoldg(i,z,dg)
c     colnew external calling 
c=====================================
      include '../stack.h'
      double precision z(*), dg(*)
      integer i,it1
      character*6    nam1,efsub,edfsub,egsub,edgsub,eguess
      integer         iero
      common /iercol/ iero
      common / colname / efsub,edfsub,egsub,edgsub,eguess
c
      iero=0
      call majmin(6,edgsub,nam1)
c     INSERT YOUR OWN ROUTINE HERE:
c+
      if(nam1.eq.'dg') then
       call dg1(i,z,dg)
       return
      endif
c+
c     dynamic link
      call tlink(edgsub,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,i,z,dg)
cc fin
      return
c
 2000 iero=1
      buf=edgsub
      call error(50)
      return
      end

      subroutine fcolg(i,z,g)
c     colnew external calling 
c=====================================
      include '../stack.h'
      double precision z(*), g(*)
      integer i,it1
      character*6 nam1,efsub,edfsub,egsub,edgsub,eguess
      integer         iero
      common /iercol/ iero
      common / colname / efsub,edfsub,egsub,edgsub,eguess
c
      iero=0
      call majmin(6,egsub,nam1)
c     INSERT YOUR OWN ROUTINE HERE:
c+
      if(nam1.eq.'g') then
       call g1(i,z,g)
       return
      endif
c+
c     dynamic link
      call tlink(egsub,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,i,z,g)
cc fin
      return
c
 2000 iero=1
      buf=egsub
      call error(50)
      return
      end

      subroutine fcoldf(x,z,df)
c     colnew external calling 
c=====================================
      include '../stack.h'
      double precision z(*), df(*),x
      integer it1
      character*6  nam1,efsub,edfsub,egsub,edgsub,eguess
      integer         iero
      common /iercol/ iero
      common / colname / efsub,edfsub,egsub,edgsub,eguess
c
      iero=0
      call majmin(6,edfsub,nam1)
c INSERT YOUR OWN ROUTINE HERE
c+
      if(nam1.eq.'df') then
       call df11(x,z,df)
       return
      endif
c+
c     dynamic link
      call tlink(edfsub,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,x,z,df)
cc fin
      return
c
 2000 iero=1
      buf=edfsub
      call error(50)
      return
      end

      subroutine fcolf(x,z,f)
c     colnew external calling 
c=====================================
      include '../stack.h'
      double precision z(*), f(*),x
      integer it1
      character*6  nam1,efsub,edfsub,egsub,edgsub,eguess
      integer         iero
      common /iercol/ iero
      common / colname / efsub,edfsub,egsub,edgsub,eguess
c
      iero=0
      call majmin(6,efsub,nam1)
c INSERT YOUR ROUTINE HERE:
c+
      if(nam1.eq.'f') then
       call f11(x,z,f)
       return
      endif
c+
c     dynamic link
      call tlink(efsub,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,x,z,f)
cc fin
      return
c
 2000 iero=1
      buf=efsub
      call error(50)
      return
      end

      subroutine fcolgu(x,z,dmval)
c     colnew external calling 
c=====================================
      include '../stack.h'
      double precision z(*), dmval(*),x
      integer it1 
      character*6  nam1,efsub,edfsub,egsub,edgsub,eguess
      integer         iero
      common /iercol/ iero
      common / colname / efsub,edfsub,egsub,edgsub,eguess
c
      iero=0
      call majmin(6,eguess,nam1)
c INSERT YOUR OWN ROUTINE HERE:
c+
      if(nam1.eq.'gu') then
       call solutn(x,z,dmval)
       return
      endif
c+
c     dynamic link
      call tlink(eguess,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,x,z,dmval)
      return
c
 2000 iero=1
      buf=eguess
      call error(50)
      return
      end

c................................................................
      subroutine solutn (x, z, dmval)
      implicit double precision  (a-h,o-z)
      dimension z(4) , dmval(2)
      double precision gamma, xt
      data gamma/1.1d0/, xt/1/
      xt = dsqrt(2.d0*(gamma-1.d0)/gamma)
      cons = gamma * x * (1.d0-.5d0*x*x)
      dcons = gamma * (1.d0 - 1.5d0*x*x)
      d2cons = -3.d0 * gamma * x
      if (x .gt. xt) go to 10
      z(1) = 2.d0 * x
      z(2) = 2.d0
      z(3) = -2.d0*x + cons
      z(4) = -2.d0 + dcons
      dmval(2) = d2cons
      go to 20
   10 z(1) = 0.d0
      z(2) = 0.d0
      z(3) = -cons
      z(4) = -dcons
      dmval(2) = -d2cons
   20 dmval(1) = 0.d0
      return
      end
c................................................................
      subroutine f11 (x, z, f)
      implicit double precision  (a-h,o-z)
      dimension z(4), f(2)
      double precision eps, dmu, eps4mu, gamma, xt
      data eps/.01d0/, dmu/.01d0/, eps4mu/1.0/, gamma/1.1d0/, xt/1/
      eps4mu =eps**4/dmu
      xt = dsqrt(2.d0*(gamma-1.d0)/gamma)
      f(1) = z(1)/x/x - z(2)/x + (z(1) - z(3)*(1.d0-z(1)/x) -
     .       gamma*x*(1.d0-x*x/2.)) / eps4mu
      f(2) = z(3)/x/x - z(4)/x + z(1)*(1.d0-z(1)/2.d0/x) / dmu
      return
      end
c................................................................
      subroutine df11 (x, z, df)
      implicit double precision  (a-h,o-z)
      dimension z(4), df(2,4)
      double precision eps, dmu, eps4mu, gamma, xt
      data eps/.01d0/, dmu/.01d0/, eps4mu/1/, gamma/1.1d0/, xt/1/
      eps4mu =eps**4/dmu
      xt = dsqrt(2.d0*(gamma-1.d0)/gamma)
      df(1,1) = 1.d0/x/x +(1.d0 + z(3)/x) / eps4mu
      df(1,2) = -1.d0/x
      df(1,3) = -(1.d0-z(1)/x) / eps4mu
      df(1,4) = 0.d0
      df(2,1) = (1.d0 - z(1)/x) / dmu
      df(2,2) = 0.d0
      df(2,3) = 1.d0/x/x
      df(2,4) = -1.d0/x
      return
      end
c................................................................
      subroutine g1 (i, z, g)
      implicit double precision  (a-h,o-z)
      dimension z(4)
      go to (1, 2, 1, 3), i
    1 g = z(1)
      return
    2 g = z(3)
      return
    3 g = z(4) - .3d0*z(3) + .7d0
      return
      end
c................................................................
      subroutine dg1 (i, z, dg)
      implicit double precision  (a-h,o-z)
      dimension z(4), dg(4)
      do 10 j=1,4
   10    dg(j) = 0. d0
      go to (1, 2, 1, 3), i
    1 dg(1) = 1.d0
      return
    2 dg(3) = 1.d0
      return
    3 dg(4) = 1.d0
      dg(3) = -.3d0
      return
      end
c
c----------------------------------------------------------------
c

