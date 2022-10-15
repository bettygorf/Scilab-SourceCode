      subroutine fjacd(t,y,ydot,pd,cj,rpar,ipar)
c!
c user interface for dassl/dassrt for jacobian evaluation
c g(t,y,ydot).
c!
      include '../stack.h'
c
      integer ires,ipar(*)
      double precision t,y(*),ydot(*),rpar(*),cj,pd(*)
c
      integer it1
c
      character*6    namer,namej,names,nam1
      common /dassln/ namer,namej,names

      call majmin(6,namej,nam1)
c
c 
c INSERt CALL tO yOUR OWN ROUtINE HERE 
c the routine jac2 is an example: it is called when the
c string 'jac2' is given as a parameter 
c in the calling sequence of scilab's dassl (or dassrt) built-in
c function 
c+
      if(nam1.eq.'djac1') then
      call djac1 (t, y, ydot, pd, cj, rpar, IPAR)
      return
      endif
c
      if(nam1.eq.'djac2') then
      call djac2 (t, y, ydot, pd, cj, rpar, IPAR)
      return
      endif
c 
      if(nam1.eq.'jac2') then
      call jac2 (t, y, ydot, pd, cj, rpar, IPAR)
      return
      endif
c+
c     dynamic link
      call tlink(namej,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,t,y,ydot,pd,cj,rpar,IPAR)
cc fin
      return
c
 2000 ires=-2
      buf=namej
      call error(50)
      return
      end

      subroutine jac2 (t, y, ydot, pd, cj, rpar, ipar)

      implicit double precision (a-h,o-z)
      integer  nrowpd
      double precision t, y, pd
      parameter (nrowpd=2)
      dimension y(2), pd(nrowpd,2)
c
c first define the jacobian matrix for the right hand side
c of the ode: f' = f(t,y) , i.e. df/dy)
c
      pd(1,1) = 0.0d0
      pd(1,2) = 1.0d0
      pd(2,1) = -200.0d0*y(1)*y(2) - 1.0d0
      pd(2,2) = 100.0d0*(1.0d0 - y(1)*y(1))
c
c next update the jacobian with the right hand side to form the
c dae jacobian: d(f'-f)/dy = df'/dy - df/dy = i - df/dy
c
      pd(1,1) = cj - pd(1,1)
      pd(1,2) =    - pd(1,2)
      pd(2,1) =    - pd(2,1)
      pd(2,2) = cj - pd(2,2)
c
      return
      end


      subroutine djac1(t,y,yprime,pd,cj,rpar,ipar)
      implicit double precision(a-h,o-z)
      dimension y(*),yprime(*),pd(2,2)
      pd(1,1) = cj + 10.0d0
      pd(1,2) = 0.0d0
      pd(2,1) = 1.0d0
      pd(2,2) = 1.0d0
      return
      end

      subroutine djac2(t,y,yprime,pd,cj,rpar,ipar)
      implicit double precision(a-h,o-z)
      dimension y(*), pd(11,*), yprime(*),rpar(*)
      data alph1/1.0d0/, alph2/1.0d0/, ng/5/
      data ml/5/, mu/0/, neq/25/
      mband = ml + mu + 1
      mbandp1 = mband + 1
      mbandp2 = mband + 2
      mbandp3 = mband + 3
      mbandp4 = mband + 4
      mbandp5 = mband + 5
      do 10 j = 1,neq
        pd(mband,j) = -2.0d0 - cj
        pd(mbandp1,j) = alph1
        pd(mbandp2,j) = 0.0d0
        pd(mbandp3,j) = 0.0d0
        pd(mbandp4,j) = 0.0d0
 10     pd(mbandp5,j) = alph2
      do 20 j = 1,neq,ng
 20     pd(mbandp1,j) = 0.0d0
      return
      end
