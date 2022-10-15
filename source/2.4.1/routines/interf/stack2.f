      logical function putlhsvarFD()
c     ===========================
c     This function put on the stack the lhs 
c     variables which are at position lhsvar(i) 
c     on the calling stack 
c     Warning : this function supposes that the last 
c     variable on the stack is at position top-rhs+nbvars 

c     Copyright INRIA
      include '../stack.h'
      logical mvtotop, tryenhaut, mvfromto
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1

      nbvars1=0
      do 1 k=1,lhs
         nbvars1=max(nbvars1,lhsvar(k))
 1    continue
      putlhsvarFD=.false.
      misesenbas=0
 11   continue
      mvtotop=.true.
      iv=0
      do 111 ivar=1,lhs
         mvtotop=mvtotop.and.tryenhaut(top-rhs+ivar,lhsvar(ivar))
         iv=iv+1
         if(.not.mvtotop) then
            misesenbas=misesenbas+1
            if(.not.mvfromto(top-rhs+nbvars1+misesenbas,lhsvar(iv))) 
     $           return
            lhsvar(iv)=nbvars1+misesenbas
c           to prepare next pass 
            ntypes(nbvars1+misesenbas)=ichar('$')
            goto 11
         endif
 111  continue
      do 100 ivar=1,lhs
          if(.not.mvfromto(top-rhs+ivar,lhsvar(ivar))) return
 100   continue
      top=top-rhs+lhs
      putlhsvarFD=.true.
      nbvars=0
      return
      end

      logical function putlhsvar()
c     ===========================
c     This function put on the stack the lhs 
c     variables which are at position lhsvar(i) 
c     on the calling stack 
c     Warning : this function supposes that the last 
c     variable on the stack is at position top-rhs+nbvars 

      include '../stack.h'
      logical mvtotop, tryenhaut, mvfromto,lcres
      integer iadr,sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1

      nbvars1=0
      do 1 k=1,lhs
         nbvars1=max(nbvars1,lhsvar(k))
 1    continue

c        check if output variabe are in increasing order in the stack 
      lcres=.true.
      putlhsvar=.false.
      ibufprec=0
      do 105 i=1,lhs 
         if ( lhsvar(i).lt.ibufprec) then 
            lcres=.false.
            goto 106 
         else
            ibufprec = lhsvar(i)
         endif
 105  continue
 106  continue
      if (.not.lcres) then 
c         write(06,*) 'first pass '
         do 101 ivar=1,lhs
c            write(06,*) 'je bouge',top-rhs+nbvars1+ivar,'<--',
c     $           lhsvar(ivar)
            if(.not.mvfromto(top-rhs+nbvars1+ivar,lhsvar(ivar))) return
            lhsvar(ivar)=nbvars1+ivar
c           we change the type of variable nbvars1 + ivar 
c           then at the next pass we will only perform a dcopy 
            if ( nbvars1+ivar .gt. intersiz ) then 
               buf = 'putlhsvar : intersiz is too small '
               call error(998) 
               return
            endif
            ntypes(nbvars1+ivar) = ichar('$')
 101     continue
      endif
c      write(06,*) 'second pass'
      do 100 ivar=1,lhs
c         write(06,*) 'je bouge',top-rhs+ivar,'<--',lhsvar(ivar)
         if(.not.mvfromto(top-rhs+ivar,lhsvar(ivar))) return
 100  continue     
      top=top-rhs+lhs
      putlhsvar=.true.
      nbvars=0
      return
      end

      logical function mvfromto(itopl,i)
c     ==================================
c     this routines copies the variable number i 
c     (created by getrhsvar or createvar or by mvfromto itself 
c     in a precedent call)
c     from its position on the stack to position itopl
c     returns false if there's no more stack space available
c     - if type(i) # '$'  : This variable is at 
c                         position lad(i) on the stack )
c                         and itopl must be the first free position 
c                         on the stack 
c                         copy is performed + type conversion (type(i))
c     - if type(i) == '$': then it means that object at position i 
c                         is the result of a previous call to mvfromto
c                         a copyobj is performed and itopl can 
c                         can be any used position on the stack 
c                         the object which was at position itopl 
c                         is replaced by object at position i 
c                         (and access to object itopl+1 can be lost if 
c                         the object at position i is <> from object at 
c                         position itopl 
c     ===============================================
      include '../stack.h'

      logical cremat,cresmat2,vcopyobj,crebmat
      character*1 type
      integer iadr,sadr,cadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      cadr(l)=l+l+l+l-3
c
      mvfromto=.false.
      m=nbrows(i)
      n=nbcols(i)
      it=itflag(i)
      ivol=m*n
      type=char(ntypes(i))
c      write(06,*) '      m=',m,'  n=',n,' type',type
      if(type.eq.'i') then
         if(.not.cremat('mvfromto',itopl,it,m,n,lrs,lcs)) return
         call stacki2d(m*n*(it+1),lad(i),lrs) 
         lad(i)=iadr(lrs)
      elseif(type.eq.'r') then
         if(.not.cremat('mvfromto',itopl,it,m,n,lrs,lcs)) return
         call stackr2d(m*n*(it+1),lad(i),lrs) 
         lad(i)=iadr(lrs)
      elseif(type.eq.'d') then
         if(.not.cremat('mvfromto',itopl,it,m,n,lrs,lcs)) return
c        no copy if the two objects are the same 
c        the cremat above is kept to deal with possible size changes 
         if (lad(i).ne.lrs) then 
            call dcopy(m*n*(it+1),stk(lad(i)),1,stk(lrs),1)
            lad(i)=lrs
         endif
      elseif(type.eq.'c') then
         if(.not.cresmat2('mvfromto',itopl,m*n,lrs)) return
         ivol=m*n
         call stackc2i(m*n,lad(i),lrs) 
         lad(i)=cadr(lrs)
      elseif(type.eq.'b') then
         if(.not.crebmat('mvfromto',itopl,m,n,lrs)) return
         call icopy(m*n,istk(lad(i)),1,istk(lrs),1) 
         lad(i)=lrs
      elseif(type.eq.'$') then
c     special case 
c         write(06,*) '   je copie ',top-rhs+i,'-->',itopl
         if ( top-rhs+i .ne. itopl ) then 
            mvfromto=vcopyobj('mvfromto',top-rhs + i,itopl)
         else
            mvfromto=.true.
         endif
         if (.not.mvfromto) return 
      endif
      mvfromto=.true.
      return
      end

      subroutine cvstr1(n,line,str,job)
C     ====================================================================
C     Like cvstr but \n are kept and the conversion can be done ``on place''
C     ( line and str points on the same memory zone )
C     ====================================================================
      include '../stack.h'
      character str(*)
      integer n,line(n)
      if(job.ne.0) then
         call cvs2c(n,line,str,csiz,alfa,alfb)
      else
         call cvc2s(n,line,str,csiz,alfa,alfb)
      endif
      return
      end

      logical function tryenhaut(itopl,i)
c     ===================================
c     this routines check if the creation of 
c     a variable at position itopl on the stack would give an 
c     adresse >= adress of the variable number i (returns true )
c     (or < returns false )

      include '../stack.h'
      logical fakecremat,fakecresmat2,fakecrebmat
      integer iadr,sadr
      character*1 type
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      m=nbrows(i)
      n=nbcols(i)
      type=char(ntypes(i))
      it=itflag(i)
      tryenhaut=.true.
      if(type.eq.'i') then
         if(.not.fakecremat(itopl,it,m,n,lrs,lcs)) return
         if(it.eq.0) then 
            if(sadr(lad(i)).le.lrs) then 
               tryenhaut=.false.
            endif
         else
            if(sadr(ladc(i)).le.lcs) then 
               tryenhaut=.false.
            endif
         endif
      elseif(type.eq.'r') then
         if(.not.fakecremat(itopl,it,m,n,lrs,lcs)) return
         if(it.eq.0) then 
            if(sadr(lad(i)).le.lrs) then 
               tryenhaut=.false.
            endif
         else
            if(sadr(ladc(i)).le.lcs) then 
               tryenhaut=.false.
            endif
         endif
      elseif(type.eq.'b') then
         if(.not.fakecrebmat(itopl,m,n,lrs)) return
         if(lad(i).le.lrs) then
            tryenhaut=.false.
         endif
      elseif(type.eq.'d') then
         if(.not.fakecremat(itopl,it,m,n,lrs,lcs)) return
         if(it.eq.0) then 
            if(lad(i).le.lrs) then 
               tryenhaut=.false.
            endif
         else
            if(ladc(i).le.lcs) then 
               tryenhaut=.false.
            endif
         endif
      elseif(type.eq.'c') then
         if(.not.fakecresmat2(itopl,m*n,lrs)) return
         if(sadr(sadr(lad(i))).le.lrs) then
            tryenhaut=.false.
         endif
      endif
      return
      end


      logical  function isref(lw)
C     ---------------------------------------
C     checks if variable number lw is on the stack 
C     or is just a reference to a variable on the stack 
C     ---------------------------------------
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      cadr(l)=l+l+l+l-3
c
      isref=.false.
      if (lw.gt.intersiz) then 
         buf = 'isref :too many arguments in the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      nbvars=max(lw,nbvars)
      lw1=lw+top-rhs
      if((lw.lt.0)) then
         buf='bad call to isref! (1rst argument)'
         call error(998)
         return
      endif
      il=iadr(lw1)
      if(istk(il).lt.0) isref=.true.
      return
      end

      logical function isopt(k,name) 
C     ---------------------------------------
C     same as isoptlw but checks the k-th argument 
C     this function only works if top is not changed 
C     ---------------------------------------
      integer k
      character name*(*)
      include '../stack.h'
      logical isoptlw
      isopt = isoptlw(top,k+top-rhs,name)
      return
      end

      integer function vartype(number)
C     ==================================================
C     type of variable number number in the stack 
      integer lw,iadr,gettype
      include '../stack.h'
      vartype = gettype(number+top-rhs)
      return 
      end



      logical function createvar(lw,type,m,n,lr)
c     ===========================================================
c     create a variable number lw in the stack of type 
c     type and size m,n 
c     the argument must be of type type ('c','d','r','i','l','b')
c     return values m,n,lr 
c     c : string  (m-> number of characters and n->1)
c     d,r,i : matrix of double,float or integer 
c     b : boolean matrix 
c     l : a list  (m-> number of elements and n->1)
c         for each element of the list an other function 
c         must be used to <<get>> them 
c     side effects : arguments in the common intersci are modified
c     see examples in addinter-examples
c     ===========================================================
c     cremat+fill intersci common
C      implicit undefined (a-z)
      include '../stack.h'
      integer lw,it,m,n,lr
      integer iadr,sadr,cadr
      logical cremat, cresmat2,crebmat
      character*1 type
      character fname*(nlgh)
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      cadr(l)=l+l+l+l-3
c
      it=0
      createvar=.false.
      fname = 'createvar'
      if (lw.gt.intersiz) then 
         buf = 'createvar :too many arguments in the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      nbvars=max(lw,nbvars)
      lw1=lw+top-rhs
      if((lw.lt.0)) then
         buf='bad call to createvar! (1rst argument)'
         call error(998)
         return
      endif
      if(type.eq.'c') then
         if(.not.cresmat2(fname,lw1,m*n,lr)) return
         ntypes(lw)=ichar(type)
         nbrows(lw)=m*n
         nbcols(lw)=1
         lr=cadr(lr)
         do 10 i=0,m*n-1
            cstk(lr+i:lr+i)=' '
 10      continue
         cstk(lr+m*n:lr+m*n)=char(0)
         lad(lw)=lr
         createvar=.true.
      elseif(type.eq.'d') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lcs)) return
         ntypes(lw)=ichar(type)
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=0
         lad(lw)=lr
         createvar=.true.
      elseif(type.eq.'l') then
c     if(.not.crelist(lw1,m,lr)) return
         call crelist(lw1,m,lr)
         ntypes(lw)=ichar('$')
         nbrows(lw)=m
         nbcols(lw)=1
         itflag(lw)=0
         lad(lw)=lr
         createvar=.true.
      elseif(type.eq.'r') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lcs)) return
         lr=iadr(lr)
         ntypes(lw)=ichar(type)
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=0
         lad(lw)=lr
         createvar=.true.
      elseif(type.eq.'i') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lcs)) return
         lr=iadr(lr)
         ntypes(lw)=ichar(type)
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=0
         lad(lw)=lr
         createvar=.true.
      elseif(type.eq.'b') then
         if(.not.crebmat(fname,lw1,m,n,lr)) return
         ntypes(lw)=ichar(type)
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=0
         lad(lw)=lr
         createvar=.true.
      endif
      return
      end



      logical function createcvar(lw,type,it,m,n,lr,lc)
c     ===========================================================
c     create a variable number lw in the stack of type 
c     type and size m,n 
c     the argument must be of type type ('d','r','i')
c     return values m,n,lr 
c     d,r,i : matrix of double,float or integer 
c     side effects : arguments in the common intersci are modified
c     see examples in addinter-examples
c     Like createvar but for complex matrices 
c     ===========================================================
c     cremat+fill intersci common
C      implicit undefined (a-z)
      include '../stack.h'
      integer lw,it,m,n,lr
      integer iadr,sadr,cadr
      logical cremat, cresmat2,crebmat
      character*1 type
      character fname*(nlgh)
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      cadr(l)=l+l+l+l-3
c
      createcvar=.false.
      fname = 'createcvar'
      if (lw.gt.intersiz) then 
         buf = 'createcvar :too many arguments in the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      nbvars=max(lw,nbvars)
      lw1=lw+top-rhs
      if((lw.lt.0)) then
         buf='bad call to createcvar! (1rst argument)'
         call error(998)
         return
      endif
      if (type.eq.'d') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lc)) return
         ntypes(lw)=ichar(type)
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=it
         lad(lw)=lr
         ladc(lw)=lc
         createcvar=.true.
      elseif(type.eq.'r') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lc)) return
         lr=iadr(lr)
         lc=lr+m*n
         ntypes(lw)=ichar(type)
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=it
         lad(lw)=lr
         ladc(lw)=lc
         createcvar=.true.
      elseif(type.eq.'i') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lc)) return
         lr=iadr(lr)
         lc=lr+m*n
         ntypes(lw)=ichar(type)
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=it
         lad(lw)=lr
         ladc(lw)=lc
         createcvar=.true.
      endif
      return
      end

      logical function createlist(lw,nel)
c     ===========================================================
c     create a variable number lw on the stack of type 
c     list with nel elements 
c     ===========================================================
c     cremat+fill intersci common
C      implicit undefined (a-z)
      include '../stack.h'
      integer lw,it,m,n,lr
      integer iadr,sadr,cadr
      character fname*(nlgh)
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      cadr(l)=l+l+l+l-3
c
      it=0
      createlist=.false.
      fname = 'createlist'
      if (lw.gt.intersiz) then 
         buf = 'createlist :too many arguments on the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      nbvars=max(lw,nbvars)
      lw1=lw+top-rhs
      if((lw.lt.0)) then
         buf='bad call to createlist! (1rst argument)'
         call error(998)
         return
      endif
      call crelist(lw1,nel,lr)
      ntypes(lw)=ichar('$')
      nbrows(lw)=nel
      nbcols(lw)=1
      lad(lw)=lr
      createlist=.true.
      return 
      end


      logical function createvarfrom(lw,type,m,n,lr,lar)
c     ===========================================================
c     create a variable number lw on the stack of type 
c     type and size m,n 
c     the argument must be of type type ('c','d','r','i','b')
c     return values m,n,lr,lar 
c     lar is also an input value 
c     if lar != -1 var is filled with data stored at lar 
c     ===========================================================
c     cremat+fill intersci common
C      implicit undefined (a-z)
      include '../stack.h'
      integer lw,it,m,n,lr
      integer iadr,sadr,cadr
      logical cremat, cresmat2,crebmat
      character*1 type
      character fname*(nlgh)
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      cadr(l)=l+l+l+l-3
c
      it=0
      createvarfrom=.false.
      fname = 'createvarfrom'
      if (lw.gt.intersiz) then 
         buf = 'createvarfrom :too many arguments on the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      nbvars=max(lw,nbvars)
      lw1=lw+top-rhs
      if((lw.lt.0)) then
         buf='bad call to createvarfrom! (1rst argument)'
         call error(998)
         return
      endif
      if(type.eq.'c') then
         if(.not.cresmat2(fname,lw1,m*n,lr)) return
         ntypes(lw)=ichar('$')
         nbrows(lw)=m*n
         nbcols(lw)=1
         if (lar.ne.-1) then 
            call cvstr1(m*n,istk(lr),cstk(lar:lar+m*n),0)
         endif
         lar = lr 
         lr=cadr(lr)
         lad(lw)=lr
         createvarfrom=.true.
      elseif(type.eq.'d') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lcs)) return
         ntypes(lw)=ichar('$')
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=0
         lad(lw)=lr
         if (lar.ne.-1) then 
            call dcopy(m*n,stk(lar),1,stk(lr),1)
         endif
         lar = lr 
         createvarfrom=.true.
      elseif(type.eq.'r') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lcs)) return
         if (lar.ne.-1) then 
            call rea2db(m*n,sstk(lar),1,stk(lr),1)
         endif
         lar = lr 
         lr=iadr(lr)
         ntypes(lw)=ichar('$')
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=0
         lad(lw)=lr
         createvarfrom=.true.
      elseif(type.eq.'i') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lcs)) return
         if (lar.ne.-1) then 
            call int2db(m*n,istk(lar),1,stk(lr),1)
         endif
         lar = lr 
         lr=iadr(lr)
         ntypes(lw)=ichar('$')
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=0
         lad(lw)=lr
         createvarfrom=.true.
      elseif(type.eq.'b') then
         if(.not.crebmat(fname,lw1,m,n,lr)) return
         if (lar.ne.-1) then 
            call icopy(m*n,istk(lar),1,istk(lr),1)
         endif
         lar = lr 
         ntypes(lw)=ichar('$')
         nbrows(lw)=m
         nbcols(lw)=n
         lad(lw)=lr
         createvarfrom=.true.
      endif
      return
      end


      logical function createcvarfrom(lw,type,it,m,n,lr,lc,lar,lac)
c     ===========================================================
c     create a variable number lw on the stack of type 
c     type and size m,n 
c     the argument must be of type type ('d','r','i')
c     return values it,m,n,lr,lc,lar,lac
c     lar is also an input value 
c     if lar != -1 var is filled with data stored at lar 
c     idem for lac 
c     ==> like createvarfrom for complex matrices 
c     ===========================================================
c     cremat+fill intersci common
C      implicit undefined (a-z)
      include '../stack.h'
      integer lw,it,m,n,lr
      integer iadr,sadr,cadr
      logical cremat, cresmat2,crebmat
      character*1 type
      character fname*(nlgh)
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      cadr(l)=l+l+l+l-3
c
      createcvarfrom=.false.
      fname = 'createcvarfrom'
      if (lw.gt.intersiz) then 
         buf = 'createcvarfrom :too many arguments on the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      nbvars=max(lw,nbvars)
      lw1=lw+top-rhs
      if((lw.lt.0)) then
         buf='bad call to createcvarfrom! (1rst argument)'
         call error(998)
         return
      endif
      if(type.eq.'d') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lc)) return
         ntypes(lw)=ichar('$')
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=it
         lad(lw)=lr
         ladc(lw)=lc
         if (lar.ne.-1) then 
            call dcopy(m*n,stk(lar),1,stk(lr),1)
         endif
         if (lac.ne.-1) then 
            call dcopy(m*n,stk(lac),1,stk(lc),1)
         endif
         lar = lr 
         lac = lc
         createcvarfrom=.true.
      elseif(type.eq.'r') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lc)) return
         if (lar.ne.-1) then 
            call rea2db(m*n,sstk(lar),1,stk(lr),1)
         endif
         if (lac.ne.-1) then 
            call rea2db(m*n,sstk(lac),1,stk(lc),1)
         endif
         lar = lr 
         lac = lc
         lr=iadr(lr)
         lc=lr+m*n
         ntypes(lw)=ichar('$')
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=it
         lad(lw)=lr
         ladc(lw)=lc
         createcvarfrom=.true.
      elseif(type.eq.'i') then
         if(.not.cremat(fname,lw1,it,m,n,lr,lcs)) return
         if (lar.ne.-1) then 
            call int2db(m*n,istk(lar),1,stk(lr),1)
         endif
         if (lac.ne.-1) then 
            call int2db(m*n,istk(lac),1,stk(lc),1)
         endif
         lar = lr
         lac = lc 
         lr=iadr(lr)
         lc=lr+m*n
         ntypes(lw)=ichar('$')
         nbrows(lw)=m
         nbcols(lw)=n
         itflag(lw)=it
         lad(lw)=lr
         ladc(lw)=lc
         createcvarfrom=.true.
      endif
      return
      end

      logical function createlistvar(lnumber,number,type,m,n,lr,lar)
c     ===========================================================
c     This function must be called after createvar(lnumber,'l',...)
c     Argument lnumber is a list 
c     we want here to get its argument number number
c     the argument must be of type type ('c','d','r','i','b')
c     input values lnumber,number,type,lar 
c     lar : input value ( -1 or the adress of an object which is used 
c           to fill the new variable data slot.
c     lar must be a variable since it is used as input and output
c     return values m,n,lr,lar 
c         (lar --> data is coded at stk(lar) 
c          lr  --> data is coded at istk(lr) or stk(lr) or sstk(lr) 
c                  or cstk(lr)
c     c : string  (m-> number of characters and n->1)
c     d,r,i : matrix of double,float or integer 
c     ============================================================
      include '../stack.h'
      logical listcresimat,listcremat,listcrestring
      character*1 type
      character fname*(nlgh)
      character name*(nlgh)
      logical getexternal,ltype,listcrebmat
      external setfeval
c     cadr : istk--->cstk
       integer iadr, cadr
c
       iadr(l)=l+l-1
       cadr(l)=l+l+l+l-3
c
      it=0
      fname = 'createlistvar'
      createlistvar=.false.
      if (lnumber.gt.intersiz) then 
         buf = 'createlistvar :too many arguments on the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      if(type.eq.'c') then
         n=1
         if(.not.listcrestring(fname,lnumber+top-rhs,number,
     $        lad(lnumber),        m,lr)) return
         if (lar.ne.-1) then 
            call cvstr1(m,istk(lr),cstk(lar:lar+m*n),0)
         endif
         lar=lr
         lr=cadr(lr)
      elseif(type.eq.'d') then
         if(.not.listcremat(fname,lnumber+top-rhs,number,
     $        lad(lnumber),it,
     $        m,n,lr,lc )) return
         if (lar.ne.-1) then 
            call dcopy(m*n,stk(lar),1,stk(lr),1)
         endif
         lar=lr
      elseif(type.eq.'r') then
         if(.not.listcremat(fname,lnumber+top-rhs,number,
     $        lad(lnumber),it,
     $        m,n,lr,lc )) return
         if (lar.ne.-1) then 
            call rea2db(m*n,sstk(lar),1,stk(lr),1)
         endif
         lar=lr
         lr=iadr(lr)
      elseif(type.eq.'i') then
         if(.not.listcremat(fname,lnumber+top-rhs,number,
     $        lad(lnumber),it,
     $        m,n,lr,lc )) return
         if (lar.ne.-1) then 
            call int2db(m*n,istk(lar),1,stk(lr),1)
         endif
         lar = lr 
         lr=iadr(lr)
      elseif(type.eq.'b') then
         if(.not.listcrebmat(fname,lnumber+top-rhs,number,
     $        lad(lnumber),
     $        m,n,lr)) return
         if (lar.ne.-1) then 
            call icopy(m*n,istk(lar),1,istk(lr),1)
         endif
         lar = lr 
      else 
         buf='createlistvar: bad third argument!'
         call error(998)
         return 
      endif
      createlistvar=.true.
      return
      end


      logical function createlistcvar(lnumber,number,type,it,
     $     m,n,lr,lc,lar,lac)
c     ===========================================================
c     This function must be called after createvar(lnumber,'l',...)
c     Argument lnumber is a list 
c     we want here to get its argument number number
c     the argument must be of type type ('c','d','r','i','b')
c     input values lnumber,number,type,lar 
c     lar : input value ( -1 or the adress of an object which is used 
c           to fill the new variable data slot.
c     return values m,n,lr,lar 
c         (lar --> data is coded at stk(lar) 
c          lr  --> data is coded at istk(lr) or stk(lr) or sstk(lr) 
c                  or cstk(lr)
c     c : string  (m-> number of characters and n->1)
c     d,r,i : matrix of double,float or integer 
c     ============================================================
      include '../stack.h'
      logical listcresimat,listcremat,listcrestring
      character*1 type
      character fname*(nlgh)
      character name*(nlgh)
      logical getexternal,ltype,listcrebmat
      external setfeval
c     cadr : istk--->cstk
       integer iadr, cadr
c
       iadr(l)=l+l-1
       cadr(l)=l+l+l+l-3
c
      fname = 'createlistcvar'
      createlistcvar=.false.
      if (lnumber.gt.intersiz) then 
         buf = 'createlistcvar :too many arguments on the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      if(type.eq.'d') then
         if(.not.listcremat(fname,lnumber+top-rhs,number,
     $        lad(lnumber),it,
     $        m,n,lr,lc )) return
         if (lar.ne.-1) then 
            call dcopy(m*n,stk(lar),1,stk(lr),1)
         endif
         if (lac.ne.-1) then 
            call dcopy(m*n,stk(lac),1,stk(lc),1)
         endif
         lar=lr
         lac=lc
      elseif(type.eq.'r') then
         if(.not.listcremat(fname,lnumber+top-rhs,number,
     $        lad(lnumber),it,
     $        m,n,lr,lc )) return
         if (lar.ne.-1) then 
            call rea2db(m*n,sstk(lar),1,stk(lr),1)
         endif
         if (lac.ne.-1) then 
            call rea2db(m*n,sstk(lac),1,stk(lc),1)
         endif
         lar=lr
         lac=lc
         lr=iadr(lr)
         lc=lr+m*n
      elseif(type.eq.'i') then
         if(.not.listcremat(fname,lnumber+top-rhs,number,
     $        lad(lnumber),it,
     $        m,n,lr,lc )) return
         if (lar.ne.-1) then 
            call int2db(m*n,istk(lar),1,stk(lr),1)
         endif
         if (lac.ne.-1) then 
            call int2db(m*n,istk(lac),1,stk(lc),1)
         endif
         lar = lr 
         lac = lc 
         lr=iadr(lr)
         lc=lr+m*n
      else 
         buf='createlistcvar: bad third argument!'
         call error(998)
         return 
      endif
      createlistcvar=.true.
      return
      end


      logical function fakecresmat2(lw,nchar,lr)
c     ===========================================================
C     verifie que l'on peut stocker une chaine de caracteres
C     de taille nchar a  la position lw en renvoyant 
C     .true. ou .false.
C      implicit undefined (a-z)
c     ===========================================================
      integer lw,nchar,il,ilast,lr
      integer iadr,sadr
      include '../stack.h'
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      il=iadr(lstk(lw))
      err=sadr(il+4+(nchar+1))-lstk(bot)
      if(err.gt.0) then
         call error(17)
         fakecresmat2=.false.
         return
      else
         fakecresmat2=.true.
         ilast=il+4+1
         lstk(lw+1)=sadr(ilast+istk(ilast))
         lr=ilast+ istk(ilast-1)
         return
      endif
      end


      logical function getrhsvar(number,type,m,n,lr)
c     ===========================================================
c     get the argument number <<number>> 
c     the argument must be of type type ('c','d','r','i','f','l','b')
c     return values m,n,lr 
c     c : string  (m-> number of characters and n->1)
c     d,r,i : matrix of double,float or integer 
c     f : external (function)
c     b : boolean matrix 
c     l : a list  (m-> number of elements and n->1)
c         for each element of the list an other function 
c         must be used to <<get>> them 
c     side effects : arguments in the common intersci are modified
c     see examples in addinter-examples
c     ============================================================
      include '../stack.h'
      logical getsmat,getmat,getbmat
      integer topk
      character*1 type
      character fname*(nlgh)
      character name*(nlgh)
      logical getexternal,ltype,getilist
      external setfeval

c     cadr : istk--->cstk
      integer iadr, cadr
c
      iadr(l)=l+l-1
      cadr(l)=l+l+l+l-3
c
      fname='getrhsvar'
      nbvars=max(nbvars,number)
      call cvname(ids(1,pt+1),fname,1)
      getrhsvar=.false.
      lw=number+top-rhs
      if(number.gt.rhs) then
         buf='bad call to getrhsvar! (1rst argument)'
         call error(998)
         return
      endif
      if (number.gt.intersiz) then 
         buf = 'getrhsvar :too many arguments on the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      topk=top
      if(type.eq.'c') then
         n=1
         if(.not.getsmat(fname,topk,lw,m1,n1,1,1,lr,m)) return
         call in2str(m*n,istk(lr),cstk(cadr(lr):cadr(lr)+m*n))
         ntypes(number)=ichar(type)
         nbrows(number)=m
         nbcols(number)=n
         lr=cadr(lr)
         lad(number)=lr
      elseif(type.eq.'d') then
         if(.not.getmat(fname,topk,lw,it,m,n,lr,lc )) return
         ntypes(number)=ichar(type)
         nbrows(number)=m
         nbcols(number)=n
         itflag(number)=0
         lad(number)=lr
      elseif(type.eq.'r') then
         if(.not.getmat(fname,topk,lw,it,m,n,lr,lc )) return
         call simple(m*n,stk(lr),sstk(iadr(lr)))
         lr=iadr(lr)
         ntypes(number)=ichar(type)
         nbrows(number)=m
         nbcols(number)=n
         itflag(number)=0
         lad(number)=lr
      elseif(type.eq.'i') then
         if(.not.getmat(fname,topk,lw,it,m,n,lr,lc )) return
         call entier(m*n,stk(lr),istk(iadr(lr)))
         lr=iadr(lr)
         ntypes(number)=ichar(type)
         nbrows(number)=m
         nbcols(number)=n
         itflag(number)=0
         lad(number)=lr
      elseif(type.eq.'b') then
         if(.not.getbmat(fname,topk,lw,m,n,lr)) return
         ntypes(number)=ichar(type)
         nbrows(number)=m
         nbcols(number)=n
         lad(number)=lr
      elseif(type.eq.'l') then
         n=1
         if(.not.getilist(fname,topk,lw,m,n,lr)) return
         ntypes(number)=ichar('$')
c        pour avoir une copie directe ichar(type)
         nbrows(number)=m
         nbcols(number)=n
         lad(number)=0 
      elseif(type.eq.'f') then
c      logical function getrhsvar(number,type,m,n,lr)
         lr=lstk(lw)
         ils=iadr(lr)+1
         m=istk(ils)
         ile=ils+nsiz*m+1
         n=istk(ile)
         if (.not.getexternal(fname,topk,lw,name,ltype,
     $        setfeval)) return
      endif
      getrhsvar=.true.
      return
      end


      logical function getrhscvar(number,type,it,m,n,lr,lc)
c     ===========================================================
c     get the argument number <<number>> 
c     the argument must be of type type ('d','r','i')
c     like getrhsvar but for complex matrices 
c     ============================================================
      include '../stack.h'
      logical getsmat,getmat,getbmat
      integer topk
      character*1 type
      character fname*(nlgh)
      character name*(nlgh)
      logical getexternal,ltype,getilist
      external setfeval

c     cadr : istk--->cstk
       integer iadr, cadr
c
       iadr(l)=l+l-1
       cadr(l)=l+l+l+l-3
c
      nbvars=max(nbvars,number)
      call cvname(ids(1,pt+1),fname,1)
      getrhscvar=.false.
      lw=number+top-rhs
      if(number.gt.rhs) then
         buf='bad call to getrhscvar! (1rst argument)'
         call error(998)
         return
      endif
      if (number.gt.intersiz) then 
         buf = 'getrhscvar :too many arguments on the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      topk=top
      if (type.eq.'d') then
         if(.not.getmat(fname,topk,lw,it,m,n,lr,lc )) return
         ntypes(number)=ichar(type)
         nbrows(number)=m
         nbcols(number)=n
         itflag(number)=it
         lad(number)=lr
         ladc(number)=lc
      elseif(type.eq.'r') then
         if(.not.getmat(fname,topk,lw,it,m,n,lr,lc )) return
         call simple(m*n*(it+1),stk(lr),sstk(iadr(lr)))
         lr=iadr(lr)
         lc=lr+m*n
         ntypes(number)=ichar(type)
         nbrows(number)=m
         nbcols(number)=n
         itflag(number)=it
         lad(number)=lr
         ladc(number)=lc
      elseif(type.eq.'i') then
         if(.not.getmat(fname,topk,lw,it,m,n,lr,lc )) return
         call entier(m*n*(it+1),stk(lr),istk(iadr(lr)))
         lr=iadr(lr)
         lc=lr+m*n
         ntypes(number)=ichar(type)
         nbrows(number)=m
         nbcols(number)=n
         itflag(number)=it
         lad(number)=lr
         ladc(number)=lc
      endif
      getrhscvar=.true.
      return
      end

      logical function getlistrhsvar(lnumber,number,type,m,n,lr,lar)
c     ===========================================================
c     This function must be called after getrhsvar(lnumber,'l',...)
c     Argument lnumber is a list 
c     we want here to get its argument number number
c     the argument must be of type type ('c','d','r','i','b')
c     return values m,n,lr,lar 
c         (lar --> data is coded at stk(lar) 
c          lr  --> data is coded at istk(lr) or stk(lr) or sstk(lr) 
c                  or cstk(lr)
c     c : string  (m-> number of characters and n->1)
c     d,r,i : matrix of double,float or integer 
c     ============================================================
      include '../stack.h'
      logical getlistsimat,getlistmat,getlistbmat
      integer topk
      character*1 type
      character fname*(nlgh)
      character name*(nlgh)
      logical getexternal,ltype
      external setfeval

c     cadr : istk--->cstk
       integer iadr, cadr
c
       iadr(l)=l+l-1
       cadr(l)=l+l+l+l-3
c
      nbvars=max(nbvars,lnumber)
      call cvname(ids(1,pt+1),fname,1)
      getlistrhsvar=.false.
      lw=lnumber+top-rhs
      if(lnumber.gt.rhs) then
         buf='bad call to getlistrhsvar! (1rst argument)'
         call error(998)
         return
      endif
      if (lnumber.gt.intersiz) then 
         buf = 'getlistrhsvar :too many arguments on the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      topk=top
      if(type.eq.'c') then
         n=1
         if(.not.getlistsimat(fname,topk,lw,number,m1,n1,1,1,lr,m))
     $        return 
         call in2str(m*n,istk(lr),cstk(cadr(lr):cadr(lr)+m*n))
         lar=lr
         lr=cadr(lr)
      elseif(type.eq.'d') then
         if(.not.getlistmat(fname,topk,lw,number,it,m,n,lr,lc )) return
         lar=lr
      elseif(type.eq.'r') then
         if(.not.getlistmat(fname,topk,lw,number,it,m,n,lr,lc )) return
         call simple(m*n,stk(lr),sstk(iadr(lr)))
         lar=lr
         lr=iadr(lr)
      elseif(type.eq.'i') then
         if(.not.getlistmat(fname,topk,lw,number,it,m,n,lr,lc )) return
         call entier(m*n,stk(lr),istk(iadr(lr)))
         lar = lr 
         lr=iadr(lr)
      elseif(type.eq.'b') then
         if(.not.getlistbmat(fname,topk,lw,number,m,n,lr )) return
         lar = lr 
         lr  = lr
      else 
         buf='getlistrhsvar: bad third argument!'
         call error(998)
         return 
      endif
      getlistrhsvar=.true.
      return
      end

      logical function getlistrhscvar(lnumber,number,type,it,
     $     m,n,lr,lc,lar,lac)
c     ===========================================================
c     for complex 
c     ============================================================
      include '../stack.h'
      logical getlistsimat,getlistmat,getlistbmat
      integer topk
      character*1 type
      character fname*(nlgh)
      character name*(nlgh)
      logical getexternal,ltype
      external setfeval

c     cadr : istk--->cstk
       integer iadr, cadr
c
       iadr(l)=l+l-1
       cadr(l)=l+l+l+l-3
c
      nbvars=max(nbvars,lnumber)
      call cvname(ids(1,pt+1),fname,1)
      getlistrhscvar=.false.
      lw=lnumber+top-rhs
      if(lnumber.gt.rhs) then
         buf='bad call to getlistrhscvar! (1rst argument)'
         call error(998)
         return
      endif
      if (lnumber.gt.intersiz) then 
         buf = 'getlistrhscvar :too many arguments on the stack' //
     $        ' edit stack.h and enlarge intersiz'
         call error(998)
         return
      endif
      topk=top
      if(type.eq.'d') then
         if(.not.getlistmat(fname,topk,lw,number,it,m,n,lr,lc )) return
         lar=lr
         lac=lc
      elseif(type.eq.'r') then
         if(.not.getlistmat(fname,topk,lw,number,it,m,n,lr,lc )) return
         call simple(m*n*(1+it),stk(lr),sstk(iadr(lr)))
         lar=lr
         lr=iadr(lr)
         lac=lc
         lc=lr+m*n
      elseif(type.eq.'i') then
         if(.not.getlistmat(fname,topk,lw,number,it,m,n,lr,lc )) return
         call entier(m*n*(1+it),stk(lr),istk(iadr(lr)))
         lar = lr 
         lr=iadr(lr)
         lac=lc
         lc=lr+m*n
      else 
         buf='getlistrhscvar: bad third argument!'
         call error(998)
         return 
      endif
      getlistrhscvar=.true.
      return
      end


      logical function createvarfromptr(number,type,m,n,iptr)
c     ===========================================================
c     creates variable number number of type "type" and dims m,n
c     from pointer ptr
c     ===========================================================
      logical cremat,cresmat2
      include '../stack.h'
      character*(1) type
      character fname*(nlgh)
      createvarfromptr=.false.
      fname = 'createvarfromptr'
      nbvars=max(nbvars,number)
      if (number.gt.intersiz) then 
         buf = 'createvarfromptr :too many arguments '//
     $        'on the stack, enlarge intersiz (stack.h) '
         call error(998)
         return
      endif
      lw1=number+top-rhs
      if(type.eq.'d') then
         if(.not.cremat(fname,lw1,0,m,n,lrs,lcs)) return
         call cdouble(m*n,iptr,stk(lrs))   
      elseif(type.eq.'i') then
         if(.not.cremat(fname,lw1,0,m,n,lrs,lcs)) return
         call cint(m*n,iptr,stk(lrs))
      elseif(type.eq.'c') then
         if(.not.cresmat2(fname,lw1,m*n,lrs)) return
         call cchar(m*n,iptr,istk(lrs))
      else
         buf='getlistrhsvar: bad second argument!'
         call error(998)
         return 
      endif
c     this object will be copied with a vcopyobj in putlhsvar
      ntypes(number)=ichar('$')
      createvarfromptr=.true.
      return
      end

      logical function createcvarfromptr(number,type,it,m,n,
     $     iptr,iptc)
c     ===========================================================
c     for complex 
c     ===========================================================
      logical cremat,cresmat2
      include '../stack.h'
      character*(1) type
      character fname*(nlgh)
      createcvarfromptr=.false.
      fname = 'createcvarfromptr'
      nbvars=max(nbvars,number)
      if (number.gt.intersiz) then 
         buf = 'createcvarfromptr :too many arguments '//
     $        'on the stack, enlarge intersiz (stack.h) '
         call error(998)
         return
      endif
      lw1=number+top-rhs
      if(type.eq.'d') then
         if(.not.cremat(fname,lw1,it,m,n,lrs,lcs)) return
         call cdouble(m*n,iptr,stk(lrs))   
         if (it.eq.1) call cdouble(m*n,iptc,stk(lcs))   
      elseif(type.eq.'i') then
         if(.not.cremat(fname,lw1,it,m,n,lrs,lcs)) return
         call cint(m*n,iptr,stk(lrs))
         if (it.eq.1) call cint(m*n,iptc,stk(lcs))
      else
         buf='getlistrhsvar: bad second argument!'
         call error(998)
         return 
      endif
c     this object will be copied with a vcopyobj in putlhsvar
      ntypes(number)=ichar('$')
      createcvarfromptr=.true.
      return
      end


      subroutine in2str(n,line,str)
c     ===========================================================
c     int to string (cvstr)
c     line and str can point to the same zone
c     the conversion is done on place 
c     and str is null terminated 
c     used by getrhsvar
c     =======================================
      include '../stack.h'
      integer eol,line(*)
      character str*(*),mc*1
      data eol/99/
c     conversion code ->ascii
      do 30 j=1,n
         m=line(j)
         if(abs(m).gt.csiz) m=99
         if(m.eq.99) goto 10
         if(m.lt.0) then
            str(j:j)=alfb(abs(m)+1)
         else
            str(j:j)=alfa(m+1)
         endif
         goto 30
 10      str(j:j)='!'
 30   continue
      j=n+1
      str(j:j)=char(0)
      return
      end


      subroutine callscifun(string)
      INCLUDE '../stack.h'
      integer id(nsiz)
      character*(*) string
      l=len(string)
      call cvname(id,string(1:l),0)
      call putid(ids(1,pt+1),id)
      fun=-1
      return
      end





      logical function scifunction(number,ptr,mlhs,mrhs)
c     ===========================================================
c     execute scilab function with mrhs input args and mlhs output
c     variables
c     input args are supposed to be stored in the top of the stack
c     at positions top-mrhs+1:top
c     ===========================================================
      include "../stack.h"
      integer ptr
      integer mlhs,mrhs
      integer iadr,sadr

      common/ierfeval/iero
      iadr(l) = l + l - 1
      sadr(l) = (l/2) + 1
      cadr(l)=l+l+l+l-3
c   

C     macro execution 
C
      scifunction=.false.
      intop=top
      top=top-rhs+number+mrhs-1
      pt = pt + 1
      if (pt .gt. psiz) then
        call error(26)
        goto 9999
      endif
      ids(1,pt) = lhs
      ids(2,pt) = rhs
      rstk(pt) = 1001
      lhs = mlhs
      rhs = mrhs
      niv = niv + 1
      fun = 0
      fin = ptr
C     
      icall = 5
      krec = -1
      include "../callinter.h"
 200  lhs = ids(1,pt)
      rhs = ids(2,pt)
      pt = pt - 1
      niv = niv - 1
C+
      top=intop
      do 1333 i=1,mlhs
         lw=top-rhs+number+i-1
         ntypes(lw)=ichar('$')
 1333 continue
      scifunction=.true.
      return
 9999 continue
      top=intop
      scifunction=.false.
      niv=niv-1
      iero=1
      return
      end

      logical function getrhssys(lw,N,M,P,ptrA,ptrB,ptrC,ptrD,ptrX0,h)
c     test and return linear system (syslin tlist)
c     inputs: lw = variable number
c     outputs:
c     N=size of A matrix (square)                    INTEGER
c     M=number of inputs = col. dim B matrix         INTEGER
c     P=number of outputs = row. dim of C matrix     INTEGER   
c     ptr(A,B,C,D,X0) adresses of A,B,C,D,X0 in stk  INTEGERS
c     h=type   h=0.0  continuous system              DOUBLE PRECISION
c              h=1.0  discrete time system
c              h=h    sampled system h=sampling period
c 
      INCLUDE '../stack.h'
      logical getrhsvar,getlistrhsvar
      integer ptrSys,ptrA,ptrB,ptrC,ptrD,ptrX0,ptrlss
      integer M,N,P,junk
      double precision h
      integer iadr,sadr
      dimension iwork(23)
      data iwork/10,1,7,0,1,4,5,6,7,8,10,12,21,28,28,-10,-11,
     $          -12,-13,-33,0,13,29/
c     iwork=stringmat,nrows,ncols,0,1,4,5,6,7,8,10,12,...
c     'lssABCDX0dt' (=21,28,28,-10,-11,-12,-13,-33,0,13,29)

c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      getrhssys=.false.
      if(.not.getrhsvar(lw,'l',mSys,nSys,ptrSys)) return
      il=iadr(ptrsys)-mSys-1
c     syslin tlist= chain, (A,B,C,D,X0) ,chain or scalar
c                    10     1 1 1 1 1      10       1
      junk=(il+mSYS) +IADR(istk(il))
      if(istk( junk ).ne.10) return
      if(istk( (il+mSYS) +IADR(istk(il+1))).ne.1) return
      if(istk( (il+mSYS) +IADR(istk(il+2))).ne.1) return
      if(istk( (il+mSYS) +IADR(istk(il+3))).ne.1) return
      if(istk( (il+mSYS) +IADR(istk(il+4))).ne.1) return
      if(istk( (il+mSYS) +IADR(istk(il+5))).ne.1) return
      itimedomain=istk( (il+mSYS) +IADR(istk(il+6)))
c
      if (itimedomain.eq.10) then
c     Sys(7)='c' or 'd'
         icord=istk( (il+mSYS) +IADR(istk(il+6)) +6)
         if(icord.eq.12) then
            h=0.0d0
            elseif(icord.eq.13) then
            h=1.0d0
            else
            buf='invalid time domain'
            call error(9999)
            return
            endif
      elseif(itimedomain.eq.1) then
c     Sys(7)=h
         h=stk(sadr( (il+mSYS) +IADR(istk(il+6)) +4))
      else
         buf='invalid time domain'
         call error(9999)
         return
      endif

      do 23 i=1,23
         if(iwork(i).ne.istk(junk+i-1)) goto 33
 23   continue
      goto 34
 33   buf=' '
      buf='invalid system'
      call error(9999)
      return
 34   continue

      if(.not.getlistrhsvar(lw,2,'d',mA,nA,ptrA,junk)) return
      if(.not.getlistrhsvar(lw,3,'d',mB,nB,ptrB,junk)) return
      if(.not.getlistrhsvar(lw,4,'d',mC,nC,ptrC,junk)) return
      if(.not.getlistrhsvar(lw,5,'d',mD,nD,ptrD,junk)) return
      if(.not.getlistrhsvar(lw,6,'d',mX0,nX0,ptrX0,junk)) return

      if((mA.ne.nA)) then
         call erro('A matrix non square!')
         return
      endif

      if((mA.ne.mB).and.(mb.ne.0)) then
         call erro('Invalid A,B matrices')
         return
      endif

      if((mA.ne.nC.and.(nc.ne.0))) then
         call erro('Invalid A,C matrices')
         return
      endif

      if((mC.ne.mD.and.(mD.ne.0))) then
         call erro('Invalid C,D matrices')
         return
      endif

      if((nB.ne.nD.and.(nD.ne.0))) then
         call erro('Invalid B;D matrices')
         return
      endif

      N=mA
      M=nB
      P=mC
      getrhssys=.true.
      end


      subroutine errorinfo(fname,info)
c     Returns info number in routine fname.
      INCLUDE '../stack.h'
      character*(nlgh) fname
      buf=fname//': internal error, info='
      write(buf(50:53),'(i4)') info
      call error(998)
      end



      integer function maxvol(lw,type)
c     returns maximal available size for variable number lw
c     in internal stack. type='d','r','i','c'
c     used for creating a working array of maximal dimension
c     usage:
c     lwork=maxvol(nb,'d')
c     if(.not.createvar(nb,'d',lwork,1,idwork)) return
c     call pipo(   ,stk(idwork),[lwork],...)
      include '../stack.h'
      character*1 type
      integer lw
      integer iadr,sadr,cadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      cadr(l)=l+l+l+l-3
c
      lw1=lw+top-rhs

      il=iadr(lstk(lw1))
      m= lstk(bot) - sadr(il+4)

      if(type.eq.'d') then
         maxvol=m
      elseif(type.eq.'i') then
         maxvol=iadr(m)
      elseif(type.eq.'r') then
         maxvol=iadr(m)
      elseif(type.eq.'c') then
         maxvol=cadr(m)
      endif

      end
