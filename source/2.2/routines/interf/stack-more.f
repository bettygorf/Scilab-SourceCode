      logical function checkval(fname,ival1,ival2) 
      character fname*(*)
      integer ival1,ival2
      include '../stack.h'
      if ( ival1.ne.ival2 ) then 
         buf= fname // ' incompatible sizes '
         call error(999)
         checkval=.false.
      else
         checkval=.true.
      endif
      return
      end

c     -------------------------------------------------------------
c      recupere si elle existe la variable name dans le stack et 
c      met sa valeur a la position top et top est incremente 
c      ansi que rhs 
c      si la variable cherchee n'existe pas on renvoit false 
c     -------------------------------------------------------------

      logical function optvarget(fname,topk,iel,name) 
      character fname*(*),name*(*) 
      include '../stack.h'
      call  cvname(id,name,0)
      fin=0 
c     recupere la variable et incremente top 
      call stackg(id)
      if(fin .eq. 0) then 
         buf = ' '
         call error(999) 
         write(buf,*) fname 
         write(buf(nlgh+1:2*nlgh),*) name 
         write(buf(2*nlgh+1:2*nlgh+3),'(i3)') iel
         call basout(io,wte, buf(1:nlgh)// 
     $        ': optional argument '  //
     $        buf(2*nlgh+1:2*nlgh+3)//
     $        ' not given and default ')
         call basout(io,wte, 'value' // buf(nlgh+1:2*nlgh)
     $        // ' not found ')
         optvarget=.false.
         return 
      endif
      rhs = rhs + 1
      optvarget=.true.
      return
      end

c     -------------------------------------------------------------
c     verifie que l'on peut stocker dans buf nlr element 
C     a partir de la position lbuf 
C     si oui les elements sont stockes et on passera au code 
C     Fortran buf(lbufi:lbuff) 
C     lbuf est ensuite update 
C     -------------------------------------------------------------

      logical function bufstore(fname,lbuf,lbufi,lbuff,lr,nlr)
      character fname*(*)
      integer lr,nlr,lbuf,lbufi,lbuff
      include '../stack.h'
      lbufi = lbuf
      lbuff = lbufi + nlr-1
      lbuf =  lbuff + 2 
      if ( lbuff.gt.bsiz) then 
         buf = fname // ' No more space to store string arguments'
         call error(999)
         bufstore=.false.
         return 
      endif
      bufstore=.true.
      call cvstr(nlr,istk(lr),buf(lbufi:lbuff),1)
      buf(lbuff+1:lbuff+1)= char(0)
      return
      end 

C     ------------------------------------------------------------------
c     creation of an obect of type pointer at spos position on the stack 
c     the pointer points to an object of type char matrix created by 
c     the c routine stringc and is filled with a scilab stringmat 
c     which was stored at istk(ilorig) 
c     stk(lw) is used to transmit the pointer 
C     F: transforme une stringmat scilab en un objet de type 
C     pointeur qui pointe vers une traduction en C de la stringMat 
C     -------------------------------------------------------------------
      
      logical function crestringv(fname,spos,ilorig,lw)
      character fname*(*)
      logical crepointer 
      integer spos
      include '../stack.h'
      crestringv= crepointer(fname,spos,lw)
      if (.not.crestringv) return 
      call stringc(istk(ilorig),stk(lw),ierr)
      if(ierr.ne.0) then
         buf='not enough memory'
         crestringv=.false.
         call error(999)
         return
      endif
      return
      end

C     -------------------------------------------------------------------
C     Creation a la position spos de la pile d'un objet de type pointeur 
C     qui sera utilise dans les programmes appellants 
C     -------------------------------------------------------------------

      logical function crepointer(fname,spos,lw)
C     provisoirement on utiise une matrice 
      integer spos,lw
      character fname*(*)
      integer iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      if ( spos+1.ge.bot) then
         call error(18)
         crepointer =.false.
         return
      endif
      il=iadr(lstk(spos))
      err=sadr(il+4)+1 -lstk(bot)
      if(err.gt.0) then
         call error(17)
         crepointer=.false.
         return
      else
         crepointer=.true.
         istk(il)=199
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         lw=sadr(il+4)
         lstk(spos+1)=sadr(il+4)+2
         return
      endif
      end


C     -------------------------------------------------------------------
c     creates a Scilab stringmat on the stack at position spos
c     of size mxn the stringmat is filled with the datas stored 
c     in stk(lorig) ( for example created with cstringv ) 
c     and the data stored at stk(lorig) is freed 
C     -------------------------------------------------------------------

      logical function lcrestringmatfromC(fname,spos,numi,stlw,
     $     lorig,m,n)
      character fname*(*)
      integer spos,stlw,numi,lorig,m,n
      integer iadr, sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      ilw= iadr(stlw)
      call cstringf(stk(lorig),istk(ilw),m,n,lstk(bot) - stlw,ier
     $ r)
      if(ierr .gt. 0) then
         buf='not enough memory'
         call error(999)
         lcrestringmatfromC=.false.
         return
      endif
      stlw= sadr(ilw+5+m*n+istk(ilw+4+m*n)-1)
      il = iadr(lstk(spos))
      istk(il+2+numi)= stlw - sadr(il+istk(il+1)+3) +1 
      if (numi.eq.istk(il+1) ) lstk(spos+1)= stlw
      lcrestringmatfromC=.true.
      return
      end 


C     -------------------------------------------------------------------
c     creates a Scilab stringmat on the stack at position spos
c     of size mxn the stringmat is filled with the datas stored 
c     in stk(lorig) ( for example created with cstringv ) 
c     and the data stored at stk(lorig) is freed 
C     -------------------------------------------------------------------

      logical function crestringmatfromC(fname,spos,lorig,m,n)
      character fname*(*)
      integer spos
      integer iadr, sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      ilw=iadr(lstk(spos))
      call cstringf(stk(lorig),istk(ilw),m,n,lstk(bot)-lstk(spos),ier
     $ r)
      if(ierr .gt. 0) then
         buf='not enough memory'
         call error(999)
         crestringmatfromC=.false.
         return
       endif
       lstk(spos+1)=sadr(ilw+5+m*n+istk(ilw+4+m*n)-1)
       crestringmatfromC=.true.
       return
       end 

C     -------------------------------------------------------------------
c     creation d'une liste en lstk(slw) qui doit contenir ilen elements 
C     renvoit lw ( on peut stocker le premier element en stk(lw)) 
C     Attention la creation de la liste n'est complete que lorsque l'on 
C     a rajoute les elements 
C     A verifier : si la liste est vide  il faut terminer la creation 
C     ===> Attention sinon la creation de la liste ne sera finie que lorsque 
C     les elements seront bien rajoutes 
C     -------------------------------------------------------------------
       subroutine crelist(slw,ilen,lw) 
       integer slw,ilen,lw
       integer iadr, sadr
       include '../stack.h'
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       il=iadr(lstk(slw))
       istk(il)=15
       istk(il+1)=ilen
       istk(il+2)=1
       lw=sadr(il+ilen+3)
       if ( ilen.eq.0 ) lstk(lw+1)= lw
       return 
       end 

c     creation d'une liste en lstk(slw) 
C     renvoit lw ( on peut stocker le premier element en stk(lw)) 

      subroutine cretlist(slw,ilen,lw) 
      integer slw,ilen,lw
      integer iadr, sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      il=iadr(lstk(slw))
      istk(il)=16
      istk(il+1)=ilen
      istk(il+2)=1
      lw=sadr(il+ilen+3)
      return 
      end 
      
C     ------------------------------------------------------------------
C     getlistmat : recupere une matrice dans une liste 
C     ------------------------------------------------------------------

      logical function getlistmat(fname,topk,spos,lnum,it,m,n,lr,lc)
C     implicit undefined (a-z)
      logical getilist,getmatI
      character fname*(*)
      integer topk,spos,lnum,it,m,n,lr,lc 
      integer iadr, sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      getlistmat= getilist(fname,topk,spos,nv,lnum,ili)
      if (.not.getlistmat) return
      if (lnum.gt.nv) then
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // ' should be a list ')
         write(buf(1:3),'(i3)')  lnum
         call basout(io,wte,'of size at least '// buf(1:3))
         getlistmat=.false.
         return 
      endif
      getlistmat = getmatI(fname,topk,spos,ili,it,m,n,lr,lc,.true.,lnum)
      return
      end

      logical  function getmatN(fname,topk,lw,it,m,n,lr,lc)
C     Fonction normalement identique a getmat mais rajoutee
C     pour ne pas avoir a changer le stack.f de interf 
C     renvoit .true. si l'argument en lw est une matrice
C             sinon appelle error et renvoit .false.
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       lw    : position ds la pile
C     Sortie
C       [it,m,n] caracteristiques de la matrice
C       lr : pointe sur la partie reelle ( si la matrice est a
C              a(1,1)=stk(lr)
C            si l'on veut acceder a des entiers
C			   a(1,1)=istk(adr(lr,0))
C       lc : pointe sur la partie imaginaire si elle existe sinon sur zero
C
C      implicit undefined (a-z)
      integer topk,lw,it,m,n,lr,lc
      logical getmatI
      character fname*(*)
      include '../stack.h'
      getmatN= getmatI(fname,topk,lw,lstk(lw),it,m,n,lr,lc,.false.,0)
      return
      end 

      logical  function getmatI(fname,topk,spos,lw,it,m,n,lr,lc,
     $     inList,nel)
C     utilisee pour getmatN et gettlistmat 
C      implicit undefined (a-z)
      logical inList
      integer topk,lw,it,m,n,lr,lc,nel,spos
      character fname*(*)
      integer il
      integer iadr, sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      il=iadr(lw)
C     test particulier decouvert ds logic.f
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).ne.1) then
         getmatI=.false.
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         write(buf(nlgh+4:nlgh+6),'(i3)') nel
         if (inList) then 
            call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $           // buf(nlgh+1:nlgh+3) // '>('// buf(nlgh+4:nlgh+6)
     $           // 'should be a real matrix ')
            buf = ' '
            call error(999)
            return 
         else
            err=rhs+(spos-topk)
            call cvname(ids(1,pt+1),fname,0)
            getmatI=.false.
            call error(201)
            return 
         endif
      else
         m=istk(il+1)
         n=istk(il+2)
         it=istk(il+3)
         lr=sadr(il+4)
         if (it.eq.1) then
            lc=lr+m*n
         endif
         getmatI=.true.
      endif
      return
      end


cc      listcremat(top,numero,lw,....) 
cc      le numero ieme element de la liste en top doit etre un matrice 
cc      stockee a partir de lstk(lw) 
cc      doit mettre a jour les pointeurs de la liste 
cc      ainsi que stk(top+1) 
cc      si l'element a creer est le dernier 
cc      lw est aussi mis a jour 
cc

      logical function listcremat(fname,lw,numi,stlw,it,m,n,lrs,lcs)
C     implicit undefined (a-z)
      character fname*(*)
      logical crematI
      integer lw,numi,stlw,it,m,n,lrs,lcs,iadr,sadr,il
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      listcremat= crematI(fname,stlw,it,m,n,lrs,lcs)
      if (.not.listcremat) return 
      stlw =  lrs +m*n*(it+1)
      il = iadr(lstk(lw))
      istk(il+2+numi)= stlw - sadr(il+istk(il+1)+3) +1 
      if (numi.eq.istk(il+1) ) lstk(lw+1)= stlw
      return 
      end 

      logical function crematN(fname,lw,it,m,n,lr,lc)
C     verifie que l'on peut stocker une matrice [it,m,n]
C     a la position lw en renvoyant .true. ou .false. suivant la reponse
C     Entree :
C       lw : position (entier)
C       it : type 0 ou 1
C       m, n dimensions
C     Sortie :
C       lr : pointe sur la partie reelle ( si la matrice est a
C              a(1,1)=stk(lr)
C            si l'on veut acceder a des entiers
C
C			   a(1,1)=istk(adr(lr,0))
C       lc : pointe sur la partie imaginaire si besoin est
C     Effet de Bords :
C      Si on peut creer une matrice en lw on
C      initialise les dimensions et on met a jour
C      la position de lw+1
C     par contre on ne touche pas au contenu precedent
C     stk(lr-1+i...) et stk(lc-1+i...) continuent a donner les valeurs
C	  de la matrice qui etait precedemment stockee
C!
C      implicit undefined (a-z)
      logical crematI
      character fname*(*)
      integer lw,it,m,n,lr,lc
      include '../stack.h'
      if ( lw+1.ge.bot) then
         call error(18)
         crematN=.false.
         return
      endif
      crematN = crematI(fname,lstk(lw),it,m,n,lr,lc)
      if (crematN) then 
         lstk(lw+1)= lr +m*n*(it+1)
      endif
      return
      end 

c     crematI---------------------------------------------------
c     comme crematN mais la position ou il faut creer la matrice 
c     est donnee par sa position dans lstk directement 

      logical function crematI(fname,stlw,it,m,n,lr,lc)
C      implicit undefined (a-z)
      character fname*(*)
      integer stlw,it,m,n,lr,lc,il
      integer iadr, sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      il=iadr(stlw)
      err=sadr(il+4)+m*n-lstk(bot)
      if(err.gt.0) then
         call error(17)
         crematI=.false.
         return
      else
         crematI=.true.
         istk(il)=1
c        si m*n=0 les deux dimensions sont mises a zero.
         istk(il+1)=min(m,m*n)
         istk(il+2)=min(n,m*n) 
         istk(il+3)=it
         lr=sadr(il+4)
         lc=lr+m*n
         return
      endif
      end

      
C     ------------------------------------------------------------------
C     getlistrow : recupere un vecteur ligne dans une liste 
C     ------------------------------------------------------------------

      logical function getlistvectrow(fname,topk,spos,lnum,it,m,n,lr,lc)
C     implicit undefined (a-z)
      logical getilist,getmatI
      character fname*(*)
      integer topk,spos,lnum,it,m,n,lr,lc,iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      getlistvectrow= getilist(fname,topk,spos,nv,lnum,ili)
      if (.not.getlistvectrow) return
      if (lnum.gt.nv) then
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // ' should be a list ')
         write(buf(1:3),'(i3)')  lnum
         call basout(io,wte,'of size at least '// buf(1:3))
         getlistvectrow=.false.
         return 
      endif
      getlistvectrow = getmatI(fname,topk,spos,ili,it,m,n,lr,lc,
     $     .true.,lnum)
      if (.not. getlistvectrow) return 
      if (m.ne.1) then 
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         write(buf(nlgh+4:nlgh+6),'(i3)') lnum
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // '>('// buf(nlgh+4:nlgh+6)
     $        // 'should be a row vector')
         getlistvectrow = .false.
      endif
      return
      end

      logical  function getvectrow(fname,topk,spos,it,m,n,lr,lc)
C     Fonction normalement identique a getmat mais rajoutee
C     pour ne pas avoir a changer le stack.f de interf 
C     renvoit .true. si l'argument en spos est une matrice
C             sinon appelle error et renvoit .false.
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       spos    : position ds la pile
C     Sortie
C       [it,m,n] caracteristiques de la matrice
C       lr : pointe sur la partie reelle ( si la matrice est a
C              a(1,1)=stk(lr)
C            si l'on veut acceder a des entiers
C			   a(1,1)=istk(adr(lr,0))
C       lc : pointe sur la partie imaginaire si elle existe sinon sur zero
C
C      implicit undefined (a-z)
      integer topk,spos,it,m,n,lr,lc
      logical getmatI
      character fname*(*)
      include '../stack.h'
      getvectrow= getmatI(fname,topk,spos,lstk(spos),it,m,n,lr,lc,
     $     .false.,0)
      if (.not.      getvectrow) return 
      if (m.ne.1) then 
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $           // buf(nlgh+1:nlgh+3) 
     $           // 'should be a row vector matrix ')
         getvectrow=.false.
      endif
      return
      end 
      
C     ------------------------------------------------------------------
C     getlistscalar : recupere un scalaire 
C     ------------------------------------------------------------------

      logical function getlistscalar(fname,topk,spos,lnum,lr)
C     implicit undefined (a-z)
      logical getilist,getmatI
      character fname*(*)
      integer topk,spos,lnum,it,m,n,lr,lc 
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      getlistscalar= getilist(fname,topk,spos,nv,lnum,ili)
      if (.not.getlistscalar) return
      if (lnum.gt.nv) then
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // ' should be a list ')
         write(buf(1:3),'(i3)')  lnum
         call basout(io,wte,'of size at least '// buf(1:3))
         getlistscalar=.false.
         return 
      endif
      getlistscalar = getmatI(fname,topk,spos,ili,it,m,n,lr,lc,
     $     .true.,lnum)
      if (.not.getlistscalar) return 
      if (m*n.ne.1) then 
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         write(buf(nlgh+4:nlgh+6),'(i3)') lnum
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // '>('// buf(nlgh+4:nlgh+6)
     $        // 'should be a scalar')
         getlistscalar = .false.
      endif
      return
      end

      logical function listcrestring(fname,lw,numi,stlw,nch,
     $     ilrs)
C     implicit undefined (a-z)
      character fname*(*)
      logical crestringI
      integer lw,numi,stlw,iadr,sadr,ilrs,nch
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      listcrestring= crestringI(fname,stlw,nch,ilrs)
      if (.not.listcrestring) return 
      stlw =  sadr(ilrs-1+istk(ilrs-1))
      il = iadr(lstk(lw))
      istk(il+2+numi)= stlw - sadr(il+istk(il+1)+3) +1 
      if (numi.eq.istk(il+1) ) lstk(lw+1)= stlw
      return
      end 



      logical function crestring(fname,spos,nchar,ilrs)
C     verifie que l'on peut stocker une matrice [1,1]
C     de chaine de caracteres a la position spos du stack 
C     en renvoyant .true. ou .false.  suivant la reponse. 
C     nchar est le nombre de caracteres que l'on veut stocker 
C     Entree :
C       spos : position (entier)
C     Sortie :
C       ilrs 
C!
C      implicit undefined (a-z)
      character fname*(*)
      integer spos,nchar,ilrs,iadr,sadr
      logical crestringI
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1      
      crestring=crestringI(fname,lstk(spos),nchar,ilrs)
      if (crestring) then 
         lstk(spos+1)= sadr(ilrs+nchar)
      endif
      return
      end

      logical function crestringI(fname,stlw,nchar,ilrs)
C     verifie que l'on peut stocker une matrice [1,1]
C     de chaine de caracteres  a la position stlw en renvoyant .true. ou .false.
C     suivant la reponse. 
C     nchar est le nombre de caracteres que l'on veut stcoker 
C     Entree :
C       stlw : position (entier)
C     Sortie :
C       nchar : nombre de caracteres stockable
C       lr : pointe sur  a(1,1)=istk(lr)
C!
C      implicit undefined (a-z)
      character fname*(*)
      integer nchar,il,ilast,stlw
      integer iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      il=iadr(stlw)
      err=sadr(il+4+(nchar+1))-lstk(bot)
      if(err.gt.0) then
         call error(17)
         crestringI=.false.
         return
      else
         crestringI=.true.
         istk(il)=10
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         istk(il+4)=1
         istk(il+4+1)=istk(il+4)+nchar
         ilast=il+4+1
         ilrs=ilast+ istk(ilast-1)
         return
      endif
      end


      logical function getlistsimat(fname,topk,spos,lnum,m,n,i,j,lr,nlr)
C     implicit undefined (a-z)
      logical getilist,getsmatI
      character fname*(*)
      integer topk,spos,lnum,m,n,i,j,lr,nlr,nv,iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      getlistsimat= getilist(fname,topk,spos,nv,lnum,ili)
      if (.not.getlistsimat) return
      if (lnum.gt.nv) then
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // ' should be a list ')
         write(buf(1:3),'(i3)')  lnum
         call basout(io,wte,'of size at least '// buf(1:3))
         getlistsimat=.false.
         return 
      endif
      getlistsimat = getsmatI(fname,topk,spos,ili,m,n,i,j,lr,nlr,
     $     .true.,lnum)
      return
      end


      logical  function getsmatI(fname,topk,spos,lw,m,n,i,j,lr,nlr,
     $     inList,nel)
C     renvoit .true. si l'argument en spos est une matrice
C     de chaine de caractere
C	          sinon renvoit .false. et appelle error
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       spos : position dans la pile
C       i,j : indice de la chaine que l'on veut (on veut a(i,j))
C     Sortie :
C	    [m,n] caracteristiques de la matrice
C       lr : pointe sur le premier caractere de a(i,j)
C            le caractere se recupere par abs(istk(lr)) qui est
C            un codage Scilab des chaines
C       nlr : longueur de la chaine a(i,j)
C
C      implicit undefined (a-z)
      integer topk,spos,m,n,i,j,lr,nlr,lw
      logical inList
      integer il
      character fname*(*)
      integer iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      il=iadr(lw)
      if(istk(il).ne.10) then
         getsmatI=.false.
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         write(buf(nlgh+4:nlgh+6),'(i3)') nel
         if (inList) then 
            buf = ' '
            call error(999)
            call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $           // buf(nlgh+1:nlgh+3) // '>('// buf(nlgh+4:nlgh+6)
     $           // 'should be a string matrix ')
            return 
         else
            err=rhs+(spos-topk)
            call cvname(ids(1,pt+1),fname,0)
            getsmatI=.false.
            call error(207)
            return 
         endif
      endif
      call getsimatI(fname,topk,spos,lw,m,n,i,j,lr,nlr)
      getsmatI=.true.
      return
      end

      subroutine getsimatI(fname,topk,spos,lw,m,n,i,j,lr,nlr)
C     renvoit lr et nlr en supposant que lw designe
C	  une matrice de chaine de caracteres
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       lw : position dans la pile
C       i,j : indice de la chaine que l'on veut (on veut a(i,j))
C		m,n, : taille de la matrice
C     Sortie :
C       lr : pointe sur le premier caractere de a(i,j)
C            le caractere se recupere par abs(istk(lr)) qui est
C            un codage Scilab des chaines
C       nlr : longueur de le chaine a(i,j)
C
C      implicit undefined (a-z)
      include '../stack.h'
      integer topk,spos,m,n,i,j,lr,nlr,il,k,lw
      integer iadr, sadr
      character fname*(*)
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      il=iadr(lw)
      m=istk(il+1)
      n=istk(il+2)
      k=(i-1)+(j-1)*m
      lr=il+4+m*n+ istk(il+4+k)
      nlr=istk(il+4+k+1)-istk(il+4+k)
      return
      end


C     recupere un polynome 
C     
C     md est son degre et son premier element est en 
C     stk(lr),stk(lc) 
C     Finir les tests 

      logical function getonepoly(fname,topk,lw,it,md,name,
     $     namel,lr,lc)
      integer topk,lw,it,m,n,lr,lc,ilp,namel
      character fname*(*)
      character*4 name 
      include '../stack.h'
      logical getpoly
      getonepoly= getpoly(fname,topk,lw,it,m,n,name
     $     namel,ilp,lr,lc) 
      if (.not.getonepoly) return 
      if (m*n.ne.1) then
         buf = fname // 'Argument should be a polynom'
         call error(999)
         getonepoly=.false.
         return 
      endif
      getonepoly=.true.
      md= istk(ilp+1)-istk(ilp)-1 
      lr=lr+istk(ilp)
      lc=lc+istk(ilp)
      return
      end



C     -------------------------------------------------------------------
C     Creation a la position spos de la pile d'un objet de type pointeur 
C     de Matrices utilise pour le nouveau stack 
C     -------------------------------------------------------------------

      logical function creMpointer(fname,spos,lw)
      integer spos,lw
      character fname*(*)
      integer iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      if ( spos+1.ge.bot) then
         call error(18)
         creMpointer =.false.
         return
      endif
      il=iadr(lstk(spos))
      err=sadr(il+4)+1 -lstk(bot)
      if(err.gt.0) then
         call error(17)
         creMpointer=.false.
         return
      else
         creMpointer=.true.
         istk(il)=200
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         lw=sadr(il+4)
         lstk(spos+1)=sadr(il+4)+2
         return
      endif
      end



C     -------------------------------------------------------------------
C     recuperation d'un Mpointer (Matrix Pointer ) utilise pour le nouveau stack 
C     -------------------------------------------------------------------

      logical function getMpointer(fname,topk,spos,lw)
      integer spos,lw,topk
      character fname*(*)
      integer iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      if ( spos+1.ge.bot) then
         call error(18)
         getMpointer=.false.
         return
      endif
      il=iadr(lstk(spos))
      if (istk(il).ne.200 ) then 
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),*) rhs+(spos-topk)
         call basout(io,wte, buf(1:nlgh)// 
     $        ': Argument  '  // buf(nlgh+1:nlgh+3)//
     $        ' should be a Mpointer ')
         getMpointer = .false.
      else
         lw=sadr(il+4)
         getMpointer = .true.
      endif
      return 
      end








