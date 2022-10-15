       subroutine print(id,lk,lunit)
c     ====================================================================
c     print object of id id(nsiz) stored at position lk in the stack
c     ====================================================================
      include '../stack.h'
      integer id(nsiz),lk
c     
      common / ptkeep / lwk
      integer itype,itypel,gettype
      integer fl,mode,m,n,it,lr,lc,nlr,lkeep,topk,lname
      logical getmat,ilog,getpoly,typer,clsave,getsimat
      logical crewimat ,islss,getilist,getbmat
      character*4 name
c$$$      character*(nlgh) mmname
      character*10 form
      character*200 ligne
      integer nclas
      integer comma,left,right,rparen,lparen,equal,eol,mactop
      integer iadr, sadr
      data comma/52/
      data left/54/,right/55/,rparen/42/,lparen/41/,equal/50/
      data eol/99/,nclas/29/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      islss=.false.
      lineln=lct(5)
      mode=lct(6)
      ndgt=lct(7)
c     
      if (lct(1) .lt. 0) return
c     
      if(id(1).ne.0) call prntid(id,-1,lunit)
 01   nlist=0
C     topk : free stack zone for working areas 
      topk=top+1
      li2=1
      lkeep=lstk(lk)
      itype=gettype(lk)
      call basout(io,lunit,' ')
      mactop=0
      if (abs(itype).eq.11.or.abs(itype).eq.13) mactop=1
c     
 05   goto (20,10,06,70,25,26,06,06,06,30,80,06,80,90,40,40),abs(itype)
 06   call msgs(33,lunit)
      goto 45
c     
c     ----polynomial matrices
 10   ilog=getpoly("print",lk,lk,it,m,n,name,namel,ilp,lr,lc)
C     working area (see dmpdsp)
      iwl = istk(ilp + m*n)-istk(ilp) + m*n+1
      if (.not.crewimat("print",topk,1,iwl,lw)) return
      if(it.eq.0) then 
         call dmpdsp(stk(lr+istk(ilp)),istk(ilp),m,m,n,name,
     &        namel,ndgt,mode,lineln,lunit,buf,istk(lw))
      else
         call msgs(34,lunit)
         call basout(io,lunit,' ')
         if(io.eq.-1) goto 99
         call dmpdsp(stk(lr+istk(ilp)),istk(ilp),m,m,n,name,
     &       namel,ndgt,mode, lineln,lunit,buf,istk(lw))
         call msgs(35,lunit)
         call basout(io,lunit,' ')
         if(io.eq.-1) goto 99
         call dmpdsp(stk(lc+istk(ilp)),istk(ilp),m,m,n,name,
     &        namel,ndgt,mode,lineln,lunit,buf,istk(lw))
      endif
      goto 45
c     
c     -------scalar matrices 
 20   ilog=getmat("print",lk,lk,it,m,n,lr,lc)
C     working area 
      if (.not.crewimat("print",topk,1,m*n+2*n,lw)) return
      if(m*n.eq.0) then
         call basout(io,lunit,'     []')
         goto 45
      endif
      if(it.eq.0) then 
         call dmdsp(stk(lr),m,m,n,ndgt,mode,lineln,lunit,buf,istk(lw))
      else 
         call wmdsp(stk(lr),stk(lc),m,m,n,ndgt,mode,lineln,lunit,
     &        buf,istk(lw))
      endif
      goto 45 
c     -------sparse scalar matrices 
 25   il=iadr(lstk(lk))
      m=istk(il+1)
      n=istk(il+2)
      it=istk(il+3)
      ne=istk(il+4)
      irc=il+5
      lr=sadr(irc+m+ne)
      if(it.eq.0) then
         call dspdsp(ne,istk(irc),stk(lr),m,n,ndgt,mode,
     $        lineln,lunit,buf)
      else
         call wspdsp(ne,istk(irc),stk(lr),stk(lr+ne),m,n,ndgt,mode,
     $        lineln,lunit,buf)
      endif
      goto 45 
c     -------sparse boolean matrices 
 26   il=iadr(lstk(lk))
      m=istk(il+1)
      n=istk(il+2)
      ne=istk(il+4)
      irc=il+5
      call lspdsp(ne,istk(irc),m,n,ndgt,mode,
     $        lineln,lunit,buf)
      goto 45 
c     -------matrices of string 
 30   ilog=getsimat("print",lk,lk,m,n,1,1,lr,nlr)
C     working area 
      if (.not.crewimat("print",topk,1,n,lw)) return
      call strdsp(istk(lr),istk(lr-m*n-1),m,n,lineln,lunit,istk(lw),buf)
      goto 45
c     -------lists 
 40   continue
      call listtype(lk,itypel)
      if (itypel.eq.1) goto 50
      if (itypel.eq.2) islss=.true.
c     check for typed lists 
      ilog=getilist("print",lk,lk,nl,1,ilt)
      illist=lstk(lk)
C     list ( we must deal with recursion ) 
 41   nlist=nlist+1
      if(nlist.le.1) then
         if(id(1).ne.0) then
            call cvnamel(id,ligne,1,li1)
         else
            li1=li2
         endif
      else
         li1=li2
      endif
      ligne(li1+1:li1+1)='>'  
      if(islss) ligne(li1+1:li1+1)='('
      li1=li1+2
      kl=0
 43   continue
      if(nl.eq.0) call basout(io,lunit,'     ()')
 45   if(nlist.le.0) goto 99
      if(lct(1).lt.0) goto 99
      kl=kl+1
      if(kl.gt.nl) goto 47
C ce qui est dessous est plus qu'etrange getilist fair un mvptr et un ptrback
c la valeur stockee dans ptkeep est ecrasee au secon appel de mvptr et le secon ptrback 
c ne retourne pas la premiere valeur sauvee mais la seconde..... et pourtant ca marche ?????
      call mvptr(topk,illist)
      ilog=getilist("print",topk,topk,nl,kl,ilk)
      call ptrback(topk)
      lstk(lk)=ilk
      itype=gettype(lk)
C     if the argument is rational list we must not treat it as a list 
      if (itype.eq.15.or.itype.eq.16) then 
c-compat the itype.eq.15 is retained for compatibility
         call listtype(lk,itypel)
         if (itypel.ne.1) then 
            if (.not.clsave(topk,illist,kl,li1,nl)) goto 99
         endif
      endif
      fl=int(log10(real(kl+0.1)))+1
      write(form,103) fl
 103  format('(i',i3,')')
      if(li1+fl.gt.200) then
         call error(109)
         return
      endif
      write(ligne(li1:li1+fl-1),form) kl
      li2=li1+fl-1
      buf(1:nlist+6)=' '
      call basout(io,lunit,' ')
      if(io.eq.-1) goto 99
      if(islss) then
         if(kl.eq.1) then
         call basout(io,lunit,buf(1:nlist+6)//ligne(1:li2)//
     + ')   (state-space system:)')
c         ligne(1:li2)=' '
         call basout(io,lunit,' ')
         endif
         if(kl.eq.2) then
         call basout(io,lunit,buf(1:nlist+6)//ligne(1:li2)//
     + ') = A matrix = ')
         call basout(io,lunit,' ')
         endif
         if(kl.eq.3) then
         call basout(io,lunit,buf(1:nlist+6)//ligne(1:li2)//
     + ') = B matrix = ')
         call basout(io,lunit,' ')
         endif
         if(kl.eq.4) then
         call basout(io,lunit,buf(1:nlist+6)//ligne(1:li2)//
     + ') = C matrix = ')
         call basout(io,lunit,' ')
         endif
         if(kl.eq.5) then
         call basout(io,lunit,buf(1:nlist+6)//ligne(1:li2)//
     + ') = D matrix = ')
         call basout(io,lunit,' ')
         endif
         if(kl.eq.6) then
         call basout(io,lunit,buf(1:nlist+6)//ligne(1:li2)//
     + ') = X0 (initial state) = ')
         call basout(io,lunit,' ')
         endif
         if(kl.eq.7) then
         call basout(io,lunit,buf(1:nlist+6)//ligne(1:li2)//
     + ') = Time domain = ')
         call basout(io,lunit,' ')
         endif
      else
         call basout(io,lunit,buf(1:nlist+6)//ligne(1:li2))
         call basout(io,lunit,' ')
      endif
      if(io.eq.-1) goto 99
      goto 05
c     end for list 
 47   continue
      nlist=nlist-1
      if(nlist.le.0) goto 99
      call clrest(topk,illist,kl,li1,nl)
      goto 43
c     
c     -----fractions rationnelles <=> list('r',matpoly,matpoly)
 50   continue
c     Numerateur ( 2ieme elt de la liste )
      ilog=getilist("print",lk,lk,nel,2,iln)
c     ---local change of lstk(topk)
      call mvptr(topk,iln)
      ivtn=gettype(topk)
      typer=.false.
      if ( ivtn.eq.1) then 
         ilog=getmat("print",topk,topk,it,m,n,lrn,lcn)
         lrn=lrn-1
         lcn=lcn-1
      elseif ( ivtn.eq.2) then 
         ilog=getpoly("print",topk,topk,it,m,n,name,
     $        namel,ilpn,lrn,lcn)
      else 
         typer=.true.
      endif 
c     ---back to proper value 
      call ptrback(topk)
c     denominateur (3ieme elt )
      ilog=getilist("print",lk,lk,nel,3,ild)
      call mvptr(topk,ild)
      ivtd=gettype(topk)
      if ( ivtd.eq.1) then 
         ilog=getmat("print",topk,topk,it,m1,n1,lrd,lcd)
         lrd=lrd-1
         lcd=lcd-1
      elseif ( ivtd.eq.2) then 
         ilog=getpoly("print",topk,topk,it,m1,n1,name,
     $        namel,ilpd,lrd,lcd)
      else 
         typer=.true.
      endif 
      call ptrback(topk)
C     --wrong type argument or not same size 
      if (typer.or.m1.ne.m.or.n1.ne.n) then 
         call cvname(id,buf(1:nlgh),1)
         call error(103)
         return 
      endif 
C	if num or den are scalar matrix we fill a working array 
C       with 1:m*n+1 (by creating a bmat),in which we can store integers
C       it's a trick to give a proper argument 
C       to dmrdsp which will treat the scalar matrix as a polynomial 
C       matrix of degre 0 
      if ( ivtn.eq.1.or.ivtd.eq.1) then 
         if (.not.crewimat("print",topk,1,m*n+1,idb)) return
         do 11 k=0,m*n
            istk(idb+k) =k+1
 11      continue 
         if (ivtn.eq.1) ilpn=idb
         if (ivtd.eq.1) ilpd=idb
      endif 
c     first working area in stk(lw)
C     of requested size iws 
      iws=n*(4+m)+1+istk(ilpn+n*m)+istk(ilpd+n*m)
      if ( ivtn.eq.1.or.ivtd.eq.1) then 
         if (.not.crewimat("print",topk+1,1,iws,lw)) return 
      else
         if (.not.crewimat("print",topk,1,iws,lw)) return 
      endif
      call dmrdsp(stk(lrn+istk(ilpn)),istk(ilpn),stk(lrd+istk(ilpd)),
     $     istk(ilpd),m,m,n,name,
     $     namel,ndgt,mode,lineln,lunit,buf, istk(lw))
      goto 45
c     
c     -----------boolean matrix
 70   ilog= getbmat("print",lk,lk,m,n,lr)
      if(m*n.eq.0) then
         call basout(io,lunit,'     []')
      else
         call dldsp(istk(lr),m,m,n,lineln,lunit,buf)
      endif
      goto 45
c     
c     ------------macros---- a changer 
 80   continue
      il=iadr(lstk(lk))
      l=istk(il+1)
      if(istk(il).lt.0) il=iadr(lstk(l))
      ilm=il
      l=1
      is1=left
      is2=right
      do 85 i=1,2
         n=istk(il+1)
         il=il+1
         buf(l:l)=alfa(is1+1)
         l=l+1
         if (n.ne.0) then
            do 83 j=1,n
               call cvnamel(istk(il+1),buf(l:),1,lname)
               l=l+lname
               buf(l:l)=alfa(comma+1)
               l=l+1
               il=il+nsiz
 83         continue
            l=l-1
         endif	
         buf(l:l)=alfa(is2+1)
         l=l+1
         if(i.eq.2) goto 85
         buf(l:l)=alfa(equal+1)
         l=l+1
         if(mactop.eq.1) then
            call cvnamel(idstk(1,lk),buf(l:),1,lname)
            l=l+lname
         else
            buf(l:)='function'
            l=l + 8
         endif
         is1=lparen
         is2=rparen
 85   continue
      il=il+1
      l=l-1
      call basout(io,wte,buf(1:l))
      if(io.eq.-1) goto 99
      n=istk(il)
      il=il+1
C     cas ou l'object macro est au top ( pas ds une liste )
      if (mactop.eq.1) then 
c$$$c        compiled macro [ display of source code ]
c$$$         if(istk(ilm).eq.13) then 
c$$$            call cvnamel(idstk(1,lk),mmname,1,lname)
c$$$            call xscion(iflag)
c$$$            if(iflag.eq.0) then
c$$$               buf='$SCI/bin/scilab -macro "'//mmname(1:lname)//'"  '
c$$$               call bashos(buf,27+lname,ls,ierr)
c$$$            else
c$$$               buf='$SCI/bin/scilab -macro "'//mmname(1:lname)//
c$$$     $              '" | $SCI/bin/xless &   '
c$$$               call bashos(buf,45+lname,ls,ierr)
c$$$            endif
c$$$            goto 89 
c$$$         endif
C     we supress the display of the code of a non compiled macro with goto 89
         isncf=1
         if (isncf.eq.1) goto 89
         l=il
 86      if(istk(l).eq.eol) goto 87
         l=l+1
         goto 86
 87      if(istk(l+1).eq.eol) goto 89
         n=l-il
         nl=lct(5)
         do 88 i1=1,n,nl
            i2=min(n,i1+nl-1)-i1+1
            call cvstr(i2,istk(il+i1-1),buf,1)
            call basout(io,wte,buf(1:i2))
            if(io.eq.-1) goto 99
 88      continue
         il=l+1
         l=il
         goto 86
      endif
 89   il=ilm
      goto 45
c     ------------library-- a changer aussi 
C     [14,n,codagedupath(n),nombre-de-nom,nclas+1 cases,suite des noms]
 90   illib=iadr(lstk(lk))
      n=istk(illib+1)
      illib=illib+2
      call cvstr(n,istk(illib),buf,1)
      call msgs(24,n)
      illib=illib+n
      n=istk(illib)
      illib=illib+nclas+2
      call prntid(istk(illib),n,lunit)
      goto 45
c     -----------end
 99   continue
      lstk(lk)=lkeep
      return
      end

      logical function clsave(topk,il,kl,li1,nl)
      include '../stack.h'   
      logical crewimat 
      integer topk,il,kl,li1
      clsave=.false.
      if (.not.crewimat("print",topk,1,4,lr)) return     
      clsave=.true.
      istk(lr)=il
      istk(lr+1)=kl
      istk(lr+2)=li1
      istk(lr+3)=nl
      topk=topk+1
      return
      end

      subroutine clrest(topk,il,kl,li1,nl)
      include '../stack.h'   
      integer topk,il,kl,li1
      logical getwimat 
      topk=topk-1
      if (.not.getwimat("print",topk,topk,m,n,lr)) return     
      il=istk(lr)
      kl=istk(lr+1)
      li1=istk(lr+2)
      nl=istk(lr+3)
      return
      end

      subroutine listtype(lk,itype)
      include '../stack.h'
c      implicit undefined (a-z)
      integer rat,gettype
      logical ilog,getilist,getsmat
c     return itype=0 for list, itype=1 for rat, itype=2 for lss
c     check for typed lists 
      integer nl,ilt,itype,topk,lk,mt,nt,ilc,nlr
      data rat/27/
c
      itype=0
      topk=lk
      ilog=getilist("print",lk,lk,nl,1,ilt)
      call mvptr(topk,ilt)
      if (ilt.ne.0) then
         if ( gettype(topk).eq.10) then 
            ilog=getsmat("print",topk,topk,mt,nt,1,1,ilc,nlr)
            if (nlr.eq.1.and.istk(ilc).eq.rat) then 
               itype=1
               goto  999
            endif
            if (istk(ilc).eq.21.and.istk(ilc+1).eq.28.
     +           and.istk(ilc+2).eq.28) then 
               itype=2
               goto 999
            endif
         endif
      endif
 999  call ptrback(topk)
      return
      end

