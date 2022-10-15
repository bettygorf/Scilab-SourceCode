      subroutine foptim (indsim,n,x,f,g,izs,rzs,dzs)
c!
c interface for use with optim
c!
      include '../stack.h'
      integer indsim,n,izs(*)
      double precision dzs(*),g(*),x(*),f
      real rzs(*)
c
      integer it1
c
      character*80   name,nam1
      common /optim/ name
c
      call majmin(80,name,nam1)
c
c INSERT YOUR ROUTINE HERE
c+
      if (nam1.eq.'genros') then
c  Rosenbrock test (n>=3)
        call genros(indsim,n,x,f,g,izs,rzs,dzs)
        return
      elseif (nam1.eq.'topt2') then
c two level optimization
        call topt2(indsim,n,x,f,g,izs,rzs,dzs)
        return
      elseif (nam1.eq.'icsemc') then
c  ICSE
        call icsemc(indsim,n,x,f,g,izs,rzs,dzs)
        return
      endif
c+
c dynamic link
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
cc sun or dec unix
      call dyncall(it1-1,indsim,n,x,f,g,izs,rzs,dzs)
cc fin
      return
c
 2000 indsim=0
      buf=name
      call error(50)
      return
      end
