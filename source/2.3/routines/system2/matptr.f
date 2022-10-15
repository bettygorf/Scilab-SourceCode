      subroutine matptr(name,m,n,lp)
c!purpose
c     matptr returns the adress of real matrix "name"
c     in scilab's internal stack
c     m=number of rows
c     n=number of columns
c     stk(lp),stk(lp+1),...,stk(lp+m*n-1)= entries (columnwise)
c     If matrix "name" not in Scilab stack, returns m=n=-1.
c
c    Example of use:
c    Amat is a real 2 x 3 scilab matrix
c    your subroutine should be as follows:
c
c    subroutine mysubr(...)
c    include '../stack.h'
c    ...
c    call matptr('Amat',m,n,lp)
c    => m=3 , n=2, and stk(lp)=Amat(1,1)
c                      stk(lp+1)=Amat(2,1)
c                      stk(lp+2)=Amat(3,1)
c                      stk(lp+3)=Amat(1,2) ...
c                      stk(lp+5)=Amat(3,2)
c   see example in fydot.f file
c   see also  readmat.f, matz.f
      character*(*) name
c
      include '../stack.h'
      integer iadr,sadr
      integer id(nsiz)
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      lon=0
      do 100 i=1,csiz
         if(name(i:i).eq.char(0)) goto 200
         lon=lon+1
 100  continue
 200  continue
      lon1=len(name)
      if((lon1.gt.0).and.(lon1.lt.lon)) then
         ln=lon1
      else
         ln=lon
      endif
      if(lon.eq.lon1) ln=lon
      ln=min(nlgh,ln)
      call cvname(id,name(1:ln),0)
c
      fin=-1
      call stackg(id)
      if (fin .eq. 0) then
         call putid(ids(1,pt+1),id)
         call error(4)
         m=-1
         n=-1
         return
      endif
      il=iadr(lstk(fin))
      if(istk(il).ne.1.or.istk(il+3).ne.0) call error(44)
      if(err.gt.0) return
      m=istk(il+1)
      n=istk(il+2)
      lp=sadr(il+4)
      end
