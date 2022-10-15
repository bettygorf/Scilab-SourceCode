c fin = 1 
c SCILAB function : inimet
      subroutine intsinimet
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
      end
c
c fin = 2 
c SCILAB function : netwindow
      subroutine intsnetwindow
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
      end
c
c fin = 3 
c SCILAB function : netwindows
      subroutine intsnetwindows
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 0) then
          call error(39)
          return
        endif
        if (lhs .ne. 1) then
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
        lw3=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call netwindows(stk(lw1),ne1,stk(lw3))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c       Creation of output list
        top=top+1
        il=iadr(lw)
        istk(il)=15
        istk(il+1)=2
        istk(il+2)=1
        lw=sadr(il+5)
        lwtop=lw
c     
c       Element : scrs
        ilw=iadr(lw)
        err=lw+4+ne1-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne1.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne1,stk(lw1),stk(lw))
        lw=lw+ne1
c     
        istk(il+3)=lw-lwtop+1
c     
c       Element : cscr
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
        call int2db(1,stk(lw3),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+4)=lw-lwtop+1
c     
        lstk(top+1)=lw-mv
c     
c     Putting in order the stack
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 4 
c SCILAB function : loadg
      subroutine intsloadg
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lbuf = 1
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
c       checking variable path (number 1)
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
        lbuf1 = lbuf
        call cvstr(n1,istk(l1),buf(lbuf1:lbuf1+n1-1),1)
        lbuf = lbuf+n1+1
        lw3=lw
        lw=lw+1
        lw5=lw
        lw=lw+1
        lw6=lw
        lw=lw+1
        lw7=lw
        lw=lw+1
        lw8=lw
        lw=lw+1
        nn9=1
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
        lw30=lw
        lw=lw+1
        lw31=lw
        lw=lw+1
        lw32=lw
        lw=lw+1
        lw33=lw
        lw=lw+1
        lw34=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call loadg(buf(lbuf1:lbuf1+n1-1),n1,stk(lw3),ne3,stk(lw5),stk(lw
     & 6),stk(lw7),stk(lw8),stk(lw9),stk(lw10),stk(lw11),stk(lw12),stk(
     & lw13),stk(lw14),stk(lw15),stk(lw16),stk(lw17),stk(lw18),stk(lw19
     & ),stk(lw20),stk(lw21),stk(lw22),stk(lw23),stk(lw24),stk(lw25),st
     & k(lw26),stk(lw27),stk(lw28),stk(lw29),stk(lw30),stk(lw31),stk(lw
     & 32),stk(lw33),stk(lw34),ne13,ne7)
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c       Creation of output list
        top=top+1
        il=iadr(lw)
        istk(il)=15
        istk(il+1)=31
        istk(il+2)=1
        lw=sadr(il+34)
        lwtop=lw
c     
c       Element : name
        ilw=iadr(lw)
        err=sadr(ilw+6+ne3)-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=10
        istk(ilw+1)=1
        istk(ilw+2)=1
        istk(ilw+3)=0
        istk(ilw+4)=1
        istk(ilw+5)=ne3+1
        call cchar(ne3,stk(lw3),istk(ilw+6))
        lw=sadr(ilw+6+ne3)
c     
        istk(il+3)=lw-lwtop+1
c     
c       Element : directed
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
        istk(il+4)=lw-lwtop+1
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
        istk(il+5)=lw-lwtop+1
c     
c       Element : tail
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne7,stk(lw7),stk(lw))
        lw=lw+ne7
c     
        istk(il+6)=lw-lwtop+1
c     
c       Element : head
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne7,stk(lw8),stk(lw))
        lw=lw+ne7
c     
        istk(il+7)=lw-lwtop+1
c     
c       Element : node_name
        ilw=iadr(lw)
        call cstringf(stk(lw9),istk(ilw),nn9,ne13,
     &    lstk(bot)-sadr(ilw),ierr)
        if (ierr .gt. 0) then
          buf='not enough memory'
          call error(1000)
          return
        endif
        lw=sadr(ilw+5+nn9*ne13+istk(ilw+4+nn9*ne13)-1)
c     
        istk(il+8)=lw-lwtop+1
c     
c       Element : node_type
        ilw=iadr(lw)
        err=lw+4+ne13-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne13.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne13
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne13,stk(lw10),stk(lw))
        lw=lw+ne13
c     
        istk(il+9)=lw-lwtop+1
c     
c       Element : node_x
        ilw=iadr(lw)
        err=lw+4+ne13-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne13.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne13
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne13,stk(lw11),stk(lw))
        lw=lw+ne13
c     
        istk(il+10)=lw-lwtop+1
c     
c       Element : node_y
        ilw=iadr(lw)
        err=lw+4+ne13-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne13.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne13
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne13,stk(lw12),stk(lw))
        lw=lw+ne13
c     
        istk(il+11)=lw-lwtop+1
c     
c       Element : node_color
        ilw=iadr(lw)
        err=lw+4+ne13-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne13.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne13
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne13,stk(lw13),stk(lw))
        lw=lw+ne13
c     
        istk(il+12)=lw-lwtop+1
c     
c       Element : node_diam
        ilw=iadr(lw)
        err=lw+4+ne13-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne13.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne13
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne13,stk(lw14),stk(lw))
        lw=lw+ne13
c     
        istk(il+13)=lw-lwtop+1
c     
c       Element : node_border
        ilw=iadr(lw)
        err=lw+4+ne13-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne13.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne13
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne13,stk(lw15),stk(lw))
        lw=lw+ne13
c     
        istk(il+14)=lw-lwtop+1
c     
c       Element : node_font_size
        ilw=iadr(lw)
        err=lw+4+ne13-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne13.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne13
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne13,stk(lw16),stk(lw))
        lw=lw+ne13
c     
        istk(il+15)=lw-lwtop+1
c     
c       Element : node_demand
        ilw=iadr(lw)
        err=lw+4+ne13-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne13.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne13
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne13,stk(lw17),stk(lw))
        lw=lw+ne13
c     
        istk(il+16)=lw-lwtop+1
c     
c       Element : edge_name
        ilw=iadr(lw)
        call cstringf(stk(lw18),istk(ilw),nn9,ne7,
     &    lstk(bot)-sadr(ilw),ierr)
        if (ierr .gt. 0) then
          buf='not enough memory'
          call error(1000)
          return
        endif
        lw=sadr(ilw+5+nn9*ne7+istk(ilw+4+nn9*ne7)-1)
c     
        istk(il+17)=lw-lwtop+1
c     
c       Element : edge_color
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne7,stk(lw19),stk(lw))
        lw=lw+ne7
c     
        istk(il+18)=lw-lwtop+1
c     
c       Element : edge_width
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne7,stk(lw20),stk(lw))
        lw=lw+ne7
c     
        istk(il+19)=lw-lwtop+1
c     
c       Element : edge_hi_width
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne7,stk(lw21),stk(lw))
        lw=lw+ne7
c     
        istk(il+20)=lw-lwtop+1
c     
c       Element : edge_font_size
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne7,stk(lw22),stk(lw))
        lw=lw+ne7
c     
        istk(il+21)=lw-lwtop+1
c     
c       Element : edge_length
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne7,stk(lw23),stk(lw))
        lw=lw+ne7
c     
        istk(il+22)=lw-lwtop+1
c     
c       Element : edge_cost
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne7,stk(lw24),stk(lw))
        lw=lw+ne7
c     
        istk(il+23)=lw-lwtop+1
c     
c       Element : edge_min_cap
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne7,stk(lw25),stk(lw))
        lw=lw+ne7
c     
        istk(il+24)=lw-lwtop+1
c     
c       Element : edge_max_cap
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne7,stk(lw26),stk(lw))
        lw=lw+ne7
c     
        istk(il+25)=lw-lwtop+1
c     
c       Element : edge_q_weight
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne7,stk(lw27),stk(lw))
        lw=lw+ne7
c     
        istk(il+26)=lw-lwtop+1
c     
c       Element : edge_q_orig
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne7,stk(lw28),stk(lw))
        lw=lw+ne7
c     
        istk(il+27)=lw-lwtop+1
c     
c       Element : edge_weight
        ilw=iadr(lw)
        err=lw+4+ne7-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne7.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne7
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cdoublef(ne7,stk(lw29),stk(lw))
        lw=lw+ne7
c     
        istk(il+28)=lw-lwtop+1
c     
c       Element : default_node_diam
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
        call int2db(1,stk(lw30),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+29)=lw-lwtop+1
c     
c       Element : default_node_border
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
        call int2db(1,stk(lw31),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+30)=lw-lwtop+1
c     
c       Element : default_edge_width
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
        call int2db(1,stk(lw32),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+31)=lw-lwtop+1
c     
c       Element : default_edge_hi_width
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
        call int2db(1,stk(lw33),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+32)=lw-lwtop+1
c     
c       Element : default_font_size
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
        call int2db(1,stk(lw34),1,stk(lw),1)
        lw=lw+1
c     
        istk(il+33)=lw-lwtop+1
c     
        lstk(top+1)=lw-mv
c     
c     Putting in order the stack
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 5 
c SCILAB function : saveg
      subroutine intssaveg
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lbuf = 1
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 4) then
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
        if (istk(il1) .ne. 16) then
          err = 1
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable directed(g) --
        il1e3=iadr(l1+istk(il1+4)-1)
        l1e3 = sadr(il1e3+4)
c      
c       --   subvariable node_number(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable tail(g) --
        il1e5=iadr(l1+istk(il1+6)-1)
        m1e5 = istk(il1e5+2)
        l1e5 = sadr(il1e5+4)
c      
c       --   subvariable head(g) --
        il1e6=iadr(l1+istk(il1+7)-1)
        m1e6 = istk(il1e6+2)
        l1e6 = sadr(il1e6+4)
c      
c       --   subvariable node_name(g) --
        il1e7=iadr(l1+istk(il1+8)-1)
        n1e7 = istk(il1e7+1)
        m1e7 = istk(il1e7+2)
        l1e7 = il1e7
c      
c       --   subvariable node_type(g) --
        il1e8=iadr(l1+istk(il1+9)-1)
        m1e8 = istk(il1e8+2)
        l1e8 = sadr(il1e8+4)
c      
c       --   subvariable node_x(g) --
        il1e9=iadr(l1+istk(il1+10)-1)
        m1e9 = istk(il1e9+2)
        l1e9 = sadr(il1e9+4)
c      
c       --   subvariable node_y(g) --
        il1e10=iadr(l1+istk(il1+11)-1)
        m1e10 = istk(il1e10+2)
        l1e10 = sadr(il1e10+4)
c      
c       --   subvariable node_color(g) --
        il1e11=iadr(l1+istk(il1+12)-1)
        m1e11 = istk(il1e11+2)
        l1e11 = sadr(il1e11+4)
c      
c       --   subvariable node_diam(g) --
        il1e12=iadr(l1+istk(il1+13)-1)
        m1e12 = istk(il1e12+2)
        l1e12 = sadr(il1e12+4)
c      
c       --   subvariable node_border(g) --
        il1e13=iadr(l1+istk(il1+14)-1)
        m1e13 = istk(il1e13+2)
        l1e13 = sadr(il1e13+4)
c      
c       --   subvariable node_font_size(g) --
        il1e14=iadr(l1+istk(il1+15)-1)
        m1e14 = istk(il1e14+2)
        l1e14 = sadr(il1e14+4)
c      
c       --   subvariable node_demand(g) --
        il1e15=iadr(l1+istk(il1+16)-1)
        m1e15 = istk(il1e15+2)
        l1e15 = sadr(il1e15+4)
c      
c       --   subvariable edge_name(g) --
        il1e16=iadr(l1+istk(il1+17)-1)
        n1e16 = istk(il1e16+1)
        m1e16 = istk(il1e16+2)
        l1e16 = il1e16
c      
c       --   subvariable edge_color(g) --
        il1e17=iadr(l1+istk(il1+18)-1)
        m1e17 = istk(il1e17+2)
        l1e17 = sadr(il1e17+4)
c      
c       --   subvariable edge_width(g) --
        il1e18=iadr(l1+istk(il1+19)-1)
        m1e18 = istk(il1e18+2)
        l1e18 = sadr(il1e18+4)
c      
c       --   subvariable edge_hi_width(g) --
        il1e19=iadr(l1+istk(il1+20)-1)
        m1e19 = istk(il1e19+2)
        l1e19 = sadr(il1e19+4)
c      
c       --   subvariable edge_font_size(g) --
        il1e20=iadr(l1+istk(il1+21)-1)
        m1e20 = istk(il1e20+2)
        l1e20 = sadr(il1e20+4)
c      
c       --   subvariable edge_length(g) --
        il1e21=iadr(l1+istk(il1+22)-1)
        m1e21 = istk(il1e21+2)
        l1e21 = sadr(il1e21+4)
c      
c       --   subvariable edge_cost(g) --
        il1e22=iadr(l1+istk(il1+23)-1)
        m1e22 = istk(il1e22+2)
        l1e22 = sadr(il1e22+4)
c      
c       --   subvariable edge_min_cap(g) --
        il1e23=iadr(l1+istk(il1+24)-1)
        m1e23 = istk(il1e23+2)
        l1e23 = sadr(il1e23+4)
c      
c       --   subvariable edge_max_cap(g) --
        il1e24=iadr(l1+istk(il1+25)-1)
        m1e24 = istk(il1e24+2)
        l1e24 = sadr(il1e24+4)
c      
c       --   subvariable edge_q_weight(g) --
        il1e25=iadr(l1+istk(il1+26)-1)
        m1e25 = istk(il1e25+2)
        l1e25 = sadr(il1e25+4)
c      
c       --   subvariable edge_q_orig(g) --
        il1e26=iadr(l1+istk(il1+27)-1)
        m1e26 = istk(il1e26+2)
        l1e26 = sadr(il1e26+4)
c      
c       --   subvariable edge_weight(g) --
        il1e27=iadr(l1+istk(il1+28)-1)
        m1e27 = istk(il1e27+2)
        l1e27 = sadr(il1e27+4)
c      
c       --   subvariable default_node_diam(g) --
        il1e28=iadr(l1+istk(il1+29)-1)
        l1e28 = sadr(il1e28+4)
c      
c       --   subvariable default_node_border(g) --
        il1e29=iadr(l1+istk(il1+30)-1)
        l1e29 = sadr(il1e29+4)
c      
c       --   subvariable default_edge_width(g) --
        il1e30=iadr(l1+istk(il1+31)-1)
        l1e30 = sadr(il1e30+4)
c      
c       --   subvariable default_edge_hi_width(g) --
        il1e31=iadr(l1+istk(il1+32)-1)
        l1e31 = sadr(il1e31+4)
c      
c       --   subvariable default_font_size(g) --
        il1e32=iadr(l1+istk(il1+33)-1)
        l1e32 = sadr(il1e32+4)
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
c       checking variable ma (number 3)
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
c       checking variable datanet (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 10) then
          err = 4
          call error(55)
          return
        endif
        if (istk(il4+1)*istk(il4+2) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        n4 = istk(il4+5)-1
        l4 = il4+6
c     
c       cross variable size checking
c     
        if (m1e5 .ne. m1e6) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e16) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e17) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e18) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e19) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e20) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e21) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e22) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e23) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e24) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e25) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e26) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e27) then
          call error(42)
          return
        endif
        if (n1e7 .ne. n1e16) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e8) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e9) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e10) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e11) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e12) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e13) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e14) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e15) then
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
        call cvstr(n4,istk(l4),buf(lbuf1:lbuf1+n4-1),1)
        lbuf = lbuf+n4+1
        lbuf3 = lbuf
        call cvstr(n2,istk(l2),buf(lbuf3:lbuf3+n2-1),1)
        lbuf = lbuf+n2+1
        call entier(1,stk(l1e3),istk(iadr(l1e3)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        call entier(m1e5,stk(l1e5),istk(iadr(l1e5)))
        call entier(m1e6,stk(l1e6),istk(iadr(l1e6)))
        lw1e7=lw
        lw=lw+1
        call stringc(istk(il1e7),stk(lw1e7),ierr)
        if (ierr.ne.0) then
          buf='not enough memory'
          call error(1000)
          return
        endif
        call entier(m1e8,stk(l1e8),istk(iadr(l1e8)))
        call entier(m1e9,stk(l1e9),istk(iadr(l1e9)))
        call entier(m1e10,stk(l1e10),istk(iadr(l1e10)))
        call entier(m1e11,stk(l1e11),istk(iadr(l1e11)))
        call entier(m1e12,stk(l1e12),istk(iadr(l1e12)))
        call entier(m1e13,stk(l1e13),istk(iadr(l1e13)))
        call entier(m1e14,stk(l1e14),istk(iadr(l1e14)))
        lw1e16=lw
        lw=lw+1
        call stringc(istk(il1e16),stk(lw1e16),ierr)
        if (ierr.ne.0) then
          buf='not enough memory'
          call error(1000)
          return
        endif
        call entier(m1e17,stk(l1e17),istk(iadr(l1e17)))
        call entier(m1e18,stk(l1e18),istk(iadr(l1e18)))
        call entier(m1e19,stk(l1e19),istk(iadr(l1e19)))
        call entier(m1e20,stk(l1e20),istk(iadr(l1e20)))
        call entier(1,stk(l1e28),istk(iadr(l1e28)))
        call entier(1,stk(l1e29),istk(iadr(l1e29)))
        call entier(1,stk(l1e30),istk(iadr(l1e30)))
        call entier(1,stk(l1e31),istk(iadr(l1e31)))
        call entier(1,stk(l1e32),istk(iadr(l1e32)))
        call entier(1,stk(l3),istk(iadr(l3)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call saveg(buf(lbuf1:lbuf1+n4-1),n4,buf(lbuf3:lbuf3+n2-1),n2,ist
     & k(iadr(l1e3)),istk(iadr(l1e4)),istk(iadr(l1e5)),istk(iadr(l1e6))
     & ,stk(lw1e7),istk(iadr(l1e8)),istk(iadr(l1e9)),istk(iadr(l1e10)),
     & istk(iadr(l1e11)),istk(iadr(l1e12)),istk(iadr(l1e13)),istk(iadr(
     & l1e14)),stk(l1e15),stk(lw1e16),istk(iadr(l1e17)),istk(iadr(l1e18
     & )),istk(iadr(l1e19)),istk(iadr(l1e20)),stk(l1e21),stk(l1e22),stk
     & (l1e23),stk(l1e24),stk(l1e25),stk(l1e26),stk(l1e27),istk(iadr(l1
     & e28)),istk(iadr(l1e29)),istk(iadr(l1e30)),istk(iadr(l1e31)),istk
     & (iadr(l1e32)),istk(iadr(l3)))
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
      end
c
c fin = 6 
c SCILAB function : showg
      subroutine intsshowg
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lbuf = 1
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 8) then
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
        if (istk(il1) .ne. 16) then
          err = 1
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable directed(g) --
        il1e3=iadr(l1+istk(il1+4)-1)
        l1e3 = sadr(il1e3+4)
c      
c       --   subvariable node_number(g) --
        il1e4=iadr(l1+istk(il1+5)-1)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable tail(g) --
        il1e5=iadr(l1+istk(il1+6)-1)
        m1e5 = istk(il1e5+2)
        l1e5 = sadr(il1e5+4)
c      
c       --   subvariable head(g) --
        il1e6=iadr(l1+istk(il1+7)-1)
        m1e6 = istk(il1e6+2)
        l1e6 = sadr(il1e6+4)
c      
c       --   subvariable node_name(g) --
        il1e7=iadr(l1+istk(il1+8)-1)
        n1e7 = istk(il1e7+1)
        m1e7 = istk(il1e7+2)
        l1e7 = il1e7
c      
c       --   subvariable node_type(g) --
        il1e8=iadr(l1+istk(il1+9)-1)
        m1e8 = istk(il1e8+2)
        l1e8 = sadr(il1e8+4)
c      
c       --   subvariable node_x(g) --
        il1e9=iadr(l1+istk(il1+10)-1)
        m1e9 = istk(il1e9+2)
        l1e9 = sadr(il1e9+4)
c      
c       --   subvariable node_y(g) --
        il1e10=iadr(l1+istk(il1+11)-1)
        m1e10 = istk(il1e10+2)
        l1e10 = sadr(il1e10+4)
c      
c       --   subvariable node_color(g) --
        il1e11=iadr(l1+istk(il1+12)-1)
        m1e11 = istk(il1e11+2)
        l1e11 = sadr(il1e11+4)
c      
c       --   subvariable node_diam(g) --
        il1e12=iadr(l1+istk(il1+13)-1)
        m1e12 = istk(il1e12+2)
        l1e12 = sadr(il1e12+4)
c      
c       --   subvariable node_border(g) --
        il1e13=iadr(l1+istk(il1+14)-1)
        m1e13 = istk(il1e13+2)
        l1e13 = sadr(il1e13+4)
c      
c       --   subvariable node_font_size(g) --
        il1e14=iadr(l1+istk(il1+15)-1)
        m1e14 = istk(il1e14+2)
        l1e14 = sadr(il1e14+4)
c      
c       --   subvariable node_demand(g) --
        il1e15=iadr(l1+istk(il1+16)-1)
        m1e15 = istk(il1e15+2)
        l1e15 = sadr(il1e15+4)
c      
c       --   subvariable edge_name(g) --
        il1e16=iadr(l1+istk(il1+17)-1)
        n1e16 = istk(il1e16+1)
        m1e16 = istk(il1e16+2)
        l1e16 = il1e16
c      
c       --   subvariable edge_color(g) --
        il1e17=iadr(l1+istk(il1+18)-1)
        m1e17 = istk(il1e17+2)
        l1e17 = sadr(il1e17+4)
c      
c       --   subvariable edge_width(g) --
        il1e18=iadr(l1+istk(il1+19)-1)
        m1e18 = istk(il1e18+2)
        l1e18 = sadr(il1e18+4)
c      
c       --   subvariable edge_hi_width(g) --
        il1e19=iadr(l1+istk(il1+20)-1)
        m1e19 = istk(il1e19+2)
        l1e19 = sadr(il1e19+4)
c      
c       --   subvariable edge_font_size(g) --
        il1e20=iadr(l1+istk(il1+21)-1)
        m1e20 = istk(il1e20+2)
        l1e20 = sadr(il1e20+4)
c      
c       --   subvariable edge_length(g) --
        il1e21=iadr(l1+istk(il1+22)-1)
        m1e21 = istk(il1e21+2)
        l1e21 = sadr(il1e21+4)
c      
c       --   subvariable edge_cost(g) --
        il1e22=iadr(l1+istk(il1+23)-1)
        m1e22 = istk(il1e22+2)
        l1e22 = sadr(il1e22+4)
c      
c       --   subvariable edge_min_cap(g) --
        il1e23=iadr(l1+istk(il1+24)-1)
        m1e23 = istk(il1e23+2)
        l1e23 = sadr(il1e23+4)
c      
c       --   subvariable edge_max_cap(g) --
        il1e24=iadr(l1+istk(il1+25)-1)
        m1e24 = istk(il1e24+2)
        l1e24 = sadr(il1e24+4)
c      
c       --   subvariable edge_q_weight(g) --
        il1e25=iadr(l1+istk(il1+26)-1)
        m1e25 = istk(il1e25+2)
        l1e25 = sadr(il1e25+4)
c      
c       --   subvariable edge_q_orig(g) --
        il1e26=iadr(l1+istk(il1+27)-1)
        m1e26 = istk(il1e26+2)
        l1e26 = sadr(il1e26+4)
c      
c       --   subvariable edge_weight(g) --
        il1e27=iadr(l1+istk(il1+28)-1)
        m1e27 = istk(il1e27+2)
        l1e27 = sadr(il1e27+4)
c      
c       --   subvariable default_node_diam(g) --
        il1e28=iadr(l1+istk(il1+29)-1)
        l1e28 = sadr(il1e28+4)
c      
c       --   subvariable default_node_border(g) --
        il1e29=iadr(l1+istk(il1+30)-1)
        l1e29 = sadr(il1e29+4)
c      
c       --   subvariable default_edge_width(g) --
        il1e30=iadr(l1+istk(il1+31)-1)
        l1e30 = sadr(il1e30+4)
c      
c       --   subvariable default_edge_hi_width(g) --
        il1e31=iadr(l1+istk(il1+32)-1)
        l1e31 = sadr(il1e31+4)
c      
c       --   subvariable default_font_size(g) --
        il1e32=iadr(l1+istk(il1+33)-1)
        l1e32 = sadr(il1e32+4)
c      
c       --   subvariable node_label(g) --
        il1e33=iadr(l1+istk(il1+34)-1)
        n1e33 = istk(il1e33+1)
        m1e33 = istk(il1e33+2)
        l1e33 = il1e33
c      
c       --   subvariable edge_label(g) --
        il1e34=iadr(l1+istk(il1+35)-1)
        n1e34 = istk(il1e34+1)
        m1e34 = istk(il1e34+2)
        l1e34 = il1e34
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
c       checking variable ma (number 3)
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
c       checking variable window (number 4)
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
c       checking variable sup (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1)*istk(il5+2) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        l5 = sadr(il5+4)
c       checking variable scale (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1)*istk(il6+2) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        l6 = sadr(il6+4)
c       checking variable is_nlabel (number 7)
c       
        il7 = iadr(lstk(top-rhs+7))
        if (istk(il7) .ne. 1) then
          err = 7
          call error(53)
          return
        endif
        if (istk(il7+1)*istk(il7+2) .ne. 1) then
          err = 7
          call error(89)
          return
        endif
        l7 = sadr(il7+4)
c       checking variable is_elabel (number 8)
c       
        il8 = iadr(lstk(top-rhs+8))
        if (istk(il8) .ne. 1) then
          err = 8
          call error(53)
          return
        endif
        if (istk(il8+1)*istk(il8+2) .ne. 1) then
          err = 8
          call error(89)
          return
        endif
        l8 = sadr(il8+4)
c     
c       cross variable size checking
c     
        if (m1e5 .ne. m1e6) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e16) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e17) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e18) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e19) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e20) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e21) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e22) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e23) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e24) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e25) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e26) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e27) then
          call error(42)
          return
        endif
        if (m1e5 .ne. m1e34) then
          call error(42)
          return
        endif
        if (n1e7 .ne. n1e16) then
          call error(42)
          return
        endif
        if (n1e7 .ne. n1e33) then
          call error(42)
          return
        endif
        if (n1e7 .ne. n1e34) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e8) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e9) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e10) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e11) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e12) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e13) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e14) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e15) then
          call error(42)
          return
        endif
        if (m1e7 .ne. m1e33) then
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
        call entier(1,stk(l1e3),istk(iadr(l1e3)))
        call entier(1,stk(l1e4),istk(iadr(l1e4)))
        call entier(m1e5,stk(l1e5),istk(iadr(l1e5)))
        call entier(m1e6,stk(l1e6),istk(iadr(l1e6)))
        lw1e7=lw
        lw=lw+1
        call stringc(istk(il1e7),stk(lw1e7),ierr)
        if (ierr.ne.0) then
          buf='not enough memory'
          call error(1000)
          return
        endif
        call entier(m1e8,stk(l1e8),istk(iadr(l1e8)))
        call entier(m1e9,stk(l1e9),istk(iadr(l1e9)))
        call entier(m1e10,stk(l1e10),istk(iadr(l1e10)))
        call entier(m1e11,stk(l1e11),istk(iadr(l1e11)))
        call entier(m1e12,stk(l1e12),istk(iadr(l1e12)))
        call entier(m1e13,stk(l1e13),istk(iadr(l1e13)))
        call entier(m1e14,stk(l1e14),istk(iadr(l1e14)))
        lw1e16=lw
        lw=lw+1
        call stringc(istk(il1e16),stk(lw1e16),ierr)
        if (ierr.ne.0) then
          buf='not enough memory'
          call error(1000)
          return
        endif
        call entier(m1e17,stk(l1e17),istk(iadr(l1e17)))
        call entier(m1e18,stk(l1e18),istk(iadr(l1e18)))
        call entier(m1e19,stk(l1e19),istk(iadr(l1e19)))
        call entier(m1e20,stk(l1e20),istk(iadr(l1e20)))
        call entier(1,stk(l1e28),istk(iadr(l1e28)))
        call entier(1,stk(l1e29),istk(iadr(l1e29)))
        call entier(1,stk(l1e30),istk(iadr(l1e30)))
        call entier(1,stk(l1e31),istk(iadr(l1e31)))
        call entier(1,stk(l1e32),istk(iadr(l1e32)))
        call entier(1,stk(l7),istk(iadr(l7)))
        lw1e33=lw
        lw=lw+1
        call stringc(istk(il1e33),stk(lw1e33),ierr)
        if (ierr.ne.0) then
          buf='not enough memory'
          call error(1000)
          return
        endif
        call entier(1,stk(l8),istk(iadr(l8)))
        lw1e34=lw
        lw=lw+1
        call stringc(istk(il1e34),stk(lw1e34),ierr)
        if (ierr.ne.0) then
          buf='not enough memory'
          call error(1000)
          return
        endif
        call entier(1,stk(l3),istk(iadr(l3)))
        call entier(1,stk(l4),istk(iadr(l4)))
        call entier(1,stk(l5),istk(iadr(l5)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call showg(buf(lbuf1:lbuf1+n2-1),n2,istk(iadr(l1e3)),istk(iadr(l
     & 1e4)),istk(iadr(l1e5)),istk(iadr(l1e6)),stk(lw1e7),istk(iadr(l1e
     & 8)),istk(iadr(l1e9)),istk(iadr(l1e10)),istk(iadr(l1e11)),istk(ia
     & dr(l1e12)),istk(iadr(l1e13)),istk(iadr(l1e14)),stk(l1e15),stk(lw
     & 1e16),istk(iadr(l1e17)),istk(iadr(l1e18)),istk(iadr(l1e19)),istk
     & (iadr(l1e20)),stk(l1e21),stk(l1e22),stk(l1e23),stk(l1e24),stk(l1
     & e25),stk(l1e26),stk(l1e27),istk(iadr(l1e28)),istk(iadr(l1e29)),i
     & stk(iadr(l1e30)),istk(iadr(l1e31)),istk(iadr(l1e32)),istk(iadr(l
     & 7)),stk(lw1e33),istk(iadr(l8)),stk(lw1e34),istk(iadr(l3)),istk(i
     & adr(l4)),istk(iadr(l5)),stk(l6))
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
      end
c
c fin = 7 
c SCILAB function : showns
      subroutine intsshowns
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
      end
c
c fin = 8 
c SCILAB function : showp
      subroutine intsshowp
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
      end
c
c fin = 9 
c SCILAB function : prevn2p
      subroutine intsprevn2p
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 7) then
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
c       checking variable la (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable lp (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
c       checking variable ls (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        m6 = istk(il6+2)
        l6 = sadr(il6+4)
c       checking variable direct (number 7)
c       
        il7 = iadr(lstk(top-rhs+7))
        if (istk(il7) .ne. 1) then
          err = 7
          call error(53)
          return
        endif
        if (istk(il7+1)*istk(il7+2) .ne. 1) then
          err = 7
          call error(89)
          return
        endif
        l7 = sadr(il7+4)
c     
c       cross variable size checking
c     
        if (m4 .ne. m6) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(1,stk(l2),istk(iadr(l2)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(m5,stk(l5),istk(iadr(l5)))
        call entier(m6,stk(l6),istk(iadr(l6)))
        call entier(1,stk(l7),istk(iadr(l7)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        lw10=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call prevn2p(istk(iadr(l1)),istk(iadr(l2)),m4,m3,istk(iadr(l4)),
     & istk(iadr(l5)),istk(iadr(l6)),istk(iadr(l7)),istk(iadr(l3)),stk(
     & lw10),ne11)
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
        err=lw+4+ne11-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne11.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne11
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne11,stk(lw10),stk(lw))
        lw=lw+ne11
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 10 
c SCILAB function : ns2p
      subroutine intsns2p
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 5) then
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
c       checking variable la (number 2)
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
c       checking variable lp (number 3)
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
c       checking variable ls (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable n (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1)*istk(il5+2) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        l5 = sadr(il5+4)
c     
c       cross variable size checking
c     
        if (m2 .ne. m4) then
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
        lw3=lw
        lw=lw+1
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(1,stk(l5),istk(iadr(l5)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call ns2p(istk(iadr(l1)),m1,stk(lw3),ne9,istk(iadr(l2)),istk(iad
     & r(l3)),istk(iadr(l4)),istk(iadr(l5)))
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
        err=lw+4+ne9-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne9.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne9
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne9,stk(lw3),stk(lw))
        lw=lw+ne9
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 11 
c SCILAB function : p2ns
      subroutine intsp2ns
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 6) then
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
c       checking variable la (number 2)
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
c       checking variable lp (number 3)
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
c       checking variable ls (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable direct (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1)*istk(il5+2) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        l5 = sadr(il5+4)
c       checking variable n (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1)*istk(il6+2) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        l6 = sadr(il6+4)
c     
c       cross variable size checking
c     
        if (m2 .ne. m4) then
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
        lw3=lw
        lw=lw+1
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(1,stk(l5),istk(iadr(l5)))
        call entier(1,stk(l6),istk(iadr(l6)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call p2ns(istk(iadr(l1)),m1,stk(lw3),ne10,istk(iadr(l2)),istk(ia
     & dr(l3)),istk(iadr(l4)),istk(iadr(l5)),m2,istk(iadr(l6)))
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
        err=lw+4+ne10-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne10.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne10
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne10,stk(lw3),stk(lw))
        lw=lw+ne10
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 12 
c SCILAB function : edge2st
      subroutine intsedge2st
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call edge2st(m1,istk(iadr(l1)),stk(lw3),ne3)
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
        err=lw+4+ne3-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne3.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne3
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne3,stk(lw3),stk(lw))
        lw=lw+ne3
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 13 
c SCILAB function : prevn2st
      subroutine intsprevn2st
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 4) then
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
c       checking variable la (number 2)
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
c       checking variable lp (number 3)
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
c       checking variable ls (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c     
c       cross variable size checking
c     
        if (m2 .ne. m4) then
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
        lw3=lw
        lw=lw+1
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call prevn2st(m1,istk(iadr(l1)),stk(lw3),ne8,istk(iadr(l2)),istk
     & (iadr(l3)),istk(iadr(l4)))
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
        err=lw+4+ne8-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne8.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne8
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne8,stk(lw3),stk(lw))
        lw=lw+ne8
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 14 
c SCILAB function : compc
      subroutine intscompc
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 3) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
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
c       checking variable n (number 3)
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
        lw=lw+1
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(1,stk(l3),istk(iadr(l3)))
        lw6=lw
        lw=lw+istk(iadr(l3))
        lw7=lw
        lw=lw+istk(iadr(l3))
        lw8=lw
        lw=lw+istk(iadr(l3))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call compc(stk(lw1),istk(iadr(l1)),istk(iadr(l2)),m2,istk(iadr(l
     & 3)),stk(lw6),stk(lw7),stk(lw8))
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
        err=lw+4+istk(iadr(l3))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l3)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l3))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l3)),stk(lw6),1,stk(lw),1)
        lw=lw+istk(iadr(l3))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 15 
c SCILAB function : concom
      subroutine intsconcom
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
        call entier(m2,stk(l2),istk(iadr(l2)))
        lw4=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call concom(istk(iadr(l1)),m2,istk(iadr(l2)),stk(lw4),ne4)
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
        err=lw+4+ne4-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne4.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne4
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne4,stk(lw4),stk(lw))
        lw=lw+ne4
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 16 
c SCILAB function : compfc
      subroutine intscompfc
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 3) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
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
c       checking variable n (number 3)
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
        nn1=stk(l3)
        lw1=lw
        lw=lw+nn1
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(1,stk(l3),istk(iadr(l3)))
        lw6=lw
        lw=lw+1
        lw7=lw
        lw=lw+istk(iadr(l3))
        lw8=lw
        lw=lw+istk(iadr(l3))
        lw9=lw
        lw=lw+istk(iadr(l3))
        lw10=lw
        lw=lw+istk(iadr(l3))
        lw11=lw
        lw=lw+istk(iadr(l3))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call compfc(stk(lw1),istk(iadr(l1)),istk(iadr(l2)),m2,istk(iadr(
     & l3)),stk(lw6),stk(lw7),stk(lw8),stk(lw9),stk(lw10),stk(lw11))
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
        err=lw+4+istk(iadr(l3))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l3)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l3))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l3)),stk(lw7),1,stk(lw),1)
        lw=lw+istk(iadr(l3))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 17 
c SCILAB function : sconcom
      subroutine intssconcom
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
        call entier(m2,stk(l2),istk(iadr(l2)))
        lw4=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call sconcom(istk(iadr(l1)),m2,istk(iadr(l2)),stk(lw4),ne4)
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
        err=lw+4+ne4-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne4.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne4
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne4,stk(lw4),stk(lw))
        lw=lw+ne4
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 18 
c SCILAB function : pcchna
      subroutine intspcchna
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
c       checking variable lp (number 2)
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
c       checking variable ls (number 3)
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
c       checking variable n (number 4)
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
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(1,stk(l4),istk(iadr(l4)))
        lw6=lw
        lw=lw+istk(iadr(l4))
        lw7=lw
        lw=lw+istk(iadr(l4))
        lw8=lw
        lw=lw+istk(iadr(l4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call pcchna(istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),m3,istk
     & (iadr(l4)),stk(lw6),stk(lw7),stk(lw8))
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
        err=lw+4+istk(iadr(l4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l4)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l4)),stk(lw7),1,stk(lw),1)
        lw=lw+istk(iadr(l4))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: pan
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l4)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l4)),stk(lw6),1,stk(lw),1)
        lw=lw+istk(iadr(l4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 19 
c SCILAB function : ford
      subroutine intsford
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 6) then
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
c       checking variable la (number 2)
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
c       checking variable length (number 3)
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
c       checking variable lp (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable ls (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
c       checking variable n (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1)*istk(il6+2) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        l6 = sadr(il6+4)
c     
c       cross variable size checking
c     
        if (m2 .ne. m5) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(m5,stk(l5),istk(iadr(l5)))
        call entier(1,stk(l6),istk(iadr(l6)))
        lw8=lw
        lw=lw+istk(iadr(l6))
        lw9=lw
        lw=lw+istk(iadr(l6))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call ford(istk(iadr(l1)),istk(iadr(l2)),stk(l3),istk(iadr(l4)),i
     & stk(iadr(l5)),m2,istk(iadr(l6)),stk(lw8),stk(lw9))
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
        err=lw+4+istk(iadr(l6))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l6)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l6))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(istk(iadr(l6)),stk(lw9),1,stk(lw),1)
        lw=lw+istk(iadr(l6))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: p
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l6))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l6)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l6))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l6)),stk(lw8),1,stk(lw),1)
        lw=lw+istk(iadr(l6))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 20 
c SCILAB function : johns
      subroutine intsjohns
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 6) then
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
c       checking variable la (number 2)
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
c       checking variable length (number 3)
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
c       checking variable lp (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable ls (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
c       checking variable n (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1)*istk(il6+2) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        l6 = sadr(il6+4)
c     
c       cross variable size checking
c     
        if (m2 .ne. m5) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        nn1=stk(l6)
        lw1=lw
        lw=lw+nn1
        call entier(1,stk(l1),istk(iadr(l1)))
        lw3=lw
        lw=lw+nn1
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(m5,stk(l5),istk(iadr(l5)))
        call entier(1,stk(l6),istk(iadr(l6)))
        lw10=lw
        lw=lw+istk(iadr(l6))
        lw11=lw
        lw=lw+istk(iadr(l6))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call johns(stk(lw1),istk(iadr(l1)),stk(lw3),istk(iadr(l2)),stk(l
     & 3),istk(iadr(l4)),istk(iadr(l5)),m2,istk(iadr(l6)),stk(lw10),stk
     & (lw11))
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
        err=lw+4+istk(iadr(l6))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l6)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l6))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(istk(iadr(l6)),stk(lw11),1,stk(lw),1)
        lw=lw+istk(iadr(l6))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: p
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l6))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l6)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l6))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l6)),stk(lw10),1,stk(lw),1)
        lw=lw+istk(iadr(l6))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 21 
c SCILAB function : dijkst
      subroutine intsdijkst
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 6) then
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
c       checking variable la (number 2)
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
c       checking variable length (number 3)
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
c       checking variable lp (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable ls (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
c       checking variable n (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1)*istk(il6+2) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        l6 = sadr(il6+4)
c     
c       cross variable size checking
c     
        if (m2 .ne. m5) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(m5,stk(l5),istk(iadr(l5)))
        call entier(1,stk(l6),istk(iadr(l6)))
        lw8=lw
        lw=lw+istk(iadr(l6))
        lw9=lw
        lw=lw+istk(iadr(l6))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call dijkst(istk(iadr(l1)),istk(iadr(l2)),stk(l3),istk(iadr(l4))
     & ,istk(iadr(l5)),m2,istk(iadr(l6)),stk(lw8),stk(lw9))
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
        err=lw+4+istk(iadr(l6))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l6)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l6))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(istk(iadr(l6)),stk(lw9),1,stk(lw),1)
        lw=lw+istk(iadr(l6))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: p
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l6))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l6)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l6))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l6)),stk(lw8),1,stk(lw),1)
        lw=lw+istk(iadr(l6))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 22 
c SCILAB function : frang
      subroutine intsfrang
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 3) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
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
c       checking variable n (number 3)
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
        lw=lw+1
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(1,stk(l3),istk(iadr(l3)))
        lw6=lw
        lw=lw+istk(iadr(l3))
        lw7=lw
        lw=lw+istk(iadr(l3))
        lw8=lw
        lw=lw+istk(iadr(l3))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call frang(stk(lw1),istk(iadr(l1)),istk(iadr(l2)),m2,istk(iadr(l
     & 3)),stk(lw6),stk(lw7),stk(lw8))
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
        err=lw+4+istk(iadr(l3))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l3)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l3))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l3)),stk(lw8),1,stk(lw),1)
        lw=lw+istk(iadr(l3))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 23 
c SCILAB function : chcm
      subroutine intschcm
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 6) then
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
c       checking variable la (number 2)
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
c       checking variable lp (number 3)
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
c       checking variable ls (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable n (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1)*istk(il5+2) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        l5 = sadr(il5+4)
c       checking variable maxcap (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        m6 = istk(il6+2)
        l6 = sadr(il6+4)
c     
c       cross variable size checking
c     
        if (m2 .ne. m4) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(1,stk(l5),istk(iadr(l5)))
        lw8=lw
        lw=lw+istk(iadr(l5))
        lw9=lw
        lw=lw+istk(iadr(l5))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call chcm(stk(l6),istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),i
     & stk(iadr(l4)),m2,istk(iadr(l5)),stk(lw8),stk(lw9))
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
        err=lw+4+istk(iadr(l5))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l5)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l5))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(istk(iadr(l5)),stk(lw9),1,stk(lw),1)
        lw=lw+istk(iadr(l5))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: pcap
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l5))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l5)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l5))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l5)),stk(lw8),1,stk(lw),1)
        lw=lw+istk(iadr(l5))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 24 
c SCILAB function : transc
      subroutine intstransc
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 3) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
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
c       checking variable n (number 3)
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
        call entier(m1,stk(l1),istk(iadr(l1)))
        lw2=lw
        lw=lw+1
        call entier(m2,stk(l2),istk(iadr(l2)))
        lw4=lw
        lw=lw+1
        call entier(1,stk(l3),istk(iadr(l3)))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call transc(istk(iadr(l1)),stk(lw2),istk(iadr(l2)),stk(lw4),m2,n
     & e8,ne6,istk(iadr(l3)))
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
        err=lw+4+ne6-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne6.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne6
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne6,stk(lw2),stk(lw))
        lw=lw+ne6
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: lsft
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+ne8-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (ne8.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=ne8
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call cintf(ne8,stk(lw4),stk(lw))
        lw=lw+ne8
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 25 
c SCILAB function : dfs
      subroutine intsdfs
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
c       checking variable lp (number 2)
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
c       checking variable ls (number 3)
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
c       checking variable n (number 4)
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
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(1,stk(l4),istk(iadr(l4)))
        lw6=lw
        lw=lw+istk(iadr(l4))
        lw7=lw
        lw=lw+istk(iadr(l4))
        lw8=lw
        lw=lw+istk(iadr(l4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call dfs(istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),m3,istk(ia
     & dr(l4)),stk(lw6),stk(lw7),stk(lw8))
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
        err=lw+4+istk(iadr(l4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l4)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l4)),stk(lw7),1,stk(lw),1)
        lw=lw+istk(iadr(l4))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: pw
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l4)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l4)),stk(lw8),1,stk(lw),1)
        lw=lw+istk(iadr(l4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 26 
c SCILAB function : umtree
      subroutine intsumtree
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 5) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable la (number 1)
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
c       checking variable lp (number 2)
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
c       checking variable ls (number 3)
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
c       checking variable n (number 4)
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
c       checking variable weight (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
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
        nn1=stk(l4)
        lw1=lw
        lw=lw+nn1
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(1,stk(l4),istk(iadr(l4)))
        lw8=lw
        lw=lw+istk(iadr(l4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call prim(stk(lw1),istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),
     & m5,m1,istk(iadr(l4)),stk(lw8),stk(l5))
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
        err=lw+4+istk(iadr(l4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l4)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l4)),stk(lw1),1,stk(lw),1)
        lw=lw+istk(iadr(l4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 27 
c SCILAB function : umtree1
      subroutine intsumtree1
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 5) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable la (number 1)
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
c       checking variable lp (number 2)
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
c       checking variable ls (number 3)
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
c       checking variable n (number 4)
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
c       checking variable weight (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
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
        nn1=stk(l4)
        lw1=lw
        lw=lw+nn1
        lw2=lw
        lw=lw+nn1
        lw3=lw
        lw=lw+nn1
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(1,stk(l4),istk(iadr(l4)))
        lw10=lw
        lw=lw+istk(iadr(l4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call prim1(stk(lw1),stk(lw2),stk(lw3),istk(iadr(l1)),istk(iadr(l
     & 2)),istk(iadr(l3)),m5,m1,istk(iadr(l4)),stk(lw10),stk(l5))
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
        err=lw+4+istk(iadr(l4))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l4)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l4))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l4)),stk(lw1),1,stk(lw),1)
        lw=lw+istk(iadr(l4))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 28 
c SCILAB function : dmtree
      subroutine intsdmtree
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 6) then
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
c       checking variable la (number 2)
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
c       checking variable lp (number 3)
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
c       checking variable ls (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable n (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1)*istk(il5+2) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        l5 = sadr(il5+4)
c       checking variable weight (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        m6 = istk(il6+2)
        l6 = sadr(il6+4)
c     
c       cross variable size checking
c     
        if (m2 .ne. m4) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(1,stk(l5),istk(iadr(l5)))
        lw7=lw
        lw=lw+istk(iadr(l5))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call dmtree(istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),istk(ia
     & dr(l4)),m2,istk(iadr(l5)),stk(lw7),stk(l6))
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
        err=lw+4+istk(iadr(l5))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l5)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l5))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l5)),stk(lw7),1,stk(lw),1)
        lw=lw+istk(iadr(l5))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 29 
c SCILAB function : tconex
      subroutine intstconex
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 4) then
          call error(39)
          return
        endif
        if (lhs .gt. 1) then
          call error(41)
          return
        endif
c       checking variable la (number 1)
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
c       checking variable lp (number 2)
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
c       checking variable ls (number 3)
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
c       checking variable n (number 4)
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
        nn1=stk(l4)
        lw1=lw
        lw=lw+nn1
        lw2=lw
        lw=lw+1
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(1,stk(l4),istk(iadr(l4)))
        lw8=lw
        lw=lw+istk(iadr(l4))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call tconex(stk(lw1),stk(lw2),istk(iadr(l1)),istk(iadr(l2)),istk
     & (iadr(l3)),m1,istk(iadr(l4)),stk(lw8))
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
      end
c
c fin = 30 
c SCILAB function : flomax
      subroutine intsflomax
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 10) then
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
c       checking variable la (number 3)
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
c       checking variable lp (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable he (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
c       checking variable ta (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        m6 = istk(il6+2)
        l6 = sadr(il6+4)
c       checking variable mincap (number 7)
c       
        il7 = iadr(lstk(top-rhs+7))
        if (istk(il7) .ne. 1) then
          err = 7
          call error(53)
          return
        endif
        if (istk(il7+1) .ne. 1) then
          err = 7
          call error(89)
          return
        endif
        m7 = istk(il7+2)
        l7 = sadr(il7+4)
c       checking variable maxcap (number 8)
c       
        il8 = iadr(lstk(top-rhs+8))
        if (istk(il8) .ne. 1) then
          err = 8
          call error(53)
          return
        endif
        if (istk(il8+1) .ne. 1) then
          err = 8
          call error(89)
          return
        endif
        m8 = istk(il8+2)
        l8 = sadr(il8+4)
c       checking variable n (number 9)
c       
        il9 = iadr(lstk(top-rhs+9))
        if (istk(il9) .ne. 1) then
          err = 9
          call error(53)
          return
        endif
        if (istk(il9+1)*istk(il9+2) .ne. 1) then
          err = 9
          call error(89)
          return
        endif
        l9 = sadr(il9+4)
c       checking variable phi (number 10)
c       
        il10 = iadr(lstk(top-rhs+10))
        if (istk(il10) .ne. 1) then
          err = 10
          call error(53)
          return
        endif
        if (istk(il10+1) .ne. 1) then
          err = 10
          call error(89)
          return
        endif
        m10 = istk(il10+2)
        l10 = sadr(il10+4)
c     
c       cross variable size checking
c     
        if (m5 .ne. m6) then
          call error(42)
          return
        endif
        if (m5 .ne. m7) then
          call error(42)
          return
        endif
        if (m5 .ne. m8) then
          call error(42)
          return
        endif
        if (m5 .ne. m10) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m7,stk(l7),istk(iadr(l7)))
        call entier(m8,stk(l8),istk(iadr(l8)))
        call entier(m5,stk(l5),istk(iadr(l5)))
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(1,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        nn9=stk(l9)
        lw9=lw
        lw=lw+nn9
        call entier(1,stk(l9),istk(iadr(l9)))
        call entier(m6,stk(l6),istk(iadr(l6)))
        call entier(m10,stk(l10),istk(iadr(l10)))
        lw14=lw
        lw=lw+istk(iadr(l9))
        lw15=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call flomax(istk(iadr(l7)),istk(iadr(l8)),istk(iadr(l5)),istk(ia
     & dr(l1)),istk(iadr(l2)),istk(iadr(l3)),istk(iadr(l4)),m5,stk(lw9)
     & ,m3,istk(iadr(l9)),istk(iadr(l6)),istk(iadr(l10)),stk(lw14),stk(
     & lw15))
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
        err=lw+4+m5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        call icopy(4,istk(il10),1,istk(ilw),1)
        lw=sadr(ilw+4)
        call int2db(m10,stk(l10),1,stk(lw),1)
        lw=lw+m10
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 31 
c SCILAB function : kilter
      subroutine intskilter
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 8) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
          call error(41)
          return
        endif
c       checking variable mincap (number 1)
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
c       checking variable maxcap (number 2)
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
c       checking variable he (number 3)
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
c       checking variable ta (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable la (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
c       checking variable lp (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        m6 = istk(il6+2)
        l6 = sadr(il6+4)
c       checking variable n (number 7)
c       
        il7 = iadr(lstk(top-rhs+7))
        if (istk(il7) .ne. 1) then
          err = 7
          call error(53)
          return
        endif
        if (istk(il7+1)*istk(il7+2) .ne. 1) then
          err = 7
          call error(89)
          return
        endif
        l7 = sadr(il7+4)
c       checking variable cost (number 8)
c       
        il8 = iadr(lstk(top-rhs+8))
        if (istk(il8) .ne. 1) then
          err = 8
          call error(53)
          return
        endif
        if (istk(il8+1) .ne. 1) then
          err = 8
          call error(89)
          return
        endif
        m8 = istk(il8+2)
        l8 = sadr(il8+4)
c     
c       cross variable size checking
c     
        if (m1 .ne. m2) then
          call error(42)
          return
        endif
        if (m1 .ne. m3) then
          call error(42)
          return
        endif
        if (m1 .ne. m4) then
          call error(42)
          return
        endif
        if (m1 .ne. m8) then
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
        call entier(m5,stk(l5),istk(iadr(l5)))
        call entier(m6,stk(l6),istk(iadr(l6)))
        call entier(1,stk(l7),istk(iadr(l7)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        lw11=lw
        lw=lw+m1
        lw12=lw
        lw=lw+istk(iadr(l7))
        lw13=lw
        lw=lw+istk(iadr(l7))
        lw14=lw
        lw=lw+istk(iadr(l7))
        lw15=lw
        lw=lw+istk(iadr(l7))
        lw16=lw
        lw=lw+m1
        lw17=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call kilter(istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),stk(l8)
     & ,istk(iadr(l5)),istk(iadr(l6)),m1,m5,istk(iadr(l7)),istk(iadr(l4
     & )),stk(lw11),stk(lw12),stk(lw13),stk(lw14),stk(lw15),stk(lw16),s
     & tk(lw17))
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
        err=lw+4+m1-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (m1.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=m1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(m1,stk(lw11),1,stk(lw),1)
        lw=lw+m1
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: flag
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
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 32 
c SCILAB function : busack
      subroutine intsbusack
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 10) then
          call error(39)
          return
        endif
        if (lhs .gt. 3) then
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
c       checking variable maxcap (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable he (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
c       checking variable ta (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        m6 = istk(il6+2)
        l6 = sadr(il6+4)
c       checking variable la (number 7)
c       
        il7 = iadr(lstk(top-rhs+7))
        if (istk(il7) .ne. 1) then
          err = 7
          call error(53)
          return
        endif
        if (istk(il7+1) .ne. 1) then
          err = 7
          call error(89)
          return
        endif
        m7 = istk(il7+2)
        l7 = sadr(il7+4)
c       checking variable lp (number 8)
c       
        il8 = iadr(lstk(top-rhs+8))
        if (istk(il8) .ne. 1) then
          err = 8
          call error(53)
          return
        endif
        if (istk(il8+1) .ne. 1) then
          err = 8
          call error(89)
          return
        endif
        m8 = istk(il8+2)
        l8 = sadr(il8+4)
c       checking variable n (number 9)
c       
        il9 = iadr(lstk(top-rhs+9))
        if (istk(il9) .ne. 1) then
          err = 9
          call error(53)
          return
        endif
        if (istk(il9+1)*istk(il9+2) .ne. 1) then
          err = 9
          call error(89)
          return
        endif
        l9 = sadr(il9+4)
c       checking variable cost (number 10)
c       
        il10 = iadr(lstk(top-rhs+10))
        if (istk(il10) .ne. 1) then
          err = 10
          call error(53)
          return
        endif
        if (istk(il10+1) .ne. 1) then
          err = 10
          call error(89)
          return
        endif
        m10 = istk(il10+2)
        l10 = sadr(il10+4)
c     
c       cross variable size checking
c     
        if (m4 .ne. m5) then
          call error(42)
          return
        endif
        if (m4 .ne. m6) then
          call error(42)
          return
        endif
        if (m4 .ne. m10) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(m5,stk(l5),istk(iadr(l5)))
        call entier(1,stk(l1),istk(iadr(l1)))
        call entier(1,stk(l2),istk(iadr(l2)))
        call entier(m7,stk(l7),istk(iadr(l7)))
        call entier(m8,stk(l8),istk(iadr(l8)))
        nn9=stk(l9)
        lw9=lw
        lw=lw+nn9
        call entier(1,stk(l9),istk(iadr(l9)))
        call entier(m6,stk(l6),istk(iadr(l6)))
        lw13=lw
        lw=lw+istk(iadr(l9))
        lw14=lw
        lw=lw+m4
        lw15=lw
        lw=lw+istk(iadr(l9))
        call entier(1,stk(l3),istk(iadr(l3)))
        lw17=lw
        lw=lw+1
        lw18=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call busack(istk(iadr(l4)),istk(iadr(l5)),stk(l10),istk(iadr(l1)
     & ),istk(iadr(l2)),istk(iadr(l7)),istk(iadr(l8)),m4,stk(lw9),m7,is
     & tk(iadr(l9)),istk(iadr(l6)),stk(lw13),stk(lw14),stk(lw15),istk(i
     & adr(l3)),stk(lw17),stk(lw18))
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
        err=lw+4+m4-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (m4.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=m4
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(m4,stk(lw14),1,stk(lw),1)
        lw=lw+m4
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 3) then
c     
c       output variable: flag
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
        call int2db(1,stk(lw18),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 33 
c SCILAB function : floqua
      subroutine intsfloqua
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 10) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
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
c       checking variable mincap (number 2)
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
c       checking variable maxcap (number 3)
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
c       checking variable he (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable ta (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
c       checking variable la (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        m6 = istk(il6+2)
        l6 = sadr(il6+4)
c       checking variable lp (number 7)
c       
        il7 = iadr(lstk(top-rhs+7))
        if (istk(il7) .ne. 1) then
          err = 7
          call error(53)
          return
        endif
        if (istk(il7+1) .ne. 1) then
          err = 7
          call error(89)
          return
        endif
        m7 = istk(il7+2)
        l7 = sadr(il7+4)
c       checking variable n (number 8)
c       
        il8 = iadr(lstk(top-rhs+8))
        if (istk(il8) .ne. 1) then
          err = 8
          call error(53)
          return
        endif
        if (istk(il8+1)*istk(il8+2) .ne. 1) then
          err = 8
          call error(89)
          return
        endif
        l8 = sadr(il8+4)
c       checking variable qorig (number 9)
c       
        il9 = iadr(lstk(top-rhs+9))
        if (istk(il9) .ne. 1) then
          err = 9
          call error(53)
          return
        endif
        if (istk(il9+1) .ne. 1) then
          err = 9
          call error(89)
          return
        endif
        m9 = istk(il9+2)
        l9 = sadr(il9+4)
c       checking variable qweight (number 10)
c       
        il10 = iadr(lstk(top-rhs+10))
        if (istk(il10) .ne. 1) then
          err = 10
          call error(53)
          return
        endif
        if (istk(il10+1) .ne. 1) then
          err = 10
          call error(89)
          return
        endif
        m10 = istk(il10+2)
        l10 = sadr(il10+4)
c     
c       cross variable size checking
c     
        if (m2 .ne. m3) then
          call error(42)
          return
        endif
        if (m2 .ne. m4) then
          call error(42)
          return
        endif
        if (m2 .ne. m5) then
          call error(42)
          return
        endif
        if (m2 .ne. m9) then
          call error(42)
          return
        endif
        if (m2 .ne. m10) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m2,stk(l2),istk(iadr(l2)))
        lw2=lw
        lw=lw+m2
        call entier(m3,stk(l3),istk(iadr(l3)))
        lw4=lw
        lw=lw+m2
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(m6,stk(l6),istk(iadr(l6)))
        call entier(m7,stk(l7),istk(iadr(l7)))
        call entier(1,stk(l8),istk(iadr(l8)))
        call entier(m5,stk(l5),istk(iadr(l5)))
        lw14=lw
        lw=lw+m2
        lw15=lw
        lw=lw+istk(iadr(l8))
        lw16=lw
        lw=lw+istk(iadr(l8))
        lw17=lw
        lw=lw+istk(iadr(l8))
        lw18=lw
        lw=lw+istk(iadr(l8))
        lw19=lw
        lw=lw+m2
        lw21=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call floqua(istk(iadr(l2)),stk(lw2),istk(iadr(l3)),stk(lw4),stk(
     & l1),istk(iadr(l4)),istk(iadr(l6)),istk(iadr(l7)),m2,m6,istk(iadr
     & (l8)),istk(iadr(l5)),stk(l9),stk(lw14),stk(lw15),stk(lw16),stk(l
     & w17),stk(lw18),stk(lw19),stk(l10),stk(lw21))
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
        err=lw+4+m2-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (m2.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=m2
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call dcopy(m2,stk(lw14),1,stk(lw),1)
        lw=lw+m2
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: flag
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
        call int2db(1,stk(lw21),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 34 
c SCILAB function : relax
      subroutine intsrelax
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 7) then
          call error(39)
          return
        endif
        if (lhs .gt. 3) then
          call error(41)
          return
        endif
c       checking variable he (number 1)
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
c       checking variable ta (number 2)
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
c       checking variable cost (number 3)
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
c       checking variable maxcap (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 1) then
          err = 4
          call error(53)
          return
        endif
        if (istk(il4+1) .ne. 1) then
          err = 4
          call error(89)
          return
        endif
        m4 = istk(il4+2)
        l4 = sadr(il4+4)
c       checking variable demand (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        m5 = istk(il5+2)
        l5 = sadr(il5+4)
c       checking variable m (number 6)
c       
        il6 = iadr(lstk(top-rhs+6))
        if (istk(il6) .ne. 1) then
          err = 6
          call error(53)
          return
        endif
        if (istk(il6+1)*istk(il6+2) .ne. 1) then
          err = 6
          call error(89)
          return
        endif
        l6 = sadr(il6+4)
c       checking variable n (number 7)
c       
        il7 = iadr(lstk(top-rhs+7))
        if (istk(il7) .ne. 1) then
          err = 7
          call error(53)
          return
        endif
        if (istk(il7+1)*istk(il7+2) .ne. 1) then
          err = 7
          call error(89)
          return
        endif
        l7 = sadr(il7+4)
c     
c       cross variable size checking
c     
        if (m1 .ne. m2) then
          call error(42)
          return
        endif
        if (m1 .ne. m3) then
          call error(42)
          return
        endif
        if (m1 .ne. m4) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(1,stk(l6),istk(iadr(l6)))
        call entier(1,stk(l7),istk(iadr(l7)))
        call entier(m1,stk(l1),istk(iadr(l1)))
        call entier(m2,stk(l2),istk(iadr(l2)))
        call entier(m3,stk(l3),istk(iadr(l3)))
        call entier(m4,stk(l4),istk(iadr(l4)))
        call entier(m5,stk(l5),istk(iadr(l5)))
        lw8=lw
        lw=lw+istk(iadr(l6))
        lw9=lw
        lw=lw+istk(iadr(l7))
        lw10=lw
        lw=lw+istk(iadr(l7))
        lw11=lw
        lw=lw+istk(iadr(l7))
        lw12=lw
        lw=lw+istk(iadr(l6))
        lw13=lw
        lw=lw+istk(iadr(l7))
        lw14=lw
        lw=lw+istk(iadr(l6))
        lw15=lw
        lw=lw+istk(iadr(l6))
        lw16=lw
        lw=lw+istk(iadr(l7))
        lw17=lw
        lw=lw+istk(iadr(l7))
        lw18=lw
        lw=lw+istk(iadr(l7))
        lw19=lw
        lw=lw+istk(iadr(l6))
        lw20=lw
        lw=lw+istk(iadr(l7))
        lw21=lw
        lw=lw+istk(iadr(l6))
        lw22=lw
        lw=lw+istk(iadr(l6))
        lw23=lw
        lw=lw+istk(iadr(l6))
        lw24=lw
        lw=lw+istk(iadr(l6))
        lw25=lw
        lw=lw+1
        lw26=lw
        lw=lw+1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call relax(istk(iadr(l6)),istk(iadr(l7)),istk(iadr(l1)),istk(iad
     & r(l2)),istk(iadr(l3)),istk(iadr(l4)),istk(iadr(l5)),stk(lw8),stk
     & (lw9),stk(lw10),stk(lw11),stk(lw12),stk(lw13),stk(lw14),stk(lw15
     & ),stk(lw16),stk(lw17),stk(lw18),stk(lw19),stk(lw20),stk(lw21),st
     & k(lw22),stk(lw23),stk(lw24),stk(lw25),stk(lw26))
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
        err=lw+4+istk(iadr(l6))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l6)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l6))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l6)),stk(lw24),1,stk(lw),1)
        lw=lw+istk(iadr(l6))
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 3) then
c     
c       output variable: flag
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
        call int2db(1,stk(lw26),1,stk(lw),1)
        lw=lw+1
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 35 
c SCILAB function : findiso
      subroutine intsfindiso
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
c       checking variable tail (number 1)
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
c       checking variable head (number 2)
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
c       checking variable n (number 3)
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
        if (m1 .ne. m2) then
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
        call entier(1,stk(l3),istk(iadr(l3)))
        lw5=lw
        lw=lw+istk(iadr(l3))
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call findiso(istk(iadr(l1)),istk(iadr(l2)),m1,istk(iadr(l3)),stk
     & (lw5))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: v
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+istk(iadr(l3))-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (istk(iadr(l3)).eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=istk(iadr(l3))
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(istk(iadr(l3)),stk(lw5),1,stk(lw),1)
        lw=lw+istk(iadr(l3))
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 36 
c SCILAB function : ta2lpd
      subroutine intsta2lpd
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
c       checking variable tail (number 1)
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
c       checking variable head (number 2)
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
c       checking variable n1 (number 3)
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
c       checking variable n (number 4)
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
        if (m1 .ne. m2) then
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
        call entier(1,stk(l4),istk(iadr(l4)))
        nn5=stk(l3)
        lw5=lw
        lw=lw+nn5
        lw6=lw
        lw=lw+m1
        lw7=lw
        lw=lw+m1
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call ta2lpd(istk(iadr(l1)),istk(iadr(l2)),m1,istk(iadr(l4)),stk(
     & lw5),stk(lw6),stk(lw7))
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
        err=lw+4+nn5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (nn5.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=nn5
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(nn5,stk(lw5),1,stk(lw),1)
        lw=lw+nn5
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: la
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+m1-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (m1.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=m1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(m1,stk(lw6),1,stk(lw),1)
        lw=lw+m1
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 3) then
c     
c       output variable: ls
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+m1-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (m1.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=m1
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(m1,stk(lw7),1,stk(lw),1)
        lw=lw+m1
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 37 
c SCILAB function : ta2lpu
      subroutine intsta2lpu
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 5) then
          call error(39)
          return
        endif
        if (lhs .gt. 3) then
          call error(41)
          return
        endif
c       checking variable tail (number 1)
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
c       checking variable head (number 2)
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
c       checking variable n1 (number 3)
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
c       checking variable n (number 4)
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
c       checking variable m (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1)*istk(il5+2) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        l5 = sadr(il5+4)
c     
c       cross variable size checking
c     
        if (m1 .ne. m2) then
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
        call entier(1,stk(l4),istk(iadr(l4)))
        nn5=stk(l3)
        lw5=lw
        lw=lw+nn5
        nn6=stk(l5)
        lw6=lw
        lw=lw+nn6
        lw7=lw
        lw=lw+nn6
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call ta2lpu(istk(iadr(l1)),istk(iadr(l2)),m1,istk(iadr(l4)),stk(
     & lw5),stk(lw6),stk(lw7))
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
        err=lw+4+nn5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (nn5.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=nn5
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(nn5,stk(lw5),1,stk(lw),1)
        lw=lw+nn5
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: la
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+nn6-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (nn6.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=nn6
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(nn6,stk(lw6),1,stk(lw),1)
        lw=lw+nn6
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 3) then
c     
c       output variable: ls
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+nn6-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (nn6.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=nn6
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(nn6,stk(lw7),1,stk(lw),1)
        lw=lw+nn6
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 38 
c SCILAB function : lp2tad
      subroutine intslp2tad
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
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
c       checking variable la (number 2)
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
c       checking variable ls (number 3)
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
c       checking variable n (number 4)
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
        if (m2 .ne. m3) then
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
        call entier(1,stk(l4),istk(iadr(l4)))
        lw5=lw
        lw=lw+m2
        lw6=lw
        lw=lw+m2
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call lp2tad(istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),istk(ia
     & dr(l4)),stk(lw5),stk(lw6))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: tail
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+m2-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (m2.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=m2
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(m2,stk(lw5),1,stk(lw),1)
        lw=lw+m2
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: head
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+m2-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (m2.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=m2
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(m2,stk(lw6),1,stk(lw),1)
        lw=lw+m2
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c
c fin = 39 
c SCILAB function : lp2tau
      subroutine intslp2tau
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        if (rhs .ne. 5) then
          call error(39)
          return
        endif
        if (lhs .gt. 2) then
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
c       checking variable la (number 2)
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
c       checking variable ls (number 3)
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
c       checking variable n (number 4)
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
c       checking variable ma (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 1) then
          err = 5
          call error(53)
          return
        endif
        if (istk(il5+1)*istk(il5+2) .ne. 1) then
          err = 5
          call error(89)
          return
        endif
        l5 = sadr(il5+4)
c     
c       cross variable size checking
c     
        if (m2 .ne. m3) then
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
        call entier(1,stk(l4),istk(iadr(l4)))
        nn5=stk(l5)
        lw5=lw
        lw=lw+nn5
        lw6=lw
        lw=lw+nn5
        err=lw-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
c
        call lp2tau(istk(iadr(l1)),istk(iadr(l2)),istk(iadr(l3)),istk(ia
     & dr(l4)),stk(lw5),stk(lw6))
        if (err .gt. 0) return
c
        top=top-rhs
        lw0=lw
        mv=lw0-l0
c     
        if(lhs .ge. 1) then
c     
c       output variable: tail
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+nn5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (nn5.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=nn5
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(nn5,stk(lw5),1,stk(lw),1)
        lw=lw+nn5
        lstk(top+1)=lw-mv
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: head
c     
        top=top+1
        ilw=iadr(lw)
        err=lw+4+nn5-lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
        endif
        istk(ilw)=1
        if (nn5.eq.0) then
          istk(ilw+1)=0
        else
          istk(ilw+1)=1
        endif
        istk(ilw+2)=nn5
        istk(ilw+3)=0
        lw=sadr(ilw+4)
        call int2db(nn5,stk(lw6),1,stk(lw),1)
        lw=lw+nn5
        lstk(top+1)=lw-mv
        endif
c     
c       putting in order the stack
c     
        call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
        return
      end
c

c  interface function 
c   ********************
       subroutine  metane
c
      include '../stack.h'
c
      integer iadr, sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
      goto (1,2,3,4,5,6,7,8,9,10,
     $  11,12,13,14,15,16,17,18,19,20,
     $  21,22,23,24,25,26,27,28,29,30,
     $  31,32,33,34,35,36,37,38,39) fin 
       return
1      call intsinimet
      return
2      call intsnetwindow
      return
3      call intsnetwindows
      return
4      call intsloadg
      return
5      call intssaveg
      return
6      call intsshowg
      return
7      call intsshowns
      return
8      call intsshowp
      return
9      call intsprevn2p
      return
10      call intsns2p
      return
11      call intsp2ns
      return
12      call intsedge2st
      return
13      call intsprevn2st
      return
14      call intscompc
      return
15      call intsconcom
      return
16      call intscompfc
      return
17      call intssconcom
      return
18      call intspcchna
      return
19      call intsford
      return
20      call intsjohns
      return
21      call intsdijkst
      return
22      call intsfrang
      return
23      call intschcm
      return
24      call intstransc
      return
25      call intsdfs
      return
26      call intsumtree
      return
27      call intsumtree1
      return
28      call intsdmtree
      return
29      call intstconex
      return
30      call intsflomax
      return
31      call intskilter
      return
32      call intsbusack
      return
33      call intsfloqua
      return
34      call intsrelax
      return
35      call intsfindiso
      return
36      call intsta2lpd
      return
37      call intsta2lpu
      return
38      call intslp2tad
      return
39      call intslp2tau
      return
       end
