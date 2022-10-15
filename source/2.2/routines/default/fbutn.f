      subroutine fbutn(name,win,entry)
c!
c interface for buttons
c!
      include '../stack.h'
      integer win,entry
      character*(*) name
c
      integer halt
      common /coshlt/ halt

c
      integer it1
c
      nn=0
 10   nn=nn+1
      if(name(nn:nn).ne.char(0)) goto 10
      nn=nn-1
c+
      
      if(name(1:nn).eq.'halt_scicos') then
         halt=1
         return
      endif
c+
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,n,t,y,ydot) 
cc fin
      return
c
 2000 iero=1
      call  basout(io,wte,
     &     ' No action associated with this menu in fbutn')
      return
      end
