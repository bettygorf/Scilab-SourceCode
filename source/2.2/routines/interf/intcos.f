      subroutine intcos
c
      include '../stack.h'
c
      integer iadr, sadr, id(nsiz)
      double precision simpar(3)
      integer pointi,pointf
      integer funnum
      external funnum
      integer start,run,finish,flag
      common /dbcos/ idb
      parameter (start=28,run=27,finish=15)

      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
      if (fin .eq. 1) then
c 
c SCILAB function : [state,t]=scicos(state,t0,tf,sim,flag [,simpar])
c --------------------------
        lw = lstk(top+1)
        l0 = lstk(top+1-rhs)
        idb=0
        if(ddt.ne.0) idb=1
        if (rhs .gt. 6 .or.rhs .lt. 5) then
          call error(39)
          return
        endif
        if (lhs .ne. 2) then
          call error(41)
          return
        endif
c       checking variable x (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .ne. 16) then
          err = 1
          call error(56)
          return
        endif
        n1=istk(il1+1)
        l1=sadr(il1+n1+3)
c      
c       --   subvariable x0(x) --
        il1e2=iadr(l1+istk(il1+3)-1)
        m1e2 =istk(il1e2+1)*istk(il1e2+2)
        l1e2 = sadr(il1e2+4)
        nst=m1e2
c      
c       --   subvariable tevts(x) --
        il1e3=iadr(l1+istk(il1+4)-1)
        m1e3 =istk(il1e3+1)*istk(il1e3+2)
        l1e3 = sadr(il1e3+4)
c      
c       --   subvariable evtspt(x) --
        il1e4=iadr(l1+istk(il1+5)-1)
        m1e4 =istk(il1e4+1)*istk(il1e4+2)
        l1e4 = sadr(il1e4+4)
c      
c       --   subvariable pointi(x) --
        il1e5=iadr(l1+istk(il1+6)-1)
        pointi=stk(sadr(il1e5+4))
c      
c       --   subvariable pointf(x) --
        il1e6=iadr(l1+istk(il1+7)-1)
        pointf=stk(sadr(il1e6+4))
c       checking variable t0 (number 2)
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
c       checking variable tf (number 3)
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
c       checking variable simu (number 4)
c       
        il4 = iadr(lstk(top-rhs+4))
        if (istk(il4) .ne. 16) then
          err = 4
          call error(56)
          return
        endif
        n4=istk(il4+1)
        l4=sadr(il4+n4+3)
c      
c       --   subvariable funptr(simu) --
        il4e2=iadr(l4+istk(il4+3)-1)
        if (istk(il4e2) .ne. 15) then
           err = 4
           call error(56)
           return
        endif
        nblk =istk(il4e2+1)
        l4e2 = sadr(il4e2+nblk+3)
c      
c       --   subvariable stptr(simu) --
        il4e3=iadr(l4+istk(il4+4)-1)
        m4e3 =istk(il4e3+1)*istk(il4e3+2)
        l4e3 = sadr(il4e3+4)
c      
c       --   subvariable inpptr(simu) --
        il4e4=iadr(l4+istk(il4+5)-1)
        m4e4 =istk(il4e4+1)*istk(il4e4+2)
        l4e4 = sadr(il4e4+4)
c      
c       --   subvariable outptr(simu) --
        il4e5=iadr(l4+istk(il4+6)-1)
        m4e5 =istk(il4e5+1)*istk(il4e5+2)
        l4e5 = sadr(il4e5+4)
c      
c       --   subvariable cmat(simu) --
        il4e6=iadr(l4+istk(il4+7)-1)
        m4e6 =istk(il4e6+1)*istk(il4e6+2)
        l4e6 = sadr(il4e6+4)
c      
c       --   subvariable rpar(simu) --
        il4e7=iadr(l4+istk(il4+8)-1)
        m4e7 =istk(il4e7+1)*istk(il4e7+2)
        l4e7 = sadr(il4e7+4)
        nrpar=m4e7
c      
c       --   subvariable rpptr(simu) --
        il4e8=iadr(l4+istk(il4+9)-1)
        m4e8 =istk(il4e8+1)*istk(il4e8+2)
        l4e8 = sadr(il4e8+4)
c      
c       --   subvariable ipar(simu) --
        il4e9=iadr(l4+istk(il4+10)-1)
        m4e9 =istk(il4e9+1)*istk(il4e9+2)
        l4e9 = sadr(il4e9+4)
        nipar=m4e9
c      
c       --   subvariable ipptr(simu) --
        il4e10=iadr(l4+istk(il4+11)-1)
        m4e10 =istk(il4e10+1)*istk(il4e10+2)
        l4e10 = sadr(il4e10+4)
c      
c       --   subvariable clkptr(simu) --
        il4e11=iadr(l4+istk(il4+12)-1)
        m4e11 =istk(il4e11+1)*istk(il4e11+2)
        l4e11 = sadr(il4e11+4)
c      
c       --   subvariable ordptr(simu) --
        il4e12=iadr(l4+istk(il4+13)-1)
        n4e12 = istk(il4e12+1)
        m4e12 = istk(il4e12+2)
        l4e12 = sadr(il4e12+4)
c      
c       --   subvariable execlk(simu) --
        il4e13=iadr(l4+istk(il4+14)-1)
        n4e13 = istk(il4e13+1)
        m4e13 = istk(il4e13+2)
        l4e13 = sadr(il4e13+4)
c      
c       --   subvariable ordclk(simu) --
        il4e14=iadr(l4+istk(il4+15)-1)
        m4e14 =istk(il4e14+1)*istk(il4e14+2)
        l4e14 = sadr(il4e14+4)
c      
c       --   subvariable cord(simu) --
        il4e15=iadr(l4+istk(il4+16)-1)
        m4e15 =istk(il4e15+1)*istk(il4e15+2)
        l4e15 = sadr(il4e15+4)
        ncord=m4e15
c      
c       --   subvariable iord(simu) --
        il4e16=iadr(l4+istk(il4+17)-1)
        m4e16 =istk(il4e16+1)*istk(il4e16+2)
        l4e16 = sadr(il4e16+4)
c      
c       --   subvariable ncblk(simu) --
        il4e17=iadr(l4+istk(il4+18)-1)
        l4e17 = sadr(il4e17+4)
        ncblk=stk(l4e17)
c      
c       --   subvariable nxblk(simu) --
        il4e18=iadr(l4+istk(il4+19)-1)
        l4e18 = sadr(il4e18+4)
        nxblk=stk(l4e18)
c      
c       --   subvariable ndblk(simu) --
        il4e19=iadr(l4+istk(il4+20)-1)
        l4e19 = sadr(il4e19+4)
        ndblk=stk(l4e19)
c      
c       --   subvariable ndcblk(simu) --
        il4e20=iadr(l4+istk(il4+21)-1)
        l4e20 = sadr(il4e20+4)
        ndcblk=stk(l4e20)
c      
c       --   subvariable oord(simu) --
        il4e21=iadr(l4+istk(il4+22)-1)
        l4e21 = sadr(il4e21+4)
        noord=istk(il4e21+1)*istk(il4e21+2)
c      
c       --   subvariable zord(simu) --
        il4e22=iadr(l4+istk(il4+23)-1)
        l4e22 = sadr(il4e22+4)
        nzord=istk(il4e22+1)*istk(il4e22+2)
c      
c       --   subvariable critev(simu) --
        il4e23=iadr(l4+istk(il4+24)-1)
        l4e23 = sadr(il4e23+4)
        ncrit=istk(il4e23+1)*istk(il4e23+2)

c       checking variable flag (number 5)
c       
        il5 = iadr(lstk(top-rhs+5))
        if (istk(il5) .ne. 10) then
          err = 5
          call error(55)
          return
        endif
        if (istk(il5+1)*istk(il5+2).ne.1) then
           err = 5 
           call error(89)
           return
        endif
        if(istk(il5+6).eq.start) then 
           flag=1
        elseif(istk(il5+6).eq.run) then 
           flag=2
        elseif(istk(il5+6).eq.finish) then 
           flag=3
        else
           err=6
           call error(44)
           return
        endif
        if(rhs.ge.6) then
c       checking variable simpar (number 6) [atol rtol ttol]
c       
           il6 = iadr(lstk(top-rhs+6))
           if (istk(il6) .ne. 1) then
              err = 6
              call error(53)
              return
           endif
           m6 = istk(il6+1)*istk(il6+2)
           l6 = sadr(il6+4)
        endif
c     
c       cross variable size checking
c     
        if (m1e3 .ne. m1e4) then
          call error(42)
          return
        endif
        if (m4e3 .ne. (2*m4e4-1)) then
          call error(42)
          return
        endif
        if (m4e3 .ne. (2*m4e5-1)) then
          call error(42)
          return
        endif
        if (m4e3 .ne. (2*m4e8-1)) then
          call error(42)
          return
        endif
        if (m4e3 .ne. (2*m4e10-1)) then
          call error(42)
          return
        endif
        if (m4e3 .ne. (2*m4e11-1)) then
          call error(42)
          return
        endif
        if (m4e12.ne.2.and.m4e12.ne.0) then
          call error(42)
          return
        endif
        if (m4e13.ne.2.and.m4e13.ne.0) then
          call error(42)
          return
        endif
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
        call entier(m1e4,stk(l1e4),istk(iadr(l1e4)))
        call entier(m4e4,stk(l4e4),istk(iadr(l4e4)))
        call entier(m4e5,stk(l4e5),istk(iadr(l4e5)))
        call entier(m4e3,stk(l4e3),istk(iadr(l4e3)))
        call entier(m4e11,stk(l4e11),istk(iadr(l4e11)))
        call entier(m4e6,stk(l4e6),istk(iadr(l4e6)))
        call entier(n4e12*m4e12,stk(l4e12),istk(iadr(l4e12)))
        call entier(n4e13*m4e13,stk(l4e13),istk(iadr(l4e13)))
        call entier(m4e14,stk(l4e14),istk(iadr(l4e14)))
        call entier(m4e15,stk(l4e15),istk(iadr(l4e15)))
        call entier(m4e16,stk(l4e16),istk(iadr(l4e16)))
        call entier(m4e8,stk(l4e8),istk(iadr(l4e8)))
        call entier(m4e9,stk(l4e9),istk(iadr(l4e9)))
        call entier(m4e10,stk(l4e10),istk(iadr(l4e10)))
c        call entier(nblk,stk(l4e2),istk(iadr(l4e2)))
        call entier(noord,stk(l4e21),istk(iadr(l4e21)))
        call entier(nzord,stk(l4e22),istk(iadr(l4e22)))
        call entier(ncrit,stk(l4e23),istk(iadr(l4e23)))

        if(rhs.eq.5) then
           simpar(1) = 1.d-4
           simpar(2) = 1.d-6
           simpar(3) = 1.d-10
        else
           call dcopy(3,stk(l6),1,simpar,1)
        endif


        lfunpt=iadr(lw)
        lw=sadr(lfunpt+nblk)

        ncinp = istk(iadr(l4e4) +ncblk ) - 1
        ninp = istk(iadr(l4e4) +nblk ) - 1
        ncout = istk(iadr(l4e5) +ncblk ) - 1
        nout = istk(iadr(l4e5) +nblk ) - 1
        ncst = istk(iadr(l4e3) +ncblk ) - 1

        ng = istk(iadr(l4e4) +nblk)-istk(iadr(l4e4) +ncblk+ndblk)
c        ng = istk(iadr(l4e11) + nblk ) - istk(iadr(l4e11)+ncblk+ndblk)

c     maximum block state and input sizes      
        maxst=0 
        maxinp=0
        ilst=iadr(l4e3)
        ilinp=iadr(l4e4)
        do 01 i=0,ncblk+ndblk-1
           maxst = max(maxst,max(istk(ilst+i+1)-istk(ilst+i),
     &          istk(ilst+nblk+i+1)-istk(nblk+ilst+i)))
           maxinp=max(maxinp,istk(ilinp+i+1)-istk(ilinp+i))
 01     continue
        nn32 = nst + nrpar + nout +  maxst + maxinp
     &       + 22 + ncst* max(16,ncst + 9) + 3*ng 
        lw32 = lw
        lw = lw + nn32
        nn33 = 8*(nblk+1) + ninp  + nipar + ncord + nzord + noord +
     &        20 + ncst + 2*ng

        ilw33 = iadr(lw )
        lw = sadr(ilw33 + nn33 )
        err = lw - lstk(bot )
        if (err .gt. 0) then
           call error(17 )
           return
        endif
c     
c     lock working area
        lstk(top+1)=lw
c     Set function table for blocks
        lf=l4e2
        do 10 i=1,nblk
           ilf=iadr(lf)
           if(istk(ilf).eq.11.or.istk(ilf).eq.13) then
C     Block is defined by a scilab function given in the structure
              istk(lfunpt-1+i)=-lf
           elseif(istk(ilf).eq.10) then
              buf=' '
              nn=istk(ilf+5)-1
              call cvstr(nn,istk(ilf+6),buf,1)
              buf(nn+1:nn+1)=char(0)
              ifun=funnum(buf(1:nn+1))
              if (ifun.gt.0) then
C     Block is defined by a C or Fortran procedure
                 istk(lfunpt-1+i)=ifun
              else
C     Block is defined by a predefined scilab function 
                 call namstr(id,istk(ilf+6),nn,0)
                 fin=0
                 call funs(id)
                 if (fun.eq.-1.or.fun.eq.-2) then 
                    istk(lfunpt-1+i)=-lstk(fin)
                 else
                    buf='unknown block :'//buf(1:nn)
                    call error(888)
                    return
                 endif
              endif
           else
              err=4
              call error(44)
              return
           endif
           lf=lf+istk(il4e2+2+i)-istk(il4e2+1+i)
 10     continue

        ilevt=iadr(l1e4)
        ilinp=iadr(l4e4)
        iloutp=iadr(l4e5)
        ilstpt=iadr(l4e3)
        ilclk=iadr(l4e11)
        ilcmat=iadr(l4e6)
        ilordp=iadr(l4e12)
        ilexec=iadr(l4e13)
        ilordc=iadr(l4e14)
        ilcord=iadr(l4e15)
        iliord=iadr(l4e16)
        ilrppt=iadr(l4e8)
        ilippt=iadr(l4e10)
        iloord=iadr(l4e21)
        ilzord=iadr(l4e22)
        ilcrit=iadr(l4e23)
        call scicos(stk(l1e2),stk(l2),stk(l3),stk(l1e3),istk(ilevt),
     &       m1e3,pointi,pointf,istk(ilinp),istk(iloutp),
     &       istk(ilstpt),istk(ilclk),istk(ilcmat),istk(ilordp),
     &       n4e12,istk(ilexec),istk(ilordc),istk(ilcord),
     &       m4e15,istk(iliord),m4e16,istk(iloord),noord,istk(ilzord),
     &       nzord,istk(ilcrit),stk(l4e7),istk(ilrppt),
     &       istk(iadr(l4e9)),istk(ilippt),istk(lfunpt),
     &       ncblk,nxblk,ndblk,ndcblk,simpar,stk(lw32),istk(ilw33),
     &       flag,ierr)
        if (ierr .gt. 0 ) then
           if(ierr.eq.1) then
              buf='scheduling problem'
           elseif(ierr.ge.100) then
              istate=-(ierr-100)
              write(buf,'(''integration problem istate='',i5)') istate
           elseif(ierr.eq.3) then
              buf='event conflict'
           elseif(ierr.eq.4) then
              buf='algrebraic loop detected'
           endif
           call error(888)
           return
        endif
        if (err .gt. 0) return
c
        top=top-rhs
c     
        if(lhs .ge. 1) then
c     
c       output variable: x0(x)
c     
           stk(sadr(il1e5+4))=pointi
           stk(sadr(il1e6+4))=pointf
           call int2db(m1e4,istk(iadr(l1e4)),-1,stk(l1e4),-1)
           top=top+1
        endif
c     
        if(lhs .ge. 2) then
c     
c       output variable: t
c     
        top=top+1
        endif
c     
        return
      endif
c
      if(fin.eq.2) then
      lw = lstk(top+1)
      ilw=iadr(lw)
      top=top-rhs+1
      itop=top
      ilv=iadr(lstk(top))
      lv=sadr(ilv+4)
      nb=istk(ilv+1)*istk(ilv+2)
      call entier(nb,stk(lv),istk(iadr(lv)))
      top=top+1
      iln=iadr(lstk(top))
      ln=sadr(iln+4)
      nnb=istk(iln+1)*istk(iln+2)
      call entier(nnb,stk(ln),istk(iadr(ln)))
      top=top+1
      ild=iadr(lstk(top))
      ld=sadr(ild+4)
      nnb=istk(ild+1)*istk(ild+2) 
      call entier(nnb,stk(ld),istk(iadr(ld)))
      top=top+1
      ilo=iadr(lstk(top))
      lo=sadr(ilo+4)
      nnb=istk(ilo+1)*istk(ilo+2) 
      call entier(nnb,stk(lo),istk(iadr(lo)))
      top=top+1
      ilc=iadr(lstk(top))
      lc=sadr(ilc+4)
      nnb=istk(ilc+1)*istk(ilc+2) 
      call entier(nnb,stk(lc),istk(iadr(lc)))
      ilord=ilw
      ilw=ilw+nb
        lw = sadr(ilw + nb)
        err = lw - lstk(bot )
        if (err .gt. 0) then
           call error(17 )
           return
        endif
      call sctree(nb,istk(iadr(lv)),istk(iadr(ln)),
     &       istk(iadr(ld)),istk(iadr(lo)),
     &       istk(iadr(lc)),istk(ilord),nord,iok,istk(ilw))
      top=itop
      istk(ilv+1)=nord
      istk(ilv+2)=1
      call int2db(nord,istk(ilord),1,stk(lv),1)
      lstk(top+1)=lv+nord
      top=top+1
      ilv1=iadr(lstk(top))
      istk(ilv1)=1
      istk(ilv1+1)=1  
      istk(ilv1+2)=1
      istk(ilv1+3)=0
      lv1=sadr(ilv1+4)
      stk(lv1)=dble(iok)
      lstk(top+1)=lv1+1
c      subroutine sctree(nb,vec,in,depu,outptr,cmat,ord,nord,ok,kk)
      endif
      end
