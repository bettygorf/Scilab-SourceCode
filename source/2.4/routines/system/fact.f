      subroutine fact
c     ======================================================================
c     analyseur de facteurs
c     ======================================================================
c     
c     Copyright INRIA
      include '../stack.h'
c     
      parameter (nz1=nsiz-1,nz2=nsiz-2)
      logical eqid,eptover
      integer semi,eol,blank,r,excnt,lparen,rparen,num,name
      integer id(nsiz),eye(nsiz),rand(nsiz),ones(nsiz),op,fun1
      integer star,dstar,comma,quote,cconc,extrac,rconc
      integer left,right,hat,dot,equal
      logical recurs,compil
      integer setgetmode
      
      data star/47/,dstar/62/,semi/43/,eol/99/,blank/40/
      data num/0/,name/1/,comma/52/,lparen/41/,rparen/42/
      data quote/53/,left/54/,right/55/,cconc/1/,extrac/3/,rconc/4/
      data hat/62/,dot/51/,equal/50/
c     
      data eye/672014862,nz1*673720360/
      data rand/219613723,nz1*673720360/
      data ones/470685464,nz1*673720360/
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
      goto(25,26,99,29,99,51,43,48,55,62,65,66,41),r-300
      goto 99
c     
 01   if (sym.eq.left) go to 20
      if (sym.eq.quote) go to 15
      if (sym.eq.num) go to 10
      excnt = 0
      if (sym .eq. name) go to 30
      id(1) = blank
      if (sym .eq. lparen) go to 36

      if(err1.gt.0) then
         pt=pt+1
 02      pt=pt-1
         r=rstk(pt)
         if(int(r/100).ne.3) goto 02
         goto(25,26,99,29,99,51,43,48,55,62,65,66),r-300
      endif
      call error(2)
c      if (err .gt. 0) return
      return
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
c     --- matrix defined by bracket operators
c     
 20   if(char1.eq.right) then
c     create an empty matrix
         call getsym
         call defmat
         if(err.gt.0) return
         call getsym
         goto 60
      endif

 201  if(char1.eq.eol.or.char1.eq.semi) then
         call getsym
         if(sym.eq.eol) then
            if(lpt(4).eq.lpt(6))  then
               if(comp(1).ne.0) call seteol
               call getlin(0) 
            else
               lpt(4)=lpt(4)+1
               call getsym
            endif
         endif
         if(char1.eq.right) then
c     create an empty matrix
            call getsym
            call defmat
            if(err.gt.0) return
            call getsym
            goto 60
         endif
         goto 201
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
c     get next entry or block
      icall=1
c     *call* expr
      return
c     catenate  entry or block with previous on the same row
 25   continue
      if(err1.ne.0) goto 22
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
c     catenate row with previous rows
      if(err1.ne.0) goto 29
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
      if (sym.eq.eol.and.err1.ne.0) then
         pt=pt-1 
         go to 60
      endif
      if (sym .ne. right) go to 21
      pt=pt-1
      call getsym
      go to 60
c     
c     --- named variable, function evaluation or matrix element   x(...)
c     
 30   call putid(id,syn(1))
      call getsym
      if (sym .eq. lparen) then
c     .     check for blank separator in matrix definition
         if(abs(lin(lpt(3)-2)).ne.blank.or.rstk(pt-2).ne.301) then
c     .     it is really x(....)
            goto 36
         endif
      endif
      fin=0
      rhs = 0
c     
      if(comp(1).eq.0) then
c     -- put a named variable in the stack
c     check for indirect loading
         fin=setgetmode(id)
         call stackg(id)
         if (err .gt. 0) return
         if(fin.ne.0.or.err1.ne.0) goto 60
      endif
c     
c     -- check for eye, rand ones function special call
      fun1=fun
      call funs(id)
      if(err.gt.0) return
      if(fun.eq.6.and.(fin.eq.14.or.fin.eq.13.or.fin.eq.15)) goto 53
      if (fun .gt. 0) then
         call putid(ids(1,pt+1),id)
         call error(25)
         if (err .gt. 0) return
      endif
c     this should never happen???
      if (eqid(id,eye).or.eqid(id,rand)) then
         call funs(id)
         goto 53
      endif
      fun=fun1
c      fin=0
      fin=setgetmode(id)
      call stackg(id)
      if (err .gt. 0) return
      if (fin .eq. 0) then
         if(err1.ne.0) goto 60
         call  putid(ids(1,pt+1),id)
         call error(4)
         if (err .gt. 0) return
      endif
      go to 60
c     
 36   continue
c     --- function evaluation or matrix element   x(...)
      if ( eptover(1,psiz-1))  return
c     x(...) :store object or function name
      rstk(pt)=0
      pstk(pt)=lhs
      call putid(ids(1,pt),id)
c modif ss

      fun1=fun
      fun=0
      if(id(1).ne.blank) then
         fin=-2
         call funs(id)
         if (fun .ne. 0) then
c     name is a function name check if it is a call or a reference
         else
c     .     allow indirect reference to variables
            fun=-1
         endif
      endif

      if(id(1).ne.blank) lhs=1
c     
c     eval function or variable arguments
 38   call getsym
c     
      if(sym.eq.rparen) then
c     .  function has no input parameter
         excnt=-1
         goto 45
      endif
c     
      fun1=fun
      if(sym.eq.name.and.char1.eq.lparen) then
c     . check for a function name
         fun=0
         fin=-2
         call funs(syn)
         if (fun .ne. 0) then
c     name is a function name check if it is a call or a reference

         else
            fun=fun1
         endif
      endif

      excnt = excnt+1
      if(char1.ne.equal) goto 42
c     next lines to manage named arguments (..,a=..)
      fun=fun1

      lpt4=lpt(4)
      call getch
      if(char1.eq.equal) then
c     check for a==
         lpt(4)=lpt4
         goto 42
      endif
      if ( eptover(1,psiz-1))  return
      ids(1,pt)=rhs
      ids(2,pt)=lhs
      ids(3,pt)=lct(4)
      ids(4,pt)=fun
      lct(4)=-1
      rstk(pt)=313
      lpt(4)=lpt(2)
      pstk(pt)=excnt
      char1=blank
      icall=7
      return
c     *call* parse
 41   continue
      rhs=ids(1,pt)
      lhs=ids(2,pt)
      lct(4)=ids(3,pt)
      excnt = pstk(pt)
      fun=ids(4,pt)
      pt = pt-1
c     end of special code to manage named argument
      goto 44
c
 42   continue
c     argument is a standard expression
      if ( eptover(1,psiz-1))  return
      pstk(pt) = excnt
      ids(1,pt)=fun
      ids(2,pt)=fun1
      rstk(pt) = 307
      icall=1
c     *call* expr
      return
 43   excnt = pstk(pt)
      fun=ids(2,pt)
      pt = pt-1
c
 44   continue
c     one more argument ?
      if (sym .eq. comma) go to 38
c     end of argument sequence or recursive extraction ?
      if (sym .ne. rparen) then
         call error(3)
c         if (err .gt. 0) return
         return
      endif
c     
 45   continue
c     end of argument sequence or recursive extraction 
      recurs=.false.
      call getsym
      if(sym.eq.lparen) then
c        . check for blank separator in matrix definition
         if(abs(lin(lpt(3)-2)).eq.blank.and.rstk(pt-3).eq.301) then
c     .     end of argument sequence
            goto 46
         endif
c     .  recursive extraction
         if(excnt.gt.1) then
c            call error(3)
c            return
            if(comp(1).eq.0) then
c     .     form  list with individual indexes
               call mkindx(0,excnt)
               if(err.gt.0) return
            else
               if (compil(19,0,excnt,0,0)) then 
                  if (err.gt.0) return
               endif
            endif
            excnt=1
            recurs=.true.
         endif
         rstk(pt)=rstk(pt)-1
         excnt=0
c     .  get one more argument of the recursive extraction
         goto 38
      elseif(rstk(pt).lt.0) then
c     .  all args of the recursive extraction have been computed
c     .  store them into a list
         if(comp(1).eq.0) then
c     .     form  list with individual indexes
            call mkindx(1-rstk(pt),excnt)
            if(err.gt.0) return
            excnt=1
            recurs=.true.
         else
            if (compil(19,1-rstk(pt),excnt,0,0)) then 
               if (err.gt.0) return
               excnt=1
            endif
         endif
      endif

 46   continue
c     all arguments evaluated
      call putid(id,ids(1,pt))
      lhs=pstk(pt)
      pt=pt-1
      if (id(1) .eq. blank) then
         if(lhs.ne.excnt) then
            call error(41)
            if(err.gt.0) return
         endif
         if (recurs) then
            call error(250)
            return
         endif
         go to 60
      endif
      rhs = excnt

 47   continue
c     get function or variable to be evaluated for computed arguments
      fin=0
      if(comp(1).eq.0) then
         fin=-2
         call stackg(id)
         if(err.gt.0) return
      endif
      if(fin.eq.0) then
c     .  id is not a standard variable
         if (recurs) then
            call error(250)
            return
         endif
         if(err1.gt.0) goto 60
         call funs(id)
         if(err.gt.0) return
         if(fun.gt.0)  goto 53
         fin=-2
         call stackg(id)
         if(err.gt.0) return
         if(fin.eq.0) then
            if(err1.gt.0) goto 60
            call error(4)
            if(err.gt.0) return
         endif
      endif
      if(fin.gt.0) goto 50
      if(rhs.eq.0) goto 60
c     
c     --- variable is a matrix or list :extraction
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
c     --- variable is macro : execution
c     
 50   if ( eptover(1,psiz-1)) return
      call putid(id,ids(1,pt))
      rstk(pt)=306
      pstk(pt)=wmac
      icall=5
c     *call* macro
      return
 51   wmac=pstk(pt)
      pt=pt-1
      go to 60
c     
c     evaluate matrix function
 53   if ( eptover(1,psiz-1))  return
      rstk(pt) = 309
      icall=9
c     *call* matfns
      return
 55   pt = pt-1
      go to 60
c     
 60   continue
c     check for ', .'  **,  ^ and .^
      if (sym .ne. quote) go to 63
      i = lpt(3) - 2
      if (abs(lin(i)) .eq. blank) go to 90
      fin=quote
 61   rhs=1
      if ( eptover(1,psiz-1))  return
      rstk(pt)=310
      icall=4
c     *call* allops(quote) or allops(dot+quote)
      return
 62   pt=pt-1
      call getsym
 63   if(sym.eq.hat) then
         op=dstar
      elseif(sym.eq.dot.and.char1.eq.hat) then
         call getsym
         op=dstar+dot
      elseif(sym.eq.star.and.char1.eq.star) then
         call getsym
         op=dstar
      elseif(sym.eq.dot.and.char1.eq.quote) then
         call getsym
         fin=dot+quote
         goto 61
      else
         goto 90
      endif
      call getsym
      if ( eptover(1,psiz-1))  return
      rstk(pt) = 311
      pstk(pt) = op
      icall=3
c     *call* factor
      go to 01
 65   rstk(pt)=312
      fin=pstk(pt)
      rhs=2
      icall=4
c     *call* allops(dstar)
      return
 66   pt=pt-1
      goto 90

 90   return
c     
 99   call error(22)
      if (err .gt. 0) return
      return
      end
