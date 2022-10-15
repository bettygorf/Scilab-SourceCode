      subroutine fresd(t,y,ydot,res,ires,rpar,ipar)
c!
c user interface for dassl
c subroutine res returns res=g(t,y,ydot)
c!
      include '../stack.h'
c
      integer ires,ipar(*)
      double precision t,y(*),ydot(*),res(*),rpar(*)
c
      integer it1
c
      character*6    namer,namej,names,nam1
      common /dassln/ namer,namej,names

      call majmin(6,namer,nam1)
c
c insert call to your own routine here 
c the routine dres1 is an example: it is called when the
c string 'dres1' is given as a parameter 
c in the calling sequence of scilab's ddasl/ddasrt built-in
c function 
c+
      if(nam1.eq.'dres1') then
      call dres1(t,y,ydot,res,ires,rpar,ipar)
      return
      endif
c
      if(nam1.eq.'dres2') then
      call dres2(t,y,ydot,res,ires,rpar,ipar)
      return
      endif
c
      if(nam1.eq.'res1') then
      call res1(t,y,ydot,res,ires,rpar,ipar)
      return
      endif
c
      if(nam1.eq.'res2') then
      call res2(t,y,ydot,res,ires,rpar,ipar)
      return
      endif
c+
c     dynamic link
      call tlink(namer,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,t,y,ydot,res,ires,rpar,ipar)
cc fin
      return
c
 2000 ires=-2
      buf=namer
      call error(50)
      return
      end

      subroutine res1(t,y,ydot,delta,ires,rpar,ipar)
      implicit double precision (a-h,o-z)
      dimension y(*), ydot(*), delta(*),rpar(*)
      neq=1
c
c     check y to make sure that it is valid input.
c     if y is less than or equal to zero, this is invalid input.
c
      if (y(1) .le. 0.0d0) then
         ires = -1
      else
c
c        call f to obtain f(t,y)
c
         call f1(neq,t,y,delta)
c
c        form f = f'-f(t,y)
c
         do 10 i = 1,neq
            delta(i) = ydot(i) - delta(i)
 10      continue
      endif
c
      return
      end
c
      subroutine f1 (neq, t, y, ydot)
      integer neq
      double precision t, y, ydot
      dimension y(*), ydot(*)
      ydot(1) = ((2.0d0*log(y(1)) + 8.0d0)/t - 5.0d0)*y(1)
      return
      end
c

      subroutine res2(t,y,ydot,delta,ires,rpar,ipar)
      implicit double precision (a-h,o-z)
      integer neq
      dimension y(*), ydot(*), delta(*)
      neq=2
c
c     call f to obtain f(t,y)
c
      call f2(neq,t,y,delta)
c
c     form f = f'-f(t,y)
c
      do 10 i = 1,neq
         delta(i) = ydot(i) - delta(i)
 10   continue
c
      return
      end
c
      subroutine f2 (neq, t, y, ydot)
      implicit double precision (a-h,o-z)
      integer neq
      double precision t, y, ydot
      dimension y(*), ydot(*)
      ydot(1) = y(2)
      ydot(2) = 100.0d0*(1.0d0 - y(1)*y(1))*y(2) - y(1)
      return
      end

      subroutine dres1(t,y,ydot,res,ires,rpar,ipar)
      implicit double precision(a-h,o-z)
      dimension y(*),ydot(*),res(*),rpar(*)
      res(1) = ydot(1) + 10.0d0*y(1)
      res(2) = y(2) + y(1) - 1.0d0
      return
      end


      subroutine dres2(t,y,ydot,res,ires,rpar,ipar)
      implicit double precision(a-h,o-z)
      dimension y(*),ydot(*),res(*),rpar(*)
      data alph1/1.0d0/, alph2/1.0d0/, ng/5/
      do 10 j = 1,ng
      do 10 i = 1,ng
        k = i + (j - 1)*ng
        d = -2.0d0*y(k)
        if (i .ne. 1) d = d + y(k-1)*alph1
        if (j .ne. 1) d = d + y(k-ng)*alph2
 10     res(k) = d - ydot(k)
      return
      end

