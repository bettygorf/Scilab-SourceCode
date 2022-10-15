      subroutine matelm
c ====================================================================
c
c     evaluate utility functions
c
c ====================================================================
c
      INCLUDE '../stack.h'
      double precision s,sr,si,t,x,x1,eps,epsr,epsa,t1
c
      integer id(nsiz)
      integer magi,frk,top2,hilb,tops
      double precision dsum,pythag,round,norm
      integer iadr,sadr
      integer sel,row,col
c
      data magi/22/,frk/15/
      data row/27/,col/12/,star/47/
      data hilb/17/

c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1

c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matelm '//buf(1:4))
      endif
c
c     functions/fin
c     abs  real imag conj roun int  size sum  prod diag triu tril
c      1    2    3    4    5    6    7    8    9    10   11   12
c     eye  rand ones maxi mini sort kron matr sin  cos  atan exp
c      13   14   15   16   17   18  19-21 22   23   24   25   26
c     sqrt log   ^  sign clean floor ceil expm cumsum  cumprod 
c      27   28   29  30   31     32   33   34    35      36
c     var2vec  vec2var get_import set_import
c      37        38       39         40
c!
      if(rstk(pt).eq.905) goto 310
c
      tops=top
      if(top-rhs+lhs+1.ge.bot) then
         call error(18)
         return
      endif
      if(rhs.lt.0) then
         call error(39)
         return
      endif
c
      if(rhs.eq.0) goto 05
      il=iadr(lstk(top))
      if(istk(il).gt.10) goto 05
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)

      if(istk(il).eq.5) then
         mn=istk(il+4)
         l=sadr(il+5+m+mn)
      elseif(istk(il).eq.1) then
         l=sadr(il+4)
         mn=m*n
      elseif(istk(il).eq.2) then
         l=sadr(il+9+m*n)
         mn=istk(il+8+m*n)-1
         id1=il+8
      endif

      lw=lstk(top+1)
c
   05 goto (10 ,15 ,20 ,25 ,30 ,35 ,40 ,45 ,50 ,60,
     1      60 ,60 ,70 ,71 ,70 ,90 ,90 ,105,110,110,
     2      110,130,140,150,160,170,180,190,200,210,
     3      220,37 ,39 ,173,46 ,47),fin
c
c    abs
c
 10   if (lhs .ne. 1) then
         call error(41)
         return
      endif
      l1=l-1
      if(it.eq.1) goto 12
      do 11 i=1,mn
   11 stk(l1+i)=abs(stk(l1+i))
      goto 999
   12 continue
      k1=l1+mn
      do 13 i=1,mn
   13 stk(l1+i)=pythag(stk(l1+i),stk(k1+i))
      istk(il+3)=0
      lstk(top+1)=l+mn
      goto 999
c
c real
   15 continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1.and.istk(il).ne.2) then
         call cvname(id,'g_real        ',0)
         goto 300
      endif
      istk(il+3)=0
      if(istk(il).eq.1) then
         lstk(top+1)=l+mn
      else
         ilw=iadr(l+mn)
         call dmpcle(stk(l),istk(id1),m,n,istk(ilw),0.0d0,0.0d0)
         lstk(top+1)=l+istk(id1+m*n)
      endif
      goto 999
c
c imag
   20 continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1.and.istk(il).ne.2) then
         call cvname(id,'g_imag        ',0)
         goto 300
      endif

      istk(il+3)=0
      if(istk(il).eq.1) then
         if(it.eq.1) then
            call dcopy(mn,stk(l+mn),1,stk(l),1)
         else
            call dset(mn,0.0d+0,stk(l),1)
         endif
         lstk(top+1)=l+mn
      else
         if(it.eq.1) then
            call dcopy(mn,stk(l+mn),1,stk(l),1)
            ilw=iadr(l+mn)
            call dmpcle(stk(l),istk(id1),m,n,istk(ilw),0.0d0,0.0d0)
         else
            call dset(m*n,0.0d+0,stk(l),1)
            do 21 i=1,m*n+1
               istk(id1-1+i)=i
 21         continue
         endif
         lstk(top+1)=l+istk(id1+m*n)
      endif
      goto 999
c
c conjg
   25 continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1.and.istk(il).ne.2) then
         call cvname(id,'g_conj       ',0)
         goto 300
      endif
      if(it.eq.1) call dscal(mn,-1.0d+0,stk(l+mn),1)
      goto 999
c
c round
   30 continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1.and.istk(il).ne.2) then
         call cvname(id,'g_round       ',0)
         goto 300
      endif
      if(it.eq.1) mn=2*mn
      do 31 i=1,mn
       i1=i-1
       stk(l+i1)=round(stk(l+i1))
   31 continue
      goto 999
c
c     int
   35 continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1.and.istk(il).ne.2) then
         call cvname(id,'g_int         ',0)
         goto 300
      endif
      if(it.eq.1) mn=2*mn
      do 36 i=1,mn
       i1=i-1
       stk(l+i1)=aint(stk(l+i1))
   36 continue
      goto 999
c
c     floor
   37 continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1.and.istk(il).ne.2) then
         call cvname(id,'g_floor       ',0)
         goto 300
      endif
      if(it.eq.1) mn=2*mn
      do 38 i=1,mn
        i1=i-1
        t=stk(l+i1)
        t1=round(t-0.5d0)
        if(t.gt.0.d0.and.((t-t1).eq.1.0d0)) t1=t
        stk(l+i1)=t1
   38 continue
      goto 999
c
c     ceil
   39 continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1.and.istk(il).ne.2) then
         call cvname(id,'g_ceil       ',0)
         goto 300
      endif
      if(it.eq.1) mn=2*mn
      do 32 i=1,mn
       i1=i-1
        t=stk(l+i1)
        t1=round(t+0.5d0)
        if(t.lt.0.d0.and.((t1-t).eq.1.0d0)) t1=t
        stk(l+i1)=t1
   32 continue
      goto 999
c
c     size
      
 40   if(rhs.gt.2) then
         call error(42)
         return
      endif
      sel=-1
      if(rhs.eq.2) then
         if(lhs.ne.1) then
            call error(41)
            return
         endif
c     row or column size
         il=iadr(lstk(top))
         if(istk(il).eq.1) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            sel=stk(sadr(il+4))
            if(sel.ne.1.and.sel.ne.2) then
               err=2
               call error(44)
               return
            endif
         elseif (istk(il).eq.10) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            if(istk(il+6).eq.row) then
               sel=1
            elseif(istk(il+6).eq.col) then
               sel=2
            elseif(istk(il+6).eq.star) then
               sel=3
            else
               err=2
               call error(44)
               return
            endif
         else
            err=2
            call error(44)
            return
         endif
         top=top-1
      endif
      il=iadr(lstk(top))
      if(istk(il).gt.10) then
 1       if(istk(il).ne.15.and.istk(il).ne.16) then
            err=1
            call error(56)
            return
         endif
         ll=sadr(il+istk(il+1)+3)
         ilt=iadr(ll)
         if(istk(ilt).eq.10) then
            mnt=istk(ilt+1)*istk(ilt+2)
            if((istk(ilt+5).eq.2.and.istk(ilt+5+mnt).eq.27).or.
     +           (istk(ilt+5).eq.4.and.
     +           (istk(ilt+5+mnt).eq.21.and.istk(ilt+6+mnt).eq.28.and.
     +           istk(ilt+7+mnt).eq.28))) then
c     size of  'lss' or 'r' typed list
               top=tops
               call cvname(id,'g_size   ',0)
               goto 300
            endif
         endif
C     size of standard list
         if(lhs*rhs.ne.1) then
            err=1
            call error(39)
            return
         endif
         istk(il)=1
         n=istk(il+1)
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         l=sadr(il+4)
         stk(l)=dble(n)
         lstk(top+1)=l+1
         goto 999
      endif
c     matrix type variable type
      if(lhs.gt.2) then
         call error(41)
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      l=sadr(il+4)
      if(err.gt.0) return
      if(lhs.eq.1) then
         istk(il)=1
         istk(il+1)=1
         if(sel.eq.-1) then
            istk(il+2)=2
            istk(il+3)=0
            stk(l) = m
            stk(l+1) = n
            lstk(top+1)=l+2
         elseif(sel.eq.1) then
            istk(il+2)=1
            istk(il+3)=0
            stk(l) = m
            lstk(top+1)=l+1
         elseif(sel.eq.2) then
            istk(il+2)=1
            istk(il+3)=0
            stk(l) = n
            lstk(top+1)=l+1
         elseif(sel.eq.3) then
            istk(il+2)=1
            istk(il+3)=0
            stk(l) = m*n
            lstk(top+1)=l+1
         endif
      else
         istk(il)=1
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         stk(l) = m
         lstk(top+1)=l+1
         top = top + 1
         il=iadr(l+1)
         l=sadr(il+4)
         err=l+1-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         istk(il)=1
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         stk(l) = n
         lstk(top+1)=l+1
      endif
      goto 999
c
c     sum
 45   continue
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      sel=0
      if(rhs.eq.2) then
         top=top-1
         if(lhs.ne.1) then
            call error(41)
            return
         endif
c     row or column op
         il=iadr(lstk(top+1))
         if(istk(il).eq.1) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            sel=stk(sadr(il+4))
            if(sel.ne.1.and.sel.ne.2) then
               err=2
               call error(44)
               return
            endif
         elseif (istk(il).eq.10) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            if(istk(il+6).eq.row) then
               sel=1
            elseif(istk(il+6).eq.col) then
               sel=2
            elseif(istk(il+6).eq.star) then
               sel=0
            else
               err=2
               call error(44)
               return
            endif
         else
            err=2
            call error(44)
            return
         endif
      endif
      il0=iadr(lstk(top))
      if(istk(il0).ne.1.and.istk(il0).ne.5) then
         if(sel.eq.0) goto 900
         if(sel.eq.1.or.sel.eq.2) then
         top=top+1
         call cvname(id,'po_sum        ',0)
         goto 300
         endif
      endif
      if(istk(il0).eq.5) then
         it=istk(il0+3)
         mn=istk(il0+4)
         l=sadr(il0+5+m+mn)
         if(sel.eq.0) then
         istk(il0)=1
         istk(il0+1)=1
         istk(il0+2)=1
         istk(il0+3)=it
         l1=sadr(il0+4)
         stk(l1)=dsum(mn,stk(l),1)
         if(it.eq.1) stk(l1+1)=dsum(mn,stk(l+mn),1)
         lstk(top+1)=l1+(it+1)
         elseif(sel.eq.1.or.sel.eq.2) then
         top=top+1
         call cvname(id,'sp_sum        ',0)
         goto 300
         endif
      endif
      m=istk(il0+1)
      n=istk(il0+2)
      it=istk(il0+3)
      mn=m*n
      if(sel.eq.0) then
c     op(a) <=> op(a,'*')
         istk(il0)=1
         istk(il0+1)=1
         istk(il0+2)=1
         istk(il0+3)=it
         l1=sadr(il0+4)
         stk(l1)=dsum(mn,stk(l1),1)
         if(it.eq.1) stk(l1+1)=dsum(mn,stk(l1+mn),1)
         lstk(top+1)=l1+(it+1)
      elseif(sel.eq.1) then
c     op(a,'r')  <=>  op(a,1)
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=1
         istk(il0+3)=it
         l1=sadr(il0+4)
         do 450 k=0,m-1
         stk(l1+k)=dsum(n,stk(l1+k),m)
 450     continue
         if(it.eq.1) then
            do 451 k=0,n-1
            stk(l1+m+k)=dsum(n,stk(l1+mn+k),m)
 451        continue
         endif
         lstk(top+1)=l1+m*(it+1)
      elseif(sel.eq.2) then
c     op(a,'c')   <=>  op(a,2)
         istk(il0)=1
         istk(il0+1)=1
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         do 452 k=0,n-1
            stk(l1+k)=dsum(m,stk(l1+k*m),1)
 452     continue
         if(it.eq.1) then
            do 453 k=0,n-1
            stk(l1+n+k)=dsum(m,stk(l1+mn+k*m),1)
 453        continue
         endif
         lstk(top+1)=l1+n*(it+1)
      endif
      go to 999
c
c     cumsum
 46   continue
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      sel=0
      if(rhs.eq.2) then
         top=top-1
         if(lhs.ne.1) then
            call error(41)
            return
         endif
c     row or column op
         il=iadr(lstk(top+1))
         if(istk(il).eq.1) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            sel=stk(sadr(il+4))
            if(sel.ne.1.and.sel.ne.2) then
               err=2
               call error(44)
               return
            endif
         elseif (istk(il).eq.10) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            if(istk(il+6).eq.row) then
               sel=1
            elseif(istk(il+6).eq.col) then
               sel=2
            elseif(istk(il+6).eq.star) then
               sel=0
            else
               err=2
               call error(44)
               return
            endif
         else
            err=2
            call error(44)
            return
         endif
      endif
      il0=iadr(lstk(top))
      if(istk(il0).ne.1.and.istk(il0).ne.5) goto 900
      if(istk(il0).eq.5) then
         buf='sparse: op not yet implemented' 
         call error(9999)
         return
      endif
      m=istk(il0+1)
      n=istk(il0+2)
      it=istk(il0+3)
      mn=m*n
      if(sel.eq.0) then
c     op(a) <=> op(a,'*')
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         call cusum(mn,stk(l1))
         if(it.eq.1) call cusum(mn,stk(l1+mn))
         lstk(top+1)=l1+mn*(it+1)
      elseif(sel.eq.1) then
c     op(a,'r')  <=>  op(a,1)
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         do 460 k=0,n-1
         call cusum(m,stk(l1+k*m))
 460     continue
         if(it.eq.1) then
            do 461 k=0,n-1
	    call cusum(m,stk(l1+k*m+mn))
 461        continue
         endif
         lstk(top+1)=l1+mn*(it+1)
      elseif(sel.eq.2) then
c     op(a,'c')   <=>  op(a,2)
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         kk=0
         do 462 k=1,n-1
	    call dadd(m,stk(l1+kk),1,stk(l1+kk+m),1)
            kk=kk+m
 462     continue
         if(it.eq.1) then
            kk=0
            do 463 k=1,n-1
	    call dadd(m,stk(l1+mn+kk),1,stk(l1+kk+m+mn),1)
            kk=kk+m
 463        continue
         endif
         lstk(top+1)=l1+mn*(it+1)
      endif
      go to 999
c
c     cumprod
 47   continue
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      sel=0
      if(rhs.eq.2) then
         top=top-1
         if(lhs.ne.1) then
            call error(41)
            return
         endif
c     row or column op
         il=iadr(lstk(top+1))
         if(istk(il).eq.1) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            sel=stk(sadr(il+4))
            if(sel.ne.1.and.sel.ne.2) then
               err=2
               call error(44)
               return
            endif
         elseif (istk(il).eq.10) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            if(istk(il+6).eq.row) then
               sel=1
            elseif(istk(il+6).eq.col) then
               sel=2
            elseif(istk(il+6).eq.star) then
               sel=0
            else
               err=2
               call error(44)
               return
            endif
         else
            err=2
            call error(44)
            return
         endif
      endif
      il0=iadr(lstk(top))
      if(istk(il0).ne.1.and.istk(il0).ne.5) goto 900
      if(istk(il0).eq.5) then
         buf='sparse: op not yet implemented' 
         call error(9999)
         return
      endif
      m=istk(il0+1)
      n=istk(il0+2)
      it=istk(il0+3)
      mn=m*n
      if(sel.eq.0) then
c     op(a) <=> op(a,'*')
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         call cupro(mn,stk(l1))
         if(it.eq.1) call cupro(mn,stk(l1+mn))
         lstk(top+1)=l1+mn*(it+1)
      elseif(sel.eq.1) then
c     op(a,'r')  <=>  op(a,1)
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         if(it.eq.0) then
         do 470 k=0,n-1
         call cupro(m,stk(l1+k*m))
 470     continue
         elseif(it.eq.1) then
            do 471 k=0,n-1
	    call cuproi(m,stk(l1+k*m),stk(l1+k*m+mn))
 471        continue
         endif
         lstk(top+1)=l1+mn*(it+1)
      elseif(sel.eq.2) then
c     op(a,'c')   <=>  op(a,2)
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         if(it.eq.0) then
         kk=0
         do 472 k=1,n-1
	    call dvmul(m,stk(l1+kk),1,stk(l1+kk+m),1)
            kk=kk+m
 472     continue
         elseif(it.eq.1) then
            kk=0
            do 473 k=1,n-1
	    call wvmul(m,stk(l1+kk),stk(l1+mn+kk),1,
     $                  stk(l1+kk+m),stk(l1+kk+m+mn),1)
            kk=kk+m
 473        continue
         endif
         lstk(top+1)=l1+mn*(it+1)
      endif
      go to 999
c     prod
 50   continue
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      sel=0
      if(rhs.eq.2) then
         top=top-1
         if(lhs.ne.1) then
            call error(41)
            return
         endif
c     row or column op
         il=iadr(lstk(top+1))
         if(istk(il).eq.1) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            sel=stk(sadr(il+4))
            if(sel.ne.1.and.sel.ne.2) then
               err=2
               call error(44)
               return
            endif
         elseif (istk(il).eq.10) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            if(istk(il+6).eq.row) then
               sel=1
            elseif(istk(il+6).eq.col) then
               sel=2
            elseif(istk(il+6).eq.star) then
               sel=0
            else
               err=2
               call error(44)
               return
            endif
         else
            err=2
            call error(44)
            return
         endif
      endif
      il0=iadr(lstk(top))
      if(istk(il0).ne.1.and.istk(il0).ne.5) goto 900
      if(istk(il0).eq.5) then
         it=istk(il0+3)
         if(it.eq.1) then
            buf='op. not implemented'
            call error(9999)
         return
         endif
         mn=istk(il0+4)
         l=sadr(il0+5+m+mn)
         if(sel.eq.0) then
         istk(il0)=1
         istk(il0+1)=1
         istk(il0+2)=1
         istk(il0+3)=it
         l1=sadr(il0+4)
         call dvmul(mn-1,stk(l+1),1,stk(l),0)
         stk(l1)=stk(l)
         elseif(sel.eq.1.or.sel.eq.2) then
         buf='sparse: op with 2 args not yet implemented' 
         call error(9999)
         return
         endif
      endif
      m=istk(il0+1)
      n=istk(il0+2)
      it=istk(il0+3)
      mn=m*n
      if(sel.eq.0) then
c     op(a) <=> op(a,'*')
         istk(il0)=1
         istk(il0+1)=1
         istk(il0+2)=1
         istk(il0+3)=it
         l1=sadr(il0+4)
         if(it.eq.0) then
         call dvmul(mn-1,stk(l1+1),1,stk(l1),0)
         elseif(it.eq.1) then
         call wvmul(mn-1,stk(l1+1),stk(l1+mn+1),1,stk(l1),stk(l1+mn),0)
         stk(l1+1)=stk(l1+mn)
         endif
         lstk(top+1)=l1+(it+1)
      elseif(sel.eq.1) then
c     op(a,'r')  <=>  op(a,1)
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=1
         istk(il0+3)=it
         l1=sadr(il0+4)
         if(it.eq.0) then
         do 550 k=0,m-1
         call dvmul(n-1,stk(l1+k+m),m,stk(l1+k),0)
 550     continue
         elseif(it.eq.1) then
            do 551 k=0,m-1
         call wvmul(n-1,stk(l1+k+m),stk(l1+k+m+mn),m,stk(l1+k),
     $             stk(l1+k+mn),0)
 551        continue
         call dcopy(m,stk(l1+mn),1,stk(l1+m),1)
         endif
         lstk(top+1)=l1+m*(it+1)
      elseif(sel.eq.2) then
c     op(a,'c')   <=>  op(a,2)
         istk(il0)=1
         istk(il0+1)=1
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         if(it.eq.0) then
         do 552 k=0,n-1
            call dvmul(m-1,stk(l1+k*m+1),1,stk(l1+k*m),0)
 552     continue
         call dcopy(n,stk(l1),m,stk(l1),1)
         elseif(it.eq.1) then
            do 553 k=0,n-1
             call wvmul(m-1,stk(l1+k*m+1),stk(l1+k*m+mn+1),
     $                 1,stk(l1+k*m),stk(l1+k*m+mn),0)
 553        continue
         call dcopy(n-1,stk(l1+m),m,stk(l1+1),1)
         call dcopy(n,stk(l1+mn),m,stk(l1+n),1)
         endif
         lstk(top+1)=l1+n*(it+1)
      endif
      go to 999
c     diag, triu, tril
   60 continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      k = 0
      il=iadr(lstk(top+1-rhs))
      if(istk(il).ne.1) then
         if(istk(il).eq.2) then
c           *call* polelm
            fun=16
            return
         else
            if(fin.eq.10) then
               call cvname(id,'g_diag        ',0)
            elseif(fin.eq.11) then
               call cvname(id,'g_triu        ',0)
            else
               call cvname(id,'g_tril        ',0)
            endif
            goto 300
         endif
      endif
      if (rhs .ne. 2) go to 61
      il=iadr(lstk(top-1))
      k = int(stk(l))
      top = top-1
      m=istk(il+1)
      n=istk(il+2)
      mn=m*n
      it=istk(il+3)
      l=sadr(il+4)
   61 if (fin .ge. 11) go to 64
      if (m .eq. 1 .or. n .eq. 1) go to 63
c     diag(a,k)
      if (k.ge.0) mn=max(0,min(m,n-k))
      if (k.lt.0) mn=max(0,min(m+k,n))
      if(mn.eq.0) then
         istk(il+1)=0
         istk(il+2)=0
         istk(il+3)=0
         lstk(top+1)=sadr(il+4)+1
         goto 999
      endif
      istk(il+1)=mn
      istk(il+2)=1
      istk(il+3)=it
      lstk(top+1)=l+istk(il+1)*(it+1)
      if(k.ge.0) call dcopy(mn,stk(l+k*m),m+1,stk(l),1)
      if(k.lt.0) call dcopy(mn,stk(l-k),m+1,stk(l),1)
      if(it.eq.0) goto 999
      if(k.ge.0) call dcopy(mn,stk(l+m*n+k*m),m+1,stk(l+mn),1)
      if(k.lt.0) call dcopy(mn,stk(l+m*n-k),m+1,stk(l+mn),1)
      go to 999
c     diag(vecteur,k)
   63 nn = max(m,n)+abs(k)
      l1=l+nn*nn*(it+1)
      err = l1 + mn*(it+1) -  lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      istk(il+1)=nn
      istk(il+2)=nn
      lstk(top+1)=l+nn*nn*(it+1)
      call dcopy(mn*(it+1),stk(l),-1,stk(l1),-1)
      call dset(nn*nn*(it+1),0.0d+0,stk(l),1)
      if(k.ge.0) call dcopy(mn,stk(l1),1,stk(l+nn*k),nn+1)
      if(k.lt.0) call dcopy(mn,stk(l1),1,stk(l-k),nn+1)
      if(it.eq.0) goto 999
      if(k.ge.0) call dcopy(mn,stk(l1+mn),1,stk(l+nn*nn+k*nn),nn+1)
      if(k.lt.0) call dcopy(mn,stk(l1+mn),1,stk(l+nn*nn-k),nn+1)
      go to 999
c
c     tril, triu
   64 if(fin.eq.12) goto 67
      if(k.le.0) goto 65
      call dset(m*k,0.0d+0,stk(l),1)
      if(it.eq.1) call dset(m*k,0.0d+0,stk(l+mn),1)
      l=l+m*k
      n=n-k
      k=0
   65 ls=l+1-k
      ll=m-1+k
      do 66 j=1,n
      if(ll.le.0) goto 999
      call dset(ll,0.0d+0,stk(ls),1)
      if(it.eq.1) call dset(ll,0.0d+0,stk(ls+mn),1)
      ll=ll-1
      ls=ls+m+1
   66 continue
      goto 999
   67 if(k.lt.0) goto 68
      l=l+m*(k+1)
      n=n-k-1
      k=-1
   68 ls=l
      ll=-k
      do 69 j=1,n
      if(ll.gt.m) ll=m
      call dset(ll,0.0d+0,stk(ls),1)
      if(it.eq.1) call dset(ll,0.0d+0,stk(ls+mn),1)
      ls=ls+m
      ll=ll+1
   69 continue
      go to 999
c     ---------------------
c     eye, ones
c     ---------------------
 70   continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(rhs.gt.2) then
         call error(39)
         return
      endif
      if(rhs.eq.0) then
c     sans argument
         top=top+1
         il=iadr(lstk(top))
         istk(il)=1
         m=1
         n=1
         if(fin.eq.13) then
            m=-1
            n=-1
         endif
      elseif(rhs.eq.1) then
         if(istk(il).gt.10) then
            if(fin.eq.15) then
               call cvname(id,'g_ones   ',0)
            elseif(fin.eq.13) then
               call cvname(id,'g_eye   ',0)
            endif
            goto 300
         endif
c     eye(matrice),ones(matrice)
      elseif(rhs.eq.2) then
c     eye(m,n),ones(m,n)
         if(istk(il).ne.1) then
            err=1
            call  error(53)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call  error(52)
            return
         endif
         if(m*n.ne.1) then
            err=1
            call error(89)
            return
         endif
         n=max(int(stk(l)),0)
         top=top-1
         il=iadr(lstk(top))
         if(istk(il).ne.1) then
            err=1
            call  error(53)
            return
         endif
         if(istk(il+3).ne.0) then
            err=1
            call  error(52)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         l=sadr(il+4)
         m=max(int(stk(l)),0)
      endif
c
   72 mn=m*n
      if(m.eq.0) n=0
      if(n.eq.0) m=0
      l=sadr(il+4)

c     to avoid integer overflow
      s=l+dble(m)*dble(n)- lstk(bot)
      if(s.gt.0.0d0) then
         err=s
         call error(17)
         return
      endif
      istk(il)=1
      istk(il+1)=m
      istk(il+2)=n
      istk(il+3)=0
      lstk(top+1)=l+mn
      if(mn.eq.0) goto 999
      if ( fin.eq.13 ) then 
c     eye
         m=abs(m)
         call dset(mn,0.0d+0,stk(l),1)
         call dset(min(m,abs(n)),1.0d+0,stk(l),m+1)
      else
c     ones
         call dset(mn,1.0d+0,stk(l),1)
      endif
      goto 999
C
C     rand 
C     
 71   call  intrand('rand',icont)
      if (icont.eq.300) goto 300
      goto 999
c
c maxi mini
c
   90 continue
      if (lhs .gt. 2) then
         call error(41)
         return
      endif
      if(istk(il).eq.15) goto 100
      if(istk(il).eq.5) then
         fin=fin-6
         call spelm
         if(err.gt.0) return
         goto 999
      endif
      if(istk(il).ne.1) then
         if(fin.eq.16) then
            call cvname(id,'g_maxi    ',0)
         else
            call cvname(id,'g_mini    ',0)
         endif
         goto 300
      endif
      if(rhs.gt.1) goto 96
      if(rhs.ne.1) then
         call error(39)
         return
      endif
      if(mn.le.0) then
         err=1
         call error(45)
         return
      endif
c     maxi mini d'un vecteur
      if(istk(il).ne.1) then
         err=1
         call error(53)
         return
      endif
      if(it.ne.0) then
         err=1
         call error(52)
         return
      endif
      k=l
      l1=l
      x1=stk(k)
      if(fin.eq.17) goto 92
c maxi
      do 91 i=2,mn
        l1=l1+1
        if(stk(l1).le.x1) goto 91
        k=l1
        x1=stk(k)
   91 continue
      goto 94
c mini
   92 continue
      do 93 i=2,mn
        l1=l1+1
        if(stk(l1).ge.x1) goto 93
        k=l1
        x1=stk(k)
   93 continue
      goto 94
c
   94 continue
      stk(l)=x1
      istk(il+1)=1
      istk(il+2)=1
      lstk(top+1)=l+1
      if(lhs.eq.1) goto 999
      k=k-l+1
      top=top+1
      il=iadr(lstk(top))
      l=sadr(il+4)
      err=l+2-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=1
      istk(il+3)=0
      stk(l)=dble(k)
      lstk(top+1)=l+1
      if(m.eq.1.or.n.eq.1) goto 999
      kc=k/m
      kl=k-kc*m
      if(kl.ne.0) goto 95
      kc=kc-1
      kl=m
   95 istk(il+2)=2
      stk(l)=dble(kl)
      stk(l+1)=dble(kc+1)
      lstk(top+1)=l+2
      goto 999
c
 96   continue
      ilw=iadr(lstk(top+1))
      err=sadr(ilw+mn)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(ilw-1+rhs)=sadr(il+4)-1
c     maxi mini a plusieur argument
      do 97 i=rhs-1,1,-1
       ili=iadr(lstk(top-rhs+i))
       if(istk(ili).ne.1) then
          err=i
          call error(53)
          return
       endif
       if(istk(ili+3).ne.0) then
          err=i
          call error(52)
          return
       endif
       if(istk(ili+1).ne.m.or.istk(ili+2).ne.n) then
          err=i
          call error(42)
          return
       endif
       istk(ilw-1+i)=sadr(ili+4)-1
 97   continue
      x=-1.0d+0
      if(fin.eq.17) x=1.0d+0
      do 99 i=1,mn
        li=istk(ilw)+i
        ji=1
        do 98 j=2,rhs
           if(x*(stk(li)-stk(istk(ilw-1+j)+i)).gt.0) then
                 stk(li)=stk(istk(ilw-1+j)+i)
                 ji=j
           endif
 98     continue
        stk(istk(ilw+1)+i)=real(ji)
 99    continue
       top=top-rhs+lhs
       goto 999
c
 100  continue
c     maxi mini des vecteurs d'une liste
      ne=istk(il+1)
      if(ne.eq.1) then
         err=1
         call error(42)
         return
      endif
      ilw=il+2
      ld=sadr(il+3+ne)
      n1=istk(il+3)-1
      n2=istk(il+4)-istk(il+3)
      do 101 i=1,ne
       ili=iadr(ld+istk(il+1+i)-1)
       if(istk(ili).ne.1) then
           err=i
           call error(53)
           return
       endif
       if(istk(ili+3).ne.0) then
          err=i
          call error(52)
          return
       endif
       if(i.eq.1) then
          m=istk(ili+1)
          n=istk(ili+2)
                  else
          if(istk(ili+1).ne.m.or.istk(ili+2).ne.n) then
             call error(42)
             return
          endif
       endif
      istk(ilw-1+i)=sadr(ili+4)-1
 101  continue
      mn=m*n
      x=-1.0d+0
      if(fin.eq.17) x=1.0d+0
      do 103 i=1,mn
        li=istk(ilw)+i
        ji=1
        do 102 j=2,ne
           if(x*(stk(li)-stk(istk(ilw-1+j)+i)).gt.0) then
              stk(li)=stk(istk(ilw-1+j)+i)
              ji=j
           endif
 102    continue
        stk(istk(ilw+1)+i)=real(ji)
 103  continue
      call dcopy(n1+n2 ,stk(ld),1,stk(lstk(top)),1)
      lstk(top+1)=lstk(top)+n1
      if(lhs.eq.2) then
         top=top+1
         lstk(top+1)=lstk(top)+n2
      endif
      goto 999
c
c sort
 105  continue
      if(rhs.gt.2) then
         call error(42)
         return
      endif
      il=iadr(lstk(top+1-rhs))
      if(istk(il).eq.10) then
c     *call* strelm
         fun=21
         fin=8
         return
      endif
      sel=0
      if(rhs.eq.2) then
         top=top-1
         if(lhs.ge.3) then
            call error(41)
            return
         endif
c     row or column op
         il=iadr(lstk(top+1))
         if(istk(il).eq.1) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            sel=stk(sadr(il+4))
            if(sel.ne.1.and.sel.ne.2) then
               err=2
               call error(44)
               return
            endif
         elseif (istk(il).eq.10) then
            if(istk(il+1)*istk(il+2).ne.1) then
               err=2
               call error(89)
               return
            endif
            if(istk(il+6).eq.row) then
               sel=1
            elseif(istk(il+6).eq.col) then
               sel=2
            elseif(istk(il+6).eq.star) then
               sel=0
            else
               err=2
               call error(44)
               return
            endif
         else
            err=2
            call error(44)
            return
         endif
      endif
      il0=iadr(lstk(top))
      if(istk(il0).ne.1.and.istk(il0).ne.5) goto 900
      if(istk(il0).eq.5) then
         if(rhs.eq.2)   top=top+1
         call cvname(id,'g_sort         ',0)
         goto 300
      endif
      m=istk(il0+1)
      n=istk(il0+2)
      it=istk(il0+3)
      mn=m*n
c
      lw=iadr(lstk(top+1))
c     
      if(mn.eq.0) then
         if(lhs.eq.1) goto 999
         top=top+1
         il=iadr(lstk(top))
         istk(il)=1
         istk(il+1)=0
         istk(il+2)=0
         istk(il+3)=0
         lstk(top+1)=sadr(il+4)
         goto 999
      endif
c
      err=sadr(lw+mn)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c
      if(sel.eq.0) then
c     sort(a) <=> sort(a,'*')
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         call dsort(stk(l1),mn,istk(lw))
         lstk(top+1)=l1+mn*(it+1)
c              cccccccccccc
         if(lhs.eq.1) goto 999
         top=top+1
         il=lw
         l1=sadr(il+4)+mn
         l2=lw+mn
         err=l1-lstk(bot)
         if(err.gt.0) then
            call error(17)
         return
         endif
         lstk(top+1)=l1
         do 106 i=1,mn
           stk(l1-i)=dble(istk(l2-i))
  106    continue
         istk(il)=1
         istk(il+1)=m
         istk(il+2)=n
         istk(il+3)=0
c                cccccccccc
      elseif(sel.eq.1) then
c     sort(a,'r')  <=>  sort(a,1)
         istk(il0)=1
         istk(il0+1)=m
         istk(il0+2)=n
         istk(il0+3)=it
         l1=sadr(il0+4)
         lw1=lw
         do 107 k=0,n-1
         call dsort(stk(l1+k*m),m,istk(lw1))
         lw1=lw1+m
 107     continue
         lstk(top+1)=l1+mn*(it+1)
c              cccccccccccc
         if(lhs.eq.1) goto 999
         top=top+1
         il=lw
         l1=sadr(il+4)+mn
         l2=lw+mn
         err=l1-lstk(bot)
         if(err.gt.0) then
            call error(17)
         return
         endif
         lstk(top+1)=l1
         do 108 i=1,mn
           stk(l1-i)=dble(istk(l2-i))
  108    continue
         istk(il)=1
         istk(il+1)=m
         istk(il+2)=n
         istk(il+3)=0
c                cccccccccc
      elseif(sel.eq.2) then
c     sort(a,'c')   <=>  sort(a,2)
c   The lazy way...
         top=top+1
         call cvname(id,'c_sort     ',0)
         goto 300
      endif
      go to 999
c
c     kronecker product
  110 if (rhs .ne. 2) then
         call error(39)
         return
      endif
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      mb=m
      nb=n
      itb=it
      lb=l
      mnb=mn
      top = top - 1
      il=iadr(lstk(top))
      ma=istk(il+1)
      na=istk(il+2)
      ita=istk(il+3)
      la=sadr(il+4)
      mna=ma*na
c
      if(fin.eq.19) goto 115
      if(fin.eq.20) goto 111
      l=la
      mn=mna
      it=ita
  111 if(it.eq.1) goto 113
      do 112 k=1,mn
      lk=l+k-1
      if(stk(lk).eq.0.0d+0) then
         call error(27)
         return
      endif
  112 stk(lk)=1.0d+0/stk(lk)
      goto 115
  113 do 114 k=1,mn
      lk=l+k-1
      sr=stk(lk)
      si=stk(lk+mn)
      s=sr*sr+si*si
      if(s.eq.0.0d+0) then
         call error(27)
         return
      endif
      stk(lk)=sr/s
  114 stk(lk+mn)=-si/s
c
  115 istk(il+1)=mb*ma
      istk(il+2)=nb*na
      istk(il+3)=max(itb,ita)
      l=la
      l1=l+mnb*mna*(max(itb,ita)+1)
      lstk(top+1)=l1
c
c move a and b
      err=l1+mnb*(itb+1)+mna*(ita+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call dcopy(mnb*(itb+1),stk(lb),-1,stk(l1+mna*(ita+1)),-1)
      lb=l1+mna*(ita+1)
      call dcopy(mna*(ita+1),stk(la),-1,stk(l1),-1)
      la=l1
      goto(117,116,118) itb+2*ita
c a et b sont reelles
      call kronr(stk(la),ma,ma,na,stk(lb),mb,mb,nb,stk(l),ma*mb)
      goto 999
c a est complexe b est reelle
  116 call kronr(stk(la),ma,ma,na,stk(lb),mb,mb,nb,stk(l),ma*mb)
      call kronr(stk(la+mna),ma,ma,na,stk(lb),mb,mb,nb,stk(l+mnb*mna),
     1 ma*mb)
      goto 999
c a est reelle b conplexe
  117 call kronr(stk(la),ma,ma,na,stk(lb),mb,mb,nb,stk(l),ma*mb)
      call kronr(stk(la),ma,ma,na,stk(lb+mnb),mb,mb,nb,
     1 stk(l+mnb*mna),ma*mb)
      goto 999
  118 call kronc(stk(la),stk(la+mna),ma,ma,na,stk(lb),stk(lb+mnb),
     1 mb,mb,nb,stk(l),stk(l+mnb*mna),ma*mb)
      goto 999
c
c    matrices de test
  130 continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      top2=top-rhs+1
      il2=iadr(lstk(top2))
      if(rhs.ne.2) goto 135
      if(istk(il2).ne.10) then
         err=1
         call error(55)
         return
      endif
      kletr=abs(istk(il2+5+istk(il2+1)*istk(il2+2)))
      il=iadr(lstk(top))
      l=sadr(il+4)
      n=max(int(stk(l)),0)
c
      top=top-1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=n
      istk(il+2)=n
      istk(il+3)=0
      l=sadr(il+4)
      lstk(top+1)=l+n*n
      err=lstk(top+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(kletr.eq.magi) goto 131
      if(kletr.eq.hilb) goto 132
      if(kletr.eq.frk) goto 133
c
c     carre magique
  131 if (n .eq. 2) n = 0
      if (n .gt. 0) call magic(stk(l),n,n)
      istk(il+1)=n
      istk(il+2)=n
      lstk(top+1)=l+n*n
      go to 999
c
c     hilbert
 132  call hilber(stk(l),n,n)
      go to 999
c
c matrice de franck
  133 continue
      job=0
      if (n .gt. 0) call franck(stk(l),n,n,job)
      go to 999
c
c changement de dimension d'une matrice
  135 continue
      il=iadr(lstk(top+1-rhs))
      if(istk(il).eq.5.or.istk(il).eq.6) then
         fin=12
         call spelm
         return
      endif
      il=iadr(lstk(top))
      if(istk(il).ne.1) then
         err=3
         call error(53)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=3
         call error(89)
         return
      endif
      if(istk(il+3).ne.0) then
         err=3
         call error(52)
         return
      endif
      n=int(stk(sadr(il+4)))
c
      top=top-1
      il=iadr(lstk(top))
      if(istk(il).ne.1) then
         err=2
         call error(53)
         return
      endif
      if(istk(il+1)*istk(il+2).ne.1) then
         err=2
         call error(89)
         return
      endif
      if(istk(il+3).ne.0) then
         err=2
         call error(52)
         return
      endif
      m=int(stk(sadr(il+4)))
c
      top=top-1
      il=iadr(lstk(top))
      if(istk(il).gt.10) then
         err=1
         call error(55)
         return
      endif
      if(m*n.ne.istk(il+1)*istk(il+2)) then
         call error(60)
         return
      endif
      if(m*n.eq.0) then
         istk(il+1)=0
         istk(il+2)=0
      else
         istk(il+1)=m
         istk(il+2)=n
      endif
      goto 999
c
c     sin
c
 140  continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1) then
         call cvname(id,'g_sin       ',0)
         goto 300
      endif
      if(mn.eq.0) goto 999
      if(it.eq.0) then
         do 141 i=0,mn-1
            stk(l+i)=sin(stk(l+i))
 141     continue
      else
         do 142 i=0,mn-1
            sr=stk(l+i)
            si=stk(l+mn+i)
            stk(l+i)=sin(sr)*cosh(si)
            stk(l+i+mn)=cos(sr)*sinh(si)
 142     continue
      endif
      goto 999
c
c     cos
c
 150  continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1) then
         call cvname(id,'g_cos       ',0)
         goto 300
      endif
      if(mn.eq.0) goto 999
      if(it.eq.0) then
         do 151 i=0,mn-1
            stk(l+i)=cos(stk(l+i))
 151     continue
      else
         do 152 i=0,mn-1
            sr=stk(l+i)
            si=stk(l+mn+i)
            stk(l+i)=cos(sr)*cosh(si)
            stk(l+i+mn)=-sin(sr)*sinh(si)
 152     continue
      endif
      goto 999
c
c     atan
c
 160  continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1) then
         err=1
         call  error(53)
         return
      endif
      if(rhs.eq.1) then
         if(mn.eq.0) goto 999
         if(it.eq.0) then
            do 161 i=0,mn-1
               stk(l+i)=atan(stk(l+i))
 161        continue
         else
            do 162 i=0,mn-1
               sr=stk(l+i)
               si=stk(l+mn+i)
               if(abs(sinh(sr)).eq.1.0d+0.and.si.eq.0.0d+0) then
                  call error(32)
                  return
               endif
               call watan(sr,si,stk(l+i),stk(l+i+mn))
 162        continue
         endif
      elseif(rhs.eq.2) then
         top=top-1
         il1=iadr(lstk(top))
         if(istk(il1).ne.1) then
            err=1
            call  error(53)
            return
         endif
         mn1=istk(il1+1)*istk(il1+2)
         if(istk(il1+3).ne.0.or.it.ne.0) then
            call error(43)
            return
         endif            
         if(mn1.ne.mn) then
            call error(60)
            return
         endif
         if(mn.eq.0) goto 999
         l1=sadr(il1+4)
         do 163 i=0,mn
            if(abs(stk(l1+i))+abs(stk(l+i)).eq.0.0d+0) then
               call error(32)
               return
            endif
            stk(l1+i)=atan2(stk(l1+i),stk(l+i))
 163     continue
      endif
      goto 999
c
c     exp element wise
c
 170  continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(mn.eq.0) goto 999
      if(istk(il).ne.1.or.(istk(il).ne.1.and.istk(il).ne.5)) then
         call cvname(id,'g_exp   ',0)
         goto 300
      endif
      if(it.eq.0) then
         do 171 i=0,mn-1
            stk(l+i)=exp(stk(l+i))
 171     continue
      else
         do 172 i=0,mn-1
            sr=stk(l+i)
            si=stk(l+mn+i)
            stk(l+i)=exp(sr)*cos(si)
            stk(l+i+mn)=exp(sr)*sin(si)
 172     continue
      endif
      goto 999
c
c     expm matricial exponential
c
 173  continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(mn.eq.0) goto 999
      if(istk(il).ne.1.or.(istk(il).ne.1.and.istk(il).ne.5)) then
         call cvname(id,'g_exp   ',0)
         goto 300
      endif
      if(m.ne.n) then
         err=1
         call error(2)
         return
      endif
      nn=mn
      if(it.eq.0) then
         le=lstk(top+1)
         lw=le+nn
         ilb=iadr(lw+4*nn+5*n)
         err=sadr(ilb+n+n)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call dexpm1(n,n,stk(l),stk(le),n,stk(lw),istk(ilb),err)
         if(err.ne.0) then
            call error(24)
            return
         endif
         call dcopy(nn,stk(le),1,stk(l),1)
      else
         le=lstk(top+1)
         lw=le+2*nn
         ilb=iadr(lw+8*nn+7*n)
         err=sadr(ilb+n+n)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         call wexpm1(n,stk(l),stk(l+nn),n,stk(le),stk(le+nn),
     *        n,stk(lw),istk(ilb),err)
         if(err.ne.0) then
            call error(24)
            return
         endif
         call dcopy(2*nn,stk(le),1,stk(l),1)
      endif
      goto 999
c
c     sqrt
c
 180  continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1) then
         call cvname(id,'g_sqrt       ',0)
         goto 300
      endif
      if(mn.eq.0) goto 999
      if(it.eq.0) then
         itr=0
         do 181 i=0,mn-1
            if(stk(l+i).lt.0.0d+0) then
               itr=1
               goto 182
            endif
 181     continue
 182     if(itr.eq.0) then
            do 183 i=0,mn-1
               stk(l+i)=sqrt(stk(l+i))
 183        continue
         else
            err=l+2*mn-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            lstk(top+1)=l+2*mn
            do 184 i=0,mn-1
               call wsqrt(stk(l+i),0.0d+0,stk(l+i),stk(l+mn+i))
 184        continue
            istk(il+3)=itr
         endif
      else
         do 185 i=0,mn-1
            sr=stk(l+i)
            si=stk(l+mn+i)
            call wsqrt(sr,si,stk(l+i),stk(l+i+mn))
 185     continue
      endif
      goto 999
c
c     log
c
 190  continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(istk(il).ne.1) then
         call cvname(id,'g_log       ',0)
         goto 300
      endif
      if(mn.eq.0) goto 999
      if(it.eq.0) then
         itr=0
         do 191 i=0,mn-1
            if(stk(l+i).lt.0.0d+0) then
               itr=1
               goto 192
            elseif(stk(l+i).eq.0.0d+0) then
               call error(32)
               return
            endif
 191     continue
 192     if(itr.eq.0) then
            do 193 i=0,mn-1
               stk(l+i)=log(stk(l+i))
 193        continue
         else
            err=l+2*mn-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
            endif
            lstk(top+1)=l+2*mn
            do 194 i=0,mn-1
               call wlog(stk(l+i),0.0d+0,stk(l+i),stk(l+mn+i))
 194        continue
            istk(il+3)=itr
         endif
      else
         do 195 i=0,mn-1
            sr=stk(l+i)
            si=stk(l+mn+i)
            if(sr*sr+si*si.eq.0.0d+0) then
               call error(32)
               return
            endif
            call wlog(sr,si,stk(l+i),stk(l+i+mn))
 195     continue
      endif
      goto 999
c
c  ** puissance non entiere des matrices carres ou scalaire^matrice
c
 200  continue
      call cvname(id,'g_pow    ',0)
      goto 300
c
c     sign
c
 210  continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      if(mn.eq.0) goto 999
      if(it.eq.0) then
         do 211 i=0,mn-1
            if(stk(l+i).gt.0.d0) then
               stk(l+i)=1.d0
            elseif(stk(l+i).lt.0.d0) then
               stk(l+i)=-1.d0
            else
               stk(l+i)=0.0d0
            endif
 211     continue
      else
         err=1
         call error(52)
      endif
      goto 999
c
c     clean
c
 220  continue
      if (lhs .ne. 1) then
         call error(41)
         return
      endif
      ilp=iadr(lstk(top+1-rhs))
      if(istk(ilp).eq.2) then
         fin=17
         call polelm
         return
      elseif(istk(ilp).eq.5) then
         fin=8
         call spelm
         return
      elseif(istk(ilp).ne.1) then
         call cvname(id,'g_clean         ',0)
         goto 300
      endif
      if (rhs.eq.3) then
c     clean(p,epsa,epsr)
         iler=iadr(lstk(top))
         ler=sadr(iler+4)
         ilea=iadr(lstk(top-1))
         lea=sadr(ilea+4)
         epsr=stk(ler)
         epsa=stk(lea)
         top=top-2
      else if (rhs.eq.2) then
c     clean(p,epsa)
         ilea=iadr(lstk(top))
         lea=sadr(ilea+4)
         top=top-1
         epsr=1.0d-10
         epsa=stk(lea)
      else if(rhs.eq.1) then
         epsr=1.0d-10
         epsa=1.0d-10
      endif
      m=istk(ilp+1)
      n=istk(ilp+2)
      it=istk(ilp+3)
      l=sadr(ilp+4)
      if(it.eq.0) then
         norm=dasum(m*n,stk(l),1)
      else
         norm=wasum(m*n,stk(l),stk(l+m*n),1)
      endif
      eps=max(epsa,epsr*norm)
      do 221 kk=0,m*n*(it+1)
         if (abs(stk(l+kk)).le.eps) stk(l+kk)=0.d0
 221  continue

      goto 999

c
c  fonctions matricielles gerees par l'appel a une macro
c
 300  fin=0
      call funs(id)
      if(err.gt.0) return
      if(fun.gt.0) then
         buf='primitive call'
         call error(9999)
         return
      endif
      if(fin.eq.0) then
         call putid(ids(1,pt+1),id)
         call error(4)
         if(err.gt.0) return
      endif
      pt=pt+1
      fin=lstk(fin)
      rstk(pt)=905
      icall=5
      fun=0
c     *call*  macro
      return
 310  continue
      pt=pt-1
      goto 999
c
  900 continue
      if(istk(il).ne.2) then
         err=1
         call error(44)
         return
      endif
c     *call* polelm
      fun=16
      return

c
  999 return
      end

      subroutine intrand(fname,icont)
c     -------------------------------
      character*(*) fname
c     Interface for rand function 
      INCLUDE '../stack.h'
      double precision s,sr,si
      integer id(nsiz)
      double precision urand
      logical checkrhs,checklhs,getsmat,getscalar,cremat,getmat
      logical cresmat2
      integer gettype
      character*(20) randtype
      integer iadr,sadr
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      randtype='uniform'//char(0)
      irt=0
      icont=0
      m=-99
      if (.not.checkrhs(fname,0,3)) return
      if (.not.checklhs(fname,1,1)) return
      topk=top
C     if rhs=3 third argument is a string giving the rand type ( 'uniform','gaussian',...)
      if ( rhs.eq.3 ) then 
         if(.not.getsmat(fname,topk,top,mt,nt,1,1,lrt,nlrt))return
         call cvstr(nlrt,istk(lrt),randtype,1)
         randtype(nlrt+1:nlrt+1)=char(0)
         irt=2
         top=top-1
      endif
C     
      if( rhs.ge.2) then
         itype=gettype(top) 
         if ( itype.eq.1) then 
            if(.not.getscalar(fname,topk,top,lr2))return
            n=int(stk(lr2))
         elseif ( itype.eq.10 ) then 
            if(.not.getsmat(fname,topk,top,mt,nt,1,1,lrt,nlrt))return
            call cvstr(nlrt,istk(lrt),randtype,1)
            randtype(nlrt+1:nlrt+1)=char(0)
            irt=2
         else
            buf=fname//' : second argument has wrong type'
            call error(999)
            return
         endif
         top=top-1
      endif
C     
      it1=-1
      if( rhs.ge.1) then
         itype1=gettype(top) 
         if ( itype1.eq.1.and.rhs.eq.1) then 
            if(.not.getmat(fname,topk,top,it1,m,n,lr1,lc1))return
         elseif ( itype1.eq.1.and.rhs.ge.1.and.itype.eq.1) then 
            if(.not.getscalar(fname,topk,top,lr1))return
            m=int(stk(lr1))
         elseif ( itype1.eq.1.and.rhs.ge.1.and.itype.ne.1) then 
            if(.not.getmat(fname,topk,top,it1,m,n,lr1,lc1))return
         elseif ( itype1.eq.10 ) then 
            if(.not.getsmat(fname,topk,top,mt,nt,1,1,lrt,nlrt))return
            call cvstr(nlrt,istk(lrt),randtype,1)
            randtype(nlrt+1:nlrt+1)=char(0)
            irt=1
         elseif ( rhs.eq.1.and.itype1.gt.10 ) then 
            call cvname(id,'g_rand   ',0)
            icont=300
            return
         else
            buf=fname//' : first argument has wrong type'
            call error(999)
            return
         endif
      endif
      if (rhs.eq.0) then 
         top=top+1
         il=iadr(lstk(top))
         istk(il)=1
         m=1
         n=1
      endif
C     seed options 
      if ( randtype(1:nlrt).eq.'seed') then 
         if ( rhs.eq.1 ) then 
            if (.not.cremat(fname,top,0,1,1,lr,lc)) return
            stk(lr) = ran(1)            
            return
         else
            if (itype.eq.1) then
               ran(1) = max(int(stk(lr2)),0)
               call objvide(fname,top)
               return
            else
               buf=fname//' : second argument has wrong type'
               call error(999)
               return
            endif
         endif
      endif
C     getting info 
      if ( randtype(1:nlrt).eq.'info') then 
         call randinfo(randtype,ilen) 
         if (.not.cresmat2(fname,top,ilen,lr)) return
         call cvstr(ilen,istk(lr),randtype,0) 
         return
      endif
C     switching to an other law 
      if ( irt.ge.1 ) then 
         iran1kp=ran(2)
         call randswitch(randtype)
      endif
C     no need for random generation 
      if(m.eq.-99) then 
         call objvide(fname,top)
         return
      endif
C     random generation 
      if(m.eq.0) n=0
      if(n.eq.0) m=0
      if(it1.ne.-1) then 
         itres= it1
      else
         itres= 0
      endif
      if (.not.cremat(fname,top,itres,m,n,lr,lc)) return
      if ( m*n .ne. 0 ) then 
         if ( ran(2).eq.0 ) then 
            do 76 j = 0, (itres+1)*m*n-1
               stk(lr+j) = urand(ran(1))
 76         continue
         elseif (ran(2).eq.1) then 
            do 77 j = 0, m*n-1
 75            sr=2.0d+0*urand(ran(1))-1.0d+0
               si=2.0d+0*urand(ran(1))-1.0d+0
               t = sr*sr+si*si
               if (t .gt. 1.0d+0) go to 75
               stk(lr+j) = sr*sqrt(-2.0d+0*log(t)/t)
 77         continue
         endif
      endif
C     switching back to the default randvalue
      if ( irt.ge.2) then 
         ran(2)=iran1kp
      endif
      return
      end
      
      subroutine randswitch(randtype)
      character*(20) randtype
      INCLUDE '../stack.h'
      if ( randtype(1:1).eq.'u') then 
         ran(2)=0
      else if ( randtype(1:1).eq.'g') then 
         ran(2)=1
      else if ( randtype(1:1).eq.'n') then 
         ran(2)=1
      else 
         ran(2)=0
      endif
      return
      end

      subroutine randinfo(randtype,ilen) 
      INCLUDE '../stack.h'
      character*(20) randtype
      integer ilen 
      if ( ran(2).eq.0) then 
         randtype='uniform'
         ilen=7
      else if ( ran(2).eq.1) then 
         randtype='normal'
         ilen=6
      endif
      return
      end

