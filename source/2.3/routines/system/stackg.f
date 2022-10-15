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
c fin=-2 : extraction
c          oui  retour d'une variable de type indirect fin=-1
c          non fin=0
c fin=-3 : recherche dans l'environnement propre au niveau courant
c          uniquement  (insertion)
c          oui : retour d'une variable de type indirect fin=-1
c          non : retour d'une matrice vide fin=-1
c     =============================================================
c
      INCLUDE '../stack.h'
      logical compil,vcopyobj
      integer id(nsiz)
c
      logical eqid
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (ddt .eq. 4) then
         call cvname(id,buf,1)
         call basout(io,wte,' stackg  '//buf(1:nlgh))
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
      last=isiz-1
      if(fin.ne.-3.or.(macr.eq.0.and.paus.eq.0)) goto 20
      k=lpt(1)-(13+nsiz)
      last=lin(k+5)-1
c
c     recherche parmi les variables
   20 k=bot-1
   21 k = k+1
      if(k.gt.last) goto 81
      if (.not.eqid(idstk(1,k), id)) go to 21
      if(fin.eq.-1) goto 80
   22 lk = lstk(k)
      ilk=iadr(lk)
c
      if(fin.eq.-2) then
c     extraction
         if(istk(ilk).eq.11.or.istk(ilk).eq.13) goto 79
         goto 30
      elseif(fin.eq.-3) then
c     insertion
         goto 30
      endif
c
c     chargement de la variable au sommet de la pile
      top = top+1
      if (.not.vcopyobj(' ',k,top)) return
      infstk(top)=0
      call putid(idstk(1,top),idstk(1,k))
      go to 99
c
   30 continue
c adressage indirect
      top=top+1
      il=iadr(lstk(top))
      istk(il)=-istk(ilk)
      istk(il+1)=lk
      istk(il+2)=k
      lstk(top+1)=sadr(il+3)
      goto 99
c
   79 fin=lk
      fun=0
      return
   80 fin=k
      fun=0
      return
   81 k = 0
      if(fin.eq.-3) goto 82
      fin=0
      return
   82 call defmat
   99 fin = -1
      fun = 0
      return
      end
