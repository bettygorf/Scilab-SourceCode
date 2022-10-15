C/MEMBR ADD NAME=GETSYM,SSI=0
      subroutine getsym
c     get a symbol
C     cette fonction modifie 
C     fin ?
C     char : caractere courant lu 
C     syn(nsiz=2) : codage du symbole lu 
C     sym : flag de type du symbole lu 
C     stk(lstk(isiz)) si le symbole est un nombre 
C     lpt(6) : mystere 
C     buf : buffer pour imprimer 
c*------------------------------------------------------------------
      include '../stack.h'
      double precision syv,s
      integer blank,z,dot,d,e,plus,minus,name,num,sign,chcnt,eol
      integer star,slash,bslash,ss,percen
      integer i,nlghs2,io
      data blank/40/,z/35/,dot/51/,d/13/,e/14/,eol/99/,plus/45/
      data minus/46/,name/1/,num/0/,star/47/,slash/48/,bslash/49/
      data percen/56/
      fin=0
   10 if (char1 .ne. blank) go to 20
      call getch
      go to 10
   20 lpt(2) = lpt(3)
      lpt(3) = lpt(4)
      char1=abs(char1)
      if (char1 .le. 9) go to 50
      if (char1 .lt. blank.or. char1.eq.percen) go to 30
c
c     special char1acter
      ss = sym
      sym = char1
      call getch
      if (sym .ne. dot) go to 90
c
c     is dot part of number or operator
      syv = 0.0d+0
      if (char1 .le. 9) go to 55
      if (char1.eq.star .or. char1.eq.slash .or. char1.eq.bslash) 
     $     goto 90
      if (ss.eq.star .or. ss.eq.slash .or. ss.eq.bslash) go to 90
      go to 55
c
c     name
   30 sym = name
      nlghs2=nlgh/2
      syn(1) = char1
      syn(2)=0
      chcnt = 1
   40 call getch
      chcnt = chcnt+1
      if (char1 .ge. blank)goto 45
      if(chcnt.gt.nlgh)goto 40
      if (chcnt .le. nlghs2) then
           syn(1)=syn(1)+char1*256**(chcnt-1)
      else
           syn(2)=syn(2)+char1*256**(chcnt-nlghs2-1)
      endif
      go to 40
   45 if (chcnt .gt. nlghs2) go to 47
      do 46 i = chcnt, nlghs2
   46 syn(1) = syn(1)+blank*256**(i-1)
      chcnt=nlghs2+1
   47 if(chcnt .gt.nlgh) goto 90
      do 48 i=chcnt,nlgh
   48 syn(2)=syn(2)+blank*256**(i-nlghs2-1)
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
   60 if (char1.ne.d .and. char1.ne.e) go to 70
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
      if (sym .ge. csiz) call basout(io,wte, ' eol')
      if (sym .eq. name) call prntid(syn(1),1)
      if (sym .eq. num) then
         write(buf(1:9),'(1x,g8.2)') syv
         call basout(io,wte,buf(1:8))
      endif
      return
      end
