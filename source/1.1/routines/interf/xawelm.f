      subroutine xawelm
c     ====================================================================== 
c     Primitives liee a l'environnement  Xwindow 
c     ======================================================================
c     
      include '../stack.h'
c     
c     
      integer ixini,blank
      integer iadr,sadr
      data blank /40/
      data ixini/0/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' xawelm '//buf(1:4))
      endif
c     
      if(ixini.eq.0) then
c     initialisation de l'environnement Xwindow
         call inix()
         ixini=1
      endif
c     
      if(fin.eq.1) then
c     dialog box
         if(rhs.lt.1.or.rhs.gt.3) then 
            call error(39)
            return
         elseif(rhs.eq.1) then
c     on simule une chaine reduite a 1 blanc
            ilini=iadr(lstk(top+1))
            istk(ilini+4)=1
            istk(ilini+5)=2
            ni=1
            istk(ilini+5+ni)=blank
         else
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
         endif
c     
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
     $        istk(ilmes+4),n,istk(ilw),istk(ilmes+4),nrep,ierr)
         if(ierr.eq.3) then
            call error(26)
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
         if(rhs.ne.1) then
            err=1
            call error(39)
            return
         endif         
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
         call xmsg(istk(ils),n,istk(ilmes+4),ierr)
         if(ierr.eq.1) then 
            call error(112)
            return
         endif
         istk(ilmes)=0
         lstk(top+1)=sadr(ilmes+1)
         return
      endif
c     
      if(fin.eq.3) then
c     choose
         if(rhs.ne.2) then 
            call error(39)
            return
         endif
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
     $        istk(ils),n,istk(ilmes+4),nr,ierr)
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
c     mdialog
c     dialog box
         if(rhs.ne.3) then 
            call error(39)
            return
         endif
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
c     
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
         if(istk(ilmes+1).ne.ni) then
            call error(42)
            return
         endif
         top=top-1
         
         illab=iadr(lstk(top))
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
         
         ilw=ilmes+4+ni
c     
         ierr=iadr(lstk(bot))-ilw
         err=-sadr(ierr)
         call xmdial(istk(illab+5+nlab),istk(illab+4),nlab,
     $        istk(ilini+5+ni),istk(ilini+4),
     $        istk(ilmes+5+n),istk(ilmes+4),ni,
     $        istk(illab+5+ni),istk(illab+4),ierr)
         if(ierr.eq.3) then
            call error(26)
            return
         elseif(ierr.eq.2) then
            call error(17)
            return
         elseif(ierr.eq.1) then
            call error(112)
            return
         endif
         if(ni.eq.0) then
            istk(illab)=1
            istk(illab+1)=0
            istk(illab+2)=0
            istk(illab+3)=0
            lstk(top+1)=sadr(illab+4)
         else
            istk(illab+1)=ni
            istk(illab+2)=1
            lstk(top+1)=sadr(illab+5+ni+istk(illab+4+ni))
            return
         endif
         return
      endif
c     
 9999 return
         
      end
