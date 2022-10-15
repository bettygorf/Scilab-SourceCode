      subroutine nextj(id,j)
c     ==============================================================
C     extracts the jth occurence of x in do x=val and stores its value on top 
C     of the stack 
c     ==============================================================
      include '../stack.h'
c
      double precision d1mach
      integer id(nsiz),j,vt,semi
c
      integer ogettype,lr,lc,lr1,lc1
      character*4 name
      logical getmat,cremat,smatj,lmatj,getsmat,getilist,getpoly,pmatj
c
c
      integer iadr
      data semi/43/
c
      iadr(l)=l+l-1
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') j
         call cvname(id,buf(5:4+nsiz*4),1)
         call basout(io,wte,' nextj j:'//buf(1:4)//' var:'//
     $        buf(5:4+nsiz*4))
      endif
c
      j = j + 1
      if(comp(1).ne.0) return
      top = top + 1
      vt=ogettype(top-1)
      goto (10,20,2,2,2,2,2,2,2,30,2,2,2,2,40) vt
 2    err=vt
      call error(76)
      return
c---  matrices scalaires 
 10   if (.not.getmat("nextj",top-1,top-1,it,m,n,lr,lc)) return
      if (m.eq.-3) then
C        boucle implicite 
         if (.not.cremat("nextj",top,0,1,1,lr1,lc1)) return
         stk(lr1) = stk(lr) + (j - 1)*stk(lr + 1)
         if( stk(lr+1) * (stk(lr1) - stk(lr+2)) .gt. 0) then
            if(abs(stk(lr1)-stk(lr+2)).gt.
     $           abs(stk(lr+1)*d1mach(4))) goto 50
         endif
      else
         if (j .gt. n) go to 50
         if (.not.cremat("nextj",top,it,m,1,lr1,lc1)) return
         call dcopy(m,stk(lr+(j-1)*m),1,stk(lr1),1)
         if(it.eq.1) call dcopy(m,stk(lc+(j-1)*m),1,stk(lc1),1)
      endif
      goto 21
c--   matrices de polynomes
 20   if (.not.getpoly("nextj",top-1,top-1,it,m,n,name,namel,ilp,lr,lc))
     $     return 
      if(j.gt.n) goto 50
      if (.not.pmatj("nextj",top,j)) return 
      goto 21
c---  chaines de caracteres
 30   if (.not.getsmat("nextj",top-1,top-1,m,n,1,1,lr,nlj)) return
      if ( j .gt.n) goto 50
      if (.not.smatj("nextj",top,j)) return 
      goto 21
c---- listes
 40   if (.not.getilist("nextj",top-1,top-1,m,j,ilj)) return 
      if(j.gt.m) goto 50
      if (.not.lmatj("nextj",top,j)) return 
      goto 21
 21   rhs = 0
      sym=semi
      call stackp(id,0)
      return
 50   top=top-1
      il = iadr(lstk(top))
      istk(il) = 0
      rhs = 0
      sym=semi
      call stackp(id,0)
      j = 0
      return
      end
