c     this include file contains code relative to interfaces calling. We use
c     include file instead of subroutine to avoid recursion pb's. This file
c     must be included in each routine which compute an external
c
 60   call  parse
      if(err.gt.0) goto 9999
      if(fun.eq.99) then
         fun=0
         goto 200
      endif
c     
      ir=rstk(pt)-900
      goto(104,96,96,96,97,91),ir
c
      if(top.lt.rhs ) then
         call error(22)
         goto 60
      endif
      if(top-rhs+lhs+1.ge.bot) then
         call error(17)
         goto 60
      endif
c     
 90   if(err.gt.0) goto 9999
      k=fun
      fun=0
      if(k.eq.krec) then
        call error(22)
        goto 9999
      endif
      goto(91,92,94,95,96,97,98,99,100,101,102,103,104,105,106,
     &     107,108,109,110,111,112,113,114,115,116,117) k
      if(k.eq.0) goto 60
      call userlk(k)
      goto 90
c     
 91   call matlu
      goto 90
 92   il=iadr(lstk(top+1-rhs))
      if(istk(il+3).eq.1) goto 93
      call matdsr
      goto 90
 93   call matdsc
      goto 90
 94   call matsvd
      goto 90
 95   call matqr
      goto 90
 96   call matio
      goto 90
 97   call matelm
      goto 90
 98   call matdes
      goto 90
 99   call matqz
      goto 90
 100  call matric
      goto 90
 101  call matnew
      goto 90
 102  call matopt
      goto 90
 103  call matode
      goto 90
 104  call matsys
      goto 90
 105  call matusr
      goto 90
 106  call metane
      goto 90
 107  call polelm
      goto 90
 108  call lstelm
      goto 90
 109  call sigelm
      goto 90
 110  call datatf
      goto 90
 111  call polaut
      goto 90
 112  call strelm
      goto 90
 113  call fmlelm
      goto 90
 114  call logelm
      goto 90
 115  call matus2
      goto 90
 116  call xawelm
      goto 90
 117  call matimp
      goto 90
