      subroutine inibas( ini1, bu1, vsizr, ierr)
c             initialization
c ====================================================================
C     implicit undefined (a-z)
      integer        ierr,ini1,vsizr
      character*(*)  bu1
c
c
      include '../stack.h'
      parameter (nz1=nsiz-1,nz2=nsiz-2)
c
c common unite logique
      integer         nunit,unit(20)
      common /units / nunit,unit
c common pour la gestion du break
      logical         iflag
      common /basbrk/ iflag
c common pour le mode de protection des macros
      integer macprt
      common /mprot/ macprt
c common pour la synchronisation
      integer isok,ntfy,enabled(100)
      common /syncro/ isok,ntfy,enabled
c
      save /stack/,/vstk/,/recu/,/iop/,/com/,/cha1/
      save /units/
c
      logical first
      double precision d1mach
      integer i1mach
      integer i,k,l,lecbuf,nc
      integer eps(nsiz),im(nsiz),exp(nsiz),pi(nsiz),bl(nsiz),io(nsiz)
      integer inf(nsiz),nan(nsiz),true(nsiz),false(nsiz)
      integer iadr,sadr
c
      double precision  iov(2)
c     character set
c            0       10       20       30       40       50
c
c     0      0        a        k        u   colon  :  less   <
c     1      1        b        l        v   plus   +  great  >
c     2      2        c        m        w   minus  -  perc   %
c     3      3        d        n        x   star   *  under  _
c     4      4        e        o        y   slash  /
c     5      5        f        p        z   bslash \
c     6      6        g        q  blank     equal  =
c     7      7        h        r  lparen (  dot    .
c     8      8        i        s  rparen )  comma  ,
c     9      9        j        t  semi   ;  quote  '
c
      character alpha(csiz)*1,alphb(csiz)*1
      data alpha /'0','1','2','3','4','5','6','7','8','9',
     $    'a','b','c','d','e','f','g','h','i','j',
     $    'k','l','m','n','o','p','q','r','s','t',
     $    'u','v','w','x','y','z','_','#','!','0',
     $    ' ','(',')',';',':','+','-','*','/','\\',
     $    '=','.',',','''','[',']','%','|','&','<','>','~',
     $    '^'/
c
c     alternate character set
c
      data alphb /'0','1','2','3','4','5','6','7','8','9',
     $    'A','B','C','D','E','F','G','H','I','J',
     $    'K','L','M','N','O','P','Q','R','S','T',
     $    'U','V','W','X','Y','Z','0','0','?','0',
     $    '0','0','0','0','0','0','0','0','0','$',
     $    '0','0','0','"','{','}','0','0','0','`','0','@',
     $    '0'/
c
      data im/673714744,nz1*673720360/,exp/673713720,nz1*673720360/
      data pi/672274744,nz1*673720360/,bl/nsiz*673720360/
      data eps/471404088,nz1*673720360/,io/672666168,nz1*673720360/
      data first/.true./
      data inf/253170232,nz1*673720360/,nan/386537272,nz1*673720360/
      data true/673717560,nz1*673720360/,false/673713976,nz1*673720360/
c
      data nunit/20/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
c
c -----------------------
c initialisation 
c -----------------------
c
      comp(1) =   0
      err     =   0
      errct   =   -1
      err1    =   0
      err2    =   0
      fun     =   0
      macr    =   0
      niv     =   0
      paus    =   0
      pt      =   0
      top     =   0
      lstk(1) =   1
      lcntr   =   0
      nmacs   =   0
      lgptrs(1)=  1
      wmac    =   0
      call iset(100,0,enabled,1)
c
c -----------------------------------
c initialisation ini1  and buffer
c -----------------------------------
c
      if ( ini1.lt.-1 ) then
         if ( bu1.ne.' ' ) then
            buf    = bu1
            lecbuf =   1
         else
            lecbuf = 0
         endif
         if ( ini1.ne.-3 ) ini1 = ini1 + 2
      else
         lecbuf = 0
      endif
      if ( ini1.lt.0 ) goto 10
c
c ---------------------------------------
c initialisation pour ini1 positif ou nul
c ---------------------------------------
c
      if(lecbuf.eq.1) then
         rio=-1
         goto 90
      elseif(ini1.eq.0) then
         rio=rte
         fin=  0
         goto 90
      elseif(ini1.le.nunit) then
         err=nunit
         call error(122)
         ierr=err
         return
      elseif(unit(ini1).ne.0) then
         err=ini1
         call error(65)
         ierr=err
         return
      endif
      rio=ini1
      fin= -1
      pt =  0
      pt = pt+1
      pstk(pt)=0
      rstk(pt)=21
      lpt(1)=1
      lpt(6)=0
      goto 90
c
c --------------------------------
c initialisation pour ini1 negatif
c --------------------------------
c
  10  continue
c
c initialisation de la table de liens dynamiques
c ----------------------------------------------
      nlink=0
c
c mode de protection des macros
c------------------------------
      macprt=0
c
c initialisation des entrees/sorties standard
c -------------------------------------------
      do 11 i=1,nunit
         unit(i)=0
   11 continue
c rte = unit number for terminal input
      if(ini1.ne.-3) then
         rte = i1mach(1)
         call clunit(rte,buf,0)
         if(err.gt.0) then
            call error(48)
            ierr=err
            return
         endif
      else
         rte=9999
      endif
      rio = rte
      if(lecbuf.eq.1) rio = -1
c wte = unit number for terminal output
      if(ini1.ne.-3) then
         wte = i1mach(2)
         call clunit(wte,buf,1)
         if(err.gt.0) then
            call error(48)
            ierr=err
            return
         endif
      else
         wte=9999
      endif
      wio = 0
c hio =unit for history output
      hio = 0
      i   = 0
      call inffic(4,buf,nc)
      nc=max(1,nc)
      call clunit(i,buf(1:nc),3)
      if(err.gt.0) then
         call error(err)
         hio=0
         err=0
      else
         hio=i
      endif
c baniere
c -------
      call banier(wte)
      rio=rte
c recuperation du break
c----------------------
      if (first) then
          call inibrk
          first=.false.
      endif
c random number seed
c ------------------
      ran(1) =  0
      ran(2) =  0
c limites initiales sur le nombre de lignes et de colonnes
c---------------------------------------------------------
      lct(2) = 45
      lct(5) = 72
c format initial 
c---------------
      lct(6) =  1
      lct(7) = 10
c mode de debug
c--------------
      ddt = 0
c table des caracteres
c---------------------
      do 20 i = 1, csiz
         alfa(i) = alpha(i)
         alfb(i) = alphb(i)
   20 continue
c pile
c-----
      bot=isiz-7
      bbot=bot
      bot0=bot
      l=vsizr-(8*sadr(5)+2)-2*sadr(4)
      k=bot
      lstk(k)=l
C----- Inserting predefined variables 
c     %t   : variable logique vraie
      call crebmatvar(true,k,1,1,1)
      k=k+1
c     %f   : variable logique fausse
      call crebmatvar(false,k,1,1,0)
      k=k+1
c     %eps : precision machine
      call crematvar(eps,k,0,1,1,d1mach(4),0.0d0)
      leps=sadr( iadr(lstk(k)) +4)
      k=k+1
c     %io : entree/sorties ecran
      iov(1)=dble(rte)
      iov(2)=dble(wte)
      call crematvar(io,k,0,1,2,iov,0.0d0)
      k=k+1
c     %i : racine carre de -1
      call crematvar(im,k,1,1,1,0.0d0,1.0d0)
      k=k+1
c     %e : exponentielle de 1
      call crematvar(exp,k,0,1,1,2.71828182845904530d+0,0.0d0)
      k=k+1
c     %pi : comme son nom l'indique
      call crematvar(pi,k,0,1,1,3.14159265358979320d+0,0.0d0)
      k=k+1
c     blanc ?
      call crematvar(bl,k,0,1,1,0.0d0,0.0d0)
      k=k+1
c
 90   return
      end

      subroutine crematvar(id,lw,it,m,n,rtab,itab)
C     same as cremat, but without test ( we are below bot)
C     and adding a call to putid 
C     cree une variable de type matrice 
C     de nom id 
C     en lw : sans verification de place 
C     implicit undefined (a-z)
      integer id(*),lw,it,m,n,lr,lc,il,adr
      double precision rtab(*),itab(*)
      include '../stack.h'
      call putid(idstk(1,lw),id)
      il=adr(lstk(lw),0)
      istk(il)=1
      istk(il+1)=m
      istk(il+2)=n
      istk(il+3)=it
      lr=adr(il+4,1)
      lc=lr+m*n
      if (lw.lt.isiz) lstk(lw+1)=adr(il+4,1)+m*n*(it+1)
      call dcopy(m*n,rtab,1,stk(lr),1)
      if (it.eq.1) call dcopy(m*n,itab,1,stk(lc),1)
      return
      end

      subroutine crebmatvar(id,lw,m,n,val)
C     crebmat without check and call to putid 
C      implicit undefined (a-z)
      integer lw,m,n,val(*),il,adr,id(*),lr
      include '../stack.h'
      call putid(idstk(1,lw),id)
      il=adr(lstk(lw),0)
      istk(il)=4
      istk(il+1)=m
      istk(il+2)=n
      lr=il+3
      lstk(lw+1)=adr(il+3+m*n+2,1)
      call icopy(m*n,val,1,istk(lr),1)
      end
