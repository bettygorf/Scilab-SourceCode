      subroutine getstr
c ====================================================================
c             interpretation d une chaine de caracteres
c               et rangement dans la base de donnees
c ================================== ( Inria    ) =============
      include '../stack.h'
      integer quote,eol,bl(nsiz),lkp
      logical compil,cresmat
      integer iadr,sadr
      data quote/53/,eol/99/, bl/673720360,673720360/
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if(err1.gt.0) return
      fin=1
C     maximum number of characters that we can store 
      ilmax=iadr(lstk(bot)-1)
      n = 0
c
C     compilation [3 nombre-de-char char1 ,....]
C     on ne sait pas encore combien il y en a 
      lkp=comp(1)
      if (compil(2,3,1,0)) then 
         comp(1)=lkp
         ln=lkp+2
         l0=lkp+1
      else
         if(top.eq.0) lstk(1)=1
         if(top+2.ge.bot) then
            call error(18)
            return
         endif
         top=top+1
         call putid(idstk(1,top),bl)
         if (.not.cresmat("getstr",top,1,1,1)) return
         ln=iadr(lstk(top))+6
      endif
c     Begin : reading the string 
      l=ln
      lpt(4) = lpt(3)
      call getch
   16 if (abs(char1) .eq. quote) go to 18
   17 ln = l+n
      if (char1 .eq. eol) then
         call error(31)
         return
      endif
      if(ln.ge.ilmax) then 
         err=sadr(ln)-lstk(bot)
         call error(17)
         return
      endif
      istk(ln) = char1
      n = n+1
      call getch
      go to 16
   18 call getch
      if (abs(char1) .eq. quote) go to 17
      if (n .le. 0) then
         call error(31)
         return
      endif
C     end reading : the string is stored in istk(ln-> ln+(n-1))
c     Storing size info in data Base
      if(comp(1).ne.0) then 
         istk(l0)=n
         comp(1)=l+n
      else
         if (.not.cresmat("getstr",top,1,1,n)) return
      endif
      return
      end

