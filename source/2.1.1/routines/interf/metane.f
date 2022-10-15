      subroutine metane
c
      include '../stack.h'
c
      integer iadr, sadr, id(nsiz)
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
      if (fin .eq. 1) then
c 
c SCILAB function : inimet
c --------------------------
        lbuf = 1
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable datanet (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 10) then
          err = 1
          call error(55)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        n1 = istk(il1+5)-1
        l1 = il1+6
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+1
        lbuf2 = lbuf
        call cvstr(n1,istk(l1),buf(lbuf2:lbuf2+n1-1),1)
        lbuf = lbuf+n1+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call inimet(stk(lw1),buf(lbuf2:lbuf2+n1-1),n1)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: window
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw1),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 2) then
c 
c SCILAB function : netwindow
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 1) then
          call error(39)
          return
        endif
        if (lhs .ne. 1) then
          call error(41)
          return
        endif
c       checking variable window (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call netwindow(istk(iadr(l1)))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c       no output variable
        top=top+1
        il=iadr(l0)
        istk(il)=0
        lstk(top+1)=l0+1
        return
      endif
c
      if (fin .eq. 3) then
c 
c SCILAB function : netwindows
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call netwindows(stk(lw1),ne1)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: scrs
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne1-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne1,stk(lw1),stk(lw))
        lw=lw+ne1
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 4) then
c 
c SCILAB function : loadg
c --------------------------
        lbuf = 1
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .ne. 1) then
          call error(41)
          return
        endif
c       checking variable name (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 10) then
          err = 1
          call error(55)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        n1 = istk(il1+5)-1
        l1 = il1+6
c       checking variable sup (number 2)
c       
        if (rhs .eq. 1) then
          il2 = iadr(lstk(top + 1))
          top = top + 1
          rhs = rhs + 1
          err = lstk(top) + 5 - lstk(bot)
          if (err .gt. 0) then
            call error(17)
            return
          endif
          istk(il2) = 1
          istk(il2 + 1) = 1
          istk(il2 + 2) = 1
          istk(il2 + 3) = 0
          stk(sadr(il2 + 4)) = 0
          lstk(top + 1) = sadr(il2 + 4) + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1)*istk(il2+2) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        l2 = sadr(il2+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l2),istk(iadr(l2)))
        lbuf2 = lbuf
        call cvstr(n1,istk(l1),buf(lbuf2:lbuf2+n1-1),1)
        lbuf = lbuf+n1+1
        lw4=lw
        lw=lw+1
        lw5=lw
        lw=lw+1
        lw6=lw
        lw=lw+1
        lw7=lw
        lw=lw+1
        lw8=lw
        lw=lw+1
        lw9=lw
        lw=lw+1
        lw10=lw
        lw=lw+1
        lw11=lw
        lw=lw+1
        lw12=lw
        lw=lw+1
        lw13=lw
        lw=lw+1
        lw14=lw
        lw=lw+1
        lw15=lw
        lw=lw+1
        lw16=lw
        lw=lw+1
        lw17=lw
        lw=lw+1
        lw18=lw
        lw=lw+1
        lw19=lw
        lw=lw+1
        lw20=lw
        lw=lw+1
        lw21=lw
        lw=lw+1
        lw22=lw
        lw=lw+1
        lw23=lw
        lw=lw+1
        lw24=lw
        lw=lw+1
        lw25=lw
        lw=lw+1
        lw26=lw
        lw=lw+1
        lw27=lw
        lw=lw+1
        lw28=lw
        lw=lw+1
        lw29=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call loadg(istk(iadr(l2)),buf(lbuf2:lbuf2+n1-1),n1,stk(lw4),stk(
     & lw5),stk(lw6),stk(lw7),stk(lw8),stk(lw9),stk(lw10),stk(lw11),stk
     & (lw12),stk(lw13),stk(lw14),stk(lw15),stk(lw16),stk(lw17),stk(lw1
     & 8),stk(lw19),stk(lw20),stk(lw21),stk(lw22),stk(lw23),stk(lw24),s
     & tk(lw25),stk(lw26),stk(lw27),stk(lw28),stk(lw29),ne11,ne9,ne21,n
     & e14,ne18)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c       Creation of output list
        top=top+1
        il=iadr(lw)
        istk(il)=15
        istk(il+1)=27
        istk(il+2)=1
        lw=sadr(il+30)
        lwtop=lw
c     
c       Element : name
        ilw=iadr(lw)
        err=sadr(ilw+5+n1)-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        call icopy(6,istk(il1),1,istk(ilw),1)
        lw=ilw+6
        call cvstr(n1,istk(lw),buf(lbuf2:lbuf2+n1),0)
        lw=lw+sadr(ilw+n1)
c     
        istk(il+3)=lw-lwtop+1
c     
c       Element : flag
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw4),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+4)=lw-lwtop+1
c     
c       Element : m
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw5),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+5)=lw-lwtop+1
c     
c       Element : n
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw6),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+6)=lw-lwtop+1
c     
c       Element : ma
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw7),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+7)=lw-lwtop+1
c     
c       Element : mm
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw8),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+8)=lw-lwtop+1
c     
c       Element : la1
        ilw=iadr(lw)
        err=lw+4+ne9-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne9
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne9,stk(lw9),stk(lw))
        lw=lw+ne9
c     
        istk(il+9)=lw-lwtop+1
c     
c       Element : lp1
        ilw=iadr(lw)
        err=lw+4+ne11-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne11
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne11,stk(lw10),stk(lw))
        lw=lw+ne11
c     
        istk(il+10)=lw-lwtop+1
c     
c       Element : ls1
        ilw=iadr(lw)
        err=lw+4+ne9-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne9
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne9,stk(lw11),stk(lw))
        lw=lw+ne9
c     
        istk(il+11)=lw-lwtop+1
c     
c       Element : la2
        ilw=iadr(lw)
        err=lw+4+ne14-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne14
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne14,stk(lw12),stk(lw))
        lw=lw+ne14
c     
        istk(il+12)=lw-lwtop+1
c     
c       Element : lp2
        ilw=iadr(lw)
        err=lw+4+ne11-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne11
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne11,stk(lw13),stk(lw))
        lw=lw+ne11
c     
        istk(il+13)=lw-lwtop+1
c     
c       Element : ls2
        ilw=iadr(lw)
        err=lw+4+ne14-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne14
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne14,stk(lw14),stk(lw))
        lw=lw+ne14
c     
        istk(il+14)=lw-lwtop+1
c     
c       Element : he
        ilw=iadr(lw)
        err=lw+4+ne18-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne18
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne18,stk(lw15),stk(lw))
        lw=lw+ne18
c     
        istk(il+15)=lw-lwtop+1
c     
c       Element : ta
        ilw=iadr(lw)
        err=lw+4+ne18-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne18
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne18,stk(lw16),stk(lw))
        lw=lw+ne18
c     
        istk(il+16)=lw-lwtop+1
c     
c       Element : ntype
        ilw=iadr(lw)
        err=lw+4+ne21-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne21
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne21,stk(lw17),stk(lw))
        lw=lw+ne21
c     
        istk(il+17)=lw-lwtop+1
c     
c       Element : xnode
        ilw=iadr(lw)
        err=lw+4+ne21-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne21
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne21,stk(lw18),stk(lw))
        lw=lw+ne21
c     
        istk(il+18)=lw-lwtop+1
c     
c       Element : ynode
        ilw=iadr(lw)
        err=lw+4+ne21-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne21
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne21,stk(lw19),stk(lw))
        lw=lw+ne21
c     
        istk(il+19)=lw-lwtop+1
c     
c       Element : ncolor
        ilw=iadr(lw)
        err=lw+4+ne21-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne21
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne21,stk(lw20),stk(lw))
        lw=lw+ne21
c     
        istk(il+20)=lw-lwtop+1
c     
c       Element : demand
        ilw=iadr(lw)
        err=lw+4+ne21-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne21
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne21,stk(lw21),stk(lw))
        lw=lw+ne21
c     
        istk(il+21)=lw-lwtop+1
c     
c       Element : acolor
        ilw=iadr(lw)
        err=lw+4+ne18-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne18
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne18,stk(lw22),stk(lw))
        lw=lw+ne18
c     
        istk(il+22)=lw-lwtop+1
c     
c       Element : length
        ilw=iadr(lw)
        err=lw+4+ne18-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne18
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne18,stk(lw23),stk(lw))
        lw=lw+ne18
c     
        istk(il+23)=lw-lwtop+1
c     
c       Element : cost
        ilw=iadr(lw)
        err=lw+4+ne18-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne18
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne18,stk(lw24),stk(lw))
        lw=lw+ne18
c     
        istk(il+24)=lw-lwtop+1
c     
c       Element : mincap
        ilw=iadr(lw)
        err=lw+4+ne18-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne18
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne18,stk(lw25),stk(lw))
        lw=lw+ne18
c     
        istk(il+25)=lw-lwtop+1
c     
c       Element : maxcap
        ilw=iadr(lw)
        err=lw+4+ne18-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne18
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne18,stk(lw26),stk(lw))
        lw=lw+ne18
c     
        istk(il+26)=lw-lwtop+1
c     
c       Element : qweight
        ilw=iadr(lw)
        err=lw+4+ne18-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne18
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne18,stk(lw27),stk(lw))
        lw=lw+ne18
c     
        istk(il+27)=lw-lwtop+1
c     
c       Element : qorig
        ilw=iadr(lw)
        err=lw+4+ne18-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne18
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne18,stk(lw28),stk(lw))
        lw=lw+ne18
c     
        istk(il+28)=lw-lwtop+1
c     
c       Element : weight
        ilw=iadr(lw)
        err=lw+4+ne18-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne18
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne18,stk(lw29),stk(lw))
        lw=lw+ne18
c     
        istk(il+29)=lw-lwtop+1
c     
        lstk(top+1)=lw-mv
c     
c     Putting in order the stack
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 5) then
c 
c SCILAB function : createg
c --------------------------
        lbuf = 1
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 2) then
          call error(39)
          return
        endif
        if (lhs .ne. 1) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable direct(g) --
        il1e2=iadr(l1+istk(il1+3)-1)
        l1e2 = sadr(il1e2+4)
c      
c       --   subvariable m(g) --
        il1e3=iadr(l1+istk(il1+4)-1)
        l1e3 = sadr(il1e3+4)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable ma(g) --
        il1e5=iadr(l1+istk(il1+6)-1)
        l1e5 = sadr(il1e5+4)
c      
c       --   subvariable mm(g) --
        il1e6=iadr(l1+istk(il1+7)-1)
        l1e6 = sadr(il1e6+4)
c      
c       --   subvariable la1(g) --
        il1e7=iadr(l1+istk(il1+8)-1)
        m1e7 = istk(il1e7+2)
        l1e7 = sadr(il1e7+4)
c      
c       --   subvariable lp1(g) --
        il1e8=iadr(l1+istk(il1+9)-1)
        m1e8 = istk(il1e8+2)
        l1e8 = sadr(il1e8+4)
c      
c       --   subvariable ls1(g) --
        il1e9=iadr(l1+istk(il1+10)-1)
        m1e9 = istk(il1e9+2)
        l1e9 = sadr(il1e9+4)
c      
c       --   subvariable la2(g) --
        il1e10=iadr(l1+istk(il1+11)-1)
        m1e10 = istk(il1e10+2)
        l1e10 = sadr(il1e10+4)
c      
c       --   subvariable lp2(g) --
        il1e11=iadr(l1+istk(il1+12)-1)
        m1e11 = istk(il1e11+2)
        l1e11 = sadr(il1e11+4)
c      
c       --   subvariable ls2(g) --
        il1e12=iadr(l1+istk(il1+13)-1)
        m1e12 = istk(il1e12+2)
        l1e12 = sadr(il1e12+4)
c      
c       --   subvariable he(g) --
        il1e13=iadr(l1+istk(il1+14)-1)
        m1e13 = istk(il1e13+2)
        l1e13 = sadr(il1e13+4)
c      
c       --   subvariable ta(g) --
        il1e14=iadr(l1+istk(il1+15)-1)
        m1e14 = istk(il1e14+2)
        l1e14 = sadr(il1e14+4)
c      
c       --   subvariable ntype(g) --
        il1e15=iadr(l1+istk(il1+16)-1)
        m1e15 = istk(il1e15+2)
        l1e15 = sadr(il1e15+4)
c      
c       --   subvariable xnode(g) --
        il1e16=iadr(l1+istk(il1+17)-1)
        m1e16 = istk(il1e16+2)
        l1e16 = sadr(il1e16+4)
c      
c       --   subvariable ynode(g) --
        il1e17=iadr(l1+istk(il1+18)-1)
        m1e17 = istk(il1e17+2)
        l1e17 = sadr(il1e17+4)
c      
c       --   subvariable ncolor(g) --
        il1e18=iadr(l1+istk(il1+19)-1)
        m1e18 = istk(il1e18+2)
        l1e18 = sadr(il1e18+4)
c      
c       --   subvariable demand(g) --
        il1e19=iadr(l1+istk(il1+20)-1)
        m1e19 = istk(il1e19+2)
        l1e19 = sadr(il1e19+4)
c      
c       --   subvariable acolor(g) --
        il1e20=iadr(l1+istk(il1+21)-1)
        m1e20 = istk(il1e20+2)
        l1e20 = sadr(il1e20+4)
c      
c       --   subvariable length(g) --
        il1e21=iadr(l1+istk(il1+22)-1)
        m1e21 = istk(il1e21+2)
        l1e21 = sadr(il1e21+4)
c      
c       --   subvariable cost(g) --
        il1e22=iadr(l1+istk(il1+23)-1)
        m1e22 = istk(il1e22+2)
        l1e22 = sadr(il1e22+4)
c      
c       --   subvariable mincap(g) --
        il1e23=iadr(l1+istk(il1+24)-1)
        m1e23 = istk(il1e23+2)
        l1e23 = sadr(il1e23+4)
c      
c       --   subvariable maxcap(g) --
        il1e24=iadr(l1+istk(il1+25)-1)
        m1e24 = istk(il1e24+2)
        l1e24 = sadr(il1e24+4)
c      
c       --   subvariable qweight(g) --
        il1e25=iadr(l1+istk(il1+26)-1)
        m1e25 = istk(il1e25+2)
        l1e25 = sadr(il1e25+4)
c      
c       --   subvariable qorig(g) --
        il1e26=iadr(l1+istk(il1+27)-1)
        m1e26 = istk(il1e26+2)
        l1e26 = sadr(il1e26+4)
c      
c       --   subvariable weight(g) --
        il1e27=iadr(l1+istk(il1+28)-1)
        m1e27 = istk(il1e27+2)
        l1e27 = sadr(il1e27+4)
c       checking variable name (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 10) then
          err = 2
          call error(55)
          return
        endif
        if (istk(il2+1)*istk(il2+2) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        n2 = istk(il2+5)-1
        l2 = il2+6
c     
c       cross variable size checking
c     
        if (m1e8 .ne. m1e11) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lbuf1 = lbuf
        call cvstr(n2,istk(l2),buf(lbuf1:lbuf1+n2-1),1)
        lbuf = lbuf+n2+1
        call entier(1,stk(l1e2),istk(iadr(l1e2)))
        call entier(1,stk(l1e3),istk(iadr(l1e3)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        call entier(1,stk(l1e5),istk(iadr(l1e5)))
        call entier(1,stk(l1e6),istk(iadr(l1e6)))
        call entier(m1e7,stk(l1e7),istk(iadr(l1e7)))
        call entier(m1e8,stk(l1e8),istk(iadr(l1e8)))
        call entier(m1e9,stk(l1e9),istk(iadr(l1e9)))
        call entier(m1e10,stk(l1e10),istk(iadr(l1e10)))
        call entier(m1e11,stk(l1e11),istk(iadr(l1e11)))
        call entier(m1e12,stk(l1e12),istk(iadr(l1e12)))
        call entier(m1e13,stk(l1e13),istk(iadr(l1e13)))
        call entier(m1e14,stk(l1e14),istk(iadr(l1e14)))
        call entier(m1e15,stk(l1e15),istk(iadr(l1e15)))
        call entier(m1e16,stk(l1e16),istk(iadr(l1e16)))
        call entier(m1e17,stk(l1e17),istk(iadr(l1e17)))
        call entier(m1e18,stk(l1e18),istk(iadr(l1e18)))
        call entier(m1e20,stk(l1e20),istk(iadr(l1e20)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call createg(buf(lbuf1:lbuf1+n2-1),n2,istk(iadr(l1e2)),istk(iadr
     & (l1e3)),istk(iadr(l1e4)),istk(iadr(l1e5)),istk(iadr(l1e6)),istk(
     & iadr(l1e7)),istk(iadr(l1e8)),istk(iadr(l1e9)),istk(iadr(l1e10)),
     & istk(iadr(l1e11)),istk(iadr(l1e12)),istk(iadr(l1e13)),istk(iadr(
     & l1e14)),istk(iadr(l1e15)),istk(iadr(l1e16)),istk(iadr(l1e17)),is
     & tk(iadr(l1e18)),stk(l1e19),istk(iadr(l1e20)),stk(l1e21),stk(l1e2
     & 2),stk(l1e23),stk(l1e24),stk(l1e25),stk(l1e26),stk(l1e27))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c       no output variable
        top=top+1
        il=iadr(l0)
        istk(il)=0
        lstk(top+1)=l0+1
        return
      endif
c
      if (fin .eq. 6) then
c 
c SCILAB function : showns
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .ne. 1) then
          call error(41)
          return
        endif
c       checking variable ns (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable sup (number 2)
c       
        if (rhs .eq. 1) then
          il2 = iadr(lstk(top + 1))
          top = top + 1
          rhs = rhs + 1
          err = lstk(top) + 5 - lstk(bot)
          if (err .gt. 0) then
            call error(17)
            return
          endif
          istk(il2) = 1
          istk(il2 + 1) = 1
          istk(il2 + 2) = 1
          istk(il2 + 3) = 0
          stk(sadr(il2 + 4)) = 0
          lstk(top + 1) = sadr(il2 + 4) + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1)*istk(il2+2) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        l2 = sadr(il2+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(1,stk(l2),istk(iadr(l2)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call showns(istk(iadr(l1)),m1,istk(iadr(l2)))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c       no output variable
        top=top+1
        il=iadr(l0)
        istk(il)=0
        lstk(top+1)=l0+1
        return
      endif
c
      if (fin .eq. 7) then
c 
c SCILAB function : showp
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .ne. 1) then
          call error(41)
          return
        endif
c       checking variable p (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable sup (number 2)
c       
        if (rhs .eq. 1) then
          il2 = iadr(lstk(top + 1))
          top = top + 1
          rhs = rhs + 1
          err = lstk(top) + 5 - lstk(bot)
          if (err .gt. 0) then
            call error(17)
            return
          endif
          istk(il2) = 1
          istk(il2 + 1) = 1
          istk(il2 + 2) = 1
          istk(il2 + 3) = 0
          stk(sadr(il2 + 4)) = 0
          lstk(top + 1) = sadr(il2 + 4) + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1)*istk(il2+2) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        l2 = sadr(il2+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(1,stk(l2),istk(iadr(l2)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call showp(istk(iadr(l1)),m1,istk(iadr(l2)))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c       no output variable
        top=top+1
        il=iadr(l0)
        istk(il)=0
        lstk(top+1)=l0+1
        return
      endif
c
      if (fin .eq. 8) then
c 
c SCILAB function : prevn2p
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 4 .or. rhs .lt. 3) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable i (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable j (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1)*istk(il2+2) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        l2 = sadr(il2+4)
c       checking variable pln (number 3)
c       
        il3 = iadr(lstk(top-rhs+3))
        if (istk(il3) .ne. 1) then
          err = 3
          call error(53)
          return
        endif
        if (istk(il3+1) .ne. 1) then
          err = 3
          call error(89)
          return
        endif
        m3 = istk(il3+2)
        l3 = sadr(il3+4)
c       checking variable g (number 4)
c       
        if (rhs .eq. 3) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 15) then
          err = 4
          call error(56)
          return
        endif
        n4=istk(il4+1)
        l4=sadr(il4+n4+3)
c      
c       --   subvariable n(g) --
        il4e4=iadr(l4+istk(il4+5)-1)
        l4e4 = sadr(il4e4+4)
c      
c       --   subvariable direct(g) --
        il4e2=iadr(l4+istk(il4+3)-1)
        l4e2 = sadr(il4e2+4)
c      
c       --   subvariable m(g) --
        il4e3=iadr(l4+istk(il4+4)-1)
        l4e3 = sadr(il4e3+4)
c      
c       --   subvariable la1(g) --
        il4e7=iadr(l4+istk(il4+8)-1)
        m4e7 = istk(il4e7+2)
        l4e7 = sadr(il4e7+4)
c      
c       --   subvariable lp1(g) --
        il4e8=iadr(l4+istk(il4+9)-1)
        m4e8 = istk(il4e8+2)
        l4e8 = sadr(il4e8+4)
c      
c       --   subvariable ls1(g) --
        il4e9=iadr(l4+istk(il4+10)-1)
        m4e9 = istk(il4e9+2)
        l4e9 = sadr(il4e9+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(1,stk(l2),istk(iadr(l2)))
        call entier(1,stk(l4e3),istk(iadr(l4e3)))
        call entier(1,stk(l4e4),istk(iadr(l4e4)))
        call entier(m4e7,stk(l4e7),istk(iadr(l4e7)))
        call entier(m4e8,stk(l4e8),istk(iadr(l4e8)))
        call entier(m4e9,stk(l4e9),istk(iadr(l4e9)))
        call entier(1,stk(l4e2),istk(iadr(l4e2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        lw10=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call prevn2p(istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l4e3)),istk
     & (iadr(l4e4)),istk(iadr(l4e7)),istk(iadr(l4e8)),istk(iadr(l4e9)),
     & istk(iadr(l4e2)),istk(iadr(l3)),stk(lw10),ne34)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: p
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne34-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne34
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne34,stk(lw10),stk(lw))
        lw=lw+ne34
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 9) then
c 
c SCILAB function : ns2p
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable ns (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable direct(g) --
        il2e2=iadr(l2+istk(il2+3)-1)
        l2e2 = sadr(il2e2+4)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable la1(g) --
        il2e7=iadr(l2+istk(il2+8)-1)
        m2e7 = istk(il2e7+2)
        l2e7 = sadr(il2e7+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1,stk(l1),istk(iadr(l1)))
        lw3=lw
        lw=lw+1
        call entier(m2e7,stk(l2e7),istk(iadr(l2e7)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        call entier(1,stk(l2e2),istk(iadr(l2e2)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call ns2p(istk(iadr(l1)),m1,stk(lw3),ne33,istk(iadr(l2e7)),istk(
     & iadr(l2e8)),istk(iadr(l2e9)),istk(iadr(l2e2)),istk(iadr(l2e4)))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: p
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne33-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne33
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne33,stk(lw3),stk(lw))
        lw=lw+ne33
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 10) then
c 
c SCILAB function : p2ns
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable p (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable direct(g) --
        il2e2=iadr(l2+istk(il2+3)-1)
        l2e2 = sadr(il2e2+4)
c      
c       --   subvariable m(g) --
        il2e3=iadr(l2+istk(il2+4)-1)
        l2e3 = sadr(il2e3+4)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable la1(g) --
        il2e7=iadr(l2+istk(il2+8)-1)
        m2e7 = istk(il2e7+2)
        l2e7 = sadr(il2e7+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1,stk(l1),istk(iadr(l1)))
        lw3=lw
        lw=lw+1
        call entier(m2e7,stk(l2e7),istk(iadr(l2e7)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        call entier(1,stk(l2e2),istk(iadr(l2e2)))
        call entier(1,stk(l2e3),istk(iadr(l2e3)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call p2ns(istk(iadr(l1)),m1,stk(lw3),ne33,istk(iadr(l2e7)),istk(
     & iadr(l2e8)),istk(iadr(l2e9)),istk(iadr(l2e2)),istk(iadr(l2e3)),i
     & stk(iadr(l2e4)))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: ns
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne33-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne33
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne33,stk(lw3),stk(lw))
        lw=lw+ne33
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 11) then
c 
c SCILAB function : compl2
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 4) then
          call error(39)
          return
        endif
        if (lhs .gt. 3) then
          call error(41)
          return
        endif
c       checking variable la1 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable lp1 (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        m2 = istk(il2+2)
        l2 = sadr(il2+4)
c       checking variable ls1 (number 3)
c       
        il3 = iadr(lstk(top-rhs+3))
        if (istk(il3) .ne. 1) then
          err = 3
          call error(53)
          return
        endif
        if (istk(il3+1) .ne. 1) then
          err = 3
          call error(89)
          return
        endif
        m3 = istk(il3+2)
        l3 = sadr(il3+4)
c       checking variable dir (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1)*istk(il4+2) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        l4 = sadr(il4+4)
c     
c       cross variable size checking
c     
        if (m1 .ne. m3) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        lw6=lw
        lw=lw+1
        lw7=lw
        lw=lw+m2
        lw8=lw
        lw=lw+1
        call entier(1,stk(l4),istk(iadr(l4)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call compl2(istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),m1,m2,s
     & tk(lw6),stk(lw7),stk(lw8),istk(iadr(l4)),ne7)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: la2
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne7,stk(lw6),stk(lw))
        lw=lw+ne7
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: lp2
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+m2-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=m2
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(m2,stk(lw7),1,stk(lw),1)
        lw=lw+m2
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 3) then
c     
c       output variable: ls2
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne7,stk(lw8),stk(lw))
        lw=lw+ne7
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 12) then
c 
c SCILAB function : compht
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 4) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable la1 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable lp1 (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        m2 = istk(il2+2)
        l2 = sadr(il2+4)
c       checking variable ls1 (number 3)
c       
        il3 = iadr(lstk(top-rhs+3))
        if (istk(il3) .ne. 1) then
          err = 3
          call error(53)
          return
        endif
        if (istk(il3+1) .ne. 1) then
          err = 3
          call error(89)
          return
        endif
        m3 = istk(il3+2)
        l3 = sadr(il3+4)
c       checking variable dir (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1)*istk(il4+2) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        l4 = sadr(il4+4)
c     
c       cross variable size checking
c     
        if (m1 .ne. m3) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        lw6=lw
        lw=lw+1
        lw7=lw
        lw=lw+1
        call entier(1,stk(l4),istk(iadr(l4)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call compht(istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),m1,m2,s
     & tk(lw6),stk(lw7),istk(iadr(l4)),ne7)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: he
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne7,stk(lw6),stk(lw))
        lw=lw+ne7
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: ta
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne7,stk(lw7),stk(lw))
        lw=lw+ne7
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 13) then
c 
c SCILAB function : compunl1
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 3) then
          call error(39)
          return
        endif
        if (lhs .gt. 3) then
          call error(41)
          return
        endif
c       checking variable la1 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable lp1 (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        m2 = istk(il2+2)
        l2 = sadr(il2+4)
c       checking variable ls1 (number 3)
c       
        il3 = iadr(lstk(top-rhs+3))
        if (istk(il3) .ne. 1) then
          err = 3
          call error(53)
          return
        endif
        if (istk(il3+1) .ne. 1) then
          err = 3
          call error(89)
          return
        endif
        m3 = istk(il3+2)
        l3 = sadr(il3+4)
c     
c       cross variable size checking
c     
        if (m1 .ne. m3) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        lw6=lw
        lw=lw+1
        lw7=lw
        lw=lw+m2
        lw8=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call compunl1(istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),m1,m2
     & ,stk(lw6),stk(lw7),stk(lw8),ne6)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: lla1
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne6-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne6
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne6,stk(lw6),stk(lw))
        lw=lw+ne6
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: llp1
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+m2-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=m2
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(m2,stk(lw7),1,stk(lw),1)
        lw=lw+m2
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 3) then
c     
c       output variable: lls1
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne6-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne6
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne6,stk(lw8),stk(lw))
        lw=lw+ne6
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 14) then
c 
c SCILAB function : edge2st
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable alpha (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        call entier(m1,stk(l1),istk(iadr(l1)))
        lw3=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call edge2st(istk(iadr(l2e4)),istk(iadr(l1)),stk(lw3),ne32)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: tree
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne32-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne32
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne32,stk(lw3),stk(lw))
        lw=lw+ne32
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 15) then
c 
c SCILAB function : prevn2st
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable nodes (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable la1(g) --
        il2e7=iadr(l2+istk(il2+8)-1)
        m2e7 = istk(il2e7+2)
        l2e7 = sadr(il2e7+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        call entier(m1,stk(l1),istk(iadr(l1)))
        lw3=lw
        lw=lw+1
        call entier(m2e7,stk(l2e7),istk(iadr(l2e7)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call prevn2st(istk(iadr(l2e4)),istk(iadr(l1)),stk(lw3),ne32,istk
     & (iadr(l2e7)),istk(iadr(l2e8)),istk(iadr(l2e9)))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: tree
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne32-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne32
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne32,stk(lw3),stk(lw))
        lw=lw+ne32
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 16) then
c 
c SCILAB function : l2adj
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 2) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable lp (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable ls (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        m2 = istk(il2+2)
        l2 = sadr(il2+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        lw6=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call l2adj(istk(iadr(l1)),istk(iadr(l2)),m1,me5,m2,stk(lw6))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: a
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+me5*me5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=me5
        istk(ilw+2)=me5
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(me5*me5,stk(lw6),stk(lw))
        lw=lw+me5*me5
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 17) then
c 
c SCILAB function : adj2l
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable a (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. istk(il1+2)) then
          err = 1
          call error(20)
          return
        endif
        n1 = istk(il1+1)
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c     
c       cross variable size checking
c     
        if (n1 .ne. m1) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(n1*m1,stk(l1),istk(iadr(l1)))
        lw3=lw
        lw=lw+1
        lw4=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call adj2l(istk(iadr(l1)),n1,stk(lw3),stk(lw4),ne3,ne5)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: lp
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne3-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne3
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne3,stk(lw3),stk(lw))
        lw=lw+ne3
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: ls
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne5
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne5,stk(lw4),stk(lw))
        lw=lw+ne5
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 18) then
c 
c SCILAB function : compla
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 3) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable lp (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        m1 = istk(il1+2)
        l1 = sadr(il1+4)
c       checking variable ls (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        m2 = istk(il2+2)
        l2 = sadr(il2+4)
c       checking variable dir (number 3)
c       
        il3 = iadr(lstk(top-rhs+3))
        if (istk(il3) .ne. 1) then
          err = 3
          call error(53)
          return
        endif
        if (istk(il3+1)*istk(il3+2) .ne. 1) then
          err = 3
          call error(89)
          return
        endif
        l3 = sadr(il3+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+m2
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(1,stk(l3),istk(iadr(l3)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call compla(stk(lw1),istk(iadr(l1)),istk(iadr(l2)),m2,m1,istk(ia
     & dr(l3)))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: la
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+m2-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=m2
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(m2,stk(lw1),1,stk(lw),1)
        lw=lw+m2
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 19) then
c 
c SCILAB function : connex
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable mm(g) --
        il1e6=iadr(l1+istk(il1+7)-1)
        l1e6 = sadr(il1e6+4)
c      
c       --   subvariable lp2(g) --
        il1e11=iadr(l1+istk(il1+12)-1)
        m1e11 = istk(il1e11+2)
        l1e11 = sadr(il1e11+4)
c      
c       --   subvariable ls2(g) --
        il1e12=iadr(l1+istk(il1+13)-1)
        m1e12 = istk(il1e12+2)
        l1e12 = sadr(il1e12+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+1
        call entier(m1e11,stk(l1e11),istk(iadr(l1e11)))
        call entier(m1e12,stk(l1e12),istk(iadr(l1e12)))
        call entier(1,stk(l1e6),istk(iadr(l1e6)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        lw6=lw
        lw=lw+istk(iadr(l1e4))
        lw7=lw
        lw=lw+istk(iadr(l1e4))
        lw8=lw
        lw=lw+istk(iadr(l1e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call compc(stk(lw1),istk(iadr(l1e11)),istk(iadr(l1e12)),istk(iad
     & r(l1e6)),istk(iadr(l1e4)),stk(lw6),stk(lw7),stk(lw8))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: l
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw1),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: ncomp
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l1e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l1e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l1e4)),stk(lw6),1,stk(lw),1)
        lw=lw+istk(iadr(l1e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 20) then
c 
c SCILAB function : concom
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 3 .or. rhs .lt. 2) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable icomp (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable ncomp (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        m2 = istk(il2+2)
        l2 = sadr(il2+4)
c       checking variable g (number 3)
c       
        if (rhs .eq. 2) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il3 = iadr(lstk(top-rhs+3))
        if (istk(il3) .ne. 15) then
          err = 3
          call error(56)
          return
        endif
        n3=istk(il3+1)
        l3=sadr(il3+n3+3)
c      
c       --   subvariable n(g) --
        il3e4=iadr(l3+istk(il3+5)-1)
        l3e4 = sadr(il3e4+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(1,stk(l3e4),istk(iadr(l3e4)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        lw4=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call concom(istk(iadr(l1)),istk(iadr(l3e4)),istk(iadr(l2)),stk(l
     & w4),ne33)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: ns
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne33-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne33
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne33,stk(lw4),stk(lw))
        lw=lw+ne33
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 21) then
c 
c SCILAB function : sconnex
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable m(g) --
        il1e3=iadr(l1+istk(il1+4)-1)
        l1e3 = sadr(il1e3+4)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable lp1(g) --
        il1e8=iadr(l1+istk(il1+9)-1)
        m1e8 = istk(il1e8+2)
        l1e8 = sadr(il1e8+4)
c      
c       --   subvariable ls1(g) --
        il1e9=iadr(l1+istk(il1+10)-1)
        m1e9 = istk(il1e9+2)
        l1e9 = sadr(il1e9+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+int(stk(l1e4))
        call entier(m1e8,stk(l1e8),istk(iadr(l1e8)))
        call entier(m1e9,stk(l1e9),istk(iadr(l1e9)))
        call entier(1,stk(l1e3),istk(iadr(l1e3)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        lw6=lw
        lw=lw+1
        lw7=lw
        lw=lw+istk(iadr(l1e4))
        lw8=lw
        lw=lw+istk(iadr(l1e4))
        lw9=lw
        lw=lw+istk(iadr(l1e4))
        lw10=lw
        lw=lw+istk(iadr(l1e4))
        lw11=lw
        lw=lw+istk(iadr(l1e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call compfc(stk(lw1),istk(iadr(l1e8)),istk(iadr(l1e9)),istk(iadr
     & (l1e3)),istk(iadr(l1e4)),stk(lw6),stk(lw7),stk(lw8),stk(lw9),stk
     & (lw10),stk(lw11))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: nc
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw6),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: nfcomp
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l1e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l1e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l1e4)),stk(lw7),1,stk(lw),1)
        lw=lw+istk(iadr(l1e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 22) then
c 
c SCILAB function : sconcom
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 3 .or. rhs .lt. 2) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable icomp (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable nfcomp (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        m2 = istk(il2+2)
        l2 = sadr(il2+4)
c       checking variable g (number 3)
c       
        if (rhs .eq. 2) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il3 = iadr(lstk(top-rhs+3))
        if (istk(il3) .ne. 15) then
          err = 3
          call error(56)
          return
        endif
        n3=istk(il3+1)
        l3=sadr(il3+n3+3)
c      
c       --   subvariable n(g) --
        il3e4=iadr(l3+istk(il3+5)-1)
        l3e4 = sadr(il3e4+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(1,stk(l3e4),istk(iadr(l3e4)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        lw4=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call sconcom(istk(iadr(l1)),istk(iadr(l3e4)),istk(iadr(l2)),stk(
     & lw4),ne33)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: ns
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne33-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne33
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne33,stk(lw4),stk(lw))
        lw=lw+ne33
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 23) then
c 
c SCILAB function : pcchna
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable i0 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable m(g) --
        il2e3=iadr(l2+istk(il2+4)-1)
        l2e3 = sadr(il2e3+4)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        call entier(1,stk(l2e3),istk(iadr(l2e3)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        lw6=lw
        lw=lw+istk(iadr(l2e4))
        lw7=lw
        lw=lw+istk(iadr(l2e4))
        lw8=lw
        lw=lw+istk(iadr(l2e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call pcchna(istk(iadr(l1)),istk(iadr(l2e8)),istk(iadr(l2e9)),ist
     & k(iadr(l2e3)),istk(iadr(l2e4)),stk(lw6),stk(lw7),stk(lw8))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: pani
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l2e4)),stk(lw7),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: pan
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l2e4)),stk(lw6),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 24) then
c 
c SCILAB function : ford
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable i0 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable m(g) --
        il2e3=iadr(l2+istk(il2+4)-1)
        l2e3 = sadr(il2e3+4)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable la1(g) --
        il2e7=iadr(l2+istk(il2+8)-1)
        m2e7 = istk(il2e7+2)
        l2e7 = sadr(il2e7+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c      
c       --   subvariable length(g) --
        il2e21=iadr(l2+istk(il2+22)-1)
        m2e21 = istk(il2e21+2)
        l2e21 = sadr(il2e21+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2e7,stk(l2e7),istk(iadr(l2e7)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        call entier(1,stk(l2e3),istk(iadr(l2e3)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        lw8=lw
        lw=lw+istk(iadr(l2e4))
        lw9=lw
        lw=lw+istk(iadr(l2e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call ford(istk(iadr(l1)),istk(iadr(l2e7)),stk(l2e21),istk(iadr(l
     & 2e8)),istk(iadr(l2e9)),istk(iadr(l2e3)),istk(iadr(l2e4)),stk(lw8
     & ),stk(lw9))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: pi
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(istk(iadr(l2e4)),stk(lw9),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: p
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l2e4)),stk(lw8),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 25) then
c 
c SCILAB function : johns
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable i0 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable m(g) --
        il2e3=iadr(l2+istk(il2+4)-1)
        l2e3 = sadr(il2e3+4)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable la1(g) --
        il2e7=iadr(l2+istk(il2+8)-1)
        m2e7 = istk(il2e7+2)
        l2e7 = sadr(il2e7+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c      
c       --   subvariable length(g) --
        il2e21=iadr(l2+istk(il2+22)-1)
        m2e21 = istk(il2e21+2)
        l2e21 = sadr(il2e21+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+int(stk(l2e4))
        call entier(1,stk(l1),istk(iadr(l1)))
        lw3=lw
        lw=lw+int(stk(l2e4))
        call entier(m2e7,stk(l2e7),istk(iadr(l2e7)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        call entier(1,stk(l2e3),istk(iadr(l2e3)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        lw10=lw
        lw=lw+istk(iadr(l2e4))
        lw11=lw
        lw=lw+istk(iadr(l2e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call johns(stk(lw1),istk(iadr(l1)),stk(lw3),istk(iadr(l2e7)),stk
     & (l2e21),istk(iadr(l2e8)),istk(iadr(l2e9)),istk(iadr(l2e3)),istk(
     & iadr(l2e4)),stk(lw10),stk(lw11))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: pi
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(istk(iadr(l2e4)),stk(lw11),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: p
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l2e4)),stk(lw10),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 26) then
c 
c SCILAB function : dijkst
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable i0 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable m(g) --
        il2e3=iadr(l2+istk(il2+4)-1)
        l2e3 = sadr(il2e3+4)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable la1(g) --
        il2e7=iadr(l2+istk(il2+8)-1)
        m2e7 = istk(il2e7+2)
        l2e7 = sadr(il2e7+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c      
c       --   subvariable length(g) --
        il2e21=iadr(l2+istk(il2+22)-1)
        m2e21 = istk(il2e21+2)
        l2e21 = sadr(il2e21+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2e7,stk(l2e7),istk(iadr(l2e7)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        call entier(1,stk(l2e3),istk(iadr(l2e3)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        lw8=lw
        lw=lw+istk(iadr(l2e4))
        lw9=lw
        lw=lw+istk(iadr(l2e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call dijkst(istk(iadr(l1)),istk(iadr(l2e7)),stk(l2e21),istk(iadr
     & (l2e8)),istk(iadr(l2e9)),istk(iadr(l2e3)),istk(iadr(l2e4)),stk(l
     & w8),stk(lw9))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: pi
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(istk(iadr(l2e4)),stk(lw9),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: p
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l2e4)),stk(lw8),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 27) then
c 
c SCILAB function : frank
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable m(g) --
        il1e3=iadr(l1+istk(il1+4)-1)
        l1e3 = sadr(il1e3+4)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable lp1(g) --
        il1e8=iadr(l1+istk(il1+9)-1)
        m1e8 = istk(il1e8+2)
        l1e8 = sadr(il1e8+4)
c      
c       --   subvariable ls1(g) --
        il1e9=iadr(l1+istk(il1+10)-1)
        m1e9 = istk(il1e9+2)
        l1e9 = sadr(il1e9+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+1
        call entier(m1e8,stk(l1e8),istk(iadr(l1e8)))
        call entier(m1e9,stk(l1e9),istk(iadr(l1e9)))
        call entier(1,stk(l1e3),istk(iadr(l1e3)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        lw6=lw
        lw=lw+istk(iadr(l1e4))
        lw7=lw
        lw=lw+istk(iadr(l1e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call frang(stk(lw1),istk(iadr(l1e8)),istk(iadr(l1e9)),istk(iadr(
     & l1e3)),istk(iadr(l1e4)),stk(lw6),stk(lw7))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: i0
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw1),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: rang
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l1e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l1e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l1e4)),stk(lw7),1,stk(lw),1)
        lw=lw+istk(iadr(l1e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 28) then
c 
c SCILAB function : chcm
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable i0 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable m(g) --
        il2e3=iadr(l2+istk(il2+4)-1)
        l2e3 = sadr(il2e3+4)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable la1(g) --
        il2e7=iadr(l2+istk(il2+8)-1)
        m2e7 = istk(il2e7+2)
        l2e7 = sadr(il2e7+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c      
c       --   subvariable maxcap(g) --
        il2e24=iadr(l2+istk(il2+25)-1)
        m2e24 = istk(il2e24+2)
        l2e24 = sadr(il2e24+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2e7,stk(l2e7),istk(iadr(l2e7)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        call entier(1,stk(l2e3),istk(iadr(l2e3)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        lw8=lw
        lw=lw+istk(iadr(l2e4))
        lw9=lw
        lw=lw+istk(iadr(l2e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call chcm(stk(l2e24),istk(iadr(l1)),istk(iadr(l2e7)),istk(iadr(l
     & 2e8)),istk(iadr(l2e9)),istk(iadr(l2e3)),istk(iadr(l2e4)),stk(lw8
     & ),stk(lw9))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: pcapi
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(istk(iadr(l2e4)),stk(lw9),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: pcap
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l2e4)),stk(lw8),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 29) then
c 
c SCILAB function : transc
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable m(g) --
        il1e3=iadr(l1+istk(il1+4)-1)
        l1e3 = sadr(il1e3+4)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable lp1(g) --
        il1e8=iadr(l1+istk(il1+9)-1)
        m1e8 = istk(il1e8+2)
        l1e8 = sadr(il1e8+4)
c      
c       --   subvariable ls1(g) --
        il1e9=iadr(l1+istk(il1+10)-1)
        m1e9 = istk(il1e9+2)
        l1e9 = sadr(il1e9+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1e8,stk(l1e8),istk(iadr(l1e8)))
        lw2=lw
        lw=lw+1
        call entier(m1e9,stk(l1e9),istk(iadr(l1e9)))
        lw4=lw
        lw=lw+1
        call entier(1,stk(l1e3),istk(iadr(l1e3)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call transc(istk(iadr(l1e8)),stk(lw2),istk(iadr(l1e9)),stk(lw4),
     & istk(iadr(l1e3)),ne33,ne31,istk(iadr(l1e4)))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: lpft
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne31-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne31
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne31,stk(lw2),stk(lw))
        lw=lw+ne31
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: lsft
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne33-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne33
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne33,stk(lw4),stk(lw))
        lw=lw+ne33
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 30) then
c 
c SCILAB function : dfs
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable i0 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable m(g) --
        il2e3=iadr(l2+istk(il2+4)-1)
        l2e3 = sadr(il2e3+4)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        call entier(1,stk(l2e3),istk(iadr(l2e3)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        lw6=lw
        lw=lw+istk(iadr(l2e4))
        lw7=lw
        lw=lw+istk(iadr(l2e4))
        lw8=lw
        lw=lw+istk(iadr(l2e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call dfs(istk(iadr(l1)),istk(iadr(l2e8)),istk(iadr(l2e9)),istk(i
     & adr(l2e3)),istk(iadr(l2e4)),stk(lw6),stk(lw7),stk(lw8))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: num
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l2e4)),stk(lw7),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: pw
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l2e4)),stk(lw8),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 31) then
c 
c SCILAB function : pccsc
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable i0 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable m(g) --
        il2e3=iadr(l2+istk(il2+4)-1)
        l2e3 = sadr(il2e3+4)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable la1(g) --
        il2e7=iadr(l2+istk(il2+8)-1)
        m2e7 = istk(il2e7+2)
        l2e7 = sadr(il2e7+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c      
c       --   subvariable length(g) --
        il2e21=iadr(l2+istk(il2+22)-1)
        m2e21 = istk(il2e21+2)
        l2e21 = sadr(il2e21+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2e7,stk(l2e7),istk(iadr(l2e7)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        call entier(1,stk(l2e3),istk(iadr(l2e3)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        lw8=lw
        lw=lw+istk(iadr(l2e4))
        lw9=lw
        lw=lw+istk(iadr(l2e4))
        lw10=lw
        lw=lw+istk(iadr(l2e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call pccsc(istk(iadr(l1)),istk(iadr(l2e7)),stk(l2e21),istk(iadr(
     & l2e8)),istk(iadr(l2e9)),istk(iadr(l2e3)),istk(iadr(l2e4)),stk(lw
     & 8),stk(lw9),stk(lw10))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: pi
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(istk(iadr(l2e4)),stk(lw10),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: p
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l2e4)),stk(lw9),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 32) then
c 
c SCILAB function : umtree
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable ma(g) --
        il1e5=iadr(l1+istk(il1+6)-1)
        l1e5 = sadr(il1e5+4)
c      
c       --   subvariable mm(g) --
        il1e6=iadr(l1+istk(il1+7)-1)
        l1e6 = sadr(il1e6+4)
c      
c       --   subvariable la2(g) --
        il1e10=iadr(l1+istk(il1+11)-1)
        m1e10 = istk(il1e10+2)
        l1e10 = sadr(il1e10+4)
c      
c       --   subvariable lp2(g) --
        il1e11=iadr(l1+istk(il1+12)-1)
        m1e11 = istk(il1e11+2)
        l1e11 = sadr(il1e11+4)
c      
c       --   subvariable ls2(g) --
        il1e12=iadr(l1+istk(il1+13)-1)
        m1e12 = istk(il1e12+2)
        l1e12 = sadr(il1e12+4)
c      
c       --   subvariable weight(g) --
        il1e27=iadr(l1+istk(il1+28)-1)
        m1e27 = istk(il1e27+2)
        l1e27 = sadr(il1e27+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+int(stk(l1e4))
        call entier(m1e10,stk(l1e10),istk(iadr(l1e10)))
        call entier(m1e11,stk(l1e11),istk(iadr(l1e11)))
        call entier(m1e12,stk(l1e12),istk(iadr(l1e12)))
        call entier(1,stk(l1e5),istk(iadr(l1e5)))
        call entier(1,stk(l1e6),istk(iadr(l1e6)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        lw8=lw
        lw=lw+istk(iadr(l1e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call prim(stk(lw1),istk(iadr(l1e10)),istk(iadr(l1e11)),istk(iadr
     & (l1e12)),istk(iadr(l1e5)),istk(iadr(l1e6)),istk(iadr(l1e4)),stk(
     & lw8),stk(l1e27))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: alpha
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l1e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l1e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l1e4)),stk(lw1),1,stk(lw),1)
        lw=lw+istk(iadr(l1e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 33) then
c 
c SCILAB function : umtree1
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable ma(g) --
        il1e5=iadr(l1+istk(il1+6)-1)
        l1e5 = sadr(il1e5+4)
c      
c       --   subvariable mm(g) --
        il1e6=iadr(l1+istk(il1+7)-1)
        l1e6 = sadr(il1e6+4)
c      
c       --   subvariable la2(g) --
        il1e10=iadr(l1+istk(il1+11)-1)
        m1e10 = istk(il1e10+2)
        l1e10 = sadr(il1e10+4)
c      
c       --   subvariable lp2(g) --
        il1e11=iadr(l1+istk(il1+12)-1)
        m1e11 = istk(il1e11+2)
        l1e11 = sadr(il1e11+4)
c      
c       --   subvariable ls2(g) --
        il1e12=iadr(l1+istk(il1+13)-1)
        m1e12 = istk(il1e12+2)
        l1e12 = sadr(il1e12+4)
c      
c       --   subvariable weight(g) --
        il1e27=iadr(l1+istk(il1+28)-1)
        m1e27 = istk(il1e27+2)
        l1e27 = sadr(il1e27+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+int(stk(l1e4))
        lw2=lw
        lw=lw+int(stk(l1e4))
        lw3=lw
        lw=lw+int(stk(l1e4))
        call entier(m1e10,stk(l1e10),istk(iadr(l1e10)))
        call entier(m1e11,stk(l1e11),istk(iadr(l1e11)))
        call entier(m1e12,stk(l1e12),istk(iadr(l1e12)))
        call entier(1,stk(l1e5),istk(iadr(l1e5)))
        call entier(1,stk(l1e6),istk(iadr(l1e6)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        lw10=lw
        lw=lw+istk(iadr(l1e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call prim1(stk(lw1),stk(lw2),stk(lw3),istk(iadr(l1e10)),istk(iad
     & r(l1e11)),istk(iadr(l1e12)),istk(iadr(l1e5)),istk(iadr(l1e6)),is
     & tk(iadr(l1e4)),stk(lw10),stk(l1e27))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: alpha
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l1e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l1e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l1e4)),stk(lw1),1,stk(lw),1)
        lw=lw+istk(iadr(l1e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 34) then
c 
c SCILAB function : dmtree
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable i0 (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable m(g) --
        il2e3=iadr(l2+istk(il2+4)-1)
        l2e3 = sadr(il2e3+4)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable la1(g) --
        il2e7=iadr(l2+istk(il2+8)-1)
        m2e7 = istk(il2e7+2)
        l2e7 = sadr(il2e7+4)
c      
c       --   subvariable lp1(g) --
        il2e8=iadr(l2+istk(il2+9)-1)
        m2e8 = istk(il2e8+2)
        l2e8 = sadr(il2e8+4)
c      
c       --   subvariable ls1(g) --
        il2e9=iadr(l2+istk(il2+10)-1)
        m2e9 = istk(il2e9+2)
        l2e9 = sadr(il2e9+4)
c      
c       --   subvariable weight(g) --
        il2e27=iadr(l2+istk(il2+28)-1)
        m2e27 = istk(il2e27+2)
        l2e27 = sadr(il2e27+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2e7,stk(l2e7),istk(iadr(l2e7)))
        call entier(m2e8,stk(l2e8),istk(iadr(l2e8)))
        call entier(m2e9,stk(l2e9),istk(iadr(l2e9)))
        call entier(1,stk(l2e3),istk(iadr(l2e3)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        lw7=lw
        lw=lw+istk(iadr(l2e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call dmtree(istk(iadr(l1)),istk(iadr(l2e7)),istk(iadr(l2e8)),ist
     & k(iadr(l2e9)),istk(iadr(l2e3)),istk(iadr(l2e4)),stk(lw7),stk(l2e
     & 27))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: pred
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l2e4)),stk(lw7),1,stk(lw),1)
        lw=lw+istk(iadr(l2e4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 35) then
c 
c SCILAB function : isconnex
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable mm(g) --
        il1e6=iadr(l1+istk(il1+7)-1)
        l1e6 = sadr(il1e6+4)
c      
c       --   subvariable la2(g) --
        il1e10=iadr(l1+istk(il1+11)-1)
        m1e10 = istk(il1e10+2)
        l1e10 = sadr(il1e10+4)
c      
c       --   subvariable lp2(g) --
        il1e11=iadr(l1+istk(il1+12)-1)
        m1e11 = istk(il1e11+2)
        l1e11 = sadr(il1e11+4)
c      
c       --   subvariable ls2(g) --
        il1e12=iadr(l1+istk(il1+13)-1)
        m1e12 = istk(il1e12+2)
        l1e12 = sadr(il1e12+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+int(stk(l1e4))
        lw2=lw
        lw=lw+1
        call entier(m1e10,stk(l1e10),istk(iadr(l1e10)))
        call entier(m1e11,stk(l1e11),istk(iadr(l1e11)))
        call entier(m1e12,stk(l1e12),istk(iadr(l1e12)))
        call entier(1,stk(l1e6),istk(iadr(l1e6)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        lw8=lw
        lw=lw+istk(iadr(l1e4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call tconex(stk(lw1),stk(lw2),istk(iadr(l1e10)),istk(iadr(l1e11)
     & ),istk(iadr(l1e12)),istk(iadr(l1e6)),istk(iadr(l1e4)),stk(lw8))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: iscon
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw2),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 36) then
c 
c SCILAB function : maxflow
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 3 .or. rhs .lt. 2) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable is (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable it (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1)*istk(il2+2) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        l2 = sadr(il2+4)
c       checking variable g (number 3)
c       
        if (rhs .eq. 2) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il3 = iadr(lstk(top-rhs+3))
        if (istk(il3) .ne. 15) then
          err = 3
          call error(56)
          return
        endif
        n3=istk(il3+1)
        l3=sadr(il3+n3+3)
c      
c       --   subvariable ma(g) --
        il3e5=iadr(l3+istk(il3+6)-1)
        l3e5 = sadr(il3e5+4)
c      
c       --   subvariable n(g) --
        il3e4=iadr(l3+istk(il3+5)-1)
        l3e4 = sadr(il3e4+4)
c      
c       --   subvariable mm(g) --
        il3e6=iadr(l3+istk(il3+7)-1)
        l3e6 = sadr(il3e6+4)
c      
c       --   subvariable la2(g) --
        il3e10=iadr(l3+istk(il3+11)-1)
        m3e10 = istk(il3e10+2)
        l3e10 = sadr(il3e10+4)
c      
c       --   subvariable lp2(g) --
        il3e11=iadr(l3+istk(il3+12)-1)
        m3e11 = istk(il3e11+2)
        l3e11 = sadr(il3e11+4)
c      
c       --   subvariable he(g) --
        il3e13=iadr(l3+istk(il3+14)-1)
        m3e13 = istk(il3e13+2)
        l3e13 = sadr(il3e13+4)
c      
c       --   subvariable ta(g) --
        il3e14=iadr(l3+istk(il3+15)-1)
        m3e14 = istk(il3e14+2)
        l3e14 = sadr(il3e14+4)
c      
c       --   subvariable mincap(g) --
        il3e23=iadr(l3+istk(il3+24)-1)
        m3e23 = istk(il3e23+2)
        l3e23 = sadr(il3e23+4)
c      
c       --   subvariable maxcap(g) --
        il3e24=iadr(l3+istk(il3+25)-1)
        m3e24 = istk(il3e24+2)
        l3e24 = sadr(il3e24+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m3e23,stk(l3e23),istk(iadr(l3e23)))
        call entier(m3e24,stk(l3e24),istk(iadr(l3e24)))
        call entier(m3e13,stk(l3e13),istk(iadr(l3e13)))
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(1,stk(l2),istk(iadr(l2)))
        call entier(m3e10,stk(l3e10),istk(iadr(l3e10)))
        call entier(m3e11,stk(l3e11),istk(iadr(l3e11)))
        call entier(1,stk(l3e5),istk(iadr(l3e5)))
        lw9=lw
        lw=lw+int(stk(l3e4))
        call entier(1,stk(l3e6),istk(iadr(l3e6)))
        call entier(1,stk(l3e4),istk(iadr(l3e4)))
        call entier(m3e14,stk(l3e14),istk(iadr(l3e14)))
        lw13=lw
        lw=lw+istk(iadr(l3e5))
        lw14=lw
        lw=lw+istk(iadr(l3e4))
        lw15=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call flomax(istk(iadr(l3e23)),istk(iadr(l3e24)),istk(iadr(l3e13)
     & ),istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3e10)),istk(iadr(l3e1
     & 1)),istk(iadr(l3e5)),stk(lw9),istk(iadr(l3e6)),istk(iadr(l3e4)),
     & istk(iadr(l3e14)),stk(lw13),stk(lw14),stk(lw15))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: vflow
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw15),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: phi
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l3e5))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l3e5))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l3e5)),stk(lw13),1,stk(lw),1)
        lw=lw+istk(iadr(l3e5))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 37) then
c 
c SCILAB function : kilter
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable ma(g) --
        il1e5=iadr(l1+istk(il1+6)-1)
        l1e5 = sadr(il1e5+4)
c      
c       --   subvariable mm(g) --
        il1e6=iadr(l1+istk(il1+7)-1)
        l1e6 = sadr(il1e6+4)
c      
c       --   subvariable la2(g) --
        il1e10=iadr(l1+istk(il1+11)-1)
        m1e10 = istk(il1e10+2)
        l1e10 = sadr(il1e10+4)
c      
c       --   subvariable lp2(g) --
        il1e11=iadr(l1+istk(il1+12)-1)
        m1e11 = istk(il1e11+2)
        l1e11 = sadr(il1e11+4)
c      
c       --   subvariable he(g) --
        il1e13=iadr(l1+istk(il1+14)-1)
        m1e13 = istk(il1e13+2)
        l1e13 = sadr(il1e13+4)
c      
c       --   subvariable ta(g) --
        il1e14=iadr(l1+istk(il1+15)-1)
        m1e14 = istk(il1e14+2)
        l1e14 = sadr(il1e14+4)
c      
c       --   subvariable cost(g) --
        il1e22=iadr(l1+istk(il1+23)-1)
        m1e22 = istk(il1e22+2)
        l1e22 = sadr(il1e22+4)
c      
c       --   subvariable mincap(g) --
        il1e23=iadr(l1+istk(il1+24)-1)
        m1e23 = istk(il1e23+2)
        l1e23 = sadr(il1e23+4)
c      
c       --   subvariable maxcap(g) --
        il1e24=iadr(l1+istk(il1+25)-1)
        m1e24 = istk(il1e24+2)
        l1e24 = sadr(il1e24+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1e23,stk(l1e23),istk(iadr(l1e23)))
        call entier(m1e24,stk(l1e24),istk(iadr(l1e24)))
        call entier(m1e13,stk(l1e13),istk(iadr(l1e13)))
        call entier(m1e10,stk(l1e10),istk(iadr(l1e10)))
        call entier(m1e11,stk(l1e11),istk(iadr(l1e11)))
        call entier(1,stk(l1e5),istk(iadr(l1e5)))
        call entier(1,stk(l1e6),istk(iadr(l1e6)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        call entier(m1e14,stk(l1e14),istk(iadr(l1e14)))
        lw11=lw
        lw=lw+istk(iadr(l1e5))
        lw12=lw
        lw=lw+istk(iadr(l1e4))
        lw13=lw
        lw=lw+istk(iadr(l1e4))
        lw14=lw
        lw=lw+istk(iadr(l1e4))
        lw15=lw
        lw=lw+istk(iadr(l1e4))
        lw16=lw
        lw=lw+istk(iadr(l1e5))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call kilter(istk(iadr(l1e23)),istk(iadr(l1e24)),istk(iadr(l1e13)
     & ),stk(l1e22),istk(iadr(l1e10)),istk(iadr(l1e11)),istk(iadr(l1e5)
     & ),istk(iadr(l1e6)),istk(iadr(l1e4)),istk(iadr(l1e14)),stk(lw11),
     & stk(lw12),stk(lw13),stk(lw14),stk(lw15),stk(lw16))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: phi
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l1e5))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l1e5))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l1e5)),stk(lw11),1,stk(lw),1)
        lw=lw+istk(iadr(l1e5))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 38) then
c 
c SCILAB function : busack
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 4 .or. rhs .lt. 3) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable is (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable it (number 2)
c       
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 1) then
          err = 2
          call error(53)
          return
        endif
        if (istk(il2+1)*istk(il2+2) .ne. 1) then
          err = 2
          call error(89)
          return
        endif
        l2 = sadr(il2+4)
c       checking variable v (number 3)
c       
        il3 = iadr(lstk(top-rhs+3))
        if (istk(il3) .ne. 1) then
          err = 3
          call error(53)
          return
        endif
        if (istk(il3+1)*istk(il3+2) .ne. 1) then
          err = 3
          call error(89)
          return
        endif
        l3 = sadr(il3+4)
c       checking variable g (number 4)
c       
        if (rhs .eq. 3) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 15) then
          err = 4
          call error(56)
          return
        endif
        n4=istk(il4+1)
        l4=sadr(il4+n4+3)
c      
c       --   subvariable n(g) --
        il4e4=iadr(l4+istk(il4+5)-1)
        l4e4 = sadr(il4e4+4)
c      
c       --   subvariable ma(g) --
        il4e5=iadr(l4+istk(il4+6)-1)
        l4e5 = sadr(il4e5+4)
c      
c       --   subvariable mm(g) --
        il4e6=iadr(l4+istk(il4+7)-1)
        l4e6 = sadr(il4e6+4)
c      
c       --   subvariable la2(g) --
        il4e10=iadr(l4+istk(il4+11)-1)
        m4e10 = istk(il4e10+2)
        l4e10 = sadr(il4e10+4)
c      
c       --   subvariable lp2(g) --
        il4e11=iadr(l4+istk(il4+12)-1)
        m4e11 = istk(il4e11+2)
        l4e11 = sadr(il4e11+4)
c      
c       --   subvariable he(g) --
        il4e13=iadr(l4+istk(il4+14)-1)
        m4e13 = istk(il4e13+2)
        l4e13 = sadr(il4e13+4)
c      
c       --   subvariable ta(g) --
        il4e14=iadr(l4+istk(il4+15)-1)
        m4e14 = istk(il4e14+2)
        l4e14 = sadr(il4e14+4)
c      
c       --   subvariable cost(g) --
        il4e22=iadr(l4+istk(il4+23)-1)
        m4e22 = istk(il4e22+2)
        l4e22 = sadr(il4e22+4)
c      
c       --   subvariable maxcap(g) --
        il4e24=iadr(l4+istk(il4+25)-1)
        m4e24 = istk(il4e24+2)
        l4e24 = sadr(il4e24+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m4e24,stk(l4e24),istk(iadr(l4e24)))
        call entier(m4e13,stk(l4e13),istk(iadr(l4e13)))
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(1,stk(l2),istk(iadr(l2)))
        call entier(m4e10,stk(l4e10),istk(iadr(l4e10)))
        call entier(m4e11,stk(l4e11),istk(iadr(l4e11)))
        call entier(1,stk(l4e5),istk(iadr(l4e5)))
        lw9=lw
        lw=lw+int(stk(l4e4))
        call entier(1,stk(l4e6),istk(iadr(l4e6)))
        call entier(1,stk(l4e4),istk(iadr(l4e4)))
        call entier(m4e14,stk(l4e14),istk(iadr(l4e14)))
        lw13=lw
        lw=lw+istk(iadr(l4e4))
        lw14=lw
        lw=lw+istk(iadr(l4e5))
        lw15=lw
        lw=lw+istk(iadr(l4e4))
        call entier(1,stk(l3),istk(iadr(l3)))
        lw17=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call busack(istk(iadr(l4e24)),istk(iadr(l4e13)),stk(l4e22),istk(
     & iadr(l1)),istk(iadr(l2)),istk(iadr(l4e10)),istk(iadr(l4e11)),ist
     & k(iadr(l4e5)),stk(lw9),istk(iadr(l4e6)),istk(iadr(l4e4)),istk(ia
     & dr(l4e14)),stk(lw13),stk(lw14),stk(lw15),istk(iadr(l3)),stk(lw17
     & ))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: valflo
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(1,stk(lw17),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: phi
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l4e5))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l4e5))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l4e5)),stk(lw14),1,stk(lw),1)
        lw=lw+istk(iadr(l4e5))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 39) then
c 
c SCILAB function : minqflow
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 2 .or. rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable eps (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 1) then
          err = 1
          call error(53)
          return
        endif
        if (istk(il1+1)*istk(il1+2) .ne. 1) then
          err = 1
          call error(89)
          return
        endif
        l1 = sadr(il1+4)
c       checking variable g (number 2)
c       
        if (rhs .eq. 1) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il2 = iadr(lstk(top-rhs+2))
        if (istk(il2) .ne. 15) then
          err = 2
          call error(56)
          return
        endif
        n2=istk(il2+1)
        l2=sadr(il2+n2+3)
c      
c       --   subvariable n(g) --
        il2e4=iadr(l2+istk(il2+5)-1)
        l2e4 = sadr(il2e4+4)
c      
c       --   subvariable ma(g) --
        il2e5=iadr(l2+istk(il2+6)-1)
        l2e5 = sadr(il2e5+4)
c      
c       --   subvariable mm(g) --
        il2e6=iadr(l2+istk(il2+7)-1)
        l2e6 = sadr(il2e6+4)
c      
c       --   subvariable la2(g) --
        il2e10=iadr(l2+istk(il2+11)-1)
        m2e10 = istk(il2e10+2)
        l2e10 = sadr(il2e10+4)
c      
c       --   subvariable lp2(g) --
        il2e11=iadr(l2+istk(il2+12)-1)
        m2e11 = istk(il2e11+2)
        l2e11 = sadr(il2e11+4)
c      
c       --   subvariable he(g) --
        il2e13=iadr(l2+istk(il2+14)-1)
        m2e13 = istk(il2e13+2)
        l2e13 = sadr(il2e13+4)
c      
c       --   subvariable ta(g) --
        il2e14=iadr(l2+istk(il2+15)-1)
        m2e14 = istk(il2e14+2)
        l2e14 = sadr(il2e14+4)
c      
c       --   subvariable mincap(g) --
        il2e23=iadr(l2+istk(il2+24)-1)
        m2e23 = istk(il2e23+2)
        l2e23 = sadr(il2e23+4)
c      
c       --   subvariable maxcap(g) --
        il2e24=iadr(l2+istk(il2+25)-1)
        m2e24 = istk(il2e24+2)
        l2e24 = sadr(il2e24+4)
c      
c       --   subvariable qweight(g) --
        il2e25=iadr(l2+istk(il2+26)-1)
        m2e25 = istk(il2e25+2)
        l2e25 = sadr(il2e25+4)
c      
c       --   subvariable qorig(g) --
        il2e26=iadr(l2+istk(il2+27)-1)
        m2e26 = istk(il2e26+2)
        l2e26 = sadr(il2e26+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m2e23,stk(l2e23),istk(iadr(l2e23)))
        lw2=lw
        lw=lw+int(stk(l2e5))
        call entier(m2e24,stk(l2e24),istk(iadr(l2e24)))
        lw4=lw
        lw=lw+int(stk(l2e5))
        call entier(m2e13,stk(l2e13),istk(iadr(l2e13)))
        call entier(m2e10,stk(l2e10),istk(iadr(l2e10)))
        call entier(m2e11,stk(l2e11),istk(iadr(l2e11)))
        call entier(1,stk(l2e5),istk(iadr(l2e5)))
        call entier(1,stk(l2e6),istk(iadr(l2e6)))
        call entier(1,stk(l2e4),istk(iadr(l2e4)))
        call entier(m2e14,stk(l2e14),istk(iadr(l2e14)))
        call entier(m2e26,stk(l2e26),istk(iadr(l2e26)))
        lw14=lw
        lw=lw+istk(iadr(l2e5))
        lw15=lw
        lw=lw+istk(iadr(l2e4))
        lw16=lw
        lw=lw+istk(iadr(l2e4))
        lw17=lw
        lw=lw+istk(iadr(l2e4))
        lw18=lw
        lw=lw+istk(iadr(l2e4))
        lw19=lw
        lw=lw+istk(iadr(l2e5))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call floqua(istk(iadr(l2e23)),stk(lw2),istk(iadr(l2e24)),stk(lw4
     & ),stk(l1),istk(iadr(l2e13)),istk(iadr(l2e10)),istk(iadr(l2e11)),
     & istk(iadr(l2e5)),istk(iadr(l2e6)),istk(iadr(l2e4)),istk(iadr(l2e
     & 14)),istk(iadr(l2e26)),stk(lw14),stk(lw15),stk(lw16),stk(lw17),s
     & tk(lw18),stk(lw19),stk(l2e25))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: phi
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l2e5))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l2e5))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(istk(iadr(l2e5)),stk(lw14),1,stk(lw),1)
        lw=lw+istk(iadr(l2e5))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 40) then
c 
c SCILAB function : maxcpl
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable ma(g) --
        il1e5=iadr(l1+istk(il1+6)-1)
        l1e5 = sadr(il1e5+4)
c      
c       --   subvariable mm(g) --
        il1e6=iadr(l1+istk(il1+7)-1)
        l1e6 = sadr(il1e6+4)
c      
c       --   subvariable la2(g) --
        il1e10=iadr(l1+istk(il1+11)-1)
        m1e10 = istk(il1e10+2)
        l1e10 = sadr(il1e10+4)
c      
c       --   subvariable lp2(g) --
        il1e11=iadr(l1+istk(il1+12)-1)
        m1e11 = istk(il1e11+2)
        l1e11 = sadr(il1e11+4)
c      
c       --   subvariable he(g) --
        il1e13=iadr(l1+istk(il1+14)-1)
        m1e13 = istk(il1e13+2)
        l1e13 = sadr(il1e13+4)
c      
c       --   subvariable ta(g) --
        il1e14=iadr(l1+istk(il1+15)-1)
        m1e14 = istk(il1e14+2)
        l1e14 = sadr(il1e14+4)
c      
c       --   subvariable weight(g) --
        il1e27=iadr(l1+istk(il1+28)-1)
        m1e27 = istk(il1e27+2)
        l1e27 = sadr(il1e27+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1e13,stk(l1e13),istk(iadr(l1e13)))
        call entier(m1e10,stk(l1e10),istk(iadr(l1e10)))
        call entier(m1e11,stk(l1e11),istk(iadr(l1e11)))
        call entier(1,stk(l1e5),istk(iadr(l1e5)))
        call entier(1,stk(l1e6),istk(iadr(l1e6)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        call entier(m1e14,stk(l1e14),istk(iadr(l1e14)))
        lw9=lw
        lw=lw+istk(iadr(l1e5))
        lw10=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call maxcpl(stk(l1e27),istk(iadr(l1e13)),istk(iadr(l1e10)),istk(
     & iadr(l1e11)),istk(iadr(l1e5)),istk(iadr(l1e6)),istk(iadr(l1e4)),
     & istk(iadr(l1e14)),stk(lw9),stk(lw10))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: z
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(1,stk(lw10),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: x
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l1e5))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l1e5))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l1e5)),stk(lw9),1,stk(lw),1)
        lw=lw+istk(iadr(l1e5))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 41) then
c 
c SCILAB function : euler
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable ma(g) --
        il1e5=iadr(l1+istk(il1+6)-1)
        l1e5 = sadr(il1e5+4)
c      
c       --   subvariable mm(g) --
        il1e6=iadr(l1+istk(il1+7)-1)
        l1e6 = sadr(il1e6+4)
c      
c       --   subvariable la2(g) --
        il1e10=iadr(l1+istk(il1+11)-1)
        m1e10 = istk(il1e10+2)
        l1e10 = sadr(il1e10+4)
c      
c       --   subvariable lp2(g) --
        il1e11=iadr(l1+istk(il1+12)-1)
        m1e11 = istk(il1e11+2)
        l1e11 = sadr(il1e11+4)
c      
c       --   subvariable ls2(g) --
        il1e12=iadr(l1+istk(il1+13)-1)
        m1e12 = istk(il1e12+2)
        l1e12 = sadr(il1e12+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        lw1=lw
        lw=lw+int(stk(l1e4))
        call entier(m1e10,stk(l1e10),istk(iadr(l1e10)))
        call entier(m1e11,stk(l1e11),istk(iadr(l1e11)))
        call entier(m1e12,stk(l1e12),istk(iadr(l1e12)))
        call entier(1,stk(l1e5),istk(iadr(l1e5)))
        call entier(1,stk(l1e6),istk(iadr(l1e6)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        lw8=lw
        lw=lw+istk(iadr(l1e4))
        lw9=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call eulerc(stk(lw1),istk(iadr(l1e10)),istk(iadr(l1e11)),istk(ia
     & dr(l1e12)),istk(iadr(l1e5)),istk(iadr(l1e6)),istk(iadr(l1e4)),st
     & k(lw8),stk(lw9),ne33)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: sigma
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne33-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=ne33
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne33,stk(lw9),stk(lw))
        lw=lw+ne33
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      if (fin .eq. 42) then
c 
c SCILAB function : mincfr
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .gt. 1 .or. rhs .lt. 0) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable g (number 1)
c       
        if (rhs .eq. 0) then
          call cvname(id,'the_g       ',0)
          call stackg(id)
          if (err .gt. 0) return
          rhs = rhs + 1
          lw = lstk(top + 1)
        endif
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 15) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable m(g) --
        il1e3=iadr(l1+istk(il1+4)-1)
        l1e3 = sadr(il1e3+4)
c      
c       --   subvariable n(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable he(g) --
        il1e13=iadr(l1+istk(il1+14)-1)
        m1e13 = istk(il1e13+2)
        l1e13 = sadr(il1e13+4)
c      
c       --   subvariable ta(g) --
        il1e14=iadr(l1+istk(il1+15)-1)
        m1e14 = istk(il1e14+2)
        l1e14 = sadr(il1e14+4)
c      
c       --   subvariable demand(g) --
        il1e19=iadr(l1+istk(il1+20)-1)
        m1e19 = istk(il1e19+2)
        l1e19 = sadr(il1e19+4)
c      
c       --   subvariable cost(g) --
        il1e22=iadr(l1+istk(il1+23)-1)
        m1e22 = istk(il1e22+2)
        l1e22 = sadr(il1e22+4)
c      
c       --   subvariable maxcap(g) --
        il1e24=iadr(l1+istk(il1+25)-1)
        m1e24 = istk(il1e24+2)
        l1e24 = sadr(il1e24+4)
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1e3),istk(iadr(l1e3)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        call entier(m1e13,stk(l1e13),istk(iadr(l1e13)))
        call entier(m1e14,stk(l1e14),istk(iadr(l1e14)))
        call entier(m1e22,stk(l1e22),istk(iadr(l1e22)))
        call entier(m1e24,stk(l1e24),istk(iadr(l1e24)))
        call entier(m1e19,stk(l1e19),istk(iadr(l1e19)))
        lw8=lw
        lw=lw+istk(iadr(l1e3))
        lw9=lw
        lw=lw+istk(iadr(l1e4))
        lw10=lw
        lw=lw+istk(iadr(l1e4))
        lw11=lw
        lw=lw+istk(iadr(l1e4))
        lw12=lw
        lw=lw+istk(iadr(l1e3))
        lw13=lw
        lw=lw+istk(iadr(l1e4))
        lw14=lw
        lw=lw+istk(iadr(l1e3))
        lw15=lw
        lw=lw+istk(iadr(l1e3))
        lw16=lw
        lw=lw+istk(iadr(l1e4))
        lw17=lw
        lw=lw+istk(iadr(l1e4))
        lw18=lw
        lw=lw+istk(iadr(l1e4))
        lw19=lw
        lw=lw+istk(iadr(l1e3))
        lw20=lw
        lw=lw+istk(iadr(l1e4))
        lw21=lw
        lw=lw+istk(iadr(l1e3))
        lw22=lw
        lw=lw+istk(iadr(l1e3))
        lw23=lw
        lw=lw+istk(iadr(l1e3))
        lw24=lw
        lw=lw+istk(iadr(l1e3))
        lw25=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call relax(istk(iadr(l1e3)),istk(iadr(l1e4)),istk(iadr(l1e13)),i
     & stk(iadr(l1e14)),istk(iadr(l1e22)),istk(iadr(l1e24)),istk(iadr(l
     & 1e19)),stk(lw8),stk(lw9),stk(lw10),stk(lw11),stk(lw12),stk(lw13)
     & ,stk(lw14),stk(lw15),stk(lw16),stk(lw17),stk(lw18),stk(lw19),stk
     & (lw20),stk(lw21),stk(lw22),stk(lw23),stk(lw24),stk(lw25))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: tcost
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(1,stk(lw25),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: x
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l1e3))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        istk(ilw+1)=1
        istk(ilw+2)=istk(iadr(l1e3))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l1e3)),stk(lw24),1,stk(lw),1)
        lw=lw+istk(iadr(l1e3))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      endif
c
      end
