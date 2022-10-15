      logical function creadmat(name,m,n,scimat)
c!purpose
c     readmat reads vector/matrix in scilab's internal stack
c
c!calling sequence
c     logic=creadmat('matrixname',m,n,scimat)
c
c  matrixname: character string; name of the scilab variable.
c  m: number of rows (output of readmat)
c  n: number of columns (output of readmat)
c  scimat: matrix entries stored columnwise (output of readmat)
c 
c    Example of use:
c    Amat is a real 2 x 3 scilab matrix
c    your subroutine should be as follows:
c
c    subroutine mysubr(...)
c
c    ...
c    call readmat('Amat',m,n,scimat)
c    => m=3 , n=2, and scimat(1)=Amat(1,1)
c                      scimat(2)=Amat(2,1)
c                      scimat(3)=Amat(3,1)
c                      scimat(4)=Amat(1,2) ...
c                      scimat(5)=Amat(3,2)
c!
      integer m,n
      character*(*) name
      double precision scimat(m,*)
c
      include '../stack.h'
      integer iadr,sadr
      integer il,it,l,id(nsiz)
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      creadmat=.false.
      it=0
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
c read   : from scilab stack -> fortran variable
c -------
c
      fin=-1
      call stackg(id)
      if (err .gt. 0) return
      if (fin .eq. 0) then
         call putid(ids(1,pt+1),id)
         call error(4)
         return
      endif
      il=iadr(lstk(fin))
      if(istk(il).ne.1.or.istk(il+3).ne.it) call error(44)
      if(err.gt.0) return
      m=istk(il+1)
      n=istk(il+2)
      l=sadr(il+4)
      call dmcopy(stk(l),m,scimat,m,m,n)
      creadmat=.true.
      return
c
      end
