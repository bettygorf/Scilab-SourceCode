       subroutine mname(op,id)
c     =======================================================
c     searches a macro name for coded operations
c     =======================================================
      include '../stack.h'
      integer gettype
      logical ilog,getilist,getsmat
c
      parameter (nops=23)
      integer op,id(nsiz),name(nlgh),blank,percen
      integer ops(nops),code(nops),top1,rhs1
      data blank/40/,percen/56/
      data ops /53,45,46,47,48,49,58, 1, 2, 3,4,98,99,100,200,201,202,
     &          44,149,150,151,50,119/
      data code/29,10,28,22,27,21,25,12,18,14,15,33,13,26,20, 34, 35, 
     &          11,30, 31, 32, 24, 23/
c
c  '  +  -  *  /  \  **  []  ()  .*  ./  .\  .*.  ./.  .\.  : *.  /. \.
c  t  a  s  m  r  l  p   c,f e,i  x   d    q   k    y    z   b u   v  w
c
c  ==  <>
c   o  n
c  caracteres  polynomes macros files   scalaires  listes(non typees)
c      c           p       m      f         s         l
c
c  padic booleen
c   pp     b
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
      goto(11,12,18,19,99,99,99,99,99,13,14,14,99,15,16),gettype(top1)
      goto 99
c     --------------matrices scalaires
   11 name(k)=28
      k=k+1
      goto 21
c     --------------polynomes a coef dans R ou C
   12 name(k)=25
      k=k+1
      goto 21
c     --------------chaine de caractere
   13 name(k)=12
      k=k+1
      goto 21
c     --------------macros
   14 name(k)=22
      k=k+1
      goto 21
c     --------------files
   15 name(k)=15
      k=k+1
      goto 21
c     --------------listes
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
            ilog= getsmat("mname",top+1,top+1,ms,ns,1,1,lr,nlr)
            do 17 i=1,min(3,nlr)
               name(k)=istk(lr+i-1)
               k=k+1
 17         continue
         endif
         call ptrback(top+1)
      endif
      goto 21
c     --------------padic
   18 name(k)=25
      name(k+1)=25
      k=k+2
      goto 21
c     --------------booleen
 19   name(k)=11
      k=k+1
      goto 21
c     --------------
   21 if(nb.eq.2) goto 24
      do 22 i=1,nops
         if(ops(i).eq.op) goto 23
   22 continue
      goto 99
   23 name(k)=code(i)
      k=k+1
      nb=2
      if(rhs1.eq.2) goto 10
c
   24 call namstr(id,name,k-1,0)
c      write(06,*) 'mname operation'
c      call prntid(id,1)
      return
c
   99 id(1)=blank
      return
      end
