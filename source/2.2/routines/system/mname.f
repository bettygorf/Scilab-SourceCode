       subroutine mname(op,id)
c     =======================================================
c     searches a macro name for coded operations
c     =======================================================
      include '../stack.h'
      integer gettype
      logical ilog,getilist,getsmat
c
      parameter (nops=25)
      integer op,id(nsiz),name(nlgh),blank,percen
      integer ops(nops),code(nops),top1,rhs1,codop
      integer compat
      data compat/1/
      data blank/40/,percen/56/
      data ops /53,45,46,47,48,49,62, 1, 2, 3,4,98,99,100,200,201,202,
     &          44,149,150,151,50,119,57,58/
      data code/29,10,28,22,27,21,25,12,18,14,15,33,13,26,20, 34, 35, 
     &          11,30, 31, 32, 24, 23, 16, 17/
c
c  '  +  -  *  /  \  **  []  ()  .*  ./  .\  .*.  ./.  .\.  : *.  /. \.
c  t  a  s  m  r  l  p   c,f e,i  x   d    q   k    y    z   b u   v  w
c
c  ==  <>
c   o  n
c  caracteres  polynomes macros files   scalaires  listes(non typees)
c      c           p       m      f         s         l
c
c  padic booleen sparse   booleen_sparse
c   pp     b      sp          spb
c
c  listes(typees): 3 premiers caracteres du premiers champ
c    ou moins si la chaine est plus courte que 3 caracteres
c
      rhs1=rhs
      if (op.eq.3) rhs1=1
      if (op.eq.2) rhs1=2
      name(1)=percen
      k=2
      nb=1
c
      top1=top-rhs1
   10 top1=top1+1
      goto(11,12,20,21,22,23,99,99,99,13,
     $     14,14,99,15,16,18),gettype(top1)
      goto 99
c     --------------matrices scalaires
   11 name(k)=28
      k=k+1
      goto 51
c     --------------polynomes a coef dans R ou C
   12 name(k)=25
      k=k+1
      goto 51
c     --------------chaine de caractere
   13 name(k)=12
      k=k+1
      goto 51
c     --------------macros
   14 name(k)=22
      k=k+1
      goto 51
c     --------------files
   15 name(k)=15
      k=k+1
      goto 51
c     --------------list
   16 continue
      ilog=getilist("mname",top,top1,n,1,ili)
      if(n.eq.0) then
c     liste vide
         name(k)=21
         k=k+1
      else
         call mvptr(top+1,ili)
         if ( gettype(top+1).ne.10) then 
            name(k)=21
            k=k+1
         else
c-compat this case is maintained for list->tlist compatibility
            if(compat.eq.1) then
               call msgs(62,0)
               compat=0
            endif
            ilog= getsmat("mname",top+1,top+1,ms,ns,1,1,lr,nlr)
            do 17 i=1,min(3,nlr)
               name(k)=istk(lr+i-1)
               k=k+1
 17         continue
         endif
         call ptrback(top+1)
      endif
      goto 51
c     --------------tlist
   18 continue
      ilog=getilist("mname",top,top1,n,1,ili)
      if(n.eq.0) then
c     liste vide
         name(k)=21
         k=k+1
      else
         call mvptr(top+1,ili)
         ilog= getsmat("mname",top+1,top+1,ms,ns,1,1,lr,nlr)
         do 19 i=1,min(3,nlr)
            name(k)=istk(lr+i-1)
            k=k+1
 19      continue
         call ptrback(top+1)
      endif
      goto 51

c     --------------padic
 20   name(k)=25
      name(k+1)=25
      k=k+2
      goto 51
c     --------------booleen
 21   name(k)=11
      k=k+1
      goto 51
c     -------------- sparse
 22   name(k)=28
      name(k+1)=25
      k=k+2
      goto 51
c     -------------- booleen sparse
 23   name(k)=28
      name(k+1)=25
      name(k+2)=11
      k=k+3
      goto 51
c     --------------
   51 if(nb.eq.2) goto 54
      do 52 i=1,nops
         if(ops(i).eq.op) goto 53
   52 continue
      goto 99
   53 codop=code(i)
      name(k)=codop
      k=k+1
      nb=2
      if(rhs1.eq.2) goto 10
c
   54 call namstr(id,name,k-1,0)
      fin=0
      call funs(id)
      if(fun.eq.0) then
         if ((gettype(top).eq.15.or.gettype(top).eq.16).and.
     $        (gettype(top-1).eq.15.or.gettype(top-1).eq.16)) then
c     tlist comparison, use general list comparison function %lol or %lnl 
c     instead of undefined type dependent one.
            name(1)=percen
            name(2)=21
            name(3)=codop
            name(4)=21
            call namstr(id,name,4,0)
            fin=0
            call funs(id)
            if(fun.ne.0) goto 55
         endif
         call error(43)
         return
      endif
 55   if(fun.eq.-2) then 
         fin=-1
         call stackg(id)
      endif
      return
c
   99 id(1)=blank
      call error(43)
      return
      end
