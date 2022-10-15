      subroutine lstops
c =============================================================
c     operations elementaires sur les listes
c =============================================================
c
      include '../stack.h'
c
c
      integer rhs1,vol1,vol2,vol3,vol3s,dvol
      integer typ2,op,iadr,sadr,top0,typ3

      integer strpos,subptr
      external strpos,subptr
      logical ptover
      integer id(nsiz)
c
c
      data insert/2/,extrac/3/

c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      icall=0
c
      if(rstk(pt).eq.403) goto 16
      if(rstk(pt).eq.405) goto 25
      if(rstk(pt).eq.406) goto 55
      op=fin
      fun=0
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') op
         call basout(io,wte,' lstops '//buf(1:4))
      endif
c
      lw=lstk(top+1)
      rhs1=rhs
      top0=top
      if(op.eq.extrac) goto 10
      if(op.eq.insert) goto 50
c
c     operations non implantee
      fin=-fin
      rhs=rhs1
      return
c
c extraction
   10 continue
      if(rhs.gt.2) then
         fin=-fin
         return
      endif
      if(rhs.le.0) then
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
      m1=istk(il1+1)
      ilist=0
      nlist=0
      if(istk(il1).eq.15) then
         ill=il1
         nlist=m1
         ll=sadr(ill+3+nlist)
         ilist=1
         il1=iadr(ll+istk(ill+1+ilist)-1)
         m1=istk(il1+1)
      endif
c
 15   continue
c
      if(istk(il1).ne.10) goto 20
c     .  arg2(arg1) with arg1 vector of strings
      ilt=iadr(sadr(il2+istk(il2+1)+3))
      nt=istk(ilt+1)*istk(ilt+2)
      if(nt.ne.1) goto 17
c     .     Soft coded extraction
      if(nlist.le.1) then
         fin=-fin
         top=top0
         rhs1=rhs
         return
      endif

c     intermediate index in the index list (extract the
c     intermediate sub-list)

c     set the index
      top=top0+1
      ll1=sadr(ill+3+nlist)+istk(ill+1+ilist)-1
      vol1=istk(ill+2+ilist)-istk(ill+1+ilist)
      call dcopy(vol1,stk(ll1),1,stk(lstk(top)),1)
      ilx=iadr(lstk(top))
      lstk(top+1)=lstk(top)+vol1
c     set the  list
      top=top+1
      vol2=sadr(2+m2+1)+istk(il2+2+m2)-1
      call dcopy(vol2,stk(sadr(il2)),1,stk(lstk(top)),1)
      ilx=iadr(lstk(top))
      lstk(top+1)=lstk(top)+vol2
c     look for macro mame
      rhs=2
      fin=3
      call mname(fin,id)
      if(err.gt.0) return
c     store context
      fin=lstk(fin)
      if (ptover(1,psiz)) return
      rstk(pt)=403
      icall=5
      ids(1,pt)=ilist
      ids(2,pt)=nlist
      ids(4,pt)=lhs
      lhs=1
      fun=0
c     *call* macro
      return
 16   continue
c     restore context
      ilist=ids(1,pt)
      nlist=ids(2,pt)
      lhs  =ids(4,pt)
      pt=pt-1
      if(ilist.eq.nlist) then
c     .  put the result at the top of the stack and return
         fin=1
         call dcopy(lstk(top+1)-lstk(top),stk(lstk(top)),1,
     $        stk(lstk(top-2)),1) 
         lstk(top-1)=lstk(top-2)+lstk(top+1)-lstk(top)
         top=top-2
         return
      else
c     .  move result ajust after the index
         ll2=lstk(top+1)-lstk(top)
         call dcopy(ll2,stk(lstk(top)),1,stk(lstk(top-1)),1) 
         lstk(top)=lstk(top-1)+ll2
         top=top-1
         lw=lstk(top+1)
         lt2=lstk(top)
         il2=iadr(lstk(top))
         m2=istk(il2+1)
         l2=sadr(il2+m2+3)
c     
         top=top-1
         ill=iadr(lstk(top))
         ll=sadr(ill+3+nlist)
         il1=iadr(ll+istk(ill+1+ilist)-1)
         goto 23
      endif
c     
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
      m1=istk(il1+1)

      if(istk(il2).eq.15.or.istk(il2).eq.16) goto 26
c     a leaf has been found
      if(ilist.ne.nlist) then
         call error(21)
         return
      endif
      if(istk(il1).eq.15) then
         if(ilist.ne.nlist) then
            call error(21)
            return
         endif
c     .  matrix/vector element extraction
c     .  form indexes at the top of the stack
         ll=sadr(il1+m1+3)
         ltop=lstk(top)
         lstk(top)=lw
         rhs=1
         do 24 i=1,m1
            rhs=rhs+1
            lstk(top+1)=lstk(top)+istk(il1+2+i)-istk(il1+1+i)
            top=top+1
 24      continue
         call dcopy(istk(il1+m1+2)-1,stk(ll),1,
     $        stk(lstk(top-m1)),1) 
      else
         ll=ll+istk(ill+1+ilist)-1
         nn=istk(ill+2+ilist)-istk(ill+1+ilist)
         call dcopy(nn,stk(ll),1,stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+nn
         rhs=2
         top=top+1
      endif
c     form variable pointer
      ilv=iadr(lstk(top))
      istk(ilv)=-istk(il2)
      istk(ilv+1)=lt2
      lstk(top+1)=sadr(ilv+2)

      fin=3
      if(istk(il2).eq.15.or.istk(il2).eq.16) then
         call dcopy(ll2,stk(lt2),1,stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+ll2
         fin=-fin
         rhs=rhs1
         return
      endif
c     back to allops for  standard extraction
      if (ptover(1,psiz)) return
      icall=4
      rstk(pt)=405
c     *call* allops
      return
 25   continue
      pt=pt-1
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
c
c insert
 50   continue
      if(rhs.ge.4) then
         fin=-fin
         return
      endif
      ltop0=lstk(top0)
c     integer vector for recursion saving
      ilrec=iadr(lw)
      lw=sadr(ilrec+13)

c     arg3(arg1)=arg2
c     get arg3
      il3=iadr(lstk(top))
      if(istk(il3).lt.0) il3=iadr(istk(il3+1))
      il3s=il3

      typ3=istk(il3)
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
      m1=istk(il1+1)
      ilist=0
      nlist=0
      if(istk(il1).eq.15.or.istk(il1).eq.16) then
         ill=il1
         nlist=m1
         ll=sadr(ill+3+nlist)
         ilist=1
         il1=iadr(ll+istk(ill+1+ilist)-1)
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
      m1=istk(il1+1)
c
      if(abs(istk(il3)).eq.15.or.abs(istk(il3)).eq.16) goto 56
c     a leaf found
      if(ilist.ne.nlist) then
         call error(21)
         return
      endif
      ltop=top
      top=top0+1
      lstk(top)=lw
      if(istk(il1).eq.15) then
c     .     index last element is a list perform matrix insertion
         if(ilist.ne.nlist) then
            call error(21)
            return
         endif
c     .     matrix/vector element extraction
         
c     .     form indexes at the top of the stack
         ll=sadr(il1+m1+3)
         rhs=2
         do 54 i=1,m1
            rhs=rhs+1
            lstk(top+1)=lstk(top)+istk(il1+2+i)-istk(il1+1+i)
            top=top+1
 54      continue
         call dcopy(istk(il1+m1+2)-1,stk(ll),1,
     $        stk(lstk(top-m1)),1)
      else
         ll=ll+istk(ill+1+ilist)-1
         nn=istk(ill+2+ilist)-istk(ill+1+ilist)
         call dcopy(nn,stk(ll),1,stk(lstk(top)),1)
         lstk(top+1)=lstk(top)+nn
         rhs=3
         top=top+1
      endif
      call dcopy(vol2,stk(l2t),1,stk(lstk(top)),1)
      lstk(top+1)=lstk(top)+vol2


      lstk(bot-1)=lstk(bot)-ll3
      call dcopy(ll3,stk(lt3),1,stk(lstk(bot-1)),1)

c     .  form variable pointer
      top=top+1
      ilv=iadr(lstk(top))
      lk=lstk(bot-1)
      istk(ilv)=-istk(iadr(lk))
      istk(ilv+1)=lk
      istk(ilv+2)=bot-1
      lstk(top+1)=sadr(ilv+3)
c     .  back to allops for  standard insertion

      if (ptover(1,psiz)) return
c     save context
      istk(ilrec)=ilist
      istk(ilrec+1)=nlist
      istk(ilrec+2)=lhs
      istk(ilrec+3)=il3p
      istk(ilrec+4)=il3s
      istk(ilrec+5)=ilind
      istk(ilrec+6)=ltop
      istk(ilrec+7)=ltop0
      istk(ilrec+8)=lt3
      istk(ilrec+9)=m3

      pstk(pt)=ilrec
      rstk(pt)=406
      icall=4
      fin=2
c     *call* allops
      return
 55   continue
c     restore context
      ilrec=pstk(pt)
      pt=pt-1
      ilist=istk(ilrec)
      nlist=istk(ilrec+1)
      lhs=istk(ilrec+2)
      il3p=istk(ilrec+3)
      il3s=istk(ilrec+4)
      ilind=istk(ilrec+5)
      ltop=istk(ilrec+6)
      ltop0=istk(ilrec+7)
      lt3=istk(ilrec+8)
      m3=istk(ilrec+9)
c     
      m3s=istk(il3s+1)
      l3s=sadr(il3s+m3s+3)
      vol3s=istk(il3s+2+m3s)-1

      il1=iadr(lstk(top))
      if(istk(il1).eq.-1) then
c     .       matrix has been modified in place
         fin=istk(il1+2)
         l2t=lstk(fin)
         vol2=lstk(fin+1)-l2t
      else
         l2t=lstk(top)
         vol2=lstk(top+1)-l2t
         lw=lstk(top+1)
      endif
      top=ltop
      il2=iadr(l2t)
      typ2=istk(il2)
      ilist=ilist-1
      nlist=nlist-1
      n=istk(ilind+nlist-1)
      il3=il3p
      l3=sadr(il3+istk(il3+1)+3)

      goto 58


c
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
            il1=iadr(lstk(top))
            istk(il1)=-1
            istk(il1+1)=-1
            istk(il1+2)=istk(iadr(ltop0)+2)
            lstk(top+1)=lstk(top)+3
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
            il1=iadr(lstk(top))
            istk(il1)=-1
            istk(il1+1)=-1
            istk(il1+2)=istk(iadr(ltop0)+2)
            lstk(top+1)=lstk(top)+3
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
            call dcopy(l3s+vol3s-lt3,stk(lt3),1,stk(lr),1)
            lr=lr+l3s+vol3s-lt3
         endif
c     .  store result
         lrn=sadr(iln)
         lt=lstk(top)
         lstk(top)=lrn
         lstk(top+1)=lstk(top)+lr-lrn
         lhs=1
         call stackp(ids(1,pt),0)
c     .  notify that result has already been stored
         top=top+1
         lstk(top)=lt
         il1=iadr(lstk(top))
         istk(il1)=-1
         istk(il1+1)=-1
         istk(il1+2)=fin
         lstk(top+1)=lstk(top)+3
      elseif(typ2.ne.0) then
c%%2
c     change the specified element
         if (istk(il3+2+n)-istk(il3+1+n).eq.vol2) then
c     element is directly replaced 
            lr=l3+istk(il3+1+n)-1
            call dcopy(vol2,stk(l2t),1,stk(lr),1)
c     .     list has been modified in place
            il1=iadr(lstk(top))
            istk(il1)=-1
            istk(il1+1)=-1
            istk(il1+2)=istk(iadr(ltop0)+2)
            lstk(top+1)=lstk(top)+3
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
            call stackp(ids(1,pt),0)
c     .     notify that result has already been stored
            top=top+1
            lstk(top)=lt
            il1=iadr(lstk(top))
            istk(il1)=-1
            istk(il1+1)=-1
            istk(il1+2)=fin
            lstk(top+1)=lstk(top)+3
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
         call stackp(ids(1,pt),0)
c     .  notify that result has already been stored
         top=top+1
         lstk(top)=lt
         il1=iadr(lstk(top))
         istk(il1)=-1
         istk(il1+1)=-1
         istk(il1+2)=fin
         lstk(top+1)=lstk(top)+3
      endif
      goto 99
c

   99 return
      end

      integer function strpos(ptr,ns,chars,str,n)
      integer ptr(ns+1),ns,chars(*),str(n),n
      do 10 i=1,ns
         i1=ptr(i)
         i2=ptr(i+1)
         if(i2-i1.eq.n) then
            do 05 j=1,n
               if(str(j).ne.chars(i1-1+j)) goto 10
 05         continue
            strpos=i
            return
         endif
 10   continue
      strpos=0
      return
      end

      subroutine updptr(ilt,ind,nind,dvol)
c!purpose
c     update new data structure pointers recursively for nested lists
c!parameters
c     ilt : pointer to the beginning of the list
c     ind : vector of indexes giving modified entry path.
c     nind: size of the path
c     dvol: difference of the old and new sizes of the modified entry
c!
      integer ind(*),dvol
      integer iadr,sadr
      include '../stack.h'

c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      il=ilt
      if(nind.le.0) return
c
      do 20 k=1,nind
c     .  m : sub-list size
         m=istk(il+1)
         mi=ind(k)
c     .  update pointers to entries following the mi sub list entry
         do 10 i=mi,m
            istk(il+i+2)=istk(il+i+2)+dvol
 10      continue
c     .  il pointer to ind(k) sub-list entry
         il=iadr(sadr(il+3+m)+istk(il+1+mi)-1)
 20   continue
      end

      integer function subptr(ilt,ind,nind)
c     !purpose
c     get pointer to an entry of a  nested list
c     !parameters
c     ilt : pointer to the beginning of the list
c     ind : vector of indexes giving modified entry path.
c     nind: size of the path
c     !
      integer ind(nind)
      integer iadr,sadr
      include '../stack.h'
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      il=ilt
      if(nind.le.0) goto 30
c
      do 20 k=1,nind
c     .  m : sub-list size
         m=istk(il+1)
c     .  il pointer to ind(k) sub-list entry
         il=iadr(sadr(il+3+m)+istk(il+1+ind(k))-1)
 20   continue
 30     subptr=il
      end
