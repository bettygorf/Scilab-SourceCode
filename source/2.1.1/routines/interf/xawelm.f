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
c     Unused 
c      if(ixini.eq.0) then
c     initialisation de l'environnement Xwindow
c         call inix()
c         ixini=1
c      endif
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
 9999 return
         
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
      integer lr1,nlr1,nrtot,lr,nlr,lrk,m,n,mm,adr,il,m1,n1
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
         il=adr(lr,0)
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











