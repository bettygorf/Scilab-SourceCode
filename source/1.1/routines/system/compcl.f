      subroutine compcl
c     ======================================================================
c     compilation des structures de controle
c     ======================================================================
      include '../stack.h'
c
      logical eqid,compil,ilog
      integer while(nsiz),else(nsiz),r,cas(nsiz),sel(nsiz),elsif(nsiz)
      integer eol
      integer iadr,sadr

      data else/236721422,673720360/, while/353505568,673720334/
      data cas/236718604,673720360/, sel/236260892,673717516/
      data elsif/236721422,673713938/
      data eol/99/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      l=comp(1)
      r = rstk(pt)-800
      if (ddt .eq. 4) then
         write(buf(1:20),'(2i4,2i6)') pt,rstk(pt),l,comp(2)
         call basout(io,wte,' compcl pt:'//buf(1:4)//' rstk(pt):'
     &              //buf(5:8)//' comp(1):'//buf(9:14)//' comp(2):'
     &              //buf(15:20))
      endif

      if(eqid(ids(1,pt),sel)) goto 10
      goto(02,03,04,05,06,08),r
c
c for : <7 l.boucle boucle.ops l.ops varn(1:nsiz) for.ops>
c
c debut for
   01 continue
      ilog=compil(1,7,comp(2))
      comp(2)=comp(1)
      return
   02 continue
      l0=comp(2)
      comp(2)=istk(l0-1)
      istk(l0-1)=l-l0
      ilog=compil(nsiz,comp(2),ids(1,pt),ids(2,pt))
      comp(2)=l
      return
c fin for
 03   l0=comp(2)
      comp(2)=istk(l0)
      istk(l0)=l-(l0+nsiz+1)
      call setlnb
      return
c
c while : <8 0 l.exprs l.then l.else exprs.ops then.ops else.ops>
c if    : <9 0 l.exprs l.then l.else exprs.ops then.ops else.ops>
c le "0" est present pour conserver la compatibilite avec la version precedente
c
c debut d'un if ou while
 04   nn=4
      ilog=compil(nn,l,comp(2),0,0,l+1)
      comp(2)=l+4
      return
c fin des expressions du if ou des elseif
   05 l0=comp(2)
      istk(l)=istk(l0)
      lc=istk(l0)+1
      istk(lc)=istk(lc)+1
      istk(l0)=l-(l0+1)
      comp(2)=l
      comp(1)=l+1
      call setlnb
      return
c fin d'un  Then
   06 l0=comp(2)
      istk(l)=istk(l0)
      istk(l0)=l-(l0+1)
      comp(2)=l
      comp(1)=l+1
      if(eqid(syn(1),elsif))return
c fin de la sequence des then
c     on debute le else par une sequence expression vide
      istk(l+1)=istk(l)
      istk(l)=0
      comp(2)=l+1
      comp(1)=l+2
      call setlnb
      if(eqid(syn(1),else)) return
c il n'y a pas de else,
c     on introduit une sequence else_instructions vide
      istk(l+2)=istk(l+1)
      istk(l+1)=0
      comp(2)=l+2
      l=l+3
      comp(1)=l
c     et on termine le if/while
      goto 09
c
c fin du else
   08 l0=comp(2)
      istk(l)=istk(l0)
      istk(l0)=l-(l0+1)
      comp(2)=l
c
c fin if/while
   09 l0=comp(2)
      l0=istk(comp(2))
      comp(2)=istk(l0)
      istk(l0)=-(l-istk(l0-1))
      istk(l0-1)=8
      if(eqid(ids(1,pt),while)) istk(l0-1)=9
      call setlnb
      return
c
c
c select case
   10 continue
      goto(11,13,14,15,12),r-2
      goto 99
c
c debut selec (premiere expression)
   11 ilog=compil(3,l,comp(2),0,0)
      comp(2)=l+3
      return
c
c fin premiere expression
   12 l0=comp(2)
      istk(l)=l0-2
      istk(l0)=l-(l0+1)
      comp(2)=l
      comp(1)=l+1
      return
c
c fin des expressions des cases
   13 l0=comp(2)
      istk(l)=istk(l0)
      lc=istk(l0)+1
      istk(lc)=istk(lc)+1
      istk(l0)=l-(l0+1)
      comp(2)=l
      comp(1)=l+1
      call setlnb
      return
c fin d'un case (partie Then)
   14 l0=comp(2)
      istk(l)=istk(l0)
      istk(l0)=l-(l0+1)
      comp(2)=l
      comp(1)=l+1
      if(eqid(syn(1),cas))return
c fin de la sequence de cases
c     on debute le else par une sequence expression vide
      istk(l+1)=istk(l)
      istk(l)=0
      comp(2)=l+1
      comp(1)=l+2
      if(eqid(syn(1),else)) then
         call setlnb
         return
      endif
c il n'y a pas de else,
c     on introduit une sequence else_instructions vide
      istk(l+2)=istk(l+1)
      istk(l+1)=0
      comp(2)=l+2
      l=l+3
      comp(1)=l
c     et on termine le select
      goto 17
c
c fin du else
   15 l0=comp(2)
      istk(l)=istk(l0)
      istk(l0)=l-(l0+1)
      comp(2)=l
c
c fin selec
   17 l0=comp(2)
      l0=istk(comp(2))
      comp(2)=istk(l0)
      istk(l0)=l-istk(l0-1)
      istk(l0-1)=10
      call setlnb
      return
c
   99 call error(22)
      return
      end
