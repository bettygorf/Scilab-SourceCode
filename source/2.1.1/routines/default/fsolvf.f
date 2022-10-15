      subroutine fsolvf(n,x,fvec,iflag)
c interface for solve fortran external (no jacobian)
      include '../stack.h'
      integer n,iflag
      double precision x(n),fvec(n)
      character*6 namef,namej,name
      common/csolve/namef,namej
c
      call majmin(6,namef,name)
c+
      if(namef.eq.'essai') then
c         call essai(n,x,fvec,iflag)
         return
      endif
c+
c dynamic link
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
cc     unix
      call dyncall(it1-1,n,x,fvec,iflag)
cc    fin
      return
c
 2000 indsim=0
      buf=name
      call error(50)
      return
      end

