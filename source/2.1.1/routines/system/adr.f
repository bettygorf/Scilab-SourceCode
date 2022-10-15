      integer function adr(l,job)
c!but
c     cette fonction permet de convertir une adresse de stk  en
c     l'adresse correspondante de istk et reciproquement.
c     si stk est un tableau simple precision la fonction adr est
c     l'egalite
c
      integer l,job
c
cc double precision
      if(job.eq.1) goto 10
c adr est l'adresse dans istk
      adr=l+l-1
      return
c adr est ladresse dans stk
   10 adr=(l/2)+1
cc simple precision (cdc cray)
cc      adr=l
cc fin version
c
      end
