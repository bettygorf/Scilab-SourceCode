      subroutine stackg(id)
c     =============================================================
c     get variables from storage
c
c action realisees selon que la variable existe ou non :
c
c fin=0  : oui retour de la variable  fin=-1
c          non fin=0
c fin=-1 : oui fin=numero de la variable
c          non fin=0
c fin=-2 : extraction ou recherche d'une macro pour execution
c          oui  retour d'une variable de type indirect fin=-1
c          non fin=0
c fin=-3 : recherche dans l'environnement propre au niveau courant
c          uniquement  (insertion)
c          oui : retour d'une variable de type indirect fin=-1
c          non : retour d'une matrice vide fin=-1
c fin=-4 : demande de retour d'une variable de type indirect
c     =============================================================
c
c     Copyright INRIA
      INCLUDE '../stack.h'
      logical compil,vcopyobj
      integer id(nsiz),fun1,vol,vk
c     
      logical eqid,local
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      if (ddt .eq. 4) then
         call cvname(id,buf,1)
         write(buf(nlgh+1:),'(i8)') fin
         call basout(io,wte,' stackg  '//buf(1:nlgh+9))
      endif
c     

      if(err1.gt.0) return
c     
      if ( compil(2,id,fin,rhs,0)) goto 99
c     
      if(top+1.ge.bot) then
         call error(18)
         if(err.gt.0) return
      endif
c     
c     set environnement where variable is searched
      if(fin.eq.-3.and.(macr.ne.0.or.paus.ne.0)) then
         k=lpt(1)-(13+nsiz)
         last=lin(k+5)-1
         local=.true.
      else
         last=isiz-1
         local=.false.
      endif
c     
c     look for id in the defined variables
      k=bot-1
 21   k = k+1
      if(k.gt.last) then
c     variable has not been found in the variables
         k = 0
         if(fin.eq.-3) then
            call defmat
            fin = -1
            fun = 0
         else
            fin=0
         endif
         return
      endif
      if (.not.eqid(idstk(1,k), id)) go to 21
c
c     variable has been found in position k
      if(fin.eq.-1) then
         fin=k
         fun=0
         return
      endif
      lk = lstk(k)
      ilk=iadr(lk)
c 
c     perform operation on the found variable
      if(fin.eq.-4) goto 31
      if(fin.eq.-2) then
c     extraction or macro call
         if(abs(istk(ilk)).eq.11.or.abs(istk(ilk)).eq.13) then
c     .     macro call
            if(istk(ilk).lt.0) lk=istk(ilk+1)
            fin=lk
            fun=0
            return
         endif
         if(istk(ilk).gt.0) then
            goto 31
         else
            goto 25
         endif
      elseif(fin.eq.-3) then
c     insertion
         if(istk(ilk).lt.0.and.local) then
c     .  insertion in a local indirect variable
c     .     replace indirect variable by its value
            k1=istk(ilk+2)
            if (k .ne. bot) then
c     .     shift storage down
               vk=lstk(k+1)-lstk(k)
               ls = lstk(bot)
               call dcopy(lstk(k)-lstk(bot),stk(ls),-1,stk(ls+vk),-1)
               do 26 i = k-1,bot,-1
                  call putid(idstk(1,i+1),idstk(1,i))
                  infstk(i+1)=infstk(i)
                  lstk(i+1) = lstk(i)+vk
 26            continue
            endif
c     .     destroy old variable
            bot = bot+1
c     .     copy the value
            vol=lstk(k1+1)-lstk(k1)
            k=bot-1
            lstk(k)=lstk(k+1)-vol
            call dcopy(vol,stk(lstk(k1)),1,stk(lstk(k)),1)
            call putid(idstk(1,k), id)
            infstk(k)=0
            bot=k
            lk = lstk(k)
            ilk=iadr(lk)
         endif
         goto 31
      endif
c     
c     copy the variable at the top of the stack
      if(istk(ilk).lt.0) then
c     if indirect variable copy the variable pointed by
         k=istk(ilk+2)
      endif
 25   top = top+1
      if (.not.vcopyobj(' ',k,top)) return
      infstk(top)=0
      call putid(idstk(1,top),id)
      go to 99
c     
 31   continue
c     return indirect variable
      top=top+1
      il=iadr(lstk(top))
      infstk(top)=0
      call putid(idstk(1,top),id)
      if(istk(ilk).gt.0) then
         istk(il)=-istk(ilk)
         istk(il+1)=lk
         istk(il+2)=k
      else
         istk(il)=istk(ilk)
         istk(il+1)=istk(ilk+1)
         istk(il+2)=istk(ilk+2)
      endif
      lstk(top+1)=sadr(il+3)
      goto 99
c     
 99   fin = -1
      fun = 0
      return
      end
