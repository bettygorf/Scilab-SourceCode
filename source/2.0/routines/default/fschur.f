      integer function fschur(lsize,alpha,beta,s,p)
c!purpose
c      interface for external fortran or C --> schur function
c!
      include '../stack.h'
      integer lsize,folhp,find,ii
      double precision alpha,beta,s,p
c
      character*6   namef,name1
      common/cschur/namef
c
      fschur=0
      call majmin(6,namef,name1)
c
c insert your code here
c+
      if(name1.eq.'c'.or.name1.eq.'cont') then
        fschur=folhp(lsize,alpha,beta,s,p)
        return
      endif
      if(name1.eq.'d'.or.name1.eq.'disc') then
        fschur=find(lsize,alpha,beta,s,p)
        return
      endif
c+
c dynamically called routines
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.namef) goto 1001
cc sun unix
c  to call subroutine foo(lsize,alpha,beta,s,p,ii)
c  ii=1 --> good eigenvalue
c  ii=-1 --> bad eigenvalue
      call dyncall(it1-1,lsize,alpha,beta,s,p,ii)
      fschur=ii
cc end
      return
c error
c
 2000 buf=namef
      call error(50)
      return
      end
