c     this include file contains code relative to interfaces calling. We use
c     include file instead of subroutine to avoid recursion pb's. This file
c     must be included in each routine which compute an external
c
 60   call  parse
      if(fun.eq.99) then
         fun=0
         goto 200
      endif
      if(err.gt.0) goto 9999
c     
      ir=rstk(pt)-900
      goto(113,105,105,105,106,101),ir
      if(ir.gt.20) goto 114
      if(ir.gt.40) goto 124
c
      if(top.lt.rhs ) then
         call error(22)
         goto 60
      endif
      if(top-rhs+lhs+1.ge.bot) then
         call error(18)
         goto 60
      endif
c     
 90   if(err.gt.0) goto 9999
      if (top-lhs+1.gt.0) call iset(lhs,0,infstk(top-lhs+1),1)
      k=fun
      fun=0
      if(k.eq.krec) then
        call error(22)
        goto 9999
      endif
      goto(101,102,103,104,105,106,107,108,109,110,
     &     111,112,113,114,115,116,117,118,119,120,
     &     121,122,123,124,125,126,127,128,129,130,
     &     131,132,133,134,135) k
      if(k.eq.0) goto 60
      call userlk(k)
      goto 90
c     
 101  call matlu
      goto 90
 102   il=iadr(lstk(top+1-rhs))
      if(istk(il+3).ne.1) then
         call matdsr
      else
         call matdsc
      endif
      goto 90
 103  call matsvd
      goto 90
 104  call matqr
      goto 90
 105  call matio
      goto 90
 106  call matelm
      goto 90
 107  call matdes
      goto 90
 108  call matqz
      goto 90
 109  call matric
      goto 90
 110  call matnew
      goto 90
 111  call matopt
      goto 90
 112  call matode
      goto 90
 113  call matsys
      goto 90
 114  call matusr
      goto 90
 115  call metane
      goto 90
 116  call polelm
      goto 90
 117  call lstelm
      goto 90
 118  call sigelm
      goto 90
 119  call datatf
      goto 90
 120  call polaut
      goto 90
 121  call strelm
      goto 90
 122  call fmlelm
      goto 90
 123  call logelm
      goto 90
 124  call matus2
      goto 90
 125  call xawelm
      goto 90
 126  call matimp
      goto 90
 127  call spelm
      goto 90
 128  call intcos
      goto 90
 129  call matodc
      goto 90
 130  call intg
      goto 90
 131  call feval
      goto 90
 132  call bva
      goto 90
 133  call comm
      goto 90
 134  call soundi
      goto 90
 135  call coselm
      goto 90
c
