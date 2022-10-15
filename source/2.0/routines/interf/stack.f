      logical function checkrhs(fname,imin,imax)
C     verifie  que le nombre d'argument rhs est >= imin <= imax
C      implicit undefined (a-z)
      integer imin,imax
      character fname*(*)
      include '../stack.h'
      if ( imin.le.rhs.and.rhs.le.imax) then
         checkrhs=.true.
      else
         checkrhs=.false.
         call cvname(ids(1,pt+1),fname,0)
         call error(77)
      endif
      return
      end

      logical function checklhs(fname,imin,imax)
C     verifie  que le nombre d'argument lhs est >= imin <= imax
C      implicit undefined (a-z)
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

      logical  function getmat(fname,topk,lw,it,m,n,lr,lc)
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
      character fname*(*)
      integer il
      include '../stack.h'
      integer adr
      il=adr(lstk(lw),0)
C     test particulier decouvert ds logic.f
      if(istk(il).lt.0) il=adr(istk(il+1),0)
      if(istk(il).ne.1) then
         getmat=.false.
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         call error(201)
      else
         m=istk(il+1)
         n=istk(il+2)
         it=istk(il+3)
         lr=adr(il+4,1)
         if (it.eq.1) then
            lc=lr+m*n
         endif
         getmat=.true.
      endif
      return
      end

      logical  function getvect(fname,topk,lw,it,m,n,lr,lc)
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
C			   a(1,1)=istk(adr(lr,0))
C       lc : pointe sur la partie imaginaire si besoin est
C
C      implicit undefined (a-z)
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
C     comme getmat, mais verifie en plus que la matrice est
C     reele
C      implicit undefined (a-z)
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
C			   a(1,1)=istk(adr(lr,0))
C      implicit undefined (a-z)
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
C     comme getmat, mais verifie en plus que la matrice est
C     bien de taille m,n
C      implicit undefined (a-z)
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
C     comme getvect, mais verifie en plus que le vecteur
C     bien de taille n
C      implicit undefined (a-z)
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
C     comme getbmat, mais verifie en plus que la matrice est
C     bien de taille m,n
C      implicit undefined (a-z)
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
      integer topk,lw,m,n,i,j,lr,nlr
      integer il
      character fname*(*)
      include '../stack.h'
      integer adr
      il=adr(lstk(lw),0)
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
      integer topk,lw,m,n,i,j,lr,nlr
      integer il,k
      character fname*(*)
      integer adr
      il=adr(lstk(lw),0)
      m=istk(il+1)
      n=istk(il+2)
      k=(i-1)+(j-1)*m
      lr=il+4+m*n+ istk(il+4+k)
      nlr=istk(il+4+k+1)-istk(il+4+k)
      return
      end


      logical function cresmat(fname,lw,m,n,nchar)
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
      character fname*(*)
      integer lw,m,n,nchar,il,ilp,kij,ilast
      integer adr
      include '../stack.h'
      if ( lw+1.ge.bot) then
         call error(18)
         cresmat=.false.
         return
      endif
      il=adr(lstk(lw),0)
      err=adr(il+4+(nchar+1)*m*n,1)-lstk(bot)
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
         lstk(lw+1)=adr(ilast+istk(ilast),1)
         return
      endif
      end


      logical function cresmat1(fname,lw,m,nchar)
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
      character fname*(*)
      integer lw,m,nchar(m),il,ilp,kij,ilast,nnchar,i
      integer adr
      include '../stack.h'
      if ( lw+1.ge.bot) then
         call error(18)
         cresmat1=.false.
         return
      endif
      nnchar=0
      do 20 i=1,m
         nnchar=nchar(i)+nnchar
 20   continue
      il=adr(lstk(lw),0)
      err=adr(il+4+(nnchar+1)*m,1)-lstk(bot)
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
         lstk(lw+1)=adr(ilast+istk(ilast),1)
         return
      endif
      end

      logical function cresmat2(fname,lw,nchar,lr)
C     verifie que l'on peut stocker une matrice [1,1]
C     de chaine de caracteres  a la position lw en renvoyant .true. ou .false.
C	  suivant la reponse. Si la reponse est .true.
C     nchar est le nombre de caracteres que l'on peut stcoker 
C     Entree :
C       lw : position (entier)
C     Sortie :
C       nchar : nombre de caracteres stockable
C       lr : pointe sur  a(1,1)=istk(lr)
C!
C      implicit undefined (a-z)
      character fname*(*)
      integer lw,nchar,il,ilast,lr
      integer adr
      include '../stack.h'
      if ( lw+1.ge.bot) then
         call error(18)
         cresmat2=.false.
         return
      endif
      il=adr(lstk(lw),0)
      err=adr(il+4+(nchar+1),1)-lstk(bot)
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
         lstk(lw+1)=adr(ilast+istk(ilast),1)
         lr=ilast+ istk(ilast-1)
         return
      endif
      end

      logical function smatj(fname,lw,j)
C     verifie qu'il y a une matrice de chaine de caracteres en lw-1
C     et verifie que l'on peut stocker l'extraction de la jieme colonne
C     en lw : si oui l'extraction est faite 
C     Entree :
C       lw : position (entier)
C       j  : colonne a extraire 
C!
C      implicit undefined (a-z)
      character fname*(*)
      integer lw,j,m,n,adr,lr,nlj,il1,il2,il2p,incj,nj,i,lj
      logical getsmat 
      include '../stack.h'
      smatj=.false.
      if ( lw+1.ge.bot) then
         call error(18)
         return
      endif
      if (.not.getsmat(fname,lw-1,lw-1,m,n,1,1,lr,nlj)) return
      if ( j.gt.n) return 
      il1=adr(lstk(lw-1),0)
      il2=adr(lstk(lw),0)
C     nombre de caracteres de la jieme colonne 
      incj=(j-1)*m
      nj=istk(il1+4+incj+m)-istk(il1+4+incj)
C     test de place 
      err=adr(il2+4+m+nj+1,1)-lstk(bot)
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
      lstk(lw+1)=adr(il2+4+m+nj+1,1)
      smatj=.true.
      return
      end


      logical function lmatj(fname,lw,j)
C     verifie qu'il y a une liste en lw-1
C     et verifie que l'on peut stocker l'extraction du jieme 
C     element de la liste en lw : si oui l'extraction est faite 
C     Entree :
C       lw : position (entier)
C       j  : colonne a extraire 
C!
C      implicit undefined (a-z)
      logical getilist
      character fname*(*)
      integer lw,j,n,il,ilj,slj
      integer adr
      include '../stack.h'
      lmatj=.false.
      if ( lw+1.ge.bot) then
         call error(18)
         return
      endif
      if (.not.getilist(fname,lw-1,lw-1,n,j,ilj)) return 
      if ( j.gt.n) return 
C     a ameliorer 
      il=adr(lstk(lw-1),0)
      slj=adr(il+3+n,1)+istk(il+2+(j-1))-1
      n=istk(il+2+j)-istk(il+2+(j-1))
      err=lstk(lw)+n-lstk(bot)
      if(err.gt.0) return
      call dcopy(n,stk(slj),1,stk(lstk(lw)),1)
      lstk(lw+1)=lstk(lw)+n
      lmatj=.true.
      return
      end

      logical function pmatj(fname,lw,j)
C     verifie qu'il y a une matrice de polynomes en  lw-1
C     et verifie que l'on peut stocker l'extraction de la jieme 
C     colonne en lw : si oui l'extraction est faite 
C     Entree :
C       lw : position (entier)
C       j  : colonne a extraire 
C!
C      implicit undefined (a-z)
      logical getpoly
      character fname*(*),name*4
      integer lw,j,n,il,it,m,namel,lr,lc
      integer adr
      include '../stack.h'
      pmatj=.false.
      if ( lw+1.ge.bot) then
         call error(18)
         return
      endif
      if (.not.getpoly(fname,lw-1,lw-1,it,m,n,name,namel,ilp,lr,lc))
     $     return
      if ( j.gt.n) return 
C     a ameliorer
      il= adr(lstk(lw-1),0)
      incj=(j-1)*m
      il2 = adr(lstk(lw),0)
      l2 = adr(il2 + 4,1)
      m2=max(m,1)
      l=adr(il+9+m*n,1)
      n=istk(il+8+m*n)
      l2=adr(il2+9+m2,1)
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
C     copie la matrice de chaine de caracteres stockee en flw
C     en tlw, les verifications de dimensions
C     ne sont pas faites
C     lstk(tlw+1) est modifie si necessaire
C      implicit undefined (a-z)
      character fname*(*)
      integer flw,tlw,dflw,fflw,dtlw
      integer adr
      include '../stack.h'
      dflw=adr(lstk(flw),0)
      fflw=adr(lstk(flw+1),0)
      dtlw=adr(lstk(tlw),0)
      call icopy(fflw-dflw,istk(dflw),1,istk(dtlw),1)
      lstk(tlw+1)=lstk(tlw) + lstk(flw+1)-lstk(flw)
      return
      end

      subroutine setsimat(fname,lw,i,j,nlr)
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
      integer lw,m,i,j,nlr,il,k
      character fname*(*)
      integer adr
      include '../stack.h'
      il=adr(lstk(lw),0)
      m=istk(il+1)
      k=(i-1)+(j-1)*m
      istk(il+4+k+1)=istk(il+4+k)+nlr
      return
      end

      subroutine realmat
C     top est une matrice qui est convertie en matrice reelle
C     on recupere de la place si top etait complexe
C     pas de verifications
C     utiliser getmat avant d'appeler realmat
C      implicit undefined (a-z)
      integer adr
      integer il,m,n
      include '../stack.h'
      il=adr(lstk(top),0)
      if (istk(il+3).eq.0) return
      m=istk(il+1)
      n=istk(il+2)
      istk(il+3)=0
      lstk(top+1)=adr(il+4,1)+m*n
      return
      end

      logical function cremat(fname,lw,it,m,n,lr,lc)
C     verifie que l'on peut stocker une matrice [it,m,n]
C     a la position lw en renvoyant .true. ou .false.
C	  suivant la reponse
C     Entree :
C       lw : position (entier)
C       it : type 0 ou 1
C       m, n dimensions
C     Sortie :
C       lr : pointe sur la partie reelle ( si la matrice est a
C              a(1,1)=stk(lr)
C            si l'on veut acceder a des entiers

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
      character fname*(*)
      integer lw,it,m,n,lr,lc
      integer il
      integer adr
      include '../stack.h'
      if ( lw+1.ge.bot) then
         call error(18)
         cremat=.false.
         return
      endif
      il=adr(lstk(lw),0)
      err=adr(il+4,1)+m*n-lstk(bot)
      if(err.gt.0) then
         call error(17)
         cremat=.false.
         return
      else
         cremat=.true.
         istk(il)=1
         istk(il+1)=m
         istk(il+2)=n
         istk(il+3)=it
         lr=adr(il+4,1)
         lc=lr+m*n
         lstk(lw+1)=adr(il+4,1)+m*n*(it+1)
         return
      endif
      end

      subroutine copyobj(fname,lw,lwd)
C     copie l'objet qui est a la position lw de la pile
C     a la position lwd de la pile
C     copie faite avec dcopy
C     pas de verification
C      implicit undefined (a-z)
      character fname*(*)
      integer lw,lwd
      include '../stack.h'
      call dcopy(lstk(lw+1)-lstk(lw),stk(lstk(lw)),1,
     $     stk(lstk(lwd)),1)
      lstk(lwd+1)=lstk(lwd)+lstk(lw+1)-lstk(lw)
      return
      end

      logical function vcopyobj(fname,lw,lwd)
C     copie l'objet qui est a la position lw de la pile
C     a la position lwd de la pile
C     copie faite avec dcopy
C     et verification 
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
         if(err.gt.0) return
      endif
      vcopyobj=.true.
      call dcopy(lv,stk(l),1,stk(l1),1)
      lstk(lwd+1)=lstk(lwd)+lv
      end

      logical function getbmat(fname,topk,lw,m,n,lr)
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
      character fname*(*)
      integer topk,lw,m,n,lr
      integer il
      integer adr
      include '../stack.h'
      il=adr(lstk(lw),0)
C     test particulier decouvert ds logic.f
      if(istk(il).lt.0) il=adr(istk(il+1),0)
      if(istk(il).ne.4) then
         getbmat=.false.
         call cvname(ids(1,pt+1),fname,0)
         err=rhs+(lw-topk)
         call error(208)
      else
         m=istk(il+1)
         n=istk(il+2)
         lr=il+3
         getbmat=.true.
      endif
      return
      end

      logical function crebmat(fname,lw,m,n,lr)
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
C!
C      implicit undefined (a-z)
      character fname*(*)
      integer lw,m,n,lr
      integer il
      integer adr
      include '../stack.h'
      il=adr(lstk(lw),0)
      err=il+3+m*n - adr(lstk(bot),0)
      if(err.gt.0) then
         call error(17)
         crebmat=.false.
         return
      else
         crebmat=.true.
         istk(il)=4
         istk(il+1)=m
         istk(il+2)=n
         lr=il+3
         lstk(lw+1)=adr(il+3+m*n+2,1)
         return
      endif
      end

      logical function swapmat(fname,topk,lw,it1,m1,n1
     $     ,mn1,it2,m2,n2,mn2)
C     suppose qu'il y a une matrice en lw de taille it1,m1,n1,mn1,
C     et une autre en lw+1 de taille it2,m2,n2,mn2
C     et echange les matrices et change les valeurs de it1,m1,n1,...
C     apres echange la taille de la matrice en lw est stocke ds(it1,m1,n1)
C     et celle en lw+1 est stocke ds (it2,m2,n2)
C     effet de bord il faut que lw+2 soit une place libre
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
C     renvoit le type de  lw
C      implicit undefined (a-z)
      integer lw
      integer adr
      include '../stack.h'
      il=adr(lstk(lw),0)
      if(istk(il).lt.0) il=adr(istk(il+1),0)
      gettype=istk(il)
      return
      end

      integer function ogettype(lw)
C     renvoit le type de  lw
C      implicit undefined (a-z)
      integer lw
      integer adr
      include '../stack.h'
      ogettype=(istk(adr(lstk(lw),0)))
      return
      end

      subroutine stackinfo(lw,typ)
C     imprime le contenu de la pile en lw en mode entier ou
C	  double precision suivant typ
C     ---> a utilier a l'interieur de dbx pour debuguer
C      implicit undefined (a-z)
      integer adr
      include '../stack.h'
      integer il,lw,i,m,n,typ,l
      character*7 t(5)
      if (lw.eq.0) return
      il =adr(lstk(lw),0)
      if(istk(il).lt.0) il=adr(istk(il+1),0)
      m  =istk(il+1)
      n  =istk(il+2)
      call basout(io,wte,
     +     '-----------------stack-info-----------------')
      call basout(io,wte,' ')
      write(t(1),'(i7)') lw
      write(t(2),'(i7)') adr(lstk(lw+1),0)
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
         l=adr(il+4,1)
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
      integer adr
      include '../stack.h'
      integer il,itype
      il=adr(lstk(lw),0)
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
C     refixe la taille d'une matrice de n'importe quoi
C     sans se preocuper du contenu
C      implicit undefined (a-z)
      character fname*(*)
      integer lw,m,n
      integer adr
      include '../stack.h'
      integer il
      il=adr(lstk(lw),0)
      istk(il+1)=m
      istk(il+2)=n
      return
      end


      logical  function getilist(fname,topk,lw,n,i,ili)
C     renvoit .true. si l'argument en lw est une liste
C     Entree :
C      fname : nom de la routine appellante pour le message
C          d'erreur
C      lw : position ds la pile
C      i  : element demande
C     Sortie :
C      n  : nombre d'elements ds la liste
C      ili : le ieme element commence en istk(adr(ili,0))
C     ==> pour recuperer un argument il suffit 
C     de faire un lk=lstk(top);lstk(top)=ili; getmat(...,top,...);stk(top)=lk
C      implicit undefined (a-z)
      character fname*(*)
      integer topk,lw,n,i,ili
      integer adr
      integer il,itype
      include '../stack.h'
      il=adr(lstk(lw),0)
      if(istk(il).lt.0) il=adr(istk(il+1),0)
      itype=istk(il)
      if(itype.ne.15) then
         err=rhs+(lw-topk)
         call cvname(ids(1,pt+1),fname,0)
         call error(210)
         getilist=.false.
         return
      endif
      n=istk(il+1)
      if ( i.le.n) then
         ili=adr(il+3+n,1) + istk(il+2+(i-1))-1
      else
         ili=0
      endif
      getilist=.true.
      end

      subroutine objvide(fname,lw)
C     cree un objet vide en lw et met a jour lw+1
C     en fait lw doit etre top
C     verifie les cas particuliers lw=0 ou lw=1
C     ainsi que le cas particulier ou une fonction
C     n'a pas d'arguments (ou il faut faire top=top+1)
C      implicit undefined (a-z)
      character fname*(*)
      integer lw
      integer adr
      include '../stack.h'
      if (lw.eq.0.or.rhs.lt.0)  lw=lw+1
      if (lw.eq.1) lstk(lw)=1
      istk(adr(lstk(lw),0))=0
      lstk(lw+1)=lstk(lw)+2
      return
      end


      logical function getexternal(fname,topk,lw,name,type)
C     renvoit .true. si l'argument en lw est un ``external''
C             sinon appelle error et renvoit .false.
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
      character fname*(*),name*6
      integer topk,lw,m,n,lr,nlr,il,gettype
      logical getsmat,type
      include '../stack.h'
      il=gettype(lw)
      if(il.eq.11.or.il.eq.13.or.il.eq.15) then
         getexternal=.true.
         type =.false.
      else if (il.eq.10) then
         getexternal=getsmat(fname,topk,lw,m,n,1,1,lr,nlr)
         type = .true.
         name = ' '
         if (getexternal.neqv..false.) call cvstr(nlr,istk(lr),name,1)
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
      integer topk,lw,it,m,n,lr,lc,ilp,il,namel
      character fname*(*)
      character*4 name 
      include '../stack.h'
      integer adr
      il=adr(lstk(lw),0)
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
 11      if ( name(namel:namel).eq.' ') then 
            namel=namel-1
            goto 11
         endif
         ilp=il+8
         lr=adr(ilp+m*n+1,1)-1
         lc=lr +istk(ilp+m*n)-1
         getpoly=.true.
      endif
      return
      end


      logical function crewimat(fname,lw,m,n,lr)
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
      character fname*(*)
      integer lw,m,n,lr
      integer il
      integer adr
      include '../stack.h'
      il=adr(lstk(lw),0)
      err=il+3+m*n - adr(lstk(bot),0)
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
         lstk(lw+1)=adr(il+3+m*n+2,1)
         return
      endif
      end

      logical function getwimat(fname,topk,lw,m,n,lr)
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
      character fname*(*)
      integer topk,lw,m,n,lr
      integer il
      integer adr
      include '../stack.h'
      il=adr(lstk(lw),0)
C     test particulier decouvert ds logic.f
      if(istk(il).lt.0) il=adr(istk(il+1),0)
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

