      subroutine stackp(id,macmod)
c     ======================================================================
c     put variables into storage
c     ======================================================================
c
      INCLUDE '../stack.h'
      integer iadr
      common /mprot/ macprt
      integer id(nsiz)
c
      logical eqid,new,compil
      integer macmod
      integer v,vk,vt,vtk,pntr
c
      iadr(l)=l+l-1
c
      if (ddt .eq. 4) then
         call cvname(id,buf,1)
         call basout(io,wte,' stackp  '//buf(1:nlgh))
      endif
c
      if(err1.gt.0) return
c     compilation  stackp: <1,nom(1:4)>
      if (compil(1,id,0,0,0)) then 
         fin=0
         return
      endif
   01 if (top .le. 0) then
         call error(1)
         return
      endif
c
      il=iadr(lstk(top))
      vt=istk(il)
      pntr=top
      if(vt.lt.0) then
         pntr=istk(il+2)
         if(istk(il+1).lt.0) then
c     cas des variables modifiees sur place (insertion)
            top=top-1
            fin=pntr
            return 
         endif
      endif

      
      new=.true.
c
c     does variable already exist
      vtk=0
c
      last=isiz
      if(macr.eq.0.and.paus.eq.0) goto 04
      k=lpt(1) - (13+nsiz)
      last=lin(k+5)
   04 continue
c
      call putid(idstk(1,bot-1),id)
      k = last
   05 k = k-1
      if (.not.eqid(idstk(1,k),id)) go to 05
      if (k .eq. bot-1) go to 06
c
      ilk=iadr(lstk(k))
      vtk=istk(ilk)
      vk=lstk(k+1)-lstk(k)
   06 continue
c
c
      v=lstk(pntr+1)-lstk(pntr)
      if(vt.eq.0) v=0
c
      if(vtk.eq.0) goto 30
c
c     est-ce une variable predefinie
c
      if(k.lt.bbot) goto 15
      if(v.ne.vk) goto 12
      if(k.le.isiz-4) goto 15
      l1=lstk(pntr)-1
      l2=lstk(k)-1
      do 11 i=1,v
         if(stk(l1+i).ne.stk(l2+i)) goto 12
 11   continue
      goto 15
   12 call error(13)
      return
c
   15 continue
c
c     preserve macros
      if(vtk.eq.13.or.vtk.eq.11) then
         if(vt.ne.0.and.macmod.eq.0) then
c            fin=-3
c            call funs(id)
c            fun=0
c            if(err.gt.0) return
c            if(fin.gt.0) then
               if(vt.ne.vtk) goto 19
c     les macros sont elle identiques ?
               if(istk(ilk).ne.istk(il)) goto 19
               if(istk(ilk+1).ne.istk(il+1)) goto 19
               mrhs=istk(ilk+1)
               do 16 i=1,nsiz*mrhs
                  if(istk(ilk+1+i).ne.istk(il+1+i)) goto 19
 16            continue
               ln=2+nsiz*mrhs
               if(istk(ilk+ln).ne.istk(il+ln)) goto 19
               mlhs=istk(ilk+ln)
               do 17 i=1,nsiz*mlhs
                  if(istk(ilk+ln+i).ne.istk(il+ln+i)) goto 19
 17            continue
               ln=ln+nsiz*mlhs+1
               if(istk(ilk+ln).ne.istk(il+ln)) goto 19
               long=istk(ilk+ln)
               do 18 i=1,long
                  if(istk(ilk+ln+i).ne.istk(il+ln+i)) goto 19
 18            continue
               goto 20
c     ce n'est pas la meme macro
 19            call  putid(ids(1,pt+1),id)
               if(macprt.eq.2) then  
                  call error(111)
                  if(err.gt.0) return
               elseif(macprt.eq.1) then  
                  call msgs(42,vt)
               endif
 20            continue
c            endif
         endif
      endif
c
c     does it fit
      if (v.eq.vk) go to 35
c
c     shift storage
      if (k .eq. bot) go to 25
      ls = lstk(bot)
      ll = ls + vk
      call dcopy(lstk(k)-lstk(bot),stk(ls),-1,stk(ll),-1)
      km1 = k-1
      do 21 ib = bot, km1
        i = bot+km1-ib
        call putid(idstk(1,i+1),idstk(1,i))
        infstk(i+1)=infstk(i)
        lstk(i+1) = lstk(i)+vk
 21   continue
c
c     destroy old variable
   25 bot = bot+1
      new=.false.
c
c     create new variable
   30 if (istk(il) .eq. 0) go to 41
      if (bot-2 .lt. top) then
         call error(18)
         return
      endif
      if(macmod.eq.0.and.new) then
         fin=-3
         call funs(id)
         fun=0
         if(fin.gt.0) then
            if(macprt.eq.2) then
               call putid(ids(1,pt+1),id)
               call  error(111)
               if(err.gt.0) return
            elseif(macprt.eq.1) then
               call putid(ids(1,pt+1),id)
               call msgs(42,vt)
            endif
         endif
      endif
      k = bot-1
      call putid(idstk(1,k), id)
      infstk(k)=0
c
c     store
   35  lstk(k) = lstk(k+1) - v
      lk = lstk(k)
      call dcopy(v,stk(lstk(pntr)),-1,stk(lk),-1)
      go to 40
c
c     pop stack
   40 if (k .eq. bot-1) bot = bot-1
   41 top =top - 1
      fin=0
      if(istk(il).ne.0) fin=k
      goto 99
c
c   92 call error(21)
c      return
c   93 call error(44)
c      return
   99 continue
      return
      end
