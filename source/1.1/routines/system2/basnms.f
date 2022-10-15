      subroutine basnms(ids,nc,istk,ni)
c!but
c     traduit un nom de variable codee scilab en une variable scilab de
c     type chaine 
c!    
      integer ids(2,nc),istk(*),nc,ni
c
      il=1
      l=il+5+nc
c     header d'une variable de type chaine
      istk(il)=10
      istk(il+1)=1
      istk(il+2)=nc
      istk(il+3)=0
c
      istk(il+4)=1
      do 10 i=1,nc
         call namstr(ids(1,i),istk(l),nstr,1)
         l=l+nstr
         istk(il+4+i)=istk(il+3+i)+nstr
 10   continue
      ni=l-1
      end
