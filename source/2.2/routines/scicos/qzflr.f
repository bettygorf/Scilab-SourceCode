c---------------------------------------------------------------------------
c---------------------------------------------------------------------------
      subroutine qzflr(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c     QZFLR, Alvaro:9-6-95
c     Continous block, MIMO
c     Gives quantized signal by floor method
c     rpar(i): quantization step used for input #i
c     out=rpar*Ceil(u/rpar)
c
      integer i
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Qzflr     t='',e10.3,'' flag='',i1)') t,flag
      endif
 
      goto(10,20,20) flag

c flag=1
      
 10   continue
      
      do 15 i=1,nu
         out(i)=rpar(i)*ANINT(u(i)/rpar(i)+0.5)
 15   continue
      return
c flag=2 OR 3
 20   continue
c ERROR
      write(*,'(''ERROR; block floor flag:'',i2,'' t '',e10.3)') flag,t
      return
      end
