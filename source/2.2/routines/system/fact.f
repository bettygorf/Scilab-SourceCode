      subroutine fact
c     ======================================================================
c     analyseur de facteurs
c     ======================================================================
c     
      include '../stack.h'
c     
      parameter (nz1=nsiz-1,nz2=nsiz-2)
      logical eqid,eptover
      integer semi,eol,blank,r,excnt,lparen,rparen,num,name
      integer id(nsiz),eye(nsiz),rand(nsiz)
      integer star,dstar,comma,quote,cconc,extrac,rconc
      integer left,right,hat
      data star/47/,dstar/62/,semi/43/,eol/99/,blank/40/
      data num/0/,name/1/,comma/52/,lparen/41/,rparen/42/
      data quote/53/,left/54/,right/55/,cconc/1/,extrac/3/,rconc/4/
      data hat/62/
c     
      data eye/672014862,nz1*673720360/
      data rand/219613723,nz1*673720360/
c     
c     
      r = rstk(pt)
c     
      if (ddt .eq. 4) then
         write(buf(1:12),'(3i4)') pt,r,sym
         call basout(io,wte,' factor pt:'//buf(1:4)//' rstk(pt):'//
     &        buf(5:8)//' sym:'//buf(9:12))
      endif
c     
      ir=r/100
      if(ir.ne.3) goto 01
      goto(25,26,99,29,99,37,45,48,55,61,65,66),r-300
      goto 99
c     
 01   if (sym.eq.left) go to 20
      if (sym.eq.quote) go to 15
      if (sym.eq.num) go to 10
      excnt = 0
      if (sym .eq. name) go to 40
      id(1) = blank
      if (sym .eq. lparen) go to 41
      call error(2)
      if (err .gt. 0) return
c     
c     put something on the stack
      
c     --- single number, getsym stored it in stk(vsiz)
c     
 10   call getnum
      if(err.gt.0) return
      call getsym
      go to 60
c     
c     --- string
c     
 15   call getstr
      if(err.gt.0) return
      call getsym
      go to 60
c     
c     --- matrice definie explicitement
c     on ouvre une matrice
c     
 20   if(char1.eq.right) then
         call getsym
         call defmat
         if(err.gt.0) return
         call getsym
         goto 60
      endif
      if (eptover(0,psiz-3))  return
      pt=pt+1
      rstk(pt)=0
      pstk(pt)=0
c     
 21   continue
      pt=pt+1
      pstk(pt)=0
      call getsym
c     
 22   if (sym.eq.semi .or. sym.eq.eol .or.sym.eq.right) go to 27
      if (sym .eq. comma) call getsym
      rstk(pt) = 301
c     acquisition de l'element suivant
      icall=1
c     *call* expr
      return
c     on concatene le nouvel elt avec les precedent de la ligne
 25   continue
      pstk(pt)=pstk(pt)+1
      if(pstk(pt).le.1) goto 22
      pstk(pt)=1
      rstk(pt)= 302
      fin=cconc
      rhs=2
      icall=4
c     *call* allops(cconc)
      return
 26   go to 22
 27   pt=pt-1
      if (sym.eq.semi .and. char1.eq.eol) call getsym
c     on concatene la ligne avec les precedentes
      if(pstk(pt+1).gt.0) pstk(pt)=pstk(pt)+1
      if(pstk(pt).le.1) goto 29
      pstk(pt)=1
      rstk(pt)= 304
      fin=rconc
      rhs=2
      icall=4
c     *call* allops(rconc)
      return
 29   if (sym .eq. eol) then
         if(lpt(4).eq.lpt(6))  then
            if(comp(1).ne.0) call seteol
            call getlin(0)
         else
            lpt(4)=lpt(4)+1
            call getsym
         endif
      endif
      if (sym .ne. right) go to 21
      pt=pt-1
      call getsym
      go to 60
c     
c     --- variable is macro
c     
 32   if ( eptover(1,psiz-1)) return
      call putid(id,ids(1,pt))
      rstk(pt)=306
      pstk(pt)=wmac
      icall=5
c     *call* macro
      return
 37   wmac=pstk(pt)
      pt=pt-1
      go to 60
c     
c     --- function or matrix element
c     
 40   call putid(id,syn(1))
      call getsym
      if (sym .eq. lparen) go to 41
      fin=0
      rhs = 0
c     
      if(comp(1).eq.0) then
         call stackg(id)
         if (err .gt. 0) return
         if(fin.ne.0.or.err1.ne.0) goto 60
      endif
c     
      call funs(id)
      if(err.gt.0) return
      if(fun.eq.6.and.(fin.eq.14.or.fin.eq.13)) goto 50
      if (fun .gt. 0) then
         call putid(ids(1,pt+1),id)
         call error(25)
         if (err .gt. 0) return
      endif
      if (eqid(id,eye).or.eqid(id,rand)) then
         call funs(id)
         goto 50
      endif
      fin=0
      call stackg(id)
      if (err .gt. 0) return
      if (fin .eq. 0) then
         call  putid(ids(1,pt+1),id)
         call error(4)
         if (err .gt. 0) return
      endif
      go to 60
c     
 41   if ( eptover(1,psiz-1))  return
      rstk(pt)=0
      pstk(pt)=lhs
      call putid(ids(1,pt),id)
      if(id(1).ne.blank) lhs=1
c     
 42   call getsym
c     
      if(sym.eq.rparen) then
c     .  function has no input parameters
         excnt=-1
         goto 46
      endif
      if(char1.ne.comma.and.char1.ne.rparen) goto 43
      if(sym.eq.name.and.eqid(syn(1),eye)) then
         call error(14)
         if(err.gt.0) return
      endif
 43   excnt = excnt+1
      if ( eptover(1,psiz-1))  return
      pstk(pt) = excnt
      rstk(pt) = 307
      icall=1
c     *call* expr
      return
 45   excnt = pstk(pt)
      pt = pt-1
      if (sym .eq. comma) go to 42
      if (sym .ne. rparen) then
         call error(3)
         if (err .gt. 0) return
      endif
 46   call getsym
      call putid(id,ids(1,pt))
      lhs=pstk(pt)
      pt=pt-1
      if (id(1) .eq. blank) then
         if(lhs.ne.excnt) then
            call error(41)
            if(err.gt.0) return
         endif
         go to 60
      endif
      rhs = excnt
 47   continue
      fin=0
      if(comp(1).eq.0) then
         fin=-2
         call stackg(id)
         if(err.gt.0) return
      endif
      if(fin.eq.0) then
         call funs(id)
         if(err.gt.0) return
         if(fun.gt.0) goto 50
         fin=-2
         call stackg(id)
         if(err.gt.0) return
         if(fin.eq.0) then
            call error(4)
            if(err.gt.0) return
         endif
      endif
      if(fin.gt.0) goto 32
      if(rhs.eq.0) goto 60
c     
c     extraction
c     
      rhs=rhs+1
      if ( eptover(1,psiz-1)) return
      rstk(pt)=308
      fin=extrac
      icall=4
c     *call* allops(extrac)
      return
 48   pt=pt-1
      goto 60
      
c     
c     evaluate matrix function
 50   if ( eptover(1,psiz-1))  return
      rstk(pt) = 309
      icall=9
c     *call* matfns
      return
 55   pt = pt-1
      go to 60
c     
 60   continue
c     check for quote (transpose) and ** or ^ (power)
      if (sym .ne. quote) go to 62
      i = lpt(3) - 2
      if (lin(i) .eq. blank) go to 90
      rhs=1
      fin=quote
      if ( eptover(1,psiz-1))  return
      rstk(pt)=310
      icall=4
c     *call* allops(quote)
      return
 61   pt=pt-1
      call getsym
 62   if(sym.eq.hat) goto 63
      if (sym.ne.star .or. char1.ne.star) go to 90
      call getsym
 63   call getsym
      if ( eptover(1,psiz-1))  return
      rstk(pt) = 311
      icall=3
c     *call* factor
      go to 01
 65   rstk(pt)=312
      fin=dstar
      rhs=2
      icall=4
c     *call* allops(dstar)
      return
 66   pt=pt-1
 90   return
c     
 99   call error(22)
      if (err .gt. 0) return
      return
      end
