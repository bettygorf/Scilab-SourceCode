      subroutine getsym
c     get a symbol
C     cette fonction modifie 
C     fin ?
C     char : caractere courant lu 
C     syn(nsiz) : codage du symbole lu 
C     sym : flag de type du symbole lu 
C     stk(lstk(isiz)) si le symbole est un nombre 
C     lpt(6) : mystere 
C     buf : buffer pour imprimer 
c*------------------------------------------------------------------
      include '../stack.h'
      double precision syv,s
      integer blank,z,dot,d,e,plus,minus,name,num,sign,chcnt,eol,achar1
      integer star,slash,bslash,ss,percen
      integer io
      integer namecd(nlgh)
      data blank/40/,z/35/,dot/51/,d/13/,e/14/,eol/99/,plus/45/
      data minus/46/,name/1/,num/0/,star/47/,slash/48/,bslash/49/
      data percen/56/
      fin=1
   10 if (char1 .ne. blank) go to 20
      call getch
      go to 10
   20 lpt(2) = lpt(3)
      lpt(3) = lpt(4)
      if (abs(char1) .le. 9) go to 50
      if (abs(char1) .lt. blank.or. char1.eq.percen) go to 30
c
c     special character
      ss = abs(sym)
      sym = abs(char1)
      call getch
      if (sym .ne. dot) go to 90
c
c     is dot part of number or operator
      syv = 0.0d+0
      achar1=abs(char1)
      if (achar1 .le. 9) go to 55
      if (achar1.eq.star .or. achar1.eq.slash .or. achar1.eq.bslash) 
     $     goto 90
      if (ss.eq.star .or. ss.eq.slash .or. ss.eq.bslash) go to 90
      go to 55
c
c     name
   30 sym = name 
      chcnt=1
      namecd(chcnt)=char1
   40 call getch
      if (abs(char1).ge.blank) goto 45
      if(chcnt.lt.nlgh) then
         chcnt = chcnt+1
         namecd(chcnt)=char1
      endif
      go to 40
 45   call namstr(syn,namecd,chcnt,0)
      go to 90
c
c     number
   50 call getval(syv)
      if (char1 .ne. dot) go to 60
      call getch
   55 chcnt = lpt(4)
      call getval(s)
      chcnt = lpt(4) - chcnt
      if (char1 .eq. eol) chcnt = chcnt+1
      syv = syv + s/10.0d+0**chcnt
   60 if (abs(char1).ne.d .and. abs(char1).ne.e) go to 70
      call getch
      sign = char1
      if (sign.eq.minus .or. sign.eq.plus) call getch
      call getval(s)
      if (sign .ne. minus) syv = syv*10.0d+0**s
      if (sign .eq. minus) syv = syv/10.0d+0**s
   70 stk(lstk(isiz)) = syv
      sym = num
c
   90 if (char1 .ne. blank) go to 99
      call getch
      go to 90
   99 if (ddt .lt. 3) return
      if (sym.gt.name .and. sym.lt.csiz) call basout(io,wte,alfa(sym+1))
      if (abs(sym) .ge. csiz) call basout(io,wte, ' eol')
      if (sym .eq. name) call prntid(syn(1),1,wte)
      if (sym .eq. num) then
         write(buf(1:9),'(1x,g8.2)') syv
         call basout(io,wte,buf(1:8))
      endif
      return
      end
