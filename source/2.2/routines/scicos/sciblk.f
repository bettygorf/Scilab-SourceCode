      subroutine sciblk(ptr,told,xc,nx,z,nz,uc,nu,rpar,nrpar,ipar,nipar,
     &     nclock,out,nout,flag)
C     routine used to evaluate a block defined by a scilab function
C     scilab function syntax must be
C     out=func(t,x,z,u,nclock,flag [,par] [,ipar])
C     with 
C        t      scalar
C        x      column vector
C        u      column vector
C        nclock integer
C        flag   integer
C        out    column vector
C!
      include "../stack.h"
      integer iadr,sadr
C
      integer mlhs,mrhs
      integer ptr,flag,nx,nz,nu,nout,ipar(*)
      double precision told,xc(*),z(*),uc(*),out(*),rpar(*)
C
      common /ierode/ iero
C
      iadr(l) = l + l - 1
      sadr(l) = (l/2) + 1
C
      if (ddt .eq. 4) then
        write (buf(1:12),"(3i4)") top, ptr
        call basout(io,wte," sciblk  top:"//buf(1:4)//" ptr :"//
     &       buf(5:8)      )
      endif
C
      if (flag.eq.4.or.flag.eq.2.and.nclock.gt.0) then
         mlhs = 2
      else
         mlhs = 1
      endif
      mrhs = 6
      iero = 0
      call dtosci(told,1,1)
      if (err .gt. 0) goto 9999
      call dtosci(xc,nx,1)
      if (err .gt. 0) goto 9999
      call dtosci(z,nz,1)
      if (err .gt. 0) goto 9999
      call dtosci(uc,nu,1)
      if (err .gt. 0) goto 9999
      call itosci(nclock,1,1)
      if (err .gt. 0) goto 9999
      call itosci(flag,1,1)
      if (err .gt. 0) goto 9999
      if(nrpar.gt.0) then
         call dtosci(rpar,nrpar,1)
         if (err .gt. 0) goto 9999
         mrhs=mrhs+1
      endif
      if(nipar.gt.0) then
         call itosci(ipar,nipar,1)
         if (err .gt. 0) goto 9999
         mrhs=mrhs+1
      endif
C     
C     macro execution 
C     
      pt = pt + 1
      if (pt .gt. psiz) then
        call error(26)
        if (err .gt. 0) goto 9999
      endif
      ids(1,pt) = lhs
      ids(2,pt) = rhs
      rstk(pt) = 1001
      lhs = mlhs
      rhs = mrhs
      niv = niv + 1
      fun = 0
      fin = ptr
C     
      icall = 5
      krec = -1
      include "../callinter.h"
 200  lhs = ids(1,pt)
      rhs = ids(2,pt)
      pt = pt - 1
C+    
C     transfer output variables to fortran
      if (mlhs.eq.2) then
c x+ computation of a discrete block (done in place)     
         if (nz.gt.0) then
            call scitod(z,nz,1)
         else
            top=top-1
         endif
         if (nx.gt.0) then
            call scitod(xc,nx,1)
         else
            top=top-1
         endif
      else
         if (nout.gt.0) then
            call scitod(out,nout,1)
         else
            top=top-1
         endif
      endif
      if (err .gt. 0) goto 9999
C+    
      niv = niv - 1
      return
C     
 9999 continue
      iero = -1
      flag=iero
      niv = niv - 1
      return
      end
      subroutine scitod(x,mx,nx)
C    scilab to fortran
C
C.. Formal Arguments .. 
      double precision  x(*)
      integer  mx
      integer  nx
C 
C.. Local Scalars .. 
      integer  il,l,lx
C 
C.. External Calls .. 
      external dcopy, error
C 
C.. Include Statements ..
      include "../stack.h"
C 
C.. Statement Functions ..
      integer  iadr
      integer  sadr
      iadr(l) = l + l - 1
      sadr(l) = (l/2) + 1
C 
C ... Executable Statements ...
C 
C
      il = iadr(lstk(top))
      if (istk(il) .ne. 1) then
        call error(98)
      elseif (istk(il+1).ne.mx.or.istk(il+2).ne.nx.or.istk(il+3).ne.0)
     &then
        call error(98)
      else
        lx = sadr(il+4)
        call dcopy(nx*mx,stk(lx),1,x,1)
        top = top - 1
      endif
      end 
      subroutine scitoi(x,mx,nx)
C    scilab to fortran
C
C.. Formal Arguments .. 
      integer  x(*)
      integer  mx
      integer  nx
C 
C.. Local Scalars .. 
      integer  il,l,lx
C 
C.. External Calls .. 
      external entier, error
C 
C.. Include Statements ..
      include "../stack.h"
C 
C.. Statement Functions ..
      integer  iadr
      integer  sadr
      iadr(l) = l + l - 1
      sadr(l) = (l/2) + 1
C 
C ... Executable Statements ...
C 
C
      il = iadr(lstk(top))
      if (istk(il) .ne. 1) then
        call error(98)
      elseif (istk(il+1).ne.mx.or.istk(il+2).ne.nx.or.istk(il+3).ne.0)
     &then
        call error(98)
      else
        lx = sadr(il+4)
        if(nx*mx.gt.0) call entier(nx*mx,stk(lx),x)
        top = top - 1
      endif
      end 
      subroutine dtosci(x,mx,nx)
C     fortran to scilab
C 
C.. Formal Arguments .. 
      double precision x(*)
      integer mx
      integer nx
C 
C.. Local Scalars .. 
      integer  il,l,m,n
C 
C.. External Calls .. 
      external dcopy, error
C 
C.. Include Statements ..
      include "../stack.h"
C 
C.. Statement Functions ..
      integer  iadr
      integer  sadr
      iadr(l) = l + l - 1
      sadr(l) = (l/2) + 1
C 
C ... Executable Statements ...
C 
C
      m = mx
      n = nx
      if(mx*nx.eq.0) then
         n = 0
         m = 0
      endif

      if (top .ge. bot) then
        call error(18)
      else
        top = top + 1
         il = iadr(lstk(top))
        l = sadr(il+4)
        err = l + m*n - lstk(bot)
        if (err .gt. 0) then
          call error(17)
        else
          istk(il) = 1
          istk(il+1) = m
          istk(il+2) = n
          istk(il+3) = 0
          if(n.ne.0) call dcopy(n*m,x,1,stk(l),1)
          lstk(top+1) = l + n*m
        endif
      endif
      end 

      subroutine itosci(x,mx,nx)
C     fortran to scilab
C 
C.. Formal Arguments .. 
      integer  x(*)
      integer  mx
      integer  nx
C 
C.. Local Scalars .. 
      integer  il,l
C 
C.. External Calls .. 
      external error, int2db
C 
C.. Include Statements ..
      include "../stack.h"
C 
C.. Statement Functions ..
      integer  iadr
      integer  sadr
      iadr(l) = l + l - 1
      sadr(l) = (l/2) + 1
C 
C ... Executable Statements ...
C 
C     
      m = mx
      n = nx
      if(mx*nx.eq.0) then
         n = 0
         m = 0
      endif

      if (top .ge. bot) then
        call error(18)
      else
        top = top + 1
        il = iadr(lstk(top))
        l = sadr(il+4)
        err = l + m*n - lstk(bot)
        if (err .gt. 0) then
          call error(17)
        else
          istk(il) = 1
          istk(il+1) = m
          istk(il+2) = n
          istk(il+3) = 0
          if(n.ne.0) call int2db(n*m,x,1,stk(l),1)
          lstk(top+1) = l + n*m
        endif
      endif
      end 
