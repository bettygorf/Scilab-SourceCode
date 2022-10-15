      subroutine back(no)
      include '../stack.h'
      integer adr
      dimension sstk(2*vsiz)
      equivalence (sstk(1),stk(1))
c
      common/adre/lbot,ie,is,ipal,nbarg,ll(30)
      common/ibfu/ibuf(200)
c
      il=adr(lstk(top),0)
      istk(il)=1
      is1=3*ie+1
      do 1 k=1,30
      if(is1.ge.200) goto 100
      if(ibuf(is1).eq.no) goto 2
      is1=is1+3
 1    continue
 100  buf='variable de sortie non trouvee'
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
      l=adr(il+4,1)
      lll=adr(ll(no),0)
      if(itf.eq.0) return
c
      if(itf.eq.27) goto 10
      if(itf.eq.18) goto 30
      if(itf.ne.13) then
      buf='variable fortran de type incorrect'
      call error(999)
      return
      endif
      lll=ll(no)
      if(lll.ne.l) call dcopy(ivol,stk(lll),1,stk(l),1)
      goto 200
c
  10  continue
      if((lll+ivol-1).ge.adr(l+ivol-1,0)) goto 15
      if(lll.le.adr(l,0)) goto 20
      iboum=adr(lll-adr(l,0),1)
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
   15 do 16 k=1,ivol
      stk(l+k-1)=dble(sstk(lll+k-1))
   16 continue
      goto 200
c
   20 do 21 k=1,ivol
      stk(l+ivol-k)=dble(sstk(lll+ivol-k))
   21 continue
      goto 200
c
   30  continue
      if((lll+ivol-1).ge.adr(l+ivol-1,0)) goto 35
      if(lll.le.adr(l,0)) goto 40
      iboum=adr(lll-adr(l,0),1)
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
