      subroutine getfun(lunit)
c
c ======================================================================     
c     get a user defined function
c ======================================================================    
c     
      include '../stack.h'
c     
      integer lrecl,id(nsiz),retu(6),ennd(3),id1(3),icount
      integer slash,dot,blank,equal,lparen,rparen
      integer comma,semi,less,great,left,right
      integer name,eol
      integer first,ierr
      integer iadr,sadr
      logical maj
c     
      data slash/48/,dot/51/,blank/40/,equal/50/,lparen/41/,rparen/42/
      data comma/52/,semi/43/,less/59/,great/60/,left/54/,right/55/
      data name/1/,eol/99/,lrecl/512/
      data retu/27,14,29,30,27,23/,ennd/14,23,13/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      lmax=iadr(lstk(bot)-1)
c     
      if(top-rhs+lhs+1.ge.bot) then
         call error(18)
         return
      endif
c     
      job=0
      l1=lpt(1)
      l2=lpt(2)
      l4=lpt(3)
      l6=lpt(6)
      lpt(1)=l6+1
      lpt(5)=lpt(3)
c     
      n=1
      first=1
 10   l = lpt(1)
      if(lunit.eq.0) goto 30
c     
c     get macro deff from file
c     ------------------------
c     acquisition d'une ligne du fichier
      icount=0
 11   buf=' '
      call basin(ierr,lunit,buf(1:lrecl),'*')
      l0=l
      if(ierr.eq.1) goto 60
      if(ierr.eq.2) goto 90
      
c     elimination des blancs en fin de la ligne
      n = lrecl+1
 15   n = n-1
      if(n.le.0) then
         if(first.eq.1) goto 11
         goto 27
      endif
      if (buf(n:n) .eq. ' ') go to 15
c     elimination des blancs en debut de ligne
      m=0
 16   m=m+1
      if(buf(m:m).eq.' ') goto 16
c
      if(buf(m:m+7).eq.'function'.or.buf(m:m+7).eq.'FUNCTION') then
         if(first.eq.1) then
            j=m+7
            goto 231            
         else
            backspace(lunit)
            goto 61
         endif
      endif
c     
c     boucle de conversion des caracteres de la ligne
      j=m-1
 17   j=j+1
      if(j.gt.n) goto 25
c     
 18   do 20 k = 1, csiz
         if (buf(j:j).eq.alfa(k)) then
            maj=.false.
            goto 21
         elseif(buf(j:j).eq.alfb(k)) then
            maj=.true.
            go to 21
         endif
 20   continue
      k = eol+1
      call xchar(buf(j:j),k)
      if (k .gt. eol) go to 10
      if (k .eq. eol) go to 11
      if (k .eq. -1) l = l-1
      if (k .le. 0) go to 23
      maj=.false.
c     
 21   k = k-1
      if (k.eq.dot .and. buf(j+1:j+1).eq.buf(j:j)) then
c     on a trouve ..
c     c'est une ligne suite si on a que des . ou //
         jj=j+1
 22      continue
         if(jj.ge.n) then
            icount=icount+1
            goto 11
         endif
         jj=jj+1
         if(buf(jj:jj).eq.buf(j:j))goto 22
         if(buf(jj:jj).eq.' ') goto 22
         if(buf(jj:jj).eq.'/'.and.buf(jj+1:jj+1).eq.'/') then
            icount=icount+1
            goto 11
         endif
      endif
c     ce n'est pas une carte suite            
      if(first.eq.1) goto 23
      if (k.eq.slash .and. buf(j+1:j+1).eq.buf(j:j)) go to 25
      istk(l) = k
c     
      if(maj) istk(l)=-k
      l = l + 1
      if(l.gt.lmax) then
         ierr=5
         goto 90
      endif
      goto 17
c     premiere ligne
 23   if(l.gt.lpt(1)) goto 24
      if(buf(m:m+7).eq.'function'.or.buf(m:m+7).eq.'FUNCTION') then
         j=m+6
      else  if(k.ne.slash .or. buf(m+1:m+1).ne.buf(m:m)) then
         ierr=4
         goto 90
      endif
      j=j+1
 231  lin(l)=blank
      l=l+1
      goto 17
 24   lin(l)=k
      if(maj) lin(l)=-k
      l=l+1
      if(l.gt.lsiz) then
        ierr=3
        goto 90
      endif
      goto 17
c     
c     fin de conversion de la ligne
 25   if(first.eq.1) goto 40
      if(k.eq.slash.and.j.eq.1) then
         call cvstr(3,id1,buf(j+2:j+4),0)
         do 26 ie=1,3
            if(abs(id1(ie)).ne.ennd(ie)) goto 27
 26      continue
         goto 61
      endif
 27   l=l-1
      if(istk(l).eq.blank) goto 27
      l=l+1
      if(l-1.le.l0) then
         istk(l)=comma
         l=l+1
      endif
      do 28 i=0,icount
c     la gestion de icount a ete ajoute pour maintenir un compteur de ligne
c     correct malgre les lignes suite
         istk(l)=eol
         istk(l+1)=blank
         l=l+2
 28   continue
      l=l-1
      icount=0
c
      goto 11
      
c     
c     get macro deff from stk
c     -----------------------
 30   if(rhs.ne.2) then
         call error(39)
         return
      endif
c     
      ilt=iadr(lstk(top))
      if(istk(ilt).ne.10) then
         err=2
         call error(55)
         return
      endif
c
      ild=iadr(lstk(top-1))
      if(istk(ild).ne.10) then
         err=1
         call error(55)
         return
      endif
      if(istk(ild+1)*istk(ild+2).ne.1) then
         err=1
         call error(89)
         return
      endif
c
      il=ild+5
      n=istk(il)-1
      do 31 j=1,n
         lin(l)=istk(il+j)
         l=l+1
 31   continue
      goto 40
c     
 33   mn=istk(ilt+1)*istk(ilt+2)
      ili=ilt+4+mn
      ilt=ilt+4
      do 35 i=1,mn
         n=istk(ilt+i)-istk(ilt+i-1)
         do 34 j=1,n
            istk(l)=istk(ili+j)
            l=l+1
 34      continue
         istk(l)=eol
         l=l+1
         ili=ili+n
 35   continue
      goto 61
c     
c     analyse de la ligne de declaration
 40   continue
      if(ddt.ge.2) call basout(io,wte,buf(1:n))
      if(l.eq.lpt(1)) then
         ierr=6
         goto 90
      endif
      lin(l) = eol
      lpt(6) = l
      lpt(4) = lpt(1)
      lpt(3) = lpt(1)
      lpt(2) = lpt(1)
      lct(1) = 0
cMAJ  
      fin=0
      call getch
c     
      if(top+2.ge.bot) then
         call error(18)
         return
      endif
      top=top+1
      il=iadr(lstk(top))
      istk(il)=11
      l=il+2
      if(l.gt.lmax) then
         ierr=5
         goto 90
      endif
c     
      call getsym
      mlhs=0
      if(sym.eq.name) then
c     a=func(..) ou func(..)
         if(char1.eq.equal) then
c     a=func(..) 
            mlhs=mlhs+1
            l=l+nsiz
            if(l.gt.lmax) then
               ierr=5
               goto 90
            endif
            call putid(istk(l-nsiz),syn(1))
            call getsym
            call getsym
         endif
      elseif(sym.eq.less.or.sym.eq.left) then
c     [..]=func()
 41      call getsym
         if(sym.ne.name) goto  42
         mlhs=mlhs+1
         l=l+nsiz
         if(l.gt.lmax) then
            ierr=5
            goto 90
         endif
         call putid(istk(l-nsiz),syn(1))
         call getsym
         if(sym.eq.comma) goto  41
 42      if(sym.ne.great.and.sym.ne.right) then
            ierr=4
            goto  90
         endif
c     
         call getsym
         if(sym.ne.equal) then
            ierr=4
            goto  90
         endif
         call getsym
      else
         ierr=4
         goto 90
      endif
c
      if(sym.ne.name) then
         ierr=4
         goto  90
      endif
      istk(il+1)=mlhs
      call putid(id,syn(1))
c     
      mrhs=0
      il=l
      l=l+1
      if(l.gt.lmax) then
         ierr=5
         goto 90
      endif
      if(char1.eq.semi.or.char1.eq.comma) goto 46
      call getsym
      if(sym.eq.eol) goto 46
      if(sym.ne.lparen) then
         ierr=4
         goto  90
      endif
 44   call getsym
      if(sym.ne.name) goto  45
      mrhs=mrhs+1
      l=l+nsiz
      if(l.gt.lmax) then
         ierr=5
         goto 90
      endif
      call putid(istk(l-nsiz),syn(1))
      call getsym
      if(sym.eq.comma) goto  44
 45   if(sym.ne.rparen) then
         ierr=4
         goto  90
      endif
 46   istk(il)=mrhs
c     
      il=l
      l=l+1
      if(lunit.eq.0) goto 33
      first=0
      goto 11
c     
c     fin
 60   if(first.eq.1) then
         job=-1
         goto 62
      else
         job=1
      endif
 61   call icopy(6,retu,1,istk(l),1)
      l=l+6
      istk(l)=eol
      l=l+1
      istk(l)=eol
      l=l+1
      istk(il)=l-(il+1)
      lstk(top+1)=sadr(l)
c     
      lpt(1)=l1
      call putid(idstk(1,top),id)
c
 62   lpt(1)=l1
      lpt(6)=l6
      lpt(4)=l4
      lpt(3)=l4
      lpt(2)=l2
      char1=semi
      sym=semi
      fin=job
      return

c     
 90   continue
c gestion des erreurs
c
c     on retablit les pointeurs de ligne pour le gestionnaire d'erreur
      lpt(1)=l1
      lpt(6)=l6
      lpt(4)=l4
      lpt(3)=l4
      lpt(2)=l2
      goto(91,92,93,94,95),ierr-1
c
 91   continue
c     erreur de lecture
      call error(49)
      return
 92   continue
c     buffer limit
      call error(26)
      return
 93   continue
c     invalid syntaxe
      call error(37)
      return
 94   err=lstk(bot)-sadr(l)
      call error(17)
      return
 95   call error(28)
      return
c     
 
      end
