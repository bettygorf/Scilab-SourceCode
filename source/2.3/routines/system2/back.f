      subroutine back(no)
      include '../stack.h'
      integer iadr,sadr
      dimension iw(50)
c
      common/ibfu/ibuf(200)
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      il=iadr(lstk(top))
      istk(il)=1
      is1=3*ie+1
      do 1 k=1,30
      if(is1.ge.200) goto 100
      if(ibuf(is1).eq.no) goto 2
      is1=is1+3
 1    continue
 100  buf='fort: invalid output variable (not found)'
      call error(999)
      return
  2   continue
      ijkl=is1+3*is
      m=ibuf(ijkl)
      n=ibuf(ijkl+1)
      itf=ibuf(ijkl+2)
      istk(il+1)=m
      istk(il+2)=n
      istk(il+3)=0
      ivol=m*n
      l=sadr(il+4)
      lll=iadr(ladr(no))
      if(itf.eq.0) return
c
      if(itf.eq.12) then
      if(ivol.ge.50) then
         buf='At most 50 caracters are allowed!'
         call error(9999)
         return
      endif
      call cvstr(ivol,iw,istk(lll),0)
      do 333 ix=1,ivol
         istk(lll-1+ix)=iw(ix)
 333  continue
      itf=18
      endif
      if(itf.eq.27) goto 10
      if(itf.eq.18) goto 30
      if(itf.ne.13) then
      buf='invalid  variable type'
      call error(999)
      return
      endif
      lll=ladr(no)
      if(lll.lt.l) then
         buf='fort: invalid ordering of output parameters'
         call error(9999)
      endif
      if(lll.ne.l) call dcopy(ivol,stk(lll),1,stk(l),1)
      goto 200
c
  10  continue
c  copy ivol entries from sstk(lll) to stk(l)
      if(sadr(lll).lt.l) then
         buf='fort: invalid ordering of output parameters'
         call error(9999)
      endif
      if((lll+ivol-1).ge.iadr(l+ivol-1)) goto 15
      if(lll.le.iadr(l)) goto 20
c     |..........|
c     |..*****...| <=> |..12543...|
c
c     |*.*.*.*.*.| <=> |1.2.5.4.3.|
      iboum=sadr(lll-iadr(l))
      imont=2*iboum-2
      ides=ivol-imont
      do 11 k=1,imont
      stk(l+k-1)=dble(sstk(lll+k-1))
   11 continue
      do 12 k=1,ides
      stk(l+ivol-k)=dble(sstk(lll+ivol-k))
   12 continue
      goto 200
c
   15 continue
c     |..........|
c     |     *****|   <=> |     12345|
c
c     |*.*.*.*.*.|   <=> |1.2.3.4.5.|
      do 16 k=1,ivol
      stk(l+k-1)=dble(sstk(lll+k-1))
   16 continue
      goto 200
c
   20 continue
c     |..........|
c     |*****.....|   <=> |54321.....|
c
c     |*.*.*.*.*.|   <=> |5.4.3.2.1.|
      do 21 k=1,ivol
      stk(l+ivol-k)=dble(sstk(lll+ivol-k))
   21 continue
      goto 200
c
   30  continue
      if(sadr(lll).lt.l) then
         buf='fort: invalid ordering of output parameters'
         call error(9999)
      endif
c  copy ivol entries from istk(lll) to stk(l)
      if((lll+ivol-1).ge.iadr(l+ivol-1)) goto 35
      if(lll.le.iadr(l)) goto 40
      iboum=sadr(lll-iadr(l))
      imont=2*iboum-2
      ides=ivol-imont
      do 31 k=1,imont
      stk(l+k-1)=dble(istk(lll+k-1))
   31 continue
      do 32 k=1,ides
      stk(l+ivol-k)=dble(istk(lll+ivol-k))
   32 continue
      goto 200
c
   35 continue
      do 36 k=1,ivol
      stk(l+k-1)=dble(istk(lll+k-1))
   36 continue
      goto 200
c
   40 continue
      do 41 k=1,ivol
      stk(l+ivol-k)=dble(istk(lll+ivol-k))
   41 continue
c
  200 continue
      lstk(top+1)=l+ivol
      top=top+1
      return
      end
