      subroutine xawelm
c     ====================================================================== 
c     Primitives liee a l'environnement  Xwindow 
c     ======================================================================
c     
      include '../stack.h'
c     
c     
      integer blank
      integer iadr,sadr
      integer verb,iwin,owin
c
      integer typ
      character*24 fname
      logical full
      data blank /40/

c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' xawelm '//buf(1:4))
      endif
c     
      if(fin.eq.1) then
c     dialog box
         if(rhs.lt.1.or.rhs.gt.3) then 
            call error(39)
            return
         endif
         if(rhs.eq.1) then
c     on simule une chaine reduite a 1 blanc
            top=top+1
            ilini=iadr(lstk(top))
            istk(ilini)=10
            istk(ilini+1)=1
            istk(ilini+2)=1
            istk(ilini+3)=0
            istk(ilini+4)=1
            istk(ilini+5)=2
            istk(ilini+6)=blank
            lstk(top+1)=sadr(ilini+7)
         endif
c
         if(rhs.lt.3) then
            top=top+1
            ilbtn=iadr(lstk(top))
            istk(ilbtn)=10
            istk(ilbtn+1)=2
            istk(ilbtn+2)=1
            istk(ilbtn+3)=0
            istk(ilbtn+4)=1
            istk(ilbtn+5)=3
            istk(ilbtn+6)=9
            call cvstr(2,istk(ilbtn+7),'Ok',0)
            call cvstr(6,istk(ilbtn+9),'Cancel',0)
            lstk(top+1)=sadr(ilbtn+15)
            rhs=rhs+1
         else
            ilbtn=iadr(lstk(top))
            if(istk(ilbtn).ne.10) then
               err=3
               call error(55)
               return
            endif
            if(istk(ilbtn+1)*istk(ilbtn+2).ne.2) then
               err=3
               call error(60)
               return
            endif
         endif
         top=top-1
c     valeur initiale
         ilini=iadr(lstk(top))
         if(istk(ilini).ne.10) then
            err=2
            call error(55)
            return
         endif
         if(istk(ilini+2).ne.1) then
            err=2
            call error(89)
            return
         endif
         ni=istk(ilini+1)
         top=top-1

c     label
         ilmes=iadr(lstk(top))
         if(istk(ilmes).ne.10) then
            err=1
            call error(55)
            return
         endif
         if(istk(ilmes+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         n=istk(ilmes+1)
c     retour maxi=200 lignes
         ilw=ilmes+4+201
c     
         nrep=200
         ierr=iadr(lstk(bot))-ilw
         err=-sadr(ierr)
         call xdialg(istk(ilini+5+ni),istk(ilini+4),ni,istk(ilmes+5+n),
     $        istk(ilmes+4),n,istk(ilbtn+7),istk(ilbtn+4),2,
     $        istk(ilw),istk(ilmes+4),nrep,ierr)
         if(ierr.eq.3) then
            call error(113)
            return
         elseif(ierr.eq.2) then
            call error(17)
            return
         elseif(ierr.eq.1) then
            call error(112)
            return
         endif
         if(nrep.eq.0) then
            istk(ilmes)=1
            istk(ilmes+1)=0
            istk(ilmes+2)=0
            istk(ilmes+3)=0
            lstk(top+1)=sadr(ilmes+4)
            return
         endif
         istk(ilmes+1)=nrep
         il=ilmes+5+nrep
         call icopy(istk(il-1)-1,istk(ilw),1,istk(il),1)
         lstk(top+1)=sadr(il+istk(il-1))
         return
      endif
c     
      if(fin.eq.2) then
c     message box
         if(rhs.ne.1.and.rhs.ne.2) then
            err=1
            call error(39)
            return
         endif
         if(rhs.eq.1) then
c     buttons are not specified
            top=top+1
            ilbtn=iadr(lstk(top))
            istk(ilbtn)=10
            istk(ilbtn+1)=1
            istk(ilbtn+2)=1
            istk(ilbtn+3)=0
            istk(ilbtn+4)=1
            istk(ilbtn+5)=3
            call cvstr(2,istk(ilbtn+6),'Ok',0)
            lstk(top+1)=sadr(ilbtn+8)
            rhs=rhs+1
            nb=1
         else
            ilbtn=iadr(lstk(top))
            if(istk(ilbtn).ne.10) then
               err=2
               call error(55)
               return
            endif
            nb=istk(ilbtn+1)*istk(ilbtn+2)
            if(nb.gt.2) then
               err=2
               call error(60)
               return
            endif
         endif
         top=top-1
         ilmes=iadr(lstk(top))
         if(istk(ilmes).ne.10) then
            err=1
            call error(55)
            return
         endif
         if(istk(ilmes+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         n=istk(ilmes+1)
         ils=ilmes+5+n
         call xmsg(istk(ils),n,istk(ilmes+4),istk(ilbtn+5+nb),
     $        istk(ilbtn+4),nb,nr,ierr)
         if(ierr.eq.1) then 
            call error(112)
            return
         endif
         if(nb.eq.1) then
            istk(ilmes)=0
            lstk(top+1)=sadr(ilmes+1)
         else
            istk(ilmes)=1
            istk(ilmes+1)=1
            istk(ilmes+2)=1
            istk(ilmes+3)=0
            lmes=sadr(ilmes+4)
            stk(lmes)=nr
            lstk(top+1)=lmes+1
         endif
         return
      endif
c     
      if(fin.eq.3) then
c     choose
         if(rhs.lt.2.or.rhs.gt.3) then 
            call error(39)
            return
         endif
         if(rhs.eq.2) then
            top=top+1
            ilbtn=iadr(lstk(top))
            istk(ilbtn)=10
            istk(ilbtn+1)=1
            istk(ilbtn+2)=1
            istk(ilbtn+3)=0
            istk(ilbtn+4)=1
            istk(ilbtn+5)=7
            call cvstr(6,istk(ilbtn+6),'Cancel',0)
            lstk(top+1)=sadr(ilbtn+12)
            rhs=rhs+1
         else
            ilbtn=iadr(lstk(top))
            if(istk(ilbtn).ne.10) then
               err=3
               call error(55)
               return
            endif
            if(istk(ilbtn+1)*istk(ilbtn+2).ne.1) then
               err=3
               call error(60)
               return
            endif
         endif
         top=top-1

         ildes=iadr(lstk(top))
         if(istk(ildes).ne.10) then
            err=2
            call error(55)
            return
         endif
         nd=istk(ildes+1)*istk(ildes+2)
         top=top-1
c     
         ilmes=iadr(lstk(top))
         if(istk(ilmes).ne.10) then
            err=1
            call error(55)
            return
         endif
         n=istk(ilmes+1)*istk(ilmes+2)
         ils=ilmes+5+n
         l=sadr(ilmes+4)
         call xchoose(istk(ildes+5+nd),istk(ildes+4),nd,
     $        istk(ils),n,istk(ilmes+4),istk(ilbtn+6),istk(ilbtn+4),1,
     $        nr,ierr)
         if(ierr.eq.1) then 
            call error(112)
            return
         endif
         stk(l)=nr
         istk(ilmes)=1
         istk(ilmes+1)=1
         istk(ilmes+2)=1
         istk(ilmes+3)=0
         lstk(top+1)=l+1
         return
      endif
c     
      
      if(fin.eq.4) then
c     mdialog et matrix dialog
         if(rhs.ne.3.and.rhs.ne.4) then 
            call error(39)
            return
         endif
         ilini=iadr(lstk(top))
         if(istk(ilini).ne.10) then
            err=rhs
            call error(55)
            return
         endif
         ni=istk(ilini+1)
         mi=istk(ilini+2)
         top=top-1
c     
         if(rhs.eq.4) then
c     matriciel
            inc=1
            ilmesh=iadr(lstk(top))
            if(istk(ilmesh).ne.10) then
               err=rhs-1
               call error(55)
               return
            endif
            if(istk(ilmesh+1)*istk(ilmesh+2).ne.mi) then
               call error(42)
               return
            endif
            top=top-1
         else
            inc=0
            ni=ni*mi
            mi=1
         endif

c
         ilmesv=iadr(lstk(top))
         if(istk(ilmesv).ne.10) then
            err=rhs-1-inc
            call error(55)
            return
         endif
          if(istk(ilmesv+1)*istk(ilmesv+2).ne.ni) then
            call error(42)
            return
         endif
         top=top-1

         
         illab=iadr(lstk(top))
         ilres=illab
         if(istk(illab).ne.10) then
            err=1
            call error(55)
            return
         endif
         if(istk(illab+2).ne.1) then
            err=1
            call error(89)
            return
         endif
         nlab=istk(illab+1)
         
         nmi=ni*mi
         ilw=ilres+4+nmi
c     
         ierr=iadr(lstk(bot))-ilw
         err=-sadr(ierr)
         if(rhs.eq.3) then
            call xmdial(istk(illab+5+nlab),istk(illab+4),nlab,
     $           istk(ilini+5+ni),istk(ilini+4),
     $           istk(ilmesv+5+ni),istk(ilmesv+4),ni,
     $           istk(ilres+5+ni),istk(ilres+4),ierr)
         else
            call xmatdg(istk(illab+5+nlab),istk(illab+4),nlab,
     $           istk(ilini+5+nmi),istk(ilini+4),
     $           istk(ilmesv+5+ni),istk(ilmesv+4),
     $           istk(ilmesh+5+mi),istk(ilmesh+4),ni,mi,
     $           istk(ilres+5+nmi),istk(ilres+4),ierr)

         endif
         if(ierr.eq.3) then
            call error(113)
            return
         elseif(ierr.eq.2) then
            call error(17)
            return
         elseif(ierr.eq.1) then
            call error(112)
            return
         endif
         if(ni.eq.0) then
            istk(ilres)=1
            istk(ilres+1)=0
            istk(ilres+2)=0
            istk(ilres+3)=0
            lstk(top+1)=sadr(ilres+4)
         else
            istk(ilres)=10
            istk(ilres+1)=ni
            istk(ilres+2)=mi
            istk(ilres+3)=0
            lstk(top+1)=sadr(ilres+5+nmi+istk(ilres+4+nmi))
            return
         endif
         return
      endif
c     
      if(fin.eq.5) then
         call sconvert("sconvert")
      endif
      if(fin.eq.6) then
         call idialog("idialog")
      endif
      if(fin.eq.7) then
         call scichoice("choices")
      endif
      if (fin.eq.12) then
         call intsxgetfile("xgetfile")
      endif

      if (fin .eq. 8) then
c     addmenu
         call xscion(inxsci)
         if (inxsci.eq.0) then
            buf='synchronous actions are not supported with -nw option'
            call error(1020)
            return
         endif
         if (rhs .lt. 1.or.rhs.gt.4) then
          call error(39)
          return
        endif
        if (lhs .ne. 1) then
          call error(41)
          return
        endif
c       checking last variable
c
        ill=iadr(lstk(top))
        if(istk(ill).eq.15) then
           full=.true.
c     .    last variable is list(typ,fname)
           nl=istk(ill+1)
           if(nl.ne.2) then
              buf='Last argument of addmenu must be list(typ,fname)'
              call error(9990)
              return
           endif
           ll=sadr(ill+nl+3)
c      
c     .    --   subvariable typ
           ille1=iadr(ll+istk(ill+2)-1)
           lle1 = sadr(ille1+4)
           if (istk(ille1).ne.1) then
              buf='Last argument of addmenu must be list(typ,fname)'
              call error(9990)
              return
           endif
           typ=stk(lle1)
c      
c     .    --   subvariable fname
           ille2=iadr(ll+istk(ill+3)-1)
           if (istk(ille2).ne.10) then
              buf='Last argument of addmenu must be list(typ,fname)'
              call error(9990)
              return
           endif
           if (istk(ille2+1)*istk(ille2+2) .ne. 1) then
              buf='Last argument of addmenu must be list(typ,fname)'
              call error(9990)
              return
           endif
           lf=ille2+6
           nf=istk(ille2+5)-1
           top=top-1
           rhs=rhs-1
        else
           typ=0
           full=.false.
        endif
c       checking variable win (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .eq. 1) then
c     in a graphic window
           if (istk(il1+1)*istk(il1+2) .ne. 1) then
              err = 1
              call error(89)
              return
           endif
           iwin= stk(sadr(il1+4))
           iskip=0
        elseif(istk(il1).eq.10) then
c     in main window
           iskip=1
           iwin=-1
        else
           err = 1
           call error(44)
           return
        endif

c       checking variable name (number 2-iskip)
c
        il2 = iadr(lstk(top-rhs+2-iskip))
        if (istk(il2) .ne. 10) then
           err = 2-iskip
           call error(55)
           return
        endif
        if (istk(il2+1)*istk(il2+2) .ne. 1) then
          err = 2-iskip
          call error(89)
          return
        endif
        l2=il2+6
        n=istk(l2-1)-1
        call cvstr(n,istk(l2),buf,1)
        buf(n+1:n+1)=char(0)
        if (full) then
           call cvstr(nf,istk(lf),fname,1)
           fname(nf+1:nf+1)=char(0)
        else
           fname=buf(1:n+1)
        endif
           

        if (rhs.eq.3-iskip) then
c       checking variable submenu names (number 3-iskip)
c
           il3 = iadr(lstk(top-rhs+3-iskip))
           if (istk(il3) .ne. 10) then
              err = 3-iskip
              call error(55)
              return
           endif
           n3=istk(il3+1)*istk(il3+2)
           l3=il3+5+n3

           top=top-rhs+1
           istk(il1)=0
           lstk(top+1)=lstk(top)+1
           verb=0
           if(iwin.ge.0) then
              call dr('xget'//char(0),'window'//char(0),verb,owin,na,
     $             v,v,v,dv,dv,dv,dv)
              call dr('xset'//char(0),'window'//char(0),iwin,iv,iv,
     $             v,v,v,dv,dv,dv,dv)
              call addmen(iwin,buf,istk(l3),istk(il3+4),n3,typ, fname,
     $             ierr) 
              call dr('xset'//char(0),'window'//char(0),owin,iv,iv,
     $             v,v,v,dv,dv,dv,dv)
           else
              call addmen(iwin,buf,istk(l3),istk(il3+4),n3,typ, fname,
     $             ierr) 
           endif
        else
           top=top-rhs+1
           istk(il1)=0
           lstk(top+1)=lstk(top)+1
           verb=0
           if(iwin.ge.0) then
              call dr('xget'//char(0),'window'//char(0),verb,owin,na,
     $             v,v,v,dv,dv,dv,dv)
              call dr('xset'//char(0),'window'//char(0),iwin,iv,iv,
     $             v,v,v,dv,dv,dv,dv)
              call addmen(iwin,buf,0,0,0,typ, fname,ierr)
              call dr('xset'//char(0),'window'//char(0),owin,iv,iv,
     $             v,v,v,dv,dv,dv,dv)
           else
              call addmen(iwin,buf,0,0,0,typ,fname,ierr)
           endif
        endif
        return
      endif

      if (fin .eq. 9) then
c     delmenu
         call xscion(inxsci)
         if (inxsci.eq.0) then
            return
         endif
         if (rhs .ne. 2.and.rhs .ne. 1) then
          call error(39)
          return
        endif
        if (lhs .ne. 1) then
          call error(41)
          return
        endif
c       checking variable win (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .eq. 1) then
c     in a graphic window
           if (istk(il1+1)*istk(il1+2) .ne. 1) then
              err = 1
              call error(89)
              return
           endif
           iskip=0
           iwin= stk(sadr(il1+4))
        elseif(istk(il1).eq.10) then
c     in main window
           iskip=1
           iwin=-1
        else
           err = 1
           call error(44)
           return
        endif

c       checking variable name (number 2-iskip)
c
        il2 = iadr(lstk(top-rhs+2-iskip))
        if (istk(il2) .ne. 10) then
           err = 2-iskip
           call error(55)
           return
        endif
        if (istk(il2+1)*istk(il2+2) .ne. 1) then
          err = 2-iskip
          call error(89)
          return
        endif
        l2=il2+6
        n=istk(l2-1)-1
        call cvstr(n,istk(l2),buf,1)
        buf(n+1:n+1)=char(0)        
        top=top-rhs+1
        istk(il1)=0
        lstk(top+1)=lstk(top)+1
        call delbtn(iwin,buf)

        return
      endif
c
      if (fin .eq. 10.or.fin .eq. 11) then
c     set/unset menu
         call xscion(inxsci)
         if (inxsci.eq.0) then
            return
         endif
         if (rhs .lt. 1) then
          call error(39)
          return
        endif
        if (lhs .ne. 1) then
          call error(41)
          return
        endif
c       checking last variable 
c
        il=iadr(lstk(top))
        if(istk(il).eq.1) then
c     .    set/unset submenu
           num=stk(sadr(il+4))
           top=top-1
           rhs=rhs-1
        else
           num=0
        endif
         if (rhs .ne. 1 .and. rhs .ne. 2) then
          call error(39)
          return
        endif

c       checking variable win (number 1)
c       
        il1 = iadr(lstk(top-rhs+1))
        if (istk(il1) .eq. 1) then
c     in a graphic window
           if (istk(il1+1)*istk(il1+2) .ne. 1) then
              err = 1
              call error(89)
              return
           endif
           iwin= stk(sadr(il1+4))
           iskip=0
        elseif(istk(il1).eq.10) then
c     in main window
           iskip=1
           iwin=-1
        else
           err = 1
           call error(44)
           return
        endif

c       checking variable name (number 2-iskip)
c
        il2 = iadr(lstk(top-rhs+2-iskip))
        if (istk(il2) .ne. 10) then
           err = 2-iskip
           call error(55)
           return
        endif
        if (istk(il2+1)*istk(il2+2) .ne. 1) then
          err = 2-iskip
          call error(89)
          return
        endif
        l2=il2+6
        n=istk(l2-1)-1
        call cvstr(n,istk(l2),buf,1)
        buf(n+1:n+1)=char(0)

        top=top-rhs+1
        istk(il1)=0
        lstk(top+1)=lstk(top)+1
        if (fin.eq.10) then
           call setmen(iwin,buf,0,0,num,ierr)
        elseif (fin.eq.11) then
           call unsmen(iwin,buf,0,0,num,ierr)
        endif
        return
      endif


 9999 return
      end


      subroutine scichoice(fname) 
      character*(*) fname
cc    implicit undefined (a-z)
      include '../stack.h'
c     mdialog et matrix dialog
      integer topk,m1,n1,lr1,il1,iadr
      integer m3,n3,il3,ild3,m2,n2,il2,ild2
      logical getrvect,getwsmat,checkrhs
      iadr(l)=l+l-1
      if (.not.checkrhs(fname,3,3)) return
      topk=top
C     le troisime argument est un vecteur de chaine de caratere
      if (.not.getwsmat(fname,topk,top,m3,n3,il3,ild3)) return
      if (m3.ne.1.and.n3.ne.1) then 
         buf= fname// ': Third argument must be a vector'
         call error(999)
         return
      endif
      top=top-1
C     le deuxieme argument est un tableau de chaine de catatere
      if (.not.getwsmat(fname,topk,top,m2,n2,il2,ild2)) return
      top=top-1
c     le premier argument est un tableau d'entiers 
      if(.not.getrvect(fname,topk,top,m1,n1,lr1))return      
      il1=iadr(lr1)
      call entier(m1*n1,stk(lr1),istk(il1))
      call xchoices(istk(il2),istk(ild2),m2*n2,
     $     istk(il3),istk(ild3),m3*n3, istk(il1),m1*n1)
      call entier2d(m1*n1,stk(lr1),istk(il1))
      return
      end


c SCILAB function : xgetfile, fin = 1
       subroutine intsxgetfile(fname)
c
       character*(*) fname
       integer topk,rhsk,topl
       logical checkrhs,checklhs,cresmat2,getsmat,checkval,bufstore,crep
     $ ointer,crestring
       include '../stack.h'
c
       integer iadr, sadr
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       lbuf = 1
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,0,2)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable a (number 1)
c       
       if(rhs .le. 0) then
        top = top+1
        rhs = rhs+1
        nlr1 = 3
        if(.not.cresmat2(fname,top,nlr1,lr1)) return
        call cvstr(nlr1,istk(lr1),'*.*',0)
       endif
       if(.not.getsmat(fname,top,top-rhs+1,m1,n1,1,1,lr1,nlr1)) return
       if(.not.checkval(fname,m1*n1,1)) return
c       checking variable dirname (number 2)
c       
       if(rhs .le. 1) then
        top = top+1
        rhs = rhs+1
        nlr2 = 1
        if(.not.cresmat2(fname,top,nlr2,lr2)) return
        call cvstr(nlr2,istk(lr2),'.',0)
       endif
       if(.not.getsmat(fname,top,top-rhs+2,m2,n2,1,1,lr2,nlr2)) return
       if(.not.checkval(fname,m2*n2,1)) return
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
       if(.not.bufstore(fname,lbuf,lbufi1,lbuff1,lr1,nlr1)) return
       if(.not.bufstore(fname,lbuf,lbufi2,lbuff2,lr2,nlr2)) return
       if(.not.crepointer(fname,top+1,lw3)) return
       call xgetfile(buf(lbufi1:lbuff1),buf(lbufi2:lbuff2),stk(lw3),ne5,
     $ err,rhsk)
       if(err .gt. 0) then 
        buf = fname // 'Internal Error' 
        call error(999)
       endif
c
       topk=top-rhs
       topl=top+1
c     
       if(lhs .ge. 1) then
c       --------------output variable: res
        top=topl+1
        if(.not.crestring(fname,top,ne5,ilrs)) return
        call ccharf(ne5,stk(lw3),istk(ilrs))
       endif
c     Putting in order the stack
       if(lhs .ge. 1) then
        call copyobj(fname,topl+1,topk+1)
       endif
       top=topk+lhs
       return
       end
c



      logical  function getwsmat(fname,topk,lw,m,n,ilr,ilrd)
C     renvoit .true. si l'argument en lw est une matrice
C     de chaine de caractere
C     sinon renvoit .false. et appelle error
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       lw : position dans la pile
C     Sortie :
C	[m,n] caracteristiques de la matrice
C       ilr : pointe sur le premier caractere de a
C            le caractere se recupere par abs(istk(ilr)) qui est
C            un codage Scilab des chaines
C       ilrd : pointe vers le descripteur des taille de chaque element 
C            c'est un tableau d'entiers istk(ilrd)
C      implicit undefined (a-z)
      integer topk,lw,m,n,ilr,ilrd,il
      integer iadr,sadr
      character fname*(*)
      include '../stack.h'
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
      if(istk(il).ne.10) then
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         call error(207)
         getwsmat=.false.
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      ilrd=il+4
      ilr=il+5+m*n
      getwsmat=.true.
      return
      end

      subroutine sconvert(fname)
C     see sconvert1
      character*(*) fname
cc    implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs
      if  (.not.checkrhs(fname,1,1)) return
      call sconvert1("sconvert",top,top+1)
      call copyobj(fname,top+1,top)
      return
      end

      subroutine sconvert1(fname,objpos,lww)
C====================================================================
C     from string vector to a unique string with \n as separator
C     and reverse conversion.
C      sconvert(["a","bb","ccc"]')=> "a\nbb\nccc\n"
C      sconvert("a\nbb\nccc\n")==> ["a","bb","ccc"]' 
C     objpos : position on the stack of the string matrix to convert 
C     lww   : first position on the stack that can be used for 
C             local work storage 
C     the result is stored at lww
C===================================================================
      character*(*) fname
cc    implicit undefined (a-z)
      include '../stack.h'
      logical getsmat,cresmat,cremat,cresmat1
      integer lr1,nlr1,nrtot,lr,nlr,lrk,m,n,mm,iadr,il,m1,n1
      integer objpos
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      nrtot=0
      if(.not.getsmat(fname,top,objpos,m,n,1,1,lr1,nlr1))return
      if (m*n.ne.1.or.(m.eq.1.and.istk(lr1+nlr1-1).ne.99)) then 
C     ======================from vector to string with \n 
 1000    if (n.ne.1) then 
            buf=fname//' : column vector expected as argument'
            call error(999)
            return
         endif
         do 10 i=1,m
            call getsimat(fname,top,objpos,m,n,i,1,lr1,nlr1)
            nrtot=nrtot+nlr1
 10      continue
         if (.not.cresmat(fname,lww,1,1,nrtot+m)) return
         call getsimat(fname,lww,lww,m1,n1,1,1,lr,nlr)
         lrk=lr
         do 20 i=1,m
            call getsimat(fname,top,objpos,mm,n,i,1,lr1,nlr1)
            call icopy(nlr1,istk(lr1),1,istk(lr),1)
            istk(lr+nlr1)=99
            lr=lr+nlr1+1
 20      continue  
      else
C     =====================from string to vector
         m=0
         do 30 i=0,nlr1-1
            if (istk(lr1+i).eq.99) m=m+1
 30      continue
C     tableau de travail de stockage des tailles ..
         if (.not.cremat(fname,lww,0,m,1,lr,lc)) return
         il=iadr(lr)
         mm=1
         nc=0
         do 40 i=0,nlr1-1
            nc=nc+1
            if (istk(lr1+i).eq.99) then 
               istk(il+mm-1)=nc-1
               mm=mm+1
               nc=0
            endif
 40      continue
         if (.not.cresmat1(fname,lww+1,m,istk(il))) return
         lrn=lr1
         do 50  i=1,m
            call getsimat(fname,top,lww+1,mm,n,i,1,lr,nlr)
            call icopy(nlr,istk(lrn),1,istk(lr),1)
            lrn=lrn+istk(il+i-1)+1
 50      continue
         call copyobj(fname,lww+1,lww)
         return
      endif
      return
      end

      subroutine tdialog(fname)
C     ====================================================================
C     only a test routine to test cvstr1 
C     and cstk(*)
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,cresmat
      integer topk,lr1,nlr1,clr1,cadr
      character cstk(8*vsiz)
      equivalence (cstk(1),stk(1))
      cadr(l)=4*l-3
      if  (.not.checkrhs(fname,1,1)) return
      topk=top
      call getsimat(fname,top,top,m,n,1,1,lr1,nlr1)
      clr1=cadr(lr1)
      call cvstr1(nlr1,istk(lr1),cstk(clr1),1)
C      write(06,*),'chaine',nlr1,'[]=' ,(cstk(clr1+i-1),i=1,nlr1)
      call ctest(cstk(clr1),nlr1)
C      write(06,*),'chaine',nlr1,'[]=' ,(cstk(clr1+i-1),i=1,nlr1)
      call cvstr1(nlr1,istk(lr1),cstk(clr1),0)
      if (.not.cresmat(fname,top,1,1,nlr1)) return
      return
      end

      subroutine idialog(fname)
C     attend deux arguments de type string(1,1) obtenus par 
C     sconvert : ne fait pas de verification 
C     cette routine est interne 
C     ====================================================================
      character*(*) fname
c      implicit undefined (a-z)
      include '../stack.h'
      logical checkrhs,cresmat,cresmat2
      integer topk,lr1,nlr1,clr1,lr2,nlr2,clr2,lr3,nlr3,clr3,cadr
      character cstk(8*vsiz)
      equivalence (cstk(1),stk(1))
      cadr(l)=4*l-3
      if  (.not.checkrhs(fname,2,2)) return
      topk=top
C     ---get first string 
      call sconvert1(fname,top-1,top+1)
      call getsimat(fname,top,top+1,m,n,1,1,lr1,nlr1)
      clr1=cadr(lr1)
      call cvstr1(nlr1,istk(lr1),cstk(clr1),1)
C     ---get second string 
      call sconvert1(fname,top,top+2)
      call getsimat(fname,top,top+2,m,n,1,1,lr2,nlr2)
      clr2=cadr(lr2)
      call cvstr1(nlr2,istk(lr2),cstk(clr2),1)
C     ---create string work area with the rest of stack
      if (.not.cresmat2(fname,top+3,nlr3,lr3)) return
      clr3=cadr(lr3)
      call idialg(cstk(clr1),nlr1,cstk(clr2),nlr2,cstk(clr3),nlr3)
C     convert and copy arg 3 on top of stack
      if (.not.cresmat(fname,top+3,1,1,nlr3)) return
      call getsimat(fname,top,top+3,m,n,1,1,lr3,nlr3)
      clr3=cadr(lr3)
      call cvstr1(nlr3,istk(lr3),cstk(clr3),0)
      call sconvert1(fname,top+3,top+4)
      call copyobj(fname,top+4,top-1)
      top=top-1
      return
      end

      subroutine cvstr1(n,line,str,job)
C     ====================================================================
C     comme cvstr mais conserve les retours a la ligne et permet une conversion
C     sur place ( line et str pointent sur la meme zone )
C     ====================================================================
      include '../stack.h'
      character str(*)
      integer n,line(n)
      if(job.ne.0) then 
         call cvs2c(n,line,str,csiz,alfa,alfb)
      else
         call cvc2s(n,line,str,csiz,alfa,alfb)
      endif
      return
      end
