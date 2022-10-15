      subroutine typ2cod(il,name,n)
c     returns in name(1:n) the code associated with the type of the
c     variable that began in istk(il)

c     Copyright INRIA
      INCLUDE '../stack.h'
      integer nmax
      parameter (nmax=8)
      integer name(*)
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      k=1
c      
      goto(01,02,9000,04,05,06,9000,9000,9000,10,
     $     11,9000,13,14,15,16,16),abs(istk(il))
      if(abs(istk(il)).eq.128) goto 128
      if(abs(istk(il)).eq.129) goto 129
      if(abs(istk(il)).gt.256.and.abs(istk(il)).le.384) goto 130
      goto 9000


c     --------------matrix of numbers (s)
 01   name(1)=28
      n=1
      return
c     --------------matrix of polynomials (p)
 02   name(1)=25
      n=1
      return
c     --------------booleen (b)
 04   name(1)=11
      n=1
      return
c     -------------- sparse (sp)
 05   name(1)=28
      name(2)=25
      n=2
      return
c     -------------- booleen sparse (spb)
 06   name(1)=28
      name(2)=25
      name(3)=11
      n=3
      return
c     --------------character string (c)
 10   name(1)=12
      n=1
      return
c     --------------macros non compilee (m)
 11   name(1)=22
      n=1
      return
c     --------------macros compilee (mc)
 13   name(1)=22
      name(2)=12
      n=2
      return
c     --------------libraries (f)
 14   name(1)=15
      n=1
      return
c     --------------list (l)
 15   continue
      name(1)=21
      n=1
      return
c     --------------tlist (tlist(1)(1))
 16   continue
      if(istk(il).lt.0) il=iadr(istk(il+1))
      n1=istk(il+1)
      iltyp=iadr(sadr(il+3+n1))
      nlt=min(nlgh-3,istk(iltyp+5)-1)
      iltyp=iltyp+5+istk(iltyp+1)*istk(iltyp+2)
      n=min(nlt,nmax)
      call icopy(n,istk(iltyp),1,name(1),1)
      return
c     --------------sparse lu pointer  (ptr)
 128  continue
      name(1)=25
      name(2)=29
      name(3)=27
      n=3
      return
c     --------------formal implicit vector (ip)
 129  continue
      name(1)=18
      name(2)=25
      n=2
      return

c     --------------tropical algebra (talg)
 130  continue
      name(1)=29
      name(2)=10
      name(3)=21
      name(4)=16
      n=4
      return
 9000 continue
      n=0
      return
      end
      
