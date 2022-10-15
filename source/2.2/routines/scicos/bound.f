c---------------------------------------------------------------------------
      subroutine bound(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c     Bound, Alvaro:17-5-95
c     Continous block, MISO
c     
c     out(i)=rpar(nu+i) if u(i)>rpar(i)
c     else out(i)=0
c
      integer i
      goto(10,20,20) flag

c flag=1
      
 10   continue
      
      do 15 i=1,nu
         if (u(i).ge.rpar(i)) then
           out(i)=rpar(nu+i)
         else
           out(i)=0.0d0
         endif
 15   continue
      return
c flag=2 OR 3
 20   continue
c ERROR
      write(*,'(''ERROR; block bound flag:'',i2,'' t '',e10.3)') flag,t
      flag=-1
      return
      end
