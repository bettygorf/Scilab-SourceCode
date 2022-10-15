      logical function checkrhs(fname,imin,imax)
C     ---------------------------------------
C     verifie  que le nombre d'argument rhs est >= imin <= imax
C      implicit undefined (a-z)
C     ---------------------------------------
c     Copyright INRIA
      integer imin,imax
      character fname*(*)
      include '../stack.h'
      if ( imin.le.rhs.and.rhs.le.imax) then
         call cvname(ids(1,pt+1),fname,0)
         checkrhs=.true.
      else
         checkrhs=.false.
         call cvname(ids(1,pt+1),fname,0)
         call error(77)
      endif
      return
      end

      logical function checklhs(fname,imin,imax)
C     ---------------------------------------
C     verifie  que le nombre d'argument lhs est >= imin <= imax
C      implicit undefined (a-z)
C     ---------------------------------------
      integer imin,imax
      character fname*(*)
      include '../stack.h'
      if ( imin.le.lhs.and.lhs.le.imax) then
         checklhs=.true.
      else
         checklhs=.false.
         call cvname(ids(1,pt+1),fname,0)
         call error(78)
      endif
      return
      end

      logical function isoptlw(topk,lw,name) 
C     ---------------------------------------
C     returns the status of the variable at lw position 
C     if its an optional variable f(x=...)
C     returns .true. and name in name 
C     ---------------------------------------
      integer topk,lw
      character name*(*)
      include '../stack.h'
      isoptlw=.false.
      if ( infstk(lw).eq.1) isoptlw=.true.
      call cvname(idstk(1,lw),name,1)
      return
      end


      integer function numopt()
C     ---------------------------------------
c     returns the number of optional variables 
c     of type xx=val 
c     top must have a correct value when using this function 
C     ---------------------------------------
      include '../stack.h'
      numopt=0
      do 10 k=1,rhs
         numopt = numopt + infstk(k+top-rhs)
 10   continue
      return
      end

      logical function getlistmat(fname,topk,spos,lnum,it,m,n,lr,lc)
C     ------------------------------------------------------------------
C     getlistmat : recupere une matrice dans une liste 
C     ------------------------------------------------------------------
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

      logical  function getmat(fname,topk,lw,it,m,n,lr,lc)
C     -------------------------------------------------------------------
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
C     -------------------------------------------------------------------
      integer topk,lw,it,m,n,lr,lc
      logical getmatI
      character fname*(*)
      include '../stack.h'
      getmat= getmatI(fname,topk,lw,lstk(lw),it,m,n,lr,lc,.false.,0)
      return
      end 

      logical  function getmatI(fname,topk,spos,lw,it,m,n,lr,lc,
     $     inList,nel)
C     -------------------------------------------------------------------
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
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).ne.1) then
         getmatI=.false.
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         write(buf(nlgh+4:nlgh+6),'(i3)') nel
         if (inList) then 
            call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $           // buf(nlgh+1:nlgh+3) // '>('// buf(nlgh+4:nlgh+6)
     $           //') '// 'should be a real matrix ')
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

      logical function listcremat(fname,lw,numi,stlw,it,m,n,lrs,lcs)
c     ----------------------------------------------------------
cc      listcremat(top,numero,lw,....) 
cc      le numero ieme element de la liste en top doit etre un matrice 
cc      stockee a partir de lstk(lw) 
cc      doit mettre a jour les pointeurs de la liste 
cc      ainsi que stk(top+1) 
cc      si l'element a creer est le dernier 
cc      lw est aussi mis a jour 
cc
c     ----------------------------------------------------------
C     implicit undefined (a-z)
      character fname*(*)
      logical crematI
      integer lw,numi,stlw,it,m,n,lrs,lcs,iadr,sadr,il
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      listcremat= crematI(fname,stlw,it,m,n,lrs,lcs,.true.)
      if (.not.listcremat) return 
      stlw =  lrs +m*n*(it+1)
      il = iadr(lstk(lw))
      istk(il+2+numi)= stlw - sadr(il+istk(il+1)+3) +1 
      if (numi.eq.istk(il+1) ) lstk(lw+1)= stlw
      return 
      end 

      logical function cremat(fname,lw,it,m,n,lr,lc)
c     ----------------------------------------------------------
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
c     ----------------------------------------------------------
      logical crematI
      character fname*(*)
      integer lw,it,m,n,lr,lc
      include '../stack.h'
      if ( lw+1.ge.bot) then
         call error(18)
         cremat=.false.
         return
      endif
      cremat = crematI(fname,lstk(lw),it,m,n,lr,lc,.true.)
      if (cremat) then 
         lstk(lw+1)= lr +m*n*(it+1)
      endif
      return
      end 

      logical function fakecremat(lw,it,m,n,lr,lc)
c     ===========================================================
C     similar to cremat but we only check for space 
C     no data is stored 
c     ===========================================================
      logical crematI
      integer lw,it,m,n,lr,lc
      include '../stack.h'
      if ( lw+1.ge.bot) then
         call error(18)
         fakecremat=.false.
         return
      endif
      fakecremat = crematI('cremat',lstk(lw),it,m,n,lr,lc,.false.)
      if (fakecremat) then 
         lstk(lw+1)= lr +m*n*(it+1)
      endif
      return
      end 

      logical function crematI(fname,stlw,it,m,n,lr,lc,flag)
c     ---------------------------------------------------------
C     internal function used by cremat and listcremat
c     comme cremat mais la position ou il faut creer la matrice 
c     est donnee par sa position dans lstk directement 
c     ----------------------------------------------------------
C      implicit undefined (a-z)
      character fname*(*)
      integer stlw,it,m,n,lr,lc,il
      integer iadr, sadr
      logical flag 
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      il=iadr(stlw)
      err=sadr(il+4)+m*n*(it+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         crematI=.false.
         return
      else
         crematI=.true.
         if ( flag) then 
            istk(il)=1
c     si m*n=0 les deux dimensions sont mises a zero.
            istk(il+1)=min(m,m*n)
            istk(il+2)=min(n,m*n) 
            istk(il+3)=it
         endif
         lr=sadr(il+4)
         lc=lr+m*n
         return
      endif
      end

      logical function getlistbmat(fname,topk,spos,lnum,m,n,lr)
C     ------------------------------------------------------------------
C     getlistbmat : recupere une bmatrice dans une liste 
C     ------------------------------------------------------------------
C     implicit undefined (a-z)
      logical getilist,getbmatI
      character fname*(*)
      integer topk,spos,lnum,it,m,n,lr,lc 
      integer iadr, sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      getlistbmat= getilist(fname,topk,spos,nv,lnum,ili)
      if (.not.getlistbmat) return
      if (lnum.gt.nv) then
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // ' should be a list ')
         write(buf(1:3),'(i3)')  lnum
         call basout(io,wte,'of size at least '// buf(1:3))
         getlistbmat=.false.
         return 
      endif
      getlistbmat = getbmatI(fname,topk,spos,ili,m,n,lr,.true.,lnum)
      return
      end

      logical  function getbmat(fname,topk,lw,m,n,lr)
C     ==================================================
C     verifie qu'il y a une matrice boolenne [m,n]
C     a la position lw en renvoyant .true. ou .false.
C	  suivant la reponse
C     Entree :
C       lw : position (entier)
C       m, n dimensions
C     Sortie :
C       lr : pointe sur le premier booleen  a(1,1)=istk(lr)
C     ==================================================
C      implicit undefined (a-z)
      integer topk,lw,m,n,lr
      logical getbmatI
      character fname*(*)
      include '../stack.h'
      getbmat= getbmatI(fname,topk,lw,lstk(lw),m,n,lr,.false.,0)
      return
      end 

      logical  function getbmatI(fname,topk,spos,lw,m,n,lr,
     $     inList,nel)
C     -------------------------------------------------------------------
C     utilisee pour getbmatN et gettlistbmat 
C      implicit undefined (a-z)
      logical inList
      integer topk,lw,m,n,lr,nel,spos
      character fname*(*)
      integer il
      integer iadr, sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      il=iadr(lw)
C     test particulier decouvert ds logic.f
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).ne.4) then
         getbmatI=.false.
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         write(buf(nlgh+4:nlgh+6),'(i3)') nel
         if (inList) then 
            call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $           // buf(nlgh+1:nlgh+3) // '>('// buf(nlgh+4:nlgh+6)
     $           //') '// 'should be a boolean matrix ')
            buf = ' '
            call error(999)
            return 
         else
            err=rhs+(spos-topk)
            call cvname(ids(1,pt+1),fname,0)
            getbmatI=.false.
            call error(208)
            return 
         endif
      else
         m=istk(il+1)
         n=istk(il+2)
         lr=il+3
         getbmatI=.true.
      endif
      return
      end

      logical function listcrebmat(fname,lw,numi,stlw,m,n,lrs)
C     ==================================================
c      listcrebmat(top,numero,lw,....) 
c      le numero ieme element de la liste en top doit etre un bmatrice 
c      stockee a partir de lstk(lw) 
c      doit mettre a jour les pointeurs de la liste 
c      ainsi que stk(top+1) 
c      si l'element a creer est le dernier 
c      lw est aussi mis a jour 
c     ----------------------------------------------------------
C     implicit undefined (a-z)
      character fname*(*)
      logical crebmatI
      integer lw,numi,stlw,it,m,n,lrs,lcs,iadr,sadr,il
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      listcrebmat= crebmatI(fname,stlw,m,n,lrs,.true.)
      if (.not.listcrebmat) return 
      stlw =  sadr(lrs+m*n+2)
      il = iadr(lstk(lw))
      istk(il+2+numi)= stlw - sadr(il+istk(il+1)+3) +1 
      if (numi.eq.istk(il+1) ) lstk(lw+1)= stlw
      return 
      end 

      logical function crebmat(fname,lw,m,n,lr)
C     ==================================================
C     verifie que l'on peut stocker une matrice boolenne [m,n]
C     a la position lw en renvoyant .true. ou .false.
C	  suivant la reponse
C     Entree :
C       lw : position (entier)
C       m, n dimensions
C     Sortie :
C       lr : pointe sur le premier booleen  a(1,1)=istk(lr)
C     Effet de Bords :
C      Si on peut creer une matrice en lw on
C      initialise les dimensions et on met a jour
C      la position de lw+1
C     par contre on ne touche pas au contenu precedent
C      implicit undefined (a-z)
c     ----------------------------------------------------------
      logical crebmatI
      character fname*(*)
      integer lw,m,n,lr,sadr
      include '../stack.h'
      sadr(l)=(l/2)+1
      if ( lw+1.ge.bot) then
         call error(18)
         crebmat=.false.
         return
      endif
      crebmat = crebmatI(fname,lstk(lw),m,n,lr,.true.)
      if (crebmat) then
         lstk(lw+1)=sadr(lr+m*n+2)
       endif
      return
      end 

      logical function fakecrebmat(fname,lw,m,n,lr)
C     ==================================================
      logical crebmatI
      integer lw,m,n,lr,sadr
      include '../stack.h'
      sadr(l)=(l/2)+1
      if ( lw+1.ge.bot) then
         call error(18)
         fakecrebmat=.false.
         return
      endif
      fakecrebmat = crebmatI('crebmat',lstk(lw),m,n,lr,.false.)
      if (fakecrebmat) then
         lstk(lw+1)=sadr(lr+m*n+2)
       endif
      return
      end 

      logical function crebmatI(fname,stlw,m,n,lr,flag)
c     ---------------------------------------------------------
C     internal function used by crebmat and listcrebmat
c     very similar to  crebmat but the position is directly given 
c     as an index in the stk array 
c     ----------------------------------------------------------
C      implicit undefined (a-z)
      character fname*(*)
      integer stlw,m,n,lr,il
      integer iadr, sadr
      logical flag 
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      il=iadr(stlw)
      err=il+3+m*n - iadr(lstk(bot))
      if(err.gt.0) then
         call error(17)
         crebmatI=.false.
         return
      else
         crebmatI=.true.
         if ( flag ) then 
            istk(il)=4
c     si m*n=0 les deux dimensions sont mises a zero.
            istk(il+1)=min(m,m*n)
            istk(il+2)=min(n,m*n) 
         endif
         lr=il+3
         return
      endif
      end



      logical  function getsparse(fname,topk,lw,it,m,n,nel,mnel,
     $     icol,lr,lc)
C     -------------------------------------------------------------------
C     recuperer une sparse matrice voir getsparseI
C      implicit undefined (a-z)
C     -------------------------------------------------------------------
      integer topk,lw,it,m,n,lr,lc,nel,mnel,icol
      logical getsparseI
      character fname*(*)
      include '../stack.h'
      getsparse= getsparseI(fname,topk,lw,lstk(lw),it,m,n,
     $     nel,mnel,icol,lr,lc,.false.,0)
      return
      end 

      logical function getlistsparse(fname,topk,spos,lnum,it,m,n,
     $     nel,mnel, icol,lr,lc)
C     ------------------------------------------------------------------
C     getlistsparse : recupere une matrice sparse dans une liste 
C     ------------------------------------------------------------------
C     implicit undefined (a-z)
      logical getilist,getsparseI
      character fname*(*)
      integer topk,spos,lnum,it,m,n,lr,lc ,nel,mnel,icol
      integer iadr, sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      getlistsparse= getilist(fname,topk,spos,nv,lnum,ili)
      if (.not.getlistsparse) return
      if (lnum.gt.nv) then
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // ' should be a list ')
         write(buf(1:3),'(i3)')  lnum
         call basout(io,wte,'of size at least '// buf(1:3))
         getlistsparse=.false.
         return 
      endif
      getlistsparse = getsparseI(fname,topk,spos,ili,it,m,n,nel,
     $     mnel,icol,lr,lc,.true.,lnum)
      return
      end

      logical  function getsparseI(fname,topk,spos,lw,it,m,n,nel,mnel,
     $     icol,lr,lc, inList,nellist)
C     ---------------------------------------
C     renvoit .true. si l'argument en lw est une matrice sparse
C             sinon appelle error et renvoit .false.
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       lw    : position ds la pile
C     Sortie
C       [it,m,n,nel] caracteristiques de la matrice
C       lr : pointe sur la partie reelle ( stk(lr) ) ( elements stockes en ligne )
C       lc : pointe sur la partie imaginaire si elle existe sinon sur zero
C       istk(mnel+i-1) ,i=1,m nbre d'elts non nuls de la ligne i
C       istk(icol+j-1) ,j=1,nel, colonne du jieme element non nul 
C            il=iadr(lstk(lw))
C            istk(il) type =>5 
C            m=istk(il+1) 
C            n=istk(il+2)
C            it=istk(il+3)
C            istk(il+4)= nel /* nbre elts non nuls */
C            istk(il+5+i-1),i=1,m ==> nbre d'elts non nuls de la ligne i
C            istk(il+5+m+j-1),j=1,nel ==> colonne du jieme element non nul 
C            lr=sadr(il+5+m+nel) 
C            stk(lr) ==> valeurs reelles 
C            stk(l+nel) ==> valeurs imaginaires 
C            lstk(top+1) = l+nel*(it+1) 
C      implicit undefined (a-z)
C     ---------------------------------------
C     utilisee pour getsparseN et gettlistsparse
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
      if(istk(il).ne.5) then
         getsparseI=.false.
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         write(buf(nlgh+4:nlgh+6),'(i3)') nellist
         if (inList) then 
            call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $           // buf(nlgh+1:nlgh+3) // '>('// buf(nlgh+4:nlgh+6)
     $           //') '// 'should be a sparse matrix ')
            buf = ' '
            call error(999)
            return 
         else
            write(buf,*) fname 
            write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
            getsparseI=.false.
            call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $           // buf(nlgh+1:nlgh+3)
     $           // 'should be a sparse matrix ')
            buf = ' '
            call error(999)
            return 
         endif
      else
         m=istk(il+1)
         n=istk(il+2)
         it=istk(il+3)
         nel=istk(il+4)
         mnel = il+5
         icol = il+5+m 
         lr=sadr(il+5+m+nel)
         if (it.eq.1) then
            lc=lr+nel 
         endif
         getsparseI=.true.
      endif
      return
      end

      logical function listcresparse(fname,lw,numi,stlw,it,m,n,
     $     nel,mnel,icol,lrs,lcs)
cc      listcresparse(top,numero,lw,....) 
C     ----------------------------------------------------------
cc      le numero ieme element de la liste en top doit etre une matrice 
cc      sparse stockee a partir de lstk(lw) 
cc      doit mettre a jour les pointeurs de la liste 
cc      ainsi que stk(top+1) 
cc      si l'element a creer est le dernier 
cc      lw est aussi mis a jour 
cc
C     ----------------------------------------------------------

C     implicit undefined (a-z)
      character fname*(*)
      logical cresparseI
      integer lw,numi,stlw,it,m,n,lrs,lcs,iadr,sadr,il
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      listcresparse= cresparseI(fname,stlw,it,m,n,nel,mnel,
     $     icol,lrs,lcs)
      if (.not.listcresparse) return 
      stlw =  lrs +nel*(it+1)
      il = iadr(lstk(lw))
      istk(il+2+numi)= stlw - sadr(il+istk(il+1)+3) +1 
      if (numi.eq.istk(il+1) ) lstk(lw+1)= stlw
      return 
      end 

      logical function cresparse(fname,lw,it,m,n,nel,mnel,icol,lr,lc)
C     ----------------------------------------------------------
C     verifie que l'on peut stocker une matrice sparse 
C     it,m,n, a nel elements non nuls a la position lw 
C     en renvoyant .true. ou .false. suivant la reponse
C     Entree :
C       lw : position (entier)
C       it : type 0 ou 1
C       m, n dimensions
C       nel 
C     Sortie :
C       lr : pointe sur la partie reelle ( stk(lr) ) 
C       lc : pointe sur la partie imaginaire si besoin est
C       istk(mnel) et istk(icol) voir getsparse 
C     Effet de Bords :
C      Si on peut creer une matrice en lw on
C      initialise les dimensions et on met a jour
C      la position de lw+1
C     par contre on ne touche pas au contenu precedent
C     stk(lr-1+i...) et stk(lc-1+i...) continuent a donner les valeurs
C	  de la matrice qui etait precedemment stockee
C!
C      implicit undefined (a-z)
C     ----------------------------------------------------------
      logical cresparseI
      character fname*(*)
      integer lw,it,m,n,lr,lc
      include '../stack.h'
      if ( lw+1.ge.bot) then
         call error(18)
         cresparse=.false.
         return
      endif
      cresparse = cresparseI(fname,lstk(lw),it,m,n,nel,mnel,
     $     icol,lr,lc)
      if (cresparse) then 
         lstk(lw+1)= lr +nel*(it+1)
      endif
      return
      end 

      logical function cresparseI(fname,stlw,it,m,n,nel,mnel,icol,lr,lc)
C     implicit undefined (a-z)
c     ---------------------------------------------------
c     creates a sparse matrix 
C            il=iadr(lstk(lw))
C            istk(il) type =>5 
C            m=istk(il+1) 
C            n=istk(il+2)
C            it=istk(il+3)
C            istk(il+4)= nel /* nbre elts non nuls */
C            istk(il+5+i-1),i=1,m ==> nbre d'elts non nuls de la ligne i
C            istk(il+5+m+j-1),j=1,nel ==> colonne du jieme element non nul 
C            lr=sadr(il+5+m+nel) 
C            stk(lr) ==> valeurs reelles 
C            stk(l+nel) ==> valeurs imaginaires 
C            lstk(top+1) = l+nel*(it+1) 
c     ---------------------------------------------------
      character fname*(*)
      integer stlw,it,m,n,lr,lc,il
      integer iadr, sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      il=iadr(stlw)
      err=sadr(il+5+m+nel)+m*n*(it+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         cresparseI=.false.
         return
      else
         cresparseI=.true.
         istk(il)=5
c        si m*n=0 les deux dimensions sont mises a zero.
         istk(il+1)=min(m,m*n)
         istk(il+2)=min(n,m*n) 
         istk(il+3)=it
         istk(il+4)=nel
         mnel=il+5
         icol = il+5+m 
         lr=sadr(il+5+m+nel)
         lc=lr+nel 
         return
      endif
      end

      logical function getlistvect(fname,topk,spos,lnum,it,m,n,lr,lc)
C     ------------------------------------------------------------------
C     getlistvect : recupere un vecteur ligne dans une liste 
C     ------------------------------------------------------------------
C     implicit undefined (a-z)
      logical getilist,getmatI
      character fname*(*)
      integer topk,spos,lnum,it,m,n,lr,lc,iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      getlistvect= getilist(fname,topk,spos,nv,lnum,ili)
      if (.not.getlistvect) return
      if (lnum.gt.nv) then
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // ' should be a list ')
         write(buf(1:3),'(i3)')  lnum
         call basout(io,wte,'of size at least '// buf(1:3))
         getlistvect=.false.
         return 
      endif
      getlistvect = getmatI(fname,topk,spos,ili,it,m,n,lr,lc,
     $     .true.,lnum)
      if (.not. getlistvect) return 
      if(m.ne.1.and.n.ne.1) then
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         write(buf(nlgh+4:nlgh+6),'(i3)') lnum
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // '>('// buf(nlgh+4:nlgh+6)
     $        // 'should be a  vector')
         getlistvect = .false.
      endif
      return
      end



      logical  function getvect(fname,topk,lw,it,m,n,lr,lc)
C     ------------------------------------------------------------------
C     renvoit .true. si l'argument en lw est un vecteur
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
C			   a(1,1)=istk(iadr(lr))
C       lc : pointe sur la partie imaginaire si besoin est
C
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      integer topk,lw
      character fname*(*)
      integer it,m,n,lr,lc
      logical getmat
      include '../stack.h'
      getvect=getmat(fname,topk,lw,it,m,n,lr,lc)
      if (getvect.eqv..false.) return
      if(m.ne.1.and.n.ne.1) then
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         call error(214)
         getvect=.false.
      else
         getvect=.true.
      endif
      return
      end

      logical  function getrmat(fname,topk,lw,m,n,lr)
C     ------------------------------------------------------------------
C     comme getmat, mais verifie en plus que la matrice est
C     reele
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      integer topk,lw,it,m,n,lr,lc
      character fname*(*)
      logical getmat
      include '../stack.h'
      getrmat=getmat(fname,topk,lw,it,m,n,lr,lc)
      if (getrmat.eqv..false.) return
      if ( it.ne.0) then
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         call error(202)
         getrmat=.false.
      else
         getrmat=.true.
      endif
      return
      end


      logical  function getrvect(fname,topk,lw,m,n,lr)
C     ------------------------------------------------------------------
C     renvoit .true. si l'argument en lw est un vecteur
C             reel sinon appelle error et renvoit .false.
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       lw    : position ds la pile
C     Sortie
C       [it,m,n] caracteristiques de la matrice
C       lr : pointe sur la partie reelle ( si la matrice est a
C              a(1,1)=stk(lr)
C            si l'on veut acceder a des entiers
C			   a(1,1)=istk(iadr(lr))
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      integer topk,lw,lr
      character fname*(*)
      integer m,n
      logical getrmat
      include '../stack.h'
      getrvect=getrmat(fname,topk,lw,m,n,lr)
      if (getrvect.eqv..false.) return
      if(m.ne.1.and.n.ne.1) then
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         call error(203)
         getrvect=.false.
      else
         getrvect=.true.
      endif
      return
      end



      logical  function getscalar(fname,topk,lw,lr)
C     ------------------------------------------------------------------
C     comme getrmat mais verifie en plus que la matrice est
C	  un scalaire
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       lw    : position ds la pile
C     Sortie
C       lr : pointe sur le scalaire a=stk(lr)
C
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      integer topk,lw,lr
      character fname*(*)
      integer m,n
      logical getrmat
      include '../stack.h'
      getscalar=getrmat(fname,topk,lw,m,n,lr)
      if (getscalar.eqv..false.) return
      if(m*n.ne.1) then
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         call error(204)
         getscalar=.false.
      else
         getscalar=.true.
      endif
      return
      end

      logical function   matsize(fname,topk,lw,m,n)
C     ------------------------------------------------------------------
C     comme getmat, mais verifie en plus que la matrice est
C     bien de taille m,n
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      integer topk,lw,m,n
      character fname*(*)
      integer it,m1,n1,lr,lc
      logical getmat
      include '../stack.h'
      matsize=getmat(fname,topk,lw,it,m1,n1,lr,lc)
      if (matsize.eqv..false.) return
      if(m.ne.m1.or.n.ne.n1) then
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         pstk(pt+1)=m
         pstk(pt+2)=n
         call error(205)
         matsize=.false.
         return
      endif
      matsize=.true.
      return
      end

      logical function  vectsize(fname,topk,lw,n)
C     ------------------------------------------------------------------
C     comme getvect, mais verifie en plus que le vecteur
C     bien de taille n
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      integer topk,lw,n
      character fname*(*)
      integer m1,n1,lr
      logical getvect
      include '../stack.h'
      vectsize=getvect(fname,topk,lw,it1,m1,n1,lr,lc)
      if (vectsize.eqv..false.) return
      if(n.ne.m1*n1) then
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         pstk(pt+1)=n
         call error(206)
         vectsize=.false.
         return
      endif
      vectsize=.true.
      return
      end

      logical function   matbsize(fname,topk,lw,m,n)
C     ------------------------------------------------------------------
C     comme getbmat, mais verifie en plus que la matrice est
C     bien de taille m,n
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      integer topk,lw,m,n
      character fname*(*)
      integer m1,n1,lr
      include '../stack.h'
      logical getbmat
      matbsize=getbmat(fname,topk,lw,m1,n1,lr)
      if (matbsize.eqv..false.) return
      if(m.ne.m1.or.n.ne.n1) then
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         pstk(pt+1)=m
         pstk(pt+2)=n
         call error(205)
         matbsize=.false.
         return
      endif
      matbsize=.true.
      return
      end

      logical  function getsmat(fname,topk,lw,m,n,i,j,lr,nlr)
C     ------------------------------------------------------------------
C     renvoit .true. si l'argument en lw est une matrice
C     de chaine de caractere
C	          sinon renvoit .false. et appelle error
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       lw : position dans la pile
C       i,j : indice de la chaine que l'on veut (on veut a(i,j))
C     Sortie :
C	    [m,n] caracteristiques de la matrice
C       lr : pointe sur le premier caractere de a(i,j)
C            le caractere se recupere par abs(istk(lr)) qui est
C            un codage Scilab des chaines
C       nlr : longueur de la chaine a(i,j)
C
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      integer topk,lw,m,n,i,j,lr,nlr
      integer il
      character fname*(*)
      include '../stack.h'
      integer iadr
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).ne.10) then
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         call error(207)
         getsmat=.false.
         return
      endif
      call getsimat(fname,topk,lw,m,n,i,j,lr,nlr)
      getsmat=.true.
      return
      end

      subroutine getsimat(fname,topk,lw,m,n,i,j,lr,nlr)
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
      include '../stack.h'
      integer topk,lw,m,n,i,j,lr,nlr
      integer il,k
      character fname*(*)
      integer iadr
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
      if(istk(il).lt.0) il=iadr(istk(il+1))
      m=istk(il+1)
      n=istk(il+2)
      k=(i-1)+(j-1)*m
      lr=il+4+m*n+ istk(il+4+k)
      nlr=istk(il+4+k+1)-istk(il+4+k)
      return
      end


      logical function cresmat(fname,lw,m,n,nchar)
C     ------------------------------------------------------------------
C     verifie que l'on peut stocker une matrice [m,n]
C     de chaine de caracteres chaque chaine etant de longueur nchar
C     a la position lw en renvoyant .true. ou .false.
C	  suivant la reponse. Si la reponse est .true. on initialise les
C     dimensions de la matrice et change la valeur de lstk(lw+1)
C     Entree :
C       lw : position (entier)
C       m, n dimensions
C       nchar : nombre de caracteres
C     Sortie :
C       lr1 : pointe sur  a(1,1)=istk(lr1)
C       nlr1 : nombre de caracteres ds a(1,1)
C!
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      character fname*(*)
      integer lw,m,n,nchar,il,ilp,kij,ilast
      integer iadr,sadr
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if ( lw+1.ge.bot) then
         call error(18)
         cresmat=.false.
         return
      endif
      il=iadr(lstk(lw))
      err=sadr(il+4+(nchar+1)*m*n)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         cresmat=.false.
         return
      else
         cresmat=.true.
         istk(il)=10
         istk(il+1)=m
         istk(il+2)=n
         istk(il+3)=0
         ilp=il+4
         istk(ilp)=1
         do 10 kij=ilp+1,m*n+ilp
            istk(kij)=istk(kij-1)+nchar
 10      continue
         ilast=ilp+m*n
         lstk(lw+1)=sadr(ilast+istk(ilast))
         return
      endif
      end


      logical function cresmat1(fname,lw,m,nchar)
C     ------------------------------------------------------------------
C     verifie que l'on peut stocker une matrice [m,1]
C     de chaine de caracteres chaque chaine etant de longueur nchar(i)
C     a la position lw en renvoyant .true. ou .false.
C	  suivant la reponse. Si la reponse est .true. on initialise les
C     dimensions de la matrice et change la valeur de lstk(lw+1)
C     Entree :
C       lw : position (entier)
C       n dimensions
C       nchar : nombre de caracteres tableau de dimension(n)
C!
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      character fname*(*)
      integer lw,m,nchar(m),il,ilp,kij,ilast,nnchar,i
      integer iadr,sadr
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c

      if ( lw+1.ge.bot) then
         call error(18)
         cresmat1=.false.
         return
      endif
      nnchar=0
      do 20 i=1,m
         nnchar=nchar(i)+nnchar
 20   continue
      il=iadr(lstk(lw))
      err=sadr(il+4+(nnchar+1)*m)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         cresmat1=.false.
         return
      else
         cresmat1=.true.
         istk(il)=10
         istk(il+1)=m
         istk(il+2)=1
         istk(il+3)=0
         ilp=il+4
         istk(ilp)=1
         i=1
         do 10 kij=ilp+1,ilp+m
            istk(kij)=istk(kij-1)+nchar(i)
            i=i+1
 10      continue
         ilast=ilp+m
         lstk(lw+1)=sadr(ilast+istk(ilast))
         return
      endif
      end

      logical function cresmat2(fname,lw,nchar,lr)
C     ------------------------------------------------------------------
C     verifie que l'on peut stocker une chaine de caracteres
C     de taille nchar a  la position lw en renvoyant 
C     .true. ou .false.
C     Si la reponse est .true. la chaine est effectivement cree
C     nchar est le nombre de caracteres que l'on veut stcoker 
C     Entree :
C       lw : position (entier)
C     Sortie :
C       lr : pointe sur  a(1,1)=istk(lr)
C!
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      character fname*(*)
      integer lw,nchar,il,ilast,lr
      integer iadr,sadr
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if ( lw+1.ge.bot) then
         call error(18)
         cresmat2=.false.
         return
      endif
      il=iadr(lstk(lw))
      err=sadr(il+4+(nchar+1))-lstk(bot)
      if(err.gt.0) then
         call error(17)
         cresmat2=.false.
         return
      else
         cresmat2=.true.
         istk(il)=10
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         istk(il+4)=1
         istk(il+4+1)=istk(il+4)+nchar
         ilast=il+4+1
         lstk(lw+1)=sadr(ilast+istk(ilast))
         lr=ilast+ istk(ilast-1)
         return
      endif
      end

      logical function smatj(fname,lw,j)
C     ------------------------------------------------------------------
C     verifie qu'il y a une matrice de chaine de caracteres en lw-1
C     et verifie que l'on peut stocker l'extraction de la jieme colonne
C     en lw : si oui l'extraction est faite 
C     Entree :
C       lw : position (entier)
C       j  : colonne a extraire 
C!
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      character fname*(*)
      integer lw,j,m,n,lr,nlj,il1,il2,il2p,incj,nj,i,lj
      integer iadr,sadr
      logical getsmat 
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      smatj=.false.
      if ( lw+1.ge.bot) then
         call error(18)
         return
      endif
      if (.not.getsmat(fname,lw-1,lw-1,m,n,1,1,lr,nlj)) return
      if ( j.gt.n) return 
      il1=iadr(lstk(lw-1))
      il2=iadr(lstk(lw))
C     nombre de caracteres de la jieme colonne 
      incj=(j-1)*m
      nj=istk(il1+4+incj+m)-istk(il1+4+incj)
C     test de place 
      err=sadr(il2+4+m+nj+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         smatj=.false.
         return
      endif
      istk(il2)=10
      istk(il2+1)=m
      istk(il2+2)=1
      istk(il2+3)=0
      il2p=il2+4
      il1j=il1+4+incj
      istk(il2p)=1
      do 14 i=1,m
         istk(il2p+i)=istk(il2p-1+i)+istk(il1j+i)-istk(il1j +i-1)
 14   continue
      lj=istk(il1+4+incj)+ il1+4+m*n 
      call icopy(nj,istk(lj),1,istk(il2+4+m+1),1)
      lstk(lw+1)=sadr(il2+4+m+nj+1)
      smatj=.true.
      return
      end


      logical function lmatj(fname,lw,j)
C     ------------------------------------------------------------------
C     verifie qu'il y a une liste en lw-1
C     et verifie que l'on peut stocker l'extraction du jieme 
C     element de la liste en lw : si oui l'extraction est faite 
C     Entree :
C       lw : position (entier)
C       j  : colonne a extraire 
C!
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      logical getilist
      character fname*(*)
      integer lw,j,n,il,ilj,slj
      integer iadr,sadr
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      lmatj=.false.
      if ( lw+1.ge.bot) then
         call error(18)
         return
      endif
      if (.not.getilist(fname,lw-1,lw-1,n,j,ilj)) return 
      if ( j.gt.n) return 
C     a ameliorer 
      il=iadr(lstk(lw-1))
      slj=sadr(il+3+n)+istk(il+2+(j-1))-1
      n=istk(il+2+j)-istk(il+2+(j-1))
      err=lstk(lw)+n-lstk(bot)
      if(err.gt.0) return
      call dcopy(n,stk(slj),1,stk(lstk(lw)),1)
      lstk(lw+1)=lstk(lw)+n
      lmatj=.true.
      return
      end

      logical function pmatj(fname,lw,j)
C     ------------------------------------------------------------------
C     verifie qu'il y a une matrice de polynomes en  lw-1
C     et verifie que l'on peut stocker l'extraction de la jieme 
C     colonne en lw : si oui l'extraction est faite 
C     Entree :
C       lw : position (entier)
C       j  : colonne a extraire 
C!
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      logical getpoly
      character fname*(*),name*4
      integer lw,j,n,il,it,m,namel,lr,lc
      integer iadr,sadr
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      pmatj=.false.
      if ( lw+1.ge.bot) then
         call error(18)
         return
      endif
      if (.not.getpoly(fname,lw-1,lw-1,it,m,n,name,
     $     namel,ilp,lr,lc))
     $     return
      if ( j.gt.n) return 
C     a ameliorer
      il= iadr(lstk(lw-1))
      incj=(j-1)*m
      il2 = iadr(lstk(lw))
      l2 = sadr(il2 + 4)
      m2=max(m,1)
      l=sadr(il+9+m*n)
      n=istk(il+8+m*n)
      l2=sadr(il2+9+m2)
      n2=istk(il+8+incj+m)-istk(il+8+incj)
      err=l2+n2*(it+1)-lstk(bot)
      if(err.gt.0) then 
         call error(17)
         return
      endif
      call icopy(4,istk(il+4),1,istk(il2+4),1)
      il2=il2+8
      il=il+8+incj
      lj=l-1+istk(il)
      istk(il2)=1
      do 12 i=1,m2
         istk(il2+i)=istk(il2-1+i)+istk(il+i)-istk(il-1+i)
 12   continue
      call dcopy(n2,stk(lj),1,stk(l2),1)
      if(it.eq.1) call dcopy(n2,stk(lj+n),1,stk(l2+n2),1)
      lstk(top+1)=l2+n2*(it+1)
      il2=il2-8
      istk(il2) = 2
      istk(il2 + 1) = m2
      istk(il2 + 2) = 1
      istk(il2 + 3) = it
      pmatj=.true.
      return 
      end

      subroutine copysmat(fname,flw,tlw)
C     ------------------------------------------------------------------
C     copie la matrice de chaine de caracteres stockee en flw
C     en tlw, les verifications de dimensions
C     ne sont pas faites
C     lstk(tlw+1) est modifie si necessaire
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      character fname*(*)
      integer flw,tlw,dflw,fflw,dtlw
      integer iadr
      include '../stack.h'
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      dflw=iadr(lstk(flw))
      fflw=iadr(lstk(flw+1))
      dtlw=iadr(lstk(tlw))
      call icopy(fflw-dflw,istk(dflw),1,istk(dtlw),1)
      lstk(tlw+1)=lstk(tlw) + lstk(flw+1)-lstk(flw)
      return
      end

      subroutine setsimat(fname,lw,i,j,nlr)
C     ------------------------------------------------------------------
C     lw designe une matrice de chaine de caracteres
C     on veut changer la taille de la chaine (i,j)
C     et lui donner la valeur nlr
C     cette routine si (i,j) != (m,n) fixe
C     le pointeur de l'argument i+j*m +1
C     sans changer les valeurs de la matrice
C     si (i,j)=(m,n) fixe juste la longeur de la chaine
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       lw : position dans la pile
C       i,j : indice considere
C       m,n : taille de la matrice
C       lr  :
C
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      integer lw,m,i,j,nlr,il,k
      character fname*(*)
      integer iadr
      include '../stack.h'
      iadr(l)=l+l-1
      il=iadr(lstk(lw))
      m=istk(il+1)
      k=(i-1)+(j-1)*m
      istk(il+4+k+1)=istk(il+4+k)+nlr
      return
      end

      subroutine realmat
C     ------------------------------------------------------------------
C     top est une matrice qui est convertie en matrice reelle
C     on recupere de la place si top etait complexe
C     pas de verifications
C     utiliser getmat avant d'appeler realmat
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      integer iadr,sadr
      integer il,m,n
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      il=iadr(lstk(top))
      if (istk(il+3).eq.0) return
      m=istk(il+1)
      n=istk(il+2)
      istk(il+3)=0
      lstk(top+1)=sadr(il+4)+m*n
      return
      end

      logical function crewmat(fname,lw,m,lr)
C     ------------------------------------------------------------------
C       lw : position (entier)
C       m  : taille 
C       lr : pointe sur la partie reelle ( si la matrice est a
C              a(1,1)=stk(lr)
C     this function uses the rest of the stack as a working area 
C     and returns in m the size of the working area in double
C!
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      character fname*(*)
      integer lw,m,lr
      integer il
      integer iadr,sadr
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if ( lw+1.ge.bot) then
         call error(18)
         crewmat=.false.
         return
      endif
      il=iadr(lstk(lw))
      m= lstk(bot) - sadr(il+4)
      crewmat=.true.
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=m
      istk(il+3)=0
      lr=sadr(il+4)
      lstk(lw+1)=sadr(il+4)+m
      return
      end

      subroutine copyobj(fname,lw,lwd)
C     ------------------------------------------------------------------
C     copie l'objet qui est a la position lw de la pile
C     a la position lwd de la pile
C     copie faite avec dcopy
C     pas de verification
C      implicit undefined (a-z)
C     ------------------------------------------------------------------
      character fname*(*)
      integer lw,lwd
      include '../stack.h'
      call dcopy(lstk(lw+1)-lstk(lw),stk(lstk(lw)),1,
     $     stk(lstk(lwd)),1)
      lstk(lwd+1)=lstk(lwd)+lstk(lw+1)-lstk(lw)
      return
      end

      logical function vcopyobj(fname,lw,lwd)
C     ==================================================
C     copie l'objet qui est a la position lw de la pile
C     a la position lwd de la pile
C     copie faite avec dcopy
C     et verification 
C     ==================================================
C      implicit undefined (a-z)
      include '../stack.h'
      character fname*(*)
      integer lw,lwd,l,l1
      vcopyobj=.false.
      l=lstk(lw)
      lv=lstk(lw+1)-lstk(lw)
      l1=lstk(lwd)
      if(lwd+1.ge.bot) then
         call error(18)
         if(err.gt.0) return
      endif
      err=lstk(lwd)+lv-lstk(bot)
      if(err.gt.0) then
         call error(17)
      else
         vcopyobj=.true.
         call dcopy(lv,stk(l),1,stk(l1),1)
         lstk(lwd+1)=lstk(lwd)+lv
      endif
      end

      logical function swapmat(fname,topk,lw,it1,m1,n1
     $     ,mn1,it2,m2,n2,mn2)
C     ==================================================
C     suppose qu'il y a une matrice en lw de taille it1,m1,n1,mn1,
C     et une autre en lw+1 de taille it2,m2,n2,mn2
C     et echange les matrices et change les valeurs de it1,m1,n1,...
C     apres echange la taille de la matrice en lw est stocke ds(it1,m1,n1)
C     et celle en lw+1 est stocke ds (it2,m2,n2)
C     effet de bord il faut que lw+2 soit une place libre
C     ==================================================
C
C     implicit undefined (a-z)
      character fname*(*)
      logical cremat,getmat
      integer topk,lw,it1,m1,n1,mn1,it2,m2,n2,mn2,lr,lc
      swapmat=cremat(fname,lw+1,it1,m1,n1,lr,lc)
      if (swapmat.neqv..true.) return
      call copyobj(fname,lw,lw+2)
      call copyobj(fname,lw+1,lw)
      call copyobj(fname,lw+2,lw+1)
      if (.not.getmat(fname,topk,lw,it1,m1,n1,lr,lc)) return
      if (.not.getmat(fname,topk,lw+1,it2,m2,n2,lr,lc)) return
      mn1=m1*n1
      mn2=m2*n2
      return
      end

      logical function insmat(topk,lw,it,m,n,lr,lc,lr1,lc1)
C     ==================================================
C     verifie qu'en lw il y a une matrice de taille (it1,m1,n1)
C     deplace cette matrice en lw+1, en reservant en lw
C     la place pour stocker une matrice (it,m,n)
C     insmat  verifie  qu'on a la place de faire tout ca
C     appelle error en cas de probleme
C     Remarque : noter par exemple que si it=it1,m1=m,n1=n
C        alors apres le contenu de la matrice en lw est une copie de
C        celle en lw+1
C     Remarque : lw doit etre top car sinon on perd ce qu'il y avait avant
C        en lw+1,....,lw+n
C     Entree :
C        lw : position
C        it ,m,n : taille de la matrice a inserer
C     Sortie :
C       lr : pointe sur la partie reelle de la matrice
C            en lw (   a(1,1)=stk(lr))
C       lc : pointe sur la partie imaginaire si besoin est
C       lr1,lc1 : meme signification mais pour la matrice en lw+1
C            ( matrice qui a ete copiee de lw a lw+1
C     ==================================================
C      implicit undefined (a-z)
      integer topk, lw,it,m,n,lr,lc
      integer it1,m1,n1,lr0,lc0,lr1,lc1
      logical getmat,cremat
      include '../stack.h'
      insmat=getmat('insmat',topk,lw,it1,m1,n1,lr0,lc0)
      if (insmat.eqv..false.) return
      insmat=cremat('insmat',lw,it,m,n,lr,lc)
      if (insmat.eqv..false.) return
      insmat=cremat('insmat',lw+1,it1,m1,n1,lr1,lc1)
      if (insmat.eqv..false.) return
      call dcopy(m1*n1*(it1+1),stk(lr0),-1,stk(lr1),-1)
      insmat=.true.
      return
      end


      integer function gettype(lw)
C     ==================================================
C     renvoit le type de  lw
C      implicit undefined (a-z)
      integer lw
      integer iadr
      include '../stack.h'
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
      if(istk(il).lt.0) il=iadr(istk(il+1))
      gettype=istk(il)
      return
      end

      integer function ogettype(lw)
C     ==================================================
C     renvoit le type de  lw
C      implicit undefined (a-z)
      integer lw
      integer iadr
      include '../stack.h'
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      ogettype=istk(iadr(lstk(lw)))
      return
      end

      subroutine stackinfo(lw,typ)
C     ==================================================
C     imprime le contenu de la pile en lw en mode entier ou
C	  double precision suivant typ
C     ---> a utilier a l'interieur de dbx pour debuguer
C      implicit undefined (a-z)
      integer iadr,sadr
      include '../stack.h'
      integer il,lw,i,m,n,typ,l
      character*7 t(5)
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (lw.eq.0) return
      il =iadr(lstk(lw))
      if(istk(il).lt.0) il=iadr(istk(il+1))
      m  =istk(il+1)
      n  =istk(il+2)
      call basout(io,wte,
     +     '-----------------stack-info-----------------')
      call basout(io,wte,' ')
      write(t(1),'(i7)') lw
      write(t(2),'(i7)') iadr(lstk(lw+1))
      call basout(io,wte,
     +     'lw='//t(1)//'-[istk]-> il lw+1 -[istk]-> '//t(2))
      write(t(1),'(i7)') il
      write(t(2),'(i7)') istk(il)
      write(t(3),'(i7)') istk(il+1)
      write(t(4),'(i7)') istk(il+2)
      write(t(5),'(i7)') istk(il+3)

      call basout(io,wte,
     +     'istk('//t(1)//':..) ->['//t(2)//t(3)//t(4)//t(5)//'....]')
      if (typ.eq.1) then
         l=sadr(il+4)
         nn=min(m*n,3)
         write(buf,'(3e15.8,2x)') (stk(l+i),i=0,nn-1)
         call basout(io,wte,'    {'//buf(1:17*nn)//'}')
      else
         l=il+4
         nn=min(m*n,3)
         write(buf,'(3i15,2x)') (istk(l+i),i=0,nn-1)
         call basout(io,wte,'    {'//buf(1:17*nn)//'}')
      endif
      call basout(io,wte,
     +     '-----------------stack-info-----------------')
      return
      end


      logical  function allmat(fname,topk,lw,m,n)
C     ==================================================
C     renvoit .true. si l'argument en lw est une matrice
C       -relle ou complexe
C       -chaine de caractere
C       -polynomes
C     fname : nom de la routine appellante pour le message
C     d'erreur
C     m : nombre de ligne, n:nombre de colonnes
C      implicit undefined (a-z)
      character fname*(*)
      integer topk,lw,m,n
      integer iadr
      include '../stack.h'
      integer il,itype
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
      itype=istk(il)
      if(itype.ne.1.and.itype.ne.2.and.itype.ne.10) then
         err=rhs+(lw-topk)
         call cvname(ids(1,pt+1),fname,0)
         call error(209)
         allmat=.false.
         return
      endif
      m=istk(il+1)
      n=istk(il+2)
      allmat=.true.
      return
      end

      subroutine allmatset(fname,lw,m,n)
C     ==================================================
C     refixe la taille d'une matrice de n'importe quoi
C     sans se preocuper du contenu
C      implicit undefined (a-z)
      character fname*(*)
      integer lw,m,n
      integer iadr
      include '../stack.h'
      integer il
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
      istk(il+1)=m
      istk(il+2)=n
      return
      end


      logical  function getilist(fname,topk,lw,n,i,ili)
C     ==================================================
C     renvoit .true. si l'argument en lw est une liste
C     Entree :
C      fname : nom de la routine appellante pour le message
C          d'erreur
C      lw : position ds la pile
C      i  : element demande
C     Sortie :
C      n  : nombre d'elements ds la liste
C      ili : le ieme element commence en istk(iadr(ili))
C     ==> pour recuperer un argument il suffit 
C     de faire un lk=lstk(top);lstk(top)=ili; getmat(...,top,...);stk(top)=lk
C      implicit undefined (a-z)
      character fname*(*)
      integer topk,lw,n,i,ili
      integer iadr,sadr
      integer il,itype
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
      if(istk(il).lt.0) il=iadr(istk(il+1))
      itype=istk(il)
      if(itype.lt.15.or.itype.gt.17) then
         err=rhs+(lw-topk)
         call cvname(ids(1,pt+1),fname,0)
         call error(210)
         getilist=.false.
         return
      endif
      n=istk(il+1)
      if ( i.le.n) then
         ili=sadr(il+3+n) + istk(il+2+(i-1))-1
      else
         ili=0
      endif
      getilist=.true.
      end

      subroutine objvide(fname,lw)
C     ==================================================
C     cree un objet vide en lw et met a jour lw+1
C     en fait lw doit etre top
C     verifie les cas particuliers lw=0 ou lw=1
C     ainsi que le cas particulier ou une fonction
C     n'a pas d'arguments (ou il faut faire top=top+1)
C     ==================================================
C      implicit undefined (a-z)
      character fname*(*)
      integer lw
      integer iadr
      include '../stack.h'
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      if (lw.eq.0.or.rhs.lt.0)  lw=lw+1
      istk(iadr(lstk(lw)))=0
      lstk(lw+1)=lstk(lw)+2
      return
      end


      logical function getexternal(fname,topk,lw,name,type,
     $     setfun)
C     ==================================================
C     renvoit .true. si l'argument en lw est un ``external''
C             sinon appelle error et renvoit .false.
C     si l'argument est un external de type string 
C         on met a jour la table des fonctions externes 
C         corespondante en appellant fun 
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       topk : numero d'argument d'appel pour le message d'ereur
C       lw    : position ds la pile
C     Sortie
C       type vaut true ou false
C       si l'external est de type chaine de caracteres
C       la chaine est mise ds name
C       et type est mise a true
C
C      implicit undefined (a-z)
C     ==================================================
      include '../stack.h'
      character fname*(*),name*(nlgh+1)
      integer topk,lw,m,n,lr,nlr,il,gettype
      logical getsmat,type
      external setfun 

      il=gettype(lw)
      if(il.eq.11.or.il.eq.13.or.il.eq.15) then
         getexternal=.true.
         type =.false.
      else if (il.eq.10) then
         getexternal=getsmat(fname,topk,lw,m,n,1,1,lr,nlr)
         type = .true.
         name = ' '
         if (getexternal.neqv..false.) then 
            call cvstr(nlr,istk(lr),name,1)
            name(nlr+1:nlr+1)=char(0)
            call setfun(name,irep)
            if ( irep.eq.1) then 
               buf = name
               call error(50)
               getexternal=.false.
               return
            endif
         endif   
      else
         err=rhs+(lw-topk)
         call cvname(ids(1,pt+1),fname,0)
         call error(211)
         getexternal=.false.
         return
      endif
      return
      end


      logical  function getpoly(fname,topk,lw,it,m,n,name,
     $     namel,ilp,lr,lc)
C     ==================================================
C     renvoit .true. si l'argument en lw est une matrice de polynome
C             sinon appelle error et renvoit .false.
C     Entree :
C       fname : nom de la routine appellante pour le message
C       d'erreur
C       lw    : position ds la pile
C     Sortie
C       [it,m,n] caracteristiques de la matrice
C       name : nom de la variable muette ( character*4) 
C       namel : taille de name <=4 ( uncounting trailling blanks) 
C       soit lij=istk(ilp+(i-1)+(j-1)*m)
C       alors le degre zero de l'elements (i,j) est en 
C       stk(lr+lij) (partie reelle ) et stk(lc+lij) (imag)
C       le degre de l'elt (i,j)= l(i+1)j - lij -1
C      implicit undefined (a-z)
C     ==================================================
      integer topk,lw,it,m,n,lr,lc,ilp,il,namel
      character fname*(*)
      character*4 name 
      include '../stack.h'
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
C     test particulier decouvert ds logic.f
      if(istk(il).ne.2) then
         getpoly=.false.
         err=rhs+(lw-topk)
         call cvname(ids(1,pt+1),fname,0)
         call error(212)
      else
         m=istk(il+1)
         n=istk(il+2)
         it=istk(il+3)
         namel=4
         call cvstr(namel,istk(il+4),name,1)
 11      continue
         if(namel.gt.0) then
            if ( name(namel:namel).eq.' ') then 
               namel=namel-1
               goto 11
            endif
         endif
         ilp=il+8
         lr=sadr(ilp+m*n+1)-1
         lc=lr +istk(ilp+m*n)-1
         getpoly=.true.
      endif
      return
      end


      logical function crewimat(fname,lw,m,n,lr)
C     ==================================================
C     matrice de travail entiere 
C     verifie que l'on peut stocker une matrice d'entier [m,n]
C     a la position lw en renvoyant .true. ou .false.
C	  suivant la reponse
C     Entree :
C       lw : position (entier)
C       m, n dimensions
C     Sortie :
C       lr : pointe sur le premier entier  a(1,1)=istk(lr)
C     Effet de Bords :
C      Si on peut creer une matrice en lw on
C      initialise les dimensions et on met a jour
C      la position de lw+1
C      par contre on ne touche pas au contenu precedent
C!
C      implicit undefined (a-z)
C     ==================================================
      character fname*(*)
      integer lw,m,n,lr
      integer il
      integer iadr,sadr
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
      err=il+3+m*n - iadr(lstk(bot))
      if(err.gt.0) then
         call error(17)
         crewimat=.false.
         return
      else
         crewimat=.true.
         istk(il)=4
         istk(il+1)=m
         istk(il+2)=n
         lr=il+3
         lstk(lw+1)=sadr(il+3+m*n+2)
         return
      endif
      end

      logical function getwimat(fname,topk,lw,m,n,lr)
C     ==================================================
C     verifie qu'il y a une matrice boolenne [m,n]
C     a la position lw en renvoyant .true. ou .false.
C	  suivant la reponse
C     Entree :
C       lw : position (entier)
C       m, n dimensions
C     Sortie :
C       lr : pointe sur le premier booleen  a(1,1)=istk(lr)
C!
C      implicit undefined (a-z)
C     ==================================================
      character fname*(*)
      integer topk,lw,m,n,lr
      integer il
      integer iadr,sadr
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
C     test particulier decouvert ds logic.f
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if(istk(il).ne.4) then
         getwimat=.false.
         err=rhs+(lw-topk)
         call cvname(ids(1,pt+1),fname,0)
         call error(213)
      else
         m=istk(il+1)
         n=istk(il+2)
         lr=il+3
         getwimat=.true.
      endif
      return
      end


      logical function checkval(fname,ival1,ival2) 
C     ==================================================
      character fname*(*)
      integer ival1,ival2
      include '../stack.h'
      if ( ival1.ne.ival2 ) then 
         buf= fname // ' incompatible sizes '
         call error(998)
         checkval=.false.
      else
         checkval=.true.
      endif
      return
      end


      logical function optvarget(fname,topk,iel,name) 
c     -------------------------------------------------------------
c      recupere si elle existe la variable name dans le stack et 
c      met sa valeur a la position top et top est incremente 
c      ansi que rhs 
c      si la variable cherchee n'existe pas on renvoit false 
c     -------------------------------------------------------------

      character fname*(*),name*(*) 
      include '../stack.h'
      integer id(nsiz)
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

      logical function bufstore(fname,lbuf,lbufi,lbuff,lr,nlr)
c     -------------------------------------------------------------
c     verifie que l'on peut stocker dans buf nlr element 
C     a partir de la position lbuf 
C     si oui les elements sont stockes et on passera au code 
C     Fortran buf(lbufi:lbuff) 
C     lbuf est ensuite update 
C     On remarquera que char(0) est automatiquement rajoute 
C     a la fin pour pouvoir aussi passer la chaine a un programme C 
C     -------------------------------------------------------------
      character fname*(*)
      integer lr,nlr,lbuf,lbufi,lbuff
      include '../stack.h'
      lbufi = lbuf
      lbuff = lbufi + nlr-1
      lbuf =  lbuff + 2 
      if ( lbuff.gt.bsiz) then 
         buf = fname // ' No more space to store string arguments'
         call error(998)
         bufstore=.false.
         return 
      endif
      bufstore=.true.
      call cvstr(nlr,istk(lr),buf(lbufi:lbuff),1)
      buf(lbuff+1:lbuff+1)= char(0)
      return
      end 


      
      logical function crestringv(fname,spos,ilorig,lw)
C     ------------------------------------------------------------------
c     creation of an object of type pointer at spos position on the stack 
c     the pointer points to an object of type char matrix created by 
c     the c routine stringc and is filled with a scilab stringmat 
c     which was stored at istk(ilorig) 
c     stk(lw) is used to transmit the pointer 
C     F: transforme une stringmat scilab en un objet de type 
C     pointeur qui pointe vers une traduction en C de la stringMat 
C     -------------------------------------------------------------------
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
         call error(998)
         return
      endif
      return
      end


      logical function crepointer(fname,spos,lw)
C     -------------------------------------------------------------------
C     Creation a la position spos de la pile d'un objet de type pointeur 
C     qui sera utilise dans les programmes appellants 
C     -------------------------------------------------------------------
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


      logical function lcrestringmatfromC(fname,spos,numi,stlw,
     $     lorig,m,n)
C     -------------------------------------------------------------------
c     creates a Scilab stringmat on the stack at position spos
c     of size mxn the stringmat is filled with the datas stored 
c     in stk(lorig) ( for example created with cstringv ) 
c     and the data stored at stk(lorig) is freed 
C     -------------------------------------------------------------------
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
         call error(998)
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



      logical function crestringmatfromC(fname,spos,lorig,m,n)
C     -------------------------------------------------------------------
c     creates a Scilab stringmat on the stack at position spos
c     of size mxn the stringmat is filled with the datas stored 
c     in stk(lorig) ( for example created with cstringv ) 
c     and the data stored at stk(lorig) is freed 
C     -------------------------------------------------------------------
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
         call error(998)
         crestringmatfromC=.false.
         return
       endif
       lstk(spos+1)=sadr(ilw+5+m*n+istk(ilw+4+m*n)-1)
       crestringmatfromC=.true.
       return
       end 


       subroutine crelist(slw,ilen,lw) 
C     -------------------------------------------------------------------
c     creation d'une liste en lstk(slw) qui doit contenir ilen elements 
C     renvoit lw ( on peut stocker le premier element en stk(lw)) 
C     Attention la creation de la liste n'est complete que lorsque l'on 
C     a rajoute les elements 
C     A verifier : si la liste est vide  il faut terminer la creation 
C     ===> Attention sinon la creation de la liste ne sera finie que lorsque 
C     les elements seront bien rajoutes 
C     XXXXX : il faudrait  lw+1 par rapport a bot si on renvoit la 
C     liste vide ....
C     -------------------------------------------------------------------
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


      subroutine cretlist(slw,ilen,lw) 
C     -------------------------------------------------------------------
c     creation d'une t-liste en lstk(slw) 
C     -------------------------------------------------------------------
C     renvoit lw ( on peut stocker le premier element en stk(lw)) 
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


      logical function getlistvectrow(fname,topk,spos,lnum,it,m,n,lr,lc)
C     ------------------------------------------------------------------
C     getlistvectrow : recupere un vecteur ligne dans une liste 
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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


      logical function getlistvectcol(fname,topk,spos,lnum,it,m,n,lr,lc)
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------
C     implicit undefined (a-z)
      logical getilist,getmatI
      character fname*(*)
      integer topk,spos,lnum,it,m,n,lr,lc,iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      getlistvectcol= getilist(fname,topk,spos,nv,lnum,ili)
      if (.not.getlistvectcol) return
      if (lnum.gt.nv) then
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // ' should be a list ')
         write(buf(1:3),'(i3)')  lnum
         call basout(io,wte,'of size at least '// buf(1:3))
         getlistvectcol=.false.
         return 
      endif
      getlistvectcol = getmatI(fname,topk,spos,ili,it,m,n,lr,lc,
     $     .true.,lnum)
      if (.not. getlistvectcol) return 
      if (n.ne.1) then 
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         write(buf(nlgh+4:nlgh+6),'(i3)') lnum
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $        // buf(nlgh+1:nlgh+3) // '>('// buf(nlgh+4:nlgh+6)
     $        // 'should be a column vector')
         getlistvectcol = .false.
      endif
      return
      end
      
      logical  function getvectcol(fname,topk,spos,it,m,n,lr,lc)
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
      integer topk,spos,it,m,n,lr,lc
      logical getmatI
      character fname*(*)
      include '../stack.h'
      getvectcol= getmatI(fname,topk,spos,lstk(spos),it,m,n,lr,lc,
     $     .false.,0)
      if (.not.      getvectcol) return 
      if (n.ne.1) then 
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),'(i3)') rhs+(spos-topk)
         call basout(io,wte,buf(1:nlgh)// ': argument ' 
     $           // buf(nlgh+1:nlgh+3) 
     $           // 'should be a column vector matrix ')
         getvectcol=.false.
      endif
      return
      end 
      

      logical function getlistscalar(fname,topk,spos,lnum,lr)
C     ------------------------------------------------------------------
C     getlistscalar : recupere un scalaire 
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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
C     ------------------------------------------------------------------
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


      logical function getonepoly(fname,topk,lw,it,md,name,
     $     namel,lr,lc)
C     ------------------------------------------------------------------
C     recupere un polynome 
C     md est son degre et son premier element est en 
C     stk(lr),stk(lc) 
C     Finir les tests 
C     ------------------------------------------------------------------
      integer topk,lw,it,m,n,lr,lc,ilp,namel
      character fname*(*)
      character*4 name 
      include '../stack.h'
      logical getpoly
      getonepoly= getpoly(fname,topk,lw,it,m,n,name,
     $     namel,ilp,lr,lc) 
      if (.not.getonepoly) return 
      if (m*n.ne.1) then
         buf = fname // 'Argument should be a polynom'
         call error(998)
         getonepoly=.false.
         return 
      endif
      getonepoly=.true.
      md= istk(ilp+1)-istk(ilp)-1 
      lr=lr+istk(ilp)
      lc=lc+istk(ilp)
      return
      end



      logical function creMpointer(fname,spos,lw)
C     -------------------------------------------------------------------
C     Creation a la position spos de la pile d'un objet de type pointeur 
C     de Matrices utilise pour le nouveau stack 
C     -------------------------------------------------------------------
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


      logical function getMpointer(fname,topk,spos,lw)
C     -------------------------------------------------------------------
C     recuperation d'un Mpointer (Matrix Pointer ) utilise pour le nouveau stack 
C     -------------------------------------------------------------------
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



C     -------------------------------------------------------------------
C     Creation a la position spos de la pile d'un objet de type pointeur 
C     de Matrices utilise pour le nouveau stack 
C     -------------------------------------------------------------------

      logical function creOpointer(fname,spos,lw)
      integer spos,lw
      character fname*(*)
      integer iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      if ( spos+1.ge.bot) then
         call error(18)
         creOpointer =.false.
         return
      endif
      il=iadr(lstk(spos))
      err=sadr(il+4)+1 -lstk(bot)
      if(err.gt.0) then
         call error(17)
         creOpointer=.false.
         return
      else
         creOpointer=.true.
         istk(il)=204
         istk(il+1)=1
         istk(il+2)=1
         istk(il+3)=0
         lw=sadr(il+4)
         lstk(spos+1)=sadr(il+4)+2
         return
      endif
      end



C     -------------------------------------------------------------------
C     recuperation d'un Opointer (Matrix Pointer ) utilise pour le nouveau stack 
C     -------------------------------------------------------------------

      logical function getOpointer(fname,topk,spos,lw)
      integer spos,lw,topk
      character fname*(*)
      integer iadr,sadr
      include '../stack.h'
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      if ( spos+1.ge.bot) then
         call error(18)
         getOpointer=.false.
         return
      endif
      il=iadr(lstk(spos))
      if (istk(il).ne.204 ) then 
         buf = ' '
         call error(999)
         write(buf,*) fname 
         write(buf(nlgh+1:nlgh+3),*) rhs+(spos-topk)
         call basout(io,wte, buf(1:nlgh)// 
     $        ': Argument  '  // buf(nlgh+1:nlgh+3)//
     $        ' should be a Opointer ')
         getOpointer = .false.
      else
         lw=sadr(il+4)
         getOpointer = .true.
      endif
      return 
      end




