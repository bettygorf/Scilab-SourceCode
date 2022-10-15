      subroutine alloc(no,ivol,nl,nc,type)
      include '../stack.h'
      character*1 type
      common/ibfu/ibuf(200)
c
      iadr(l)=l+l-1
c
c
      if(no.gt.30) then
      call error(70)
      return
      endif
c
      if(type.eq.'r') itype=27
      if(type.eq.'i') itype=18
      if(type.eq.'d') itype=13
      if(type.eq.'c') itype=12
      is1=3*ie+1
      is=is+1
      is2=is1+3*is
      l=is1+3*(2*is-1)
      ibuf(l)=nl
      ibuf(l+1)=nc
      ibuf(l+2)=itype
      call icopy(3*(is-1),ibuf(is1+(is-1)*3),-1,ibuf(is1+3*is),-1)
      k=is1+(is-1)*3
      ibuf(k)=no
      ibuf(k+1)=ivol
      ibuf(k+2)=itype
c
      if(ladr(no).eq.0.or.ladr(no).eq.(lbot-1)) then
           ladr(no)=ipal
           ipal=ipal+ivol
           err=ipal-lbot
           if(err.gt.0) call error(17)
           return
      endif
c
      if(type.eq.'r') then
      call simple(ivol,stk(ladr(no)),stk(ladr(no)))
      endif
      if(type.eq.'i') then
      call entier(ivol,stk(ladr(no)),stk(ladr(no)))
      endif
      if(type.eq.'c') then
      lll=ladr(no)
      call entier(ivol,stk(lll),stk(lll))
      call cvstr(ivol,istk(iadr(lll)),istk(iadr(lll)),1)
      endif
      return
      end
