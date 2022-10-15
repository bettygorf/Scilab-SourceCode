      subroutine gnsin(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c     GNSIN, Alvaro:9-6-95
c     Continous block, MINO
c     Sinus generator
c     rpar(1): ts, Start time
c     rpar(2): M, Signal Magnitude
c     rpar(3): phi, Phase angle in radians
c     rpar(4): w, Sinusoid frequency in rad/s
c     out=M sin( w(t-ts)+phi)
c     out=rpar(2) sin(rpar(4)(t-rpar(1))+rpar(4))

      integer i
      goto(10,20,20) flag

c flag=1
      
 10   continue
      
      do 15 i=1,nout
         if(t.ge.rpar(1))then
            out(i)=rpar(2)*sin(rpar(4)*(t-rpar(1))+rpar(3))
         else
            out(i)=0.0d0
         endif
 15   continue
      return
c flag=2 OR 3
 20   continue
c ERROR
      write(*,'(''ERROR; block gnsin flag:'',i2,'' t '',e10.3)') flag,t
      flag=-1
      return
      end
