      subroutine funs(id)
c     ====================================================================
c     scan function and macros list
c     ====================================================================
      include '../stack.h'
      integer id(nsiz),id1(nsiz)
c
      logical eqid,loaded
      integer srhs,percen,blank,fptr,mode(2)
      integer iadr,sadr
      
      data nclas/29/,percen/56/,blank/40/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
c     recherche dans les bibliotheques seulement
      if(fin.eq.-3) goto 35
c     
c     
c     recherche parmi les fonctions fortran
      call funtab(id,fptr,1)
      if(fptr.le.0) then
         if(comp(1).eq.0) goto 30
         fin=0
         fun=0
      else
         fun = fptr/100
         fin = mod(fptr,100)
      endif
      return
c     
c     est-ce une macro existant dans la pile?
 30   k=bot-1
 31   k=k+1
      if(k.gt.isiz) goto 35
      if(.not.eqid(idstk(1,k),id)) goto 31
      il=iadr(lstk(k))
      if(istk(il).ne.11.and.istk(il).ne.13) goto 35
      fin=k
      fun=-1
      return
c     
c     recherche dans les bibliotheques de macro
 35   k=bot-1
 36   k=k+1
      if(k.gt.isiz) then
         fin=0
         fun=0
         return
      endif
      il=iadr(lstk(k))
      if(istk(il).ne.14) goto 36
      nbibn=istk(il+1)
      lbibn=il+2
      il=lbibn+nbibn
      ilp=il+1
      ip=mod(id(1),256)
      if(ip.eq.percen) ip=mod(id(1)-ip,256*256)/256
      ip=ip-9
      if(ip.gt.nclas) goto 36
      n=istk(ilp+ip)-istk(ilp+ip-1)
      if(n.eq.0) goto 36
      iln=ilp+nclas+1+(istk(ilp+ip-1)-1)*nsiz
      do 37 l=1,n
         if(eqid(id,istk(iln))) goto 39
         iln=iln+nsiz
 37   continue
      goto 36
c     
c     
 39   if(fin.ne.-1.and.fin.ne.-3) goto 40
      fun=k
      fin=l
      return
c     
 40   fun=-2
      fin=l
c     
c     chargement
      n=nbibn
      call cvstr(n,istk(lbibn),buf,1)
      call cvname(id,buf(n+1:n+nlgh),1)
      n=n+nlgh+1
 41   n=n-1
      if(buf(n:n).eq.' ') goto 41
      buf(n+1:n+4)='.bin'
      n=n+4
      lunit=0
      mode(1)=-101
      mode(2)= 0
      call clunit(lunit,buf(1:n),mode)
      if(err.gt.0) then
         call error(48)
         return
      endif
c
      loaded=.false.
 49   top=top+1
      job=lstk(bot)-lstk(top)
c     on recupere toutes les variables du fichier
      id1(1)=blank
      call savlod(lunit,id1,job,top)
      if(err.gt.0) goto 51
      il=iadr(lstk(top))
      if(istk(il).eq.0) goto 50
      srhs=rhs
      rhs=0
      call stackp(id1,1)
      if(err.gt.0) goto 51
      if(eqid(id,id1)) loaded=.true.
      rhs=srhs
      goto 49
 50   if(.not.loaded) then
         fun=0
         fin=0
      endif
      top=top-1
 51   call  clunit(-lunit,buf,mode)
      return
c
      end




