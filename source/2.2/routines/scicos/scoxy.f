      subroutine scoxy(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag

c     Il y a un probleme au niveau de clipping. Le reste a l'air de marcher.
c     ipar(1) = win_num
c     ipar(2) = 0/1 color flag
c     ipar(2+i) = line type for ith curve
c
c     rpar(1)=dt
c     rpar(2)=amplitude +x
c     rpar(3)=amplitude +y
c     rpar(4)=amplitude -x
c     rpar(5)=amplitude -y

      double precision dt,amx,amx2,amy,amy2,rect(4),xx(2),yy(2)
      integer i,verb,cur,na,v,wid,nax(4)
      character*20 strf,buf
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Scoxy     t='',e10.3,'' flag='',i1)') t,flag
      endif

      if(flag.eq.1) then
      elseif(flag.eq.2) then
         dt=rpar(1)
         amx=rpar(2)
         amy=rpar(3)
         amx2=rpar(4)
         amy2=rpar(5)
         wid=ipar(1)
         if(nipar.ge.nu+6) then
            nax(1)=ipar(3+nu)
            nax(2)=ipar(4+nu)
            nax(3)=ipar(5+nu)
            nax(4)=ipar(6+nu)
         else
            nax(1)=2
            nax(2)=10
            nax(3)=2
            nax(4)=10
         endif
         call sciwin()
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
c Window initialisation
         if(x(1).lt.0) then
            call dr1('xget'//char(0),'window'//char(0),verb,cur,na,
     &           v,v,v,dv,dv,dv,dv)
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
            call dr1('xclear'//char(0),'v'//char(0),v,v,v,v,v,v,
     $           dv,dv,dv,dv)
            call dr1('xset'//char(0),'use color'//char(0),ipar(2),0,0,
     &           0,0,v,dv,dv,dv,dv)
            call dr('xstart'//char(0),'v'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
            buf='t@ @input and output'
            strf='011'//char(0)
            rect(1)=amx2
            rect(2)=amy2
            rect(3)=amx
            rect(4)=amy
            call dr1('xset'//char(0),'dashes'//char(0),0,0,0,
     &           0,0,v,dv,dv,dv,dv)
            call plot2d(rect(1),rect(2),1,1,-1,strf,buf,rect,nax)

C first point
	    out(1)=0
	
	    out(2)=u(1)
	    out(3)=u(2)
         else
            buf='xlines'//char(0)
            do 10 i=1,nu,2
             	xx(1)=x(1+i)
             	xx(2)=u(i)
             	yy(1)=x(2+i)
             	yy(2)=u(i+1)
             	out(i+1)=u(i)
	     	out(i+2)=u(i+1)
                call dr1('xpolys'//char(0),'v'//char(0),v,v,ipar(2+i),
     &               1,2,v,xx,yy,dv,dv)
 10         continue
            call dr1('xset'//char(0),'window'//char(0),cur,v,v,v,v,v,
     &           dv,dv,dv,dv)
	endif

      elseif(flag.eq.3) then
         if(nout.ge.1) then
            out(1)=t+rpar(1)
         endif
      elseif(flag.eq.4) then
      
      endif

      end
