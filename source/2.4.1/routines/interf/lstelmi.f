      subroutine lstelmi
c ================================== ( Inria    ) =============
c
c     evaluate utility list's functions with possible indirect args
c
c =============================================================
c     

c     Copyright INRIA
c     
      include '../stack.h'
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' lstelmi '//buf(1:4))
      endif
c
c     functions/fin
c     1        2       
c     getfield setfield
c
c
      rhs=max(0,rhs)
      if(top-rhs+lhs+1.ge.bot) then
         call error(18)
         return
      endif
c
      goto(10,20) fin
 10   continue
c     getfield
      call intgetfield()
      if(err.gt.0) return
      goto 99

 20   continue
c     setfield
      call intsetfield()
      if(err.gt.0) return
      goto 99

 99   return
      end
      subroutine intgetfield()
      include '../stack.h'
      integer top0,tops,vol,vol2,vol1
      integer strpos
      external strpos
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (rhs .lt. 1) then
         call error(39)
         return
      endif
      lw=lstk(top+1)
c
c extraction
   10 continue
      if(rhs.ne.2) then
         call error(39)
         return
      endif
c     arg2(arg1)
c     get arg2
      il2=iadr(lstk(top))
      if(istk(il2).lt.0) il2=iadr(istk(il2+1))
      m2=istk(il2+1)
      id2=il2+3
      l2=sadr(il2+m2+3)
c     get arg1
      top=top-1
      il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
      ilist=0
      nlist=0
      if(istk(il1).eq.15) then
         ill=il1
         nlist=m1
         ll=sadr(ill+3+nlist)
         ilist=1
         il1=iadr(ll+istk(ill+1+ilist)-1)
         if(istk(il1).lt.0) il1=iadr(istk(il1+1))
         m1=istk(il1+1)
      endif
c
 15   continue
c     
      if(istk(il1).ne.10)  goto 20
c     .  arg2(arg1) with arg1 vector of strings
      ilt=iadr(sadr(il2+istk(il2+1)+3))
      nt=istk(ilt+1)*istk(ilt+2)
      if(nt.ne.1) goto 17
c     .     Soft coded extraction
      buf='Soft coded field names not yet implemented'	
      call error(999)
      return

 17   continue
c     arg2(arg1) arg1:string, hard coded case
      if(istk(il1+1).gt.1.and.istk(il1+2).gt.1) then
         call error(21)
         return
      endif
      n1=istk(il1+1)*istk(il1+2)
      ili=iadr(lw)
      lw=sadr(ili+n1)
      err=lw-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c     .  look for corresponding index
      l=il1+5+n1
      mx=0
      do 18 i=1,n1
         nl=istk(il1+4+i)-istk(il1+3+i)
         n=strpos(istk(ilt+5),nt-1,istk(ilt+5+nt),istk(l),nl)
         l=l+nl
         if(n.le.0) then
            call error(21)
            return
         endif
         n=n+1
         mx=max(mx,n)
         istk(ili-1+i)=n
 18   continue
      n=n1
c     end of arg1=string case
      goto 22
c     begining of standard case
 20   if(m1.eq.-1) then
c     .  arg2(:)
         l=lstk(top)
         if(ilist.ne.nlist) then
            if(m2.ne.1) then
               call error(21)
               return
            endif
         endif
         if(m2.ne.lhs) then
            call error(41)
            return
         endif
         if(top+1+m2.ge.bot) then
            call error(18)
            return
         endif
         do  21 i=1,m2
            vol1=istk(il2+2+i)-istk(il2+1+i)
            if(vol1.eq.0) then
               err=i
               call error(117)
               return
            endif
            lstk(top+1)=lstk(top)+vol1
            top=top+1
 21      continue
         top=top-1
         call dcopy(istk(il2+m2+2)-1,stk(l2),1,stk(l),1)
         goto 99
      else
c     .  arg2(arg1) standard case
         call indxg(il1,m2,ili,n,mx,lw,1)
         if(err.gt.0) return
      endif
c     
 22   if(mx.gt.m2) then
         call error(21)
         return
      endif
c     
      if(ilist.ge.nlist) goto 31
      if(n.gt.1) then
         call error(21)
         return
      endif
      lt2=sadr(il2+3+m2)+istk(il2+1+istk(ili))-1
      ll2=istk(il2+2+istk(ili))-istk(il2+1+istk(ili))
      il2=iadr(lt2)
 23   ilist=ilist+1
      il1=iadr(ll+istk(ill+1+ilist)-1)
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)

      if(istk(il2).eq.15.or.istk(il2).eq.16) goto 26
      call error(21)
      return

 26   continue
      m2=istk(il2+1)
      l2=sadr(il2+m2+3)
      goto 15
c

 31   if(n.ne.lhs) then
         call error(41)
         return
      endif
c
      if(top+n+1.ge.bot) then
         call error(18)
         return
      endif
      do  32 i=1,n
         k=istk(ili-1+i)
         vol2=istk(il2+2+k)-istk(il2+1+k)
         if(vol2.eq.0) then
            err=k
            call error(117)
            return
         endif
         lstk(top+1)=lstk(top)+vol2
         top=top+1
 32   continue
      top=top-1
c
      ill=iadr(max(lw,lstk(top+1)))
      lw=sadr(ill+n)
      err=sadr(ill+n)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      do 34 i=1,n
         k=istk(ili-1+i)
         istk(ill-1+i)=istk(il2+1+k)+l2-1
 34   continue
c
      do 35 i=1,n
         k=top-n+i
         call dcopy(lstk(k+1)-lstk(k),stk(istk(ill-1+i)),1,stk(lstk(k))
     $        ,1)
 35   continue
      goto 99

 99   return
      end

      subroutine intsetfield()
      include '../stack.h'
      integer top0,tops,vol,vol2,vol1,vol3s,vol3,dvol,typ2,rhs1,id(nsiz)
      integer strpos,subptr
      external strpos,subptr
c
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (rhs .ne. 3) then
         call error(39)
         return
      endif
      top0=top
      lw=lstk(top+1)
c
      ltop0=lstk(top0)
c     integer vector for recursion saving
      ilrec=iadr(lw)
      lw=sadr(ilrec+13)

c     arg3(arg1)=arg2
c     get arg3
      call putid(id,idstk(1,top))
      il3=iadr(lstk(top))
      if(istk(il3).lt.0) then
         il3=iadr(istk(il3+1))
      else
         err=3
         call error(118)
         return
      endif
      il3s=il3
      typ3=istk(il3)
      if(typ3.lt.14.or.typ3.gt.17) then
         call error(44)
         return
      endif
      m3=istk(il3+1)
      m3s=m3
      id3=il3+3
      l3=sadr(il3+m3+3)
      l3s=l3
      vol3=istk(il3+2+m3)-1
      vol3s=vol3
c     get arg2
      top=top-1
      l2t=lstk(top)
      il2=iadr(lstk(top))
      typ2=istk(il2)
      vol2=lstk(top+1)-lstk(top)
c     get arg1
      top=top-1
      il1=iadr(lstk(top))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
      ilist=0
      nlist=0
      if(istk(il1).eq.15.or.istk(il1).eq.16) then
         ill=il1
         nlist=m1
         ll=sadr(ill+3+nlist)
         ilist=1
         il1=iadr(ll+istk(ill+1+ilist)-1)
         if(istk(il1).lt.0) il1=iadr(istk(il1+1))
         m1=istk(il1+1)
         ilind=iadr(lw)
         lw=sadr(ilind+m1)
         err=lw-lstk(bot)
         if(err.gt.0) then 
            call error(17)
            return
         endif
      else
         ilind=iadr(lw)
         lw=sadr(ilind+1)
      endif
c
 51   continue
c
      if(istk(il1).eq.10) then
         ilt=iadr(sadr(il3+istk(il3+1)+3))
         nt=istk(ilt+1)*istk(ilt+2)
         if(nt.eq.1) then
            if(nlist.le.1) then
               fin=-fin
               top=top0
               rhs1=rhs
               return
            endif
            buf='tlist soft coded insertion not allowed here'
            call error(9999)
            return
         endif
c     .  element is designated by its name
         if(istk(il1+1)*istk(il1+2).ne.1) then
            call error(21)
            return
         endif
c     .  look for corresponding index
         n=strpos(istk(ilt+5),nt-1,istk(ilt+5+nt),istk(il1+6),
     $        istk(il1+5)-istk(il1+4))
         if(n.le.0) then
            call error(21)
            return
         endif
         n=n+1
         ili=iadr(lw)
         lw=sadr(ili+2)
         istk(ili)=n
      else
c     .  arg3(arg1)=arg2 standard case
         call indxg(il1,m3,ili,nl,mx,lw,0)
         if(err.gt.0) return
         if(nl.ne.1) then
            call error(21)
            return
         endif
         n=istk(ili)
         if(n.lt.0) then
            call error(21)
            return
         endif
      endif
c
      if(ilist.ge.nlist) goto 57
c     store current index
      istk(ilind-1+ilist)=istk(ili)
c     move pointer to indexed sub-list of arg3
      il3p=il3
      lt3=sadr(il3+3+m3)+istk(il3+1+istk(ili))-1
      ll3=istk(il3+2+istk(ili))-istk(il3+1+istk(ili))
      il3=iadr(lt3)
c     move pointer to next index list entry
      ilist=ilist+1
      il1=iadr(ll+istk(ill+1+ilist)-1)
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      m1=istk(il1+1)
c
      if(abs(istk(il3)).eq.15.or.abs(istk(il3)).eq.16.or.
     $     abs(istk(il3)).eq.17) goto 56
      call error(44)
      return
c     a leaf found
      
 56   continue
      typ3=istk(il3)
      m3=istk(il3+1)
      l3p=l3
      l3=sadr(il3+m3+3)
      vol3=istk(il3+2+m3)-1
      goto 51

 57   istk(ilind+nlist-1)=istk(ili)
c
 58   if(n.eq.0) then
c     add a new element "on the left"
         if(typ2.eq.0) then
c     null element : nothing added
c            il1=iadr(lstk(top))
c            istk(il1)=-1
c            istk(il1+1)=-1
c            istk(il1+2)=istk(iadr(ltop0)+2)
c            lstk(top+1)=lstk(top)+3
            goto 99
         endif
         l3d=sadr(il3s)
         lrn=lw
         err=sadr(iadr(lrn)+3+m3s+1)+vol3s+vol2-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         if(nlist.gt.0) then
            iln=iadr(lrn)
c     .     copy the beginning of arg3 up to  the modified sub-list
            if(lt3-l3d.gt.0) then
               call dcopy(lt3-l3d,stk(l3d),1,stk(lrn),1)
c     .        lrn points to the beginning of the new entry
               lrn=lrn+lt3-l3d
            endif 
        endif
         ilr=iadr(lrn)
         istk(ilr)=typ3
         istk(ilr+1)=m3+1
         istk(ilr+2)=1
         istk(ilr+3)=1+vol2
         do 59 i=1,m3
            istk(ilr+3+i)=istk(ilr+2+i)+istk(il3+2+i)-istk(il3+1+i)
 59      continue
         lr=sadr(ilr+4+m3)
         call dcopy(vol2,stk(l2t),1,stk(lr),1)
         lr=lr+vol2
         call dcopy(vol3,stk(l3),1,stk(lr),1)
         lr=lr+vol3
         dvol=(lr-lrn)-(l3+vol3-sadr(il3))

         if(nlist.eq.0) then
            call dcopy(lr-lrn,stk(lrn),1,stk(lstk(top)),1)
            lstk(top+1)=lstk(top)+lr-lrn
         else
c     .     update new data structure pointers recursively 
            call updptr(iln,istk(ilind),nlist-1,dvol)
c     .     copy the rest of data structure
            istk(ilind+nlist-2)=istk(ilind+nlist-2)+1
            lt3=sadr(subptr(il3s,istk(ilind),nlist-1))
            call dcopy(l3s+vol3s-lt3,stk(lt3),1,stk(lr),1)
            lr=lr+l3s+vol3s-lt3
c     .     put the result in place
            lrn=sadr(iln)
            call dcopy(lr-lrn,stk(lrn),1,stk(lstk(top)),1)
            lstk(top+1)=lstk(top)+lr-lrn
         endif
      elseif(n.gt.m3) then
c     add a new element "on the right"
         if(typ2.eq.0) then
c     null element : nothing added
c            il1=iadr(lstk(top))
c            istk(il1)=-1
c            istk(il1+1)=-1
c            istk(il1+2)=istk(iadr(ltop0)+2)
c            lstk(top+1)=lstk(top)+3
            goto 99
         endif
         l3d=sadr(il3s)
         lrn=lw
         iln=iadr(lrn)
         err=sadr(iln+3+m3s+n-m3)+vol3s+vol2-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         if(nlist.gt.0) then
c     .     copy the beginning of arg3 up to  the modified sub-list
            if(lt3-l3d.gt.0) then
               call dcopy(lt3-l3d,stk(l3d),1,stk(lrn),1)
c     .        lrn points to the beginning of the new entry
               lrn=lrn+lt3-l3d
            endif
         endif
         ilr=iadr(lrn)
         call icopy(m3+3,istk(il3),1,istk(ilr),1)
         istk(ilr+1)=n
         call iset(n-m3,istk(ilr+m3+2),istk(ilr+m3+3),1)
         istk(ilr+n+2)=istk(ilr+n+1)+vol2
         lr=sadr(ilr+3+n)
         call dcopy(vol3,stk(l3),1,stk(lr),1)
         lr=lr+vol3
         call dcopy(vol2,stk(l2t),1,stk(lr),1)
         lr=lr+vol2
c
         dvol=(lr-lrn)-(l3+vol3-sadr(il3))
         if(nlist.ne.0) then
c     .     update new data structure pointers recursively 
            call updptr(iln,istk(ilind),nlist-1,dvol)
c     .     copy the rest of data structure
            istk(ilind+nlist-2)=istk(ilind+nlist-2)+n-m3
            lt3=sadr(subptr(il3s,istk(ilind),nlist-1))
            if(l3s+vol3s-lt3.gt.0) then
               call dcopy(l3s+vol3s-lt3,stk(lt3),1,stk(lr),1)
               lr=lr+l3s+vol3s-lt3
            endif
         endif
c     .  store result
         lrn=sadr(iln)
         lt=lstk(top)
         lstk(top)=lrn
         lstk(top+1)=lstk(top)+lr-lrn
         lhs=1
         call stackp(id,0)
c     .  notify that result has already been stored
         top=top+1
c         lstk(top)=lt
c         il1=iadr(lstk(top))
c         istk(il1)=-1
c         istk(il1+1)=-1
c         istk(il1+2)=fin
c         lstk(top+1)=lstk(top)+3
      elseif(typ2.ne.0) then
c%%2
c     change the specified element
         if (istk(il3+2+n)-istk(il3+1+n).eq.vol2) then
c     element is directly replaced 
            lr=l3+istk(il3+1+n)-1
            call dcopy(vol2,stk(l2t),1,stk(lr),1)
c     .     list has been modified in place
c            il1=iadr(lstk(top))
c            istk(il1)=-1
c            istk(il1+1)=-1
c            istk(il1+2)=istk(iadr(ltop0)+2)
c            lstk(top+1)=lstk(top)+3
            goto 99
         else
            iln=iadr(lw)
            lrn=lw
c     .     dvol the size variation of modified sub-element (-old+new)
            dvol=-(istk(il3+2+n)-istk(il3+1+n))+vol2
            err=sadr(iln+3+m3s)+vol3s+dvol-lstk(bot)
            if(err.gt.0) then
               call error(17)
               return
             endif
c     .     lr,ilr points to the entry to be replaced
            lr=l3+istk(il3+1+n)-1
            ilr=iadr(lr)
c     .     change list type if necessary
            if(n.eq.1.and.typ2.ne.10) istk(il3)=15
c     .     copy the beginning of arg3 up to  entry to be replaced
            l3d=sadr(il3s)
            call dcopy(lr-l3d,stk(l3d),1,stk(lrn),1)
c     .     lrn points to the beginning of the new entry
            lrn=lrn+lr-l3d
c     .     set new value of the entry
            call dcopy(vol2,stk(l2t),1,stk(lrn),1)
            lrn=lrn+vol2
c     .     copy last entries of arg3
c     .     il3l points to the end of arg3 data structure
            l3l=l3s+vol3s
            l3=l3+istk(il3+2+n)-1
            call dcopy(l3l-l3,stk(l3),1,stk(lrn),1)
            lrn=lrn+l3l-l3
c     .     update new data structure pointers recursively 
            if(nlist.eq.0) then
               nlist=1
c??               istk(ilind)=istk(ilind)+1
               istk(ilind)=n
            endif
            call  updptr(iln,istk(ilind),nlist,dvol)
c     .     store result
            lt=lstk(top)
            lstk(top)=lw
            lstk(top+1)=lstk(top)+lrn-lw
            lhs=1
            call stackp(id,0)
c     .     notify that result has already been stored
            top=top+1
            lstk(top)=lt
c            il1=iadr(lstk(top))
c            istk(il1)=-1
c            istk(il1+1)=-1
c            istk(il1+2)=fin
c            lstk(top+1)=lstk(top)+3
         endif
      else
c     suppress the specified entry
         l3d=sadr(il3s)
         lrn=lw
         iln=iadr(lrn)
         err=sadr(iln+3+m3s)+vol3s-(istk(il3+2+n)-istk(il3+1+n))
     $        -lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         if(nlist.gt.0) then
c     .     copy the beginning of arg3 up to  the modified sub-list
            if(lt3-l3d.gt.0) then
               call dcopy(lt3-l3d,stk(l3d),1,stk(lrn),1)
c     .        lrn points to the beginning of the new entry
               lrn=lrn+lt3-l3d
            endif
         endif
c     .  update sub_list  
c     .  ---------------
         il=iadr(lrn)
         l2=l3-1+istk(il3+2+n)
c     .  copy variable header and n-1 first pointers
         call icopy(2+n,istk(il3),1,istk(il),1)
         if(n.eq.1) istk(il)=15
c     .  reduce list size
         istk(il+1)=istk(il+1)-1
c     .  modify last pointers
         do 65 i=n,m3
            istk(il+i+2)=istk(il+i+1)+istk(il3+i+3)-istk(il3+i+2)
 65      continue
c     .  copy first n-1 elements
         l=sadr(il+2+m3)
         call dcopy(istk(il+n+1)-1,stk(l3),1,stk(l),1)
         l=l+istk(il+n+1)-1
c     .  dvol the size variation of modified sub-element (-old+new)
         dvol=(l-sadr(il))-(l2-sadr(il3))
c     .  copy last elements
         call dcopy(istk(il+1+m3)-istk(il+1+n),stk(l2),1,stk(l),1)
         l=l+istk(il+1+m3)-istk(il+1+n)
         if(nlist.gt.0) then
c     .     update new data structure pointers recursively 
            call updptr(iln,istk(ilind),nlist-1,dvol)
c     .     copy the rest of data structure
            istk(ilind+nlist-1)=istk(ilind+nlist-1)+1
            lt3=sadr(subptr(il3s,istk(ilind),nlist))
            call dcopy(l3s+vol3s-lt3,stk(lt3),1,stk(l),1)
            l=l+l3s+vol3s-lt3
         endif
c     .  store result
         lrn=sadr(iln)
         lt=lstk(top)
         lstk(top)=lrn
         lstk(top+1)=lstk(top)+l-lrn
         lhs=1
         call stackp(id,0)
c     .  notify that result has already been stored
         top=top+1
         lstk(top)=lt
c         il1=iadr(lstk(top))
c         istk(il1)=-1
c         istk(il1+1)=-1
c         istk(il1+2)=fin
c         lstk(top+1)=lstk(top)+3
      endif
      goto 99
 99   il1=iadr(lstk(top))
      istk(il1)=0
      lstk(top+1)=lstk(top)+1
      return
      end
